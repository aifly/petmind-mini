<template>
  <view class="container">
    <!-- 自定义导航栏 -->
    <view class="custom-nav">
      <view class="nav-back" @click="goBack">
        <text class="nav-back-icon">‹</text>
      </view>
      <text class="nav-title">我的</text>
      <view class="nav-placeholder"></view>
    </view>

    <!-- 顶部头部 -->
    <view class="page-header">
      <view class="header-bg"></view>
      <view class="header-content">
        <text class="page-title">⚙️ 我的</text>
      </view>
    </view>

    <!-- 用户信息卡片 -->
    <view class="user-card" v-if="isLoggedIn">
      <view class="user-avatar-wrap">
        <text class="avatar-emoji">🐾</text>
      </view>
      <view class="user-info">
        <text class="nickname">{{ currentUser?.email || '毛孩子家长' }}</text>
        <text class="user-id">{{ currentUser?.email ? '已登录' : '设备ID: ' + (currentUser?.id?.slice(0, 8) || '...') }}</text>
      </view>
      <view class="user-badge">
        <text class="badge-text">已登录</text>
      </view>
    </view>

    <!-- 未登录提示 -->
    <view class="login-prompt" v-else @click="goToLogin">
      <view class="login-icon-wrap">
        <text class="login-icon">🔑</text>
      </view>
      <view class="login-info">
        <text class="prompt-title">点击登录</text>
        <text class="prompt-sub">登录后可同步数据到云端</text>
      </view>
      <text class="arrow">›</text>
    </view>

    <!-- 通用设置 -->
    <view class="settings-section">
      <view class="section-label">通用设置</view>
      <view class="settings-list">
        <view class="settings-item" @click="toggleNotification">
          <view class="item-left">
            <view class="item-icon-wrap icon-orange">
              <text class="item-icon">🔔</text>
            </view>
            <text class="item-label">通知提醒</text>
          </view>
          <switch :checked="settings.notification" @change="toggleNotification" color="#FF7B54"/>
        </view>
        <view class="settings-item">
          <view class="item-left">
            <view class="item-icon-wrap icon-teal">
              <text class="item-icon">🔄</text>
            </view>
            <text class="item-label">自动同步</text>
          </view>
          <switch :checked="settings.autoSync" @change="toggleAutoSync" color="#FF7B54"/>
        </view>
        <view class="settings-item" @click="clearCache">
          <view class="item-left">
            <view class="item-icon-wrap icon-yellow">
              <text class="item-icon">🗑️</text>
            </view>
            <text class="item-label">清除缓存</text>
          </view>
          <text class="item-arrow">›</text>
        </view>
      </view>
    </view>

    <!-- 数据管理 -->
    <view class="settings-section">
      <view class="section-label">数据管理</view>
      <view class="settings-list">
        <view class="settings-item" @click="exportData">
          <view class="item-left">
            <view class="item-icon-wrap icon-purple">
              <text class="item-icon">📤</text>
            </view>
            <text class="item-label">导出数据</text>
          </view>
          <text class="item-arrow">›</text>
        </view>
        <view class="settings-item" @click="importData">
          <view class="item-left">
            <view class="item-icon-wrap icon-blue">
              <text class="item-icon">📥</text>
            </view>
            <text class="item-label">导入数据</text>
          </view>
          <text class="item-arrow">›</text>
        </view>
      </view>
    </view>

    <!-- 关于 -->
    <view class="settings-section">
      <view class="section-label">关于</view>
      <view class="settings-list">
        <view class="settings-item">
          <view class="item-left">
            <view class="item-icon-wrap icon-pink">
              <text class="item-icon">ℹ️</text>
            </view>
            <text class="item-label">版本</text>
          </view>
          <text class="item-value">v1.0.0</text>
        </view>
      </view>
    </view>

    <!-- 登出按钮 -->
    <view class="logout-section" v-if="isLoggedIn">
      <button class="logout-btn" @click="handleLogout">
        <text>退出登录</text>
      </button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, inject, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'

// 注入全局用户状态
const userInfo = inject<any>('userInfo')

