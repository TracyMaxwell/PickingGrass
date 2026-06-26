import { createRouter, createWebHistory } from 'vue-router'
import SignInView from '../views/SignInView.vue'
import { useAuthStore } from '@/stores/auth'

declare module 'vue-router' {
  interface RouteMeta {
    requiresAuth?: boolean
    label?: string
    title?: string
  }
}

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/sign-in',
      name: 'sign-in',
      component: SignInView,
      meta: { title: 'Sign In — PickingGrass' },
    },
    {
      path: '/',
      component: () => import('../layouts/PublicLayout.vue'),
      children: [
        {
          path: '',
          name: 'landing',
          component: () => import('../views/LandingView.vue'),
          meta: { label: 'Home', title: 'PickingGrass' },
        },
        {
          path: 'docs',
          name: 'docs',
          component: () => import('../views/DocsView.vue'),
          meta: { label: 'Docs', title: 'Docs — PickingGrass' },
        },
      ],
    },
    {
      path: '/editor',
      component: () => import('../layouts/AppLayout.vue'),
      meta: { requiresAuth: true },
      children: [
        {
          path: '',
          name: 'editor',
          component: () => import('../views/EditorView.vue'),
          meta: { requiresAuth: true, label: 'Editor', title: 'Editor — PickingGrass' },
        },
      ],
    },
  ],
})

router.beforeEach(async (to) => {
  const auth = useAuthStore()
  await auth.ready
  const requiresAuth = to.matched.some((r) => r.meta.requiresAuth)
  if (requiresAuth && !auth.user) {
    return { name: 'sign-in' }
  }
  if (to.name === 'sign-in' && auth.user) {
    return { name: 'editor' }
  }
  document.title = to.meta.title ?? 'PickingGrass'
})

export default router
