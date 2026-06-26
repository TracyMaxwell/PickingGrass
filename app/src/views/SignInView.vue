<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'
import { watch } from 'vue'
import GoogleSignInButton from '@/components/GoogleSignInButton.vue'

const auth = useAuthStore()
const router = useRouter()

watch(
  () => auth.user,
  (user) => {
    if (user) router.push({ name: 'app' })
  },
)
</script>

<template>
  <div class="sign-in-page">
    <GoogleSignInButton />
  </div>
</template>

<style scoped>
.sign-in-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
