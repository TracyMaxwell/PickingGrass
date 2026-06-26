import { defineStore } from 'pinia'
import { ref } from 'vue'
import { signInWithPopup, signOut, onAuthStateChanged, type User } from 'firebase/auth'
import { auth, googleProvider } from '@/firebase'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const loading = ref(true)

  const ready = new Promise<void>((resolve) => {
    onAuthStateChanged(auth, (firebaseUser) => {
      user.value = firebaseUser
      loading.value = false
      resolve()
    })
  })

  async function signInWithGoogle() {
    await signInWithPopup(auth, googleProvider)
  }

  async function signOutUser() {
    await signOut(auth)
  }

  return { user, loading, ready, signInWithGoogle, signOutUser }
})