const settings = ref({
  notification: true,
  autoSync: true
})

// 登录状态和用户信息
const isLoggedIn = ref(false)
const currentUser = ref<any>(null)

// 检查登录状态
const checkLoginStatus = () => {
  const loggedIn = uni.getStorageSync('isLoggedIn') || false
  const user = uni.getStorageSync('currentUser')
  console.log('checkLoginStatus:', { loggedIn, user })
  isLoggedIn.value = loggedIn
  if (loggedIn) {
    currentUser.value = user || null
  } else {
    currentUser.value = null
  }
}

const goToLogin = () => {
  uni.navigateTo({
    url: '/pages/login/login'
  })
}

onMounted(() => {
  checkLoginStatus()
})

// 每次显示页面时刷新登录状态
onShow(() => {
  checkLoginStatus()
})

const toggleNotification = () => {
  settings.value.notification = !settings.value.notification
  uni.showToast({
    title: settings.value.notification ? '已开启通知' : '已关闭通知',
    icon: 'none'
  })
}

const toggleAutoSync = () => {
  settings.value.autoSync = !settings.value.autoSync
  uni.showToast({
    title: settings.value.autoSync ? '已开启自动同步' : '已关闭自动同步',
    icon: 'none'
  })
}

const clearCache = () => {
  uni.showModal({
    title: '提示',
    content: '确定要清除缓存吗？',
    success: (res) => {
      if (res.confirm) {
        uni.clearStorageSync()
        uni.showToast({ title: '缓存已清除', icon: 'success' })
      }
    }
  })
}

const exportData = () => {
  uni.showToast({ title: '功能开发中', icon: 'none' })
}

const importData = () => {
  uni.showToast({ title: '功能开发中', icon: 'none' })
}

const handleLogout = () => {
  uni.showModal({
    title: '提示',
    content: '确定要退出登录吗？',
    success: (res) => {
      if (res.confirm) {
        // 清空所有缓存
        uni.clearStorageSync()
        // 触发全局状态更新
        uni.$emit('logoutSuccess')
        // 清空宠物数据
        uni.$emit('clearPets')
        uni.showToast({ title: '已退出登录', icon: 'success' })
        // 跳转到首页
        setTimeout(() => {
          uni.switchTab({
            url: '/pages/index/index'
          })
        }, 1000)
      }
    }
  })
}

// 返回上一页
const goBack = () => {
  // TabBar 页面不能使用 navigateBack，跳转到首页
  uni.switchTab({
    url: '/pages/index/index'
  })
}
</script>

<style scoped>
.container {
  min-height: 100vh;
  background: linear-gradient(180deg, #FF7B54 0%, #FFF8F5 200rpx, #FFF8F5 100%);
  padding-bottom: 200rpx;
}

/* ===== 自定义导航栏 ===== */
.custom-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 100rpx 32rpx 20rpx;
  background: linear-gradient(135deg, #FF7B54 0%, #FFB38A 100%);
}

.nav-back {
  width: 72rpx;
  height: 72rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10rpx);
  border: 2rpx solid rgba(255, 255, 255, 0.3);
  transition: all 0.2s ease;
}

.nav-back:active {
  transform: scale(0.92);
  background: rgba(255, 255, 255, 0.35);
}

.nav-back-icon {
  font-size: 36rpx;
  color: #FFFFFF;
  font-weight: 600;
  line-height: 1;
}

.nav-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #FFFFFF;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
}

.nav-placeholder {
  width: 72rpx;
}

