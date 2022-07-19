import { createRouter, createWebHistory } from 'vue-router'
import AppLayout from '@/layouts/app-layout.vue'
import RouteViewComponent from './route-view.vue'

const routes = [
  {
    path: "/:catchAll(.*)",
    redirect: { name: 'registration' },
  },
  {
    name: 'assessment',
    path: '/assessment',
    component: AppLayout,
    children: [
      {
        name: 'registration',
        path: 'registration',
        component: () => import('@/pages/registration-page.vue'),
      },
      {
        name: 'data',
        path: 'data',
        component: RouteViewComponent,
        children: [
          {
            name: 'users',
            path: 'users',
            component: () => import('@/pages/users-page.vue')
          },
          {
            name: 'colleges',
            path: 'colleges',
            component: () => import('@/pages/colleges-page.vue')
          },
          {
            name: 'exams',
            path: 'exams',
            component: () => import('@/pages/exams-page.vue')
          },
          {
            name: 'examwindows',
            path: 'examwindows',
            component: () => import('@/pages/examwindows-page.vue')
          },
        ],
      }
    ],
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  //  mode: process.env.VUE_APP_ROUTER_MODE_HISTORY === 'true' ? 'history' : 'hash',
  routes
})

export default router