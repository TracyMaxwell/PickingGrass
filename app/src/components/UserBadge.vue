<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
</script>

<template>
  <div v-if="auth.user" class="user-badge">
    <img
      v-if="auth.user.photoURL"
      :src="auth.user.photoURL"
      :alt="auth.user.displayName ?? 'User'"
      class="avatar"
    />
    <div v-else class="avatar-placeholder">
      {{ auth.user.displayName?.charAt(0) ?? '?' }}
    </div>
    <span class="name">{{ auth.user.displayName }}</span>
  </div>
</template>

<style scoped>
.user-badge {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.avatar {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  border: 2px solid var(--pg-accent-bg-mute);
}

.avatar-placeholder {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background-color: var(--pg-accent-bg-mute);
  color: var(--pg-accent-dark);
  font-size: 0.8rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
}

.name {
  font-size: 0.85rem;
  font-weight: 500;
  color: var(--pg-accent-text);
}
</style>
