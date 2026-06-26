<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'
import { watch } from 'vue'

const auth = useAuthStore()
const router = useRouter()

watch(
  () => auth.user,
  (user) => {
    if (user) router.push('/')
  },
)

async function handleSignIn() {
  try {
    await auth.signInWithGoogle()
  } catch (err) {
    console.error('Sign-in failed', err)
  }
}
</script>

<template>
  <div class="sign-in-page">
    <div class="sign-in-card">
      <h1>PickingGrass</h1>
      <p>Sign in to continue</p>
      <button class="google-btn" @click="handleSignIn">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="20" height="20">
          <path fill="#EA4335" d="M24 9.5c3.14 0 5.95 1.08 8.17 2.85l6.09-6.09C34.46 3.05 29.5 1 24 1 14.82 1 7.07 6.48 3.76 14.18l7.08 5.5C12.6 13.38 17.84 9.5 24 9.5z"/>
          <path fill="#4285F4" d="M46.52 24.5c0-1.64-.15-3.22-.42-4.74H24v8.98h12.7c-.55 2.9-2.22 5.36-4.72 7.02l7.26 5.64C43.44 37.3 46.52 31.36 46.52 24.5z"/>
          <path fill="#FBBC05" d="M10.84 28.32A14.6 14.6 0 0 1 9.5 24c0-1.5.26-2.95.72-4.32l-7.08-5.5A23.94 23.94 0 0 0 0 24c0 3.87.92 7.53 2.54 10.76l8.3-6.44z"/>
          <path fill="#34A853" d="M24 47c5.5 0 10.12-1.82 13.5-4.96l-7.26-5.64c-1.82 1.22-4.15 1.94-6.24 1.94-6.16 0-11.4-3.88-13.16-9.32l-8.3 6.44C7.07 41.52 14.82 47 24 47z"/>
          <path fill="none" d="M0 0h48v48H0z"/>
        </svg>
        Sign in with Google
      </button>
    </div>
  </div>
</template>

<style scoped>
.sign-in-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--color-background);
}

.sign-in-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.25rem;
  padding: 3rem 2.5rem;
  border: 1px solid var(--color-border);
  border-radius: 12px;
  background-color: var(--color-background-soft);
  min-width: 320px;
}

.sign-in-card h1 {
  font-size: 1.75rem;
  font-weight: 700;
  margin: 0;
}

.sign-in-card p {
  margin: 0;
  color: var(--color-text);
  opacity: 0.7;
}

.google-btn {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.65rem 1.5rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  background: white;
  color: #3c4043;
  font-size: 0.95rem;
  font-weight: 500;
  cursor: pointer;
  transition: box-shadow 0.15s;
  width: 100%;
  justify-content: center;
}

.google-btn:hover {
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.2);
}
</style>
