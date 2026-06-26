<script setup lang="ts">
import UserBadge from '@/components/UserBadge.vue'
</script>

<template>
  <div class="status-bar">
    <div class="status-bar-left">
      <slot name="left" />
    </div>
    <div class="status-bar-right">
      <slot name="right" />
      <UserBadge />
    </div>
  </div>
</template>

<style scoped>
.status-bar {
  width: 100%;
  height: 40px;
  background-color: var(--pg-accent-dark);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 1.25rem;
  box-sizing: border-box;
}

.status-bar-left,
.status-bar-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}
</style>
