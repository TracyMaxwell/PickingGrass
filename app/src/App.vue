<script setup lang="ts">
import { watch } from 'vue'
import { RouterView, useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
const router = useRouter()
const route = useRoute()

watch(
  () => auth.user,
  (user) => {
    if (!user && route.matched.some((r) => r.meta.requiresAuth)) {
      router.push('/')
    }
  },
)
</script>

<template>
  <RouterView />
</template>
