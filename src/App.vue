<script setup lang="ts">
import { onLaunch, onShow, onHide } from '@dcloudio/uni-app'
import { ref, provide } from 'vue'

// 全局响应式用户状态
const userInfo = ref<{
  isLoggedIn: boolean
  email: string
  id: string
} | null>(null)

// 初始化用户状态
const initUserState = () => {
  const isLoggedIn = uni.getStorageSync('isLoggedIn') || false
  const currentUser = uni.getStorageSync('currentUser') || null
  
  userInfo.value = {
    isLoggedIn,
    email: currentUser?.email || '',
    id: currentUser?.id || ''
  }
}

// 监听登录状态变化事件
uni.$on('loginSuccess', () => {
  initUserState()
})

uni.$on('logoutSuccess', () => {
  initUserState()
})

// 提供给子页面使用
provide('userInfo', userInfo)

onLaunch(() => {
  console.log('App Launch')
  initUserState()
})

onShow(() => {
  console.log('App Show')
  // 每次显示都检查状态
  initUserState()
})

onHide(() => {
  console.log('App Hide')
})
</script>