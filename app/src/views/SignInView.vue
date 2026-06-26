<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'
import { watch } from 'vue'
import GoogleSignInButton from '@/components/GoogleSignInButton.vue'
import logo from '@/assets/logo.svg'

const auth = useAuthStore()
const router = useRouter()

watch(
  () => auth.user,
  (user) => {
    if (user) router.push({ name: 'editor' })
  },
)
</script>

<template>
  <div class="sign-in-page">
    <div class="top-right">
      <RouterLink :to="{ name: 'docs' }" target="_blank" class="docs-link">Docs</RouterLink>
      <span class="page-label">Sign In</span>
    </div>
    <div class="sign-in-card">
      <img :src="logo" alt="PickingGrass" class="logo" />
      <h1>Welcome to PickingGrass</h1>
      <GoogleSignInButton />
    </div>
  </div>
</template>

<style scoped>
.sign-in-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--pg-accent);
  position: relative;
}

.top-right {
  position: absolute;
  top: 1rem;
  right: 1.25rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.docs-link {
  font-size: 0.85rem;
  font-weight: 500;
  color: var(--pg-accent-bg-mute);
  text-decoration: none;
  opacity: 0.85;
}

.docs-link:hover {
  opacity: 1;
  color: var(--pg-accent-text);
}

.page-label {
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--pg-accent-bg-mute);
}

.sign-in-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.5rem;
  padding: 3rem 2.5rem;
  min-width: 360px;
  border-radius: 14px;
  background-color: var(--pg-accent-bg);
  border: 1px solid var(--pg-accent-bg-mute);
}

.logo {
  width: 220px;
}

h1 {
  font-size: 1.6rem;
  font-weight: 700;
  color: var(--pg-accent-dark);
  text-align: center;
}
</style>
