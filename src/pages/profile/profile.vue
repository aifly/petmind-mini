<template>
  <view class="profile-page">
    <view class="header">
      <view class="header-bg"></view>
      <view class="header-content">
        <text class="header-title">我的</text>
      </view>
    </view>
    <view class="content">
      <view v-if="!isLoggedIn" class="login-section">
        <view class="avatar-placeholder">👤</view>
        <text class="login-title">登录解锁更多功能</text>
        <text class="login-desc">保存你的解码记录和健康问诊历史</text>
        <button class="login-btn" @click="handleLogin">微信一键登录</button>
      </view>
      <view v-else class="user-section">
        <view class="user-info">
          <image class="user-avatar" :src="userInfo.avatarUrl" mode="aspectFill" />
          <text class="user-name">{{ userInfo.nickName }}</text>
        </view>
        <view class="menu-list">
          <view class="menu-item">
            <text class="menu-icon">📝</text>
            <text class="menu-text">解码记录</text>
            <text class="menu-arrow">›</text>
          </view>
          <view class="menu-item">
            <text class="menu-icon">🏥</text>
            <text class="menu-text">问诊记录</text>
            <text class="menu-arrow">›</text>
          </view>
          <view class="menu-item" @click="handleLogout">
            <text class="menu-icon">🚪</text>
            <text class="menu-text">退出登录</text>
            <text class="menu-arrow">›</text>
          </view>
        </view>
      </view>
      <view class="footer">
        <text class="footer-text">PetMind v2.0</text>
        <text class="footer-dot">·</text>
        <text class="footer-text">AI 驱动宠物助手</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
const isLoggedIn = ref(false)
const userInfo = ref({ nickName: '', avatarUrl: '' })
const handleLogin = () => {
  uni.login({
    provider: 'weixin',
    success: () => {
      isLoggedIn.value = true
      userInfo.value = { nickName: '铲屎官', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=pet' }
    }
  })
}
const handleLogout = () => {
  uni.showModal({
    title: '确认退出',
    content: '退出后将无法查看历史记录',
    success: (res) => {
      if (res.confirm) {
        isLoggedIn.value = false
        userInfo.value = { nickName: '', avatarUrl: '' }
      }
    }
  })
}
</script>

<style scoped>
.profile-page { min-height: 100vh; background: #0f0c29; }
.header { position: relative; height: 180rpx; overflow: hidden; }
.header-bg { position: absolute; inset: 0; background: linear-gradient(135deg, #1a1a3e 0%, #0f0c29 50%, #1a1a3e 100%); }
.header-bg::before { content: ''; position: absolute; top: -50%; right: -20%; width: 80%; height: 150%; background: radial-gradient(ellipse, rgba(167, 139, 250, 0.15) 0%, transparent 70%); }
.header-content { position: relative; height: 100%; display: flex; align-items: flex-end; padding: 0 40rpx 30rpx; }
.header-title { font-size: 40rpx; font-weight: 700; color: #ffffff; }
.content { padding: 40rpx; }
.login-section { display: flex; flex-direction: column; align-items: center; padding: 60rpx 40rpx; background: rgba(255, 255, 255, 0.05); border-radius: 32rpx; border: 1rpx solid rgba(255, 255, 255, 0.1); }
.avatar-placeholder { width: 140rpx; height: 140rpx; border-radius: 50%; background: linear-gradient(135deg, rgba(167, 139, 250, 0.3), rgba(139, 92, 246, 0.2)); display: flex; align-items: center; justify-content: center; margin-bottom: 30rpx; border: 2rpx solid rgba(167, 139, 250, 0.3); font-size: 60rpx; }
.login-title { font-size: 32rpx; font-weight: 600; color: #ffffff; margin-bottom: 12rpx; }
.login-desc { font-size: 26rpx; color: rgba(255, 255, 255, 0.5); margin-bottom: 40rpx; }
.login-btn { width: 100%; height: 90rpx; background: linear-gradient(135deg, #a78bfa 0%, #8b5cf6 100%); color: #ffffff; font-size: 30rpx; font-weight: 600; border-radius: 45rpx; border: none; display: flex; align-items: center; justify-content: center; }
.login-btn::after { border: none; }
.user-section { display: flex; flex-direction: column; gap: 30rpx; }
.user-info { display: flex; align-items: center; gap: 24rpx; padding: 40rpx; background: rgba(255, 255, 255, 0.05); border-radius: 32rpx; border: 1rpx solid rgba(255, 255, 255, 0.1); }
.user-avatar { width: 120rpx; height: 120rpx; border-radius: 50%; border: 3rpx solid rgba(167, 139, 250, 0.5); }
.user-name { font-size: 36rpx; font-weight: 600; color: #ffffff; }
.menu-list { background: rgba(255, 255, 255, 0.05); border-radius: 32rpx; border: 1rpx solid rgba(255, 255, 255, 0.1); overflow: hidden; }
.menu-item { display: flex; align-items: center; padding: 32rpx 40rpx; border-bottom: 1rpx solid rgba(255, 255, 255, 0.05); }
.menu-item:last-child { border-bottom: none; }
.menu-icon { font-size: 36rpx; margin-right: 20rpx; }
.menu-text { flex: 1; font-size: 30rpx; color: #ffffff; }
.menu-arrow { font-size: 32rpx; color: rgba(255, 255, 255, 0.3); }
.footer { display: flex; align-items: center; justify-content: center; gap: 16rpx; margin-top: 60rpx; padding-bottom: 40rpx; }
.footer-text { font-size: 24rpx; color: rgba(255, 255, 255, 0.4); }
.footer-dot { font-size: 24rpx; color: rgba(255, 255, 255, 0.3); }
</style>
