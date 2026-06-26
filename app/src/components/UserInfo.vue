<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
</script>

<template>
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
</template>

<style scoped>
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
