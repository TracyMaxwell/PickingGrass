<script setup lang="ts">
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import UserBadge from '@/components/UserBadge.vue'

const route = useRoute()
const auth = useAuthStore()
</script>

<template>
  <div class="public-layout">
    <header class="public-header">
      <div class="header-left">
        <RouterLink :to="{ name: 'landing' }" class="site-title">PickingGrass Documentation</RouterLink>
        <RouterLink v-if="route.name !== 'docs' && route.name !== 'landing'" :to="{ name: 'docs' }">Docs</RouterLink>
      </div>
      <div class="header-right">
        <RouterLink
          v-if="route.name === 'docs'"
          :to="{ name: 'editor' }"
          target="_blank"
          class="header-btn"
        >
          Get Started <span class="arrow">→</span>
        </RouterLink>
        <UserBadge v-if="auth.user" />
        <RouterLink v-else :to="{ name: 'sign-in' }" class="sign-in-link">Sign In</RouterLink>
      </div>
    </header>
    <main>
      <RouterView />
    </main>
  </div>
</template>

<style scoped>
.public-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: var(--pg-accent);
}

.public-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.75rem 1.5rem;
  background-color: var(--pg-accent-dark);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.site-title {
  font-size: 1rem;
  font-weight: 700;
  color: var(--pg-accent-text);
  text-decoration: none;
  letter-spacing: 0.01em;
}

.header-left a:not(.site-title) {
  color: var(--pg-accent-text);
  text-decoration: none;
  font-size: 0.9rem;
  opacity: 0.85;
}

.header-left a:not(.site-title):hover {
  opacity: 1;
}

.sign-in-link {
  color: var(--pg-accent-text);
  text-decoration: none;
  font-size: 0.9rem;
  padding: 0.3rem 0.9rem;
  border: 1px solid var(--pg-accent-bg-mute);
  border-radius: 5px;
  opacity: 0.85;
}

.sign-in-link:hover {
  opacity: 1;
}

.header-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.3rem 0.9rem;
  border: 1px solid var(--pg-accent-bg-mute);
  border-radius: 5px;
  color: var(--pg-accent-text);
  text-decoration: none;
  font-size: 0.9rem;
  font-weight: 500;
  opacity: 0.85;
}

.header-btn:hover {
  opacity: 1;
  background-color: rgba(255, 255, 255, 0.08);
}

.arrow {
  font-size: 1rem;
}

main {
  flex: 1;
  display: flex;
  flex-direction: column;
}
</style>
