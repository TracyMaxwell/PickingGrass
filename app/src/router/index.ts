import { createRouter, createWebHistory } from 'vue-router'
import SignInView from '../views/SignInView.vue'
import { useAuthStore } from '@/stores/auth'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/sign-in',
      name: 'sign-in',
      component: SignInView,
    },
    {
      path: '/',
      name: 'app',
      component: () => import('../views/AppView.vue'),
      meta: { requiresAuth: true },
    },
  ],
})

router.beforeEach((to) => {
  const auth = useAuthStore()
  if (to.meta.requiresAuth && !auth.loading && !auth.user) {
    return { name: 'sign-in' }
  }
})

export default router
