<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
const open = ref(false)
const badgeEl = ref<HTMLElement | null>(null)

function toggle() {
  open.value = !open.value
}

function onDocClick(e: MouseEvent) {
  if (badgeEl.value && !badgeEl.value.contains(e.target as Node)) {
    open.value = false
  }
}

function signOut() {
  open.value = false
  auth.signOutUser()
}

onMounted(() => document.addEventListener('click', onDocClick))
onUnmounted(() => document.removeEventListener('click', onDocClick))
</script>

<template>
  <div v-if="auth.user" ref="badgeEl" class="user-badge" @click="toggle">
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
    <span class="chevron" :class="{ rotated: open }">▾</span>

    <div v-if="open" class="dropdown">
      <button class="dropdown-item" @click.stop="signOut">Sign out</button>
    </div>
  </div>
</template>

<style scoped>
.user-badge {
  position: relative;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  user-select: none;
}

.user-badge:hover {
  background-color: rgba(255, 255, 255, 0.08);
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

.chevron {
  font-size: 0.75rem;
  color: var(--pg-accent-text);
  opacity: 0.7;
  transition: transform 0.15s;
  display: inline-block;
}

.chevron.rotated {
  transform: rotate(180deg);
}

.dropdown {
  position: absolute;
  top: calc(100% + 6px);
  right: 0;
  min-width: 130px;
  background-color: var(--pg-accent-dark);
  border: 1px solid var(--pg-accent-bg-mute);
  border-radius: 7px;
  overflow: hidden;
  z-index: 100;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
}

.dropdown-item {
  display: block;
  width: 100%;
  padding: 0.6rem 1rem;
  background: none;
  border: none;
  color: var(--pg-accent-text);
  font-size: 0.875rem;
  text-align: left;
  cursor: pointer;
}

.dropdown-item:hover {
  background-color: rgba(255, 255, 255, 0.08);
}
</style>
