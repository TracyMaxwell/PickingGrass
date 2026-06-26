<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
</script>

<template>
  <header>
    <div class="wrapper">
      <nav>
        <RouterLink to="/">Home</RouterLink>
        <RouterLink to="/about">About</RouterLink>
      </nav>
      <div v-if="auth.user" class="user-info">
        <img
          v-if="auth.user.photoURL"
          :src="auth.user.photoURL"
          :alt="auth.user.displayName ?? 'User'"
          class="avatar"
        />
        <span>{{ auth.user.displayName }}</span>
        <button class="sign-out-btn" @click="auth.signOutUser">Sign out</button>
      </div>
    </div>
  </header>

  <RouterView />
</template>

<style scoped>
header {
  padding: 1rem 2rem;
  border-bottom: 1px solid var(--color-border);
}

.wrapper {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: 1200px;
  margin: 0 auto;
}

nav {
  display: flex;
  gap: 1rem;
  font-size: 1rem;
}

nav a {
  color: var(--color-text);
  text-decoration: none;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
}

nav a.router-link-exact-active {
  color: var(--color-text);
  font-weight: 600;
}

nav a:hover {
  background-color: var(--color-background-mute);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.9rem;
}

.avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
}

.sign-out-btn {
  padding: 0.3rem 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 4px;
  background: transparent;
  color: var(--color-text);
  cursor: pointer;
  font-size: 0.85rem;
}

.sign-out-btn:hover {
  background-color: var(--color-background-mute);
}
</style>