/* ===== 顶部头部 ===== */
.page-header {
  position: relative;
  background: linear-gradient(135deg, #FF7B54 0%, #FFB38A 100%);
  padding: 40rpx 40rpx 56rpx;
  border-radius: 0 0 40rpx 40rpx;
  margin-bottom: 32rpx;
  overflow: hidden;
}

.header-bg {
  position: absolute;
  width: 180rpx;
  height: 180rpx;
  background: rgba(255,255,255,0.1);
  border-radius: 50%;
  right: -30rpx;
  top: -30rpx;
}

.header-content {
  position: relative;
  z-index: 1;
}

.page-title {
  font-size: 48rpx;
  font-weight: 800;
  color: #FFFFFF;
  display: block;
}

/* ===== 用户卡片 ===== */
.user-card {
  background: #FFFFFF;
  border-radius: 28rpx;
  padding: 32rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 4rpx 24rpx rgba(255, 123, 84, 0.10);
  margin: 0 32rpx 32rpx;
}

.user-avatar-wrap {
  width: 120rpx;
  height: 120rpx;
  background: linear-gradient(135deg, #FF7B54 0%, #FFB38A 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.avatar-emoji {
  font-size: 56rpx;
}

.user-info {
  flex: 1;
  margin-left: 24rpx;
}

.nickname {
  font-size: 34rpx;
  font-weight: 700;
  color: #1F2937;
  display: block;
}

.user-id {
  font-size: 22rpx;
  color: #9CA3AF;
  margin-top: 8rpx;
  display: block;
}

.user-badge {
  background: #FFF0E9;
  border-radius: 999rpx;
  padding: 8rpx 20rpx;
}

.badge-text {
  font-size: 22rpx;
  color: #FF7B54;
  font-weight: 600;
}

/* ===== 登录提示 ===== */
.login-prompt {
  background: #FFFFFF;
  border-radius: 28rpx;
  padding: 28rpx 32rpx;
  display: flex;
  align-items: center;
  gap: 20rpx;
  margin: 0 32rpx 32rpx;
  box-shadow: 0 4rpx 24rpx rgba(255, 123, 84, 0.08);
}

.login-icon-wrap {
  width: 80rpx;
  height: 80rpx;
  background: #FFF0E9;
  border-radius: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.login-icon {
  font-size: 40rpx;
}

.login-info {
  flex: 1;
}

.prompt-title {
  font-size: 30rpx;
  font-weight: 700;
  color: #FF7B54;
  display: block;
}

.prompt-sub {
  font-size: 24rpx;
  color: #9CA3AF;
  margin-top: 4rpx;
  display: block;
}

.arrow {
  font-size: 40rpx;
  color: #FFB38A;
  font-weight: 600;
}

/* ===== 设置区块 ===== */
.settings-section {
  margin: 0 32rpx 28rpx;
}

.section-label {
  font-size: 24rpx;
  color: #9CA3AF;
  margin-bottom: 14rpx;
  padding-left: 8rpx;
  font-weight: 600;
  letter-spacing: 1rpx;
}

.settings-list {
  background: #FFFFFF;
  border-radius: 24rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 16rpx rgba(255, 123, 84, 0.06);
}

.settings-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 28rpx 28rpx;
  border-bottom: 1rpx solid #FFF0E9;
}

.settings-item:last-child {
  border-bottom: none;
}

.settings-item:active {
  background: #FFFAF8;
}

.item-left {
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.item-icon-wrap {
  width: 64rpx;
  height: 64rpx;
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.icon-orange { background: #FFF0E9; }
.icon-teal   { background: #E6FBF5; }
.icon-yellow { background: #FFFBEB; }
.icon-purple { background: #EDE9FE; }
.icon-blue   { background: #DBEAFE; }
.icon-pink   { background: #FCE7F3; }

.item-icon {
  font-size: 32rpx;
}

.item-label {
  font-size: 30rpx;
  color: #1F2937;
  font-weight: 500;
}

.item-value {
  font-size: 26rpx;
  color: #9CA3AF;
  background: #F3F4F6;
  padding: 6rpx 16rpx;
  border-radius: 999rpx;
}

.item-arrow {
  font-size: 36rpx;
  color: #FFB38A;
  font-weight: 600;
}

/* ===== 登出 ===== */
.logout-section {
  margin: 40rpx 32rpx 0;
}

.logout-btn {
  width: 100%;
  height: 96rpx;
  background: #FFFFFF;
  border-radius: 999rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32rpx;
  font-weight: 600;
  color: #EF4444;
  border: 2rpx solid #FEE2E2;
  box-shadow: 0 4rpx 16rpx rgba(239, 68, 68, 0.08);
}

.logout-btn:active {
  background: #FEF2F2;
}
</style>
