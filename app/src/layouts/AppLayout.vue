<script setup lang="ts">
import { useRoute } from 'vue-router'
import StatusBar from '@/components/StatusBar.vue'

const route = useRoute()
</script>

<template>
  <div class="app-layout">
    <StatusBar>
      <template #left>
        <span class="page-label">{{ route.meta.label }}</span>
      </template>
      <template #right>
        <RouterLink :to="{ name: 'docs' }" target="_blank" class="header-btn">
          Get Help <span class="arrow">→</span>
        </RouterLink>
      </template>
    </StatusBar>
    <main>
      <RouterView />
    </main>
  </div>
</template>

<style scoped>
.app-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

main {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.page-label {
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--pg-accent-bg-mute);
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
  font-size: 0.85rem;
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
</style>
