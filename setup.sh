#!/usr/bin/env bash
# setup.sh — Provision a fresh Ubuntu 24.04 EC2 instance to serve PickingGrass
#
# Run this directly on the server via the AWS Console:
#   curl -fsSL <raw-url-to-this-script> | sudo -E bash
#
# Or after cloning the repo:
#   export REPO=https://github.com/your-org/PickingGrass
#   sudo -E bash setup.sh

set -euo pipefail

# ── Config ──────────────────────────────────────────────────────────────────

REPO="${REPO:-}"
CLONE_DIR="/opt/picking-grass"
APP_DIR="$CLONE_DIR/app"
SERVE_DIR="/var/www/picking-grass"
NGINX_CONF="/etc/nginx/sites-available/picking-grass"

# ── Helpers ─────────────────────────────────────────────────────────────────

prompt_var() {
  local var="$1" prompt="$2"
  if [[ -z "${!var:-}" ]]; then
    read -r -p "$prompt: " value
    export "$var"="$value"
  fi
}

# ── Get repo URL ─────────────────────────────────────────────────────────────

if [[ -z "$REPO" ]]; then
  read -r -p "Enter git repo URL (e.g. https://github.com/your-org/PickingGrass): " REPO
fi

# ── System packages ──────────────────────────────────────────────────────────

echo ""
echo "==> Updating system packages..."
apt-get update -y
apt-get upgrade -y

echo "==> Installing git, nginx, certbot..."
apt-get install -y git nginx certbot python3-certbot-nginx

echo "==> Installing Node.js 22 (LTS)..."
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs

node --version
npm --version

# ── Clone repo ───────────────────────────────────────────────────────────────

echo ""
echo "==> Cloning $REPO into $CLONE_DIR..."
rm -rf "$CLONE_DIR"
git clone "$REPO" "$CLONE_DIR"

# ── Firebase env vars ────────────────────────────────────────────────────────

ENV_FILE="$APP_DIR/.env.local"

if [[ -f "$ENV_FILE" ]]; then
  echo "==> Loading existing $ENV_FILE..."
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
else
  echo ""
  echo "==> .env.local not found (expected — it is gitignored)."
  echo "    Enter your Firebase credentials. Find these in app/.env.local on your local machine."
  echo ""
  prompt_var VITE_FIREBASE_API_KEY             "VITE_FIREBASE_API_KEY"
  prompt_var VITE_FIREBASE_AUTH_DOMAIN         "VITE_FIREBASE_AUTH_DOMAIN"
  prompt_var VITE_FIREBASE_PROJECT_ID          "VITE_FIREBASE_PROJECT_ID"
  prompt_var VITE_FIREBASE_STORAGE_BUCKET      "VITE_FIREBASE_STORAGE_BUCKET"
  prompt_var VITE_FIREBASE_MESSAGING_SENDER_ID "VITE_FIREBASE_MESSAGING_SENDER_ID"
  prompt_var VITE_FIREBASE_APP_ID              "VITE_FIREBASE_APP_ID"
  prompt_var VITE_FIREBASE_MEASUREMENT_ID      "VITE_FIREBASE_MEASUREMENT_ID"

  echo "==> Saving credentials to $ENV_FILE..."
  cat > "$ENV_FILE" <<EOF
VITE_FIREBASE_API_KEY=$VITE_FIREBASE_API_KEY
VITE_FIREBASE_AUTH_DOMAIN=$VITE_FIREBASE_AUTH_DOMAIN
VITE_FIREBASE_PROJECT_ID=$VITE_FIREBASE_PROJECT_ID
VITE_FIREBASE_STORAGE_BUCKET=$VITE_FIREBASE_STORAGE_BUCKET
VITE_FIREBASE_MESSAGING_SENDER_ID=$VITE_FIREBASE_MESSAGING_SENDER_ID
VITE_FIREBASE_APP_ID=$VITE_FIREBASE_APP_ID
VITE_FIREBASE_MEASUREMENT_ID=$VITE_FIREBASE_MEASUREMENT_ID
EOF
  chmod 600 "$ENV_FILE"
fi

# ── Detect domain / IP ───────────────────────────────────────────────────────

if [[ -z "${DOMAIN:-}" ]]; then
  # Auto-detect EC2 public IP from instance metadata
  DETECTED_IP=$(curl -sf --connect-timeout 3 http://169.254.169.254/latest/meta-data/public-ipv4 || true)
  if [[ -n "$DETECTED_IP" ]]; then
    read -r -p "==> Detected public IP: $DETECTED_IP. Use this as the domain? [Y/n] " use_ip
    if [[ "${use_ip,,}" != "n" ]]; then
      DOMAIN="$DETECTED_IP"
    fi
  fi
fi

if [[ -z "${DOMAIN:-}" ]]; then
  read -r -p "==> Enter your domain or IP: " DOMAIN
fi

echo "==> Using domain: $DOMAIN"

# ── Build the app ────────────────────────────────────────────────────────────

echo ""
echo "==> Installing npm dependencies..."
cd "$APP_DIR"
npm ci

echo "==> Building the app..."
npm run build

echo "==> Deploying built files to $SERVE_DIR..."
mkdir -p "$SERVE_DIR"
cp -r "$APP_DIR/dist/." "$SERVE_DIR/"
chown -R www-data:www-data "$SERVE_DIR"
chmod -R 755 "$SERVE_DIR"

# ── nginx configuration ──────────────────────────────────────────────────────

echo ""
echo "==> Writing nginx config..."
cat > "$NGINX_CONF" <<NGINX
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN;

    root $SERVE_DIR;
    index index.html;

    # Vue Router — serve index.html for all routes
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Long-lived cache for hashed Vite assets
    location ~* \.(js|css|woff2?|ttf|eot|svg|png|jpg|jpeg|gif|ico|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # Deny hidden files
    location ~ /\. {
        deny all;
    }
}
NGINX

ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/picking-grass
rm -f /etc/nginx/sites-enabled/default

echo "==> Testing nginx config..."
nginx -t

echo "==> Starting nginx..."
systemctl enable nginx
systemctl restart nginx

# ── SSL via Let's Encrypt ────────────────────────────────────────────────────

if [[ "$DOMAIN" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo ""
  echo "NOTE: Using an IP address — skipping SSL (Let's Encrypt requires a domain name)."
  echo "      Once you have a domain pointed at this server, run:"
  echo "        sudo certbot --nginx -d yourdomain.com"
else
  echo ""
  read -r -p "==> Set up SSL with Let's Encrypt for $DOMAIN? [y/N] " ssl_answer
  if [[ "${ssl_answer,,}" == "y" ]]; then
    certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m "admin@$DOMAIN"
    systemctl reload nginx
    echo "==> SSL configured."
  else
    echo "    Run later: sudo certbot --nginx -d $DOMAIN"
  fi
fi

# ── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "========================================="
echo " Deployment complete!"
echo " Site is live at: http://$DOMAIN"
echo "========================================="
echo ""
echo "REMINDER: Add $DOMAIN to Firebase Console →"
echo "  Authentication → Settings → Authorized domains"
