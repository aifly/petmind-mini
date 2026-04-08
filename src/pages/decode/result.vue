<template>
  <view class="result-page">
    <!-- 顶部渐变头部 -->
    <view class="result-header">
      <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>
      <view class="nav-bar">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">解码结果</text>
        <view class="nav-placeholder"></view>
      </view>
    </view>

    <!-- 结果内容 -->
    <scroll-view class="result-body" scroll-y v-if="decodeResult">
      <!-- 性格标题 -->
      <view class="personality-title">
        <text class="title-label">你的主子性格原型</text>
        <text class="title-main">{{ decodeResult.title }}</text>
      </view>

      <!-- 核心解读卡片 -->
      <view class="analysis-card">
        <view class="card-header">
          <text class="card-icon">📖</text>
          <text class="card-title">核心解读</text>
        </view>
        <text class="analysis-text">{{ decodeResult.analysis }}</text>
      </view>

      <!-- 性格标签 -->
      <view class="tags-section">
        <view
          v-for="(tag, index) in decodeResult.tags"
          :key="index"
          class="personality-tag"
          :class="`tag-color-${index % 4}`"
        >
          #{{ tag }}
        </view>
      </view>

      <!-- 金句 -->
      <view class="slogan-box">
        <text class="quote-mark">"</text>
        <text class="slogan-text">{{ decodeResult.slogan }}</text>
        <text class="quote-mark">"</text>
      </view>

      <!-- 底部操作栏 -->
      <view class="action-bar">
        <button class="btn-primary" @click="generatePoster">
          <text class="btn-icon">🎨</text>
          <text>生成专属海报</text>
        </button>
        <button class="btn-secondary" @click="decodeAgain">
          <text class="btn-icon">🔄</text>
          <text>再测一次</text>
        </button>
      </view>

      <view class="safe-area"></view>
    </scroll-view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <text class="empty-icon">🤔</text>
      <text class="empty-text">暂无解码结果</text>
      <button class="btn-primary" @click="goBack">返回重新输入</button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

// 系统信息
const systemInfo = uni.getSystemInfoSync()
const statusBarHeight = systemInfo.statusBarHeight || 44

// 数据
const decodeResult = ref<any>(null)
const inputText = ref('')
const imageUrl = ref('')

onMounted(() => {
  // 获取页面参数
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.options || {}

  inputText.value = decodeURIComponent(options.text || '')
  imageUrl.value = decodeURIComponent(options.image || '')

  // 解析 AI 返回的结果
  try {
    const resultData = JSON.parse(decodeURIComponent(options.result || '{}'))
    decodeResult.value = {
      title: resultData.personalityTitle || '神秘小天使',
      analysis: resultData.coreAnalysis || '你的宠物有着独特的个性魅力',
      tags: resultData.tags || ['可爱', '独特', '治愈'],
      slogan: resultData.slogan || '每一个毛孩子都是独一无二的存在 ✨'
    }
  } catch (e) {
    // Fallback to mock data if parsing fails
    decodeResult.value = {
      title: '深夜哲学家·焦虑版',
      analysis: '你的主子有着敏锐的夜间感知力，半夜的狂奔不是发疯，而是在进行一场关于宇宙意义的哲学思考。',
      tags: ['夜行侠', '通灵体质', '敏感星人'],
      slogan: '凌晨三点，是哲学家的起床时间'
    }
  }
})

const goBack = () => {
  uni.navigateBack()
}

const generatePoster = () => {
  // TODO: 生成海报
  uni.showToast({ title: '海报生成中...', icon: 'loading' })
}

const decodeAgain = () => {
  uni.redirectTo({ url: '/pages/decode/decode' })
}
</script>

<style scoped>
.result-page {
  min-height: 100vh;
  background: #F7F8FA;
  display: flex;
  flex-direction: column;
}

/* 顶部渐变头部 */
.result-header {
  background: linear-gradient(165deg, #FF9A76 0%, #FF5733 100%);
  flex-shrink: 0;
}

.status-bar {
  width: 100%;
}

.nav-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 16px 20px;
  height: 44px;
}

.back-btn {
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.back-icon {
  font-size: 24px;
  color: #333;
  line-height: 1;
  margin-top: -2px;
}

.nav-title {
  font-size: 17px;
  font-weight: 600;
  color: #fff;
}

.nav-placeholder {
  width: 36px;
}

/* 结果内容 */
.result-body {
  flex: 1;
  padding: 20px 16px;
}

/* 性格标题 */
.personality-title {
  text-align: center;
  margin-bottom: 24px;
}

.title-label {
  display: block;
  font-size: 13px;
  color: #9CA3AF;
  margin-bottom: 8px;
}

.title-main {
  display: block;
  font-size: 28px;
  font-weight: 700;
  background: linear-gradient(135deg, #FF9A76 0%, #9B59B6 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* 解读卡片 */
.analysis-card {
  background: #fff;
  border-radius: 20px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
}

.card-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}

.card-icon {
  font-size: 20px;
}

.card-title {
  font-size: 15px;
  font-weight: 600;
  color: #1A1A2E;
}

.analysis-text {
  font-size: 14px;
  color: #4B5563;
  line-height: 1.8;
}

/* 标签 */
.tags-section {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 24px;
  justify-content: center;
}

.personality-tag {
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 600;
}

.tag-color-0 {
  background: rgba(255, 154, 118, 0.15);
  color: #FF5733;
}

.tag-color-1 {
  background: rgba(155, 89, 182, 0.15);
  color: #9B59B6;
}

.tag-color-2 {
  background: rgba(67, 184, 156, 0.15);
  color: #43B89C;
}

.tag-color-3 {
  background: rgba(45, 156, 219, 0.15);
  color: #2D9CDB;
}

/* 金句 */
.slogan-box {
  background: linear-gradient(135deg, rgba(255, 154, 118, 0.1) 0%, rgba(155, 89, 182, 0.1) 100%);
  border-radius: 16px;
  padding: 24px;
  text-align: center;
  margin-bottom: 32px;
  border: 1px solid rgba(255, 154, 118, 0.2);
}

.quote-mark {
  font-size: 24px;
  color: #FF9A76;
  opacity: 0.5;
}

.slogan-text {
  font-size: 16px;
  font-weight: 500;
  color: #1A1A2E;
  font-style: italic;
  margin: 0 8px;
  line-height: 1.6;
}

/* 操作栏 */
.action-bar {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.btn-primary {
  width: 100%;
  height: 52px;
  background: linear-gradient(135deg, #FF9A76 0%, #FF5733 100%);
  border-radius: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  border: none;
  box-shadow: 0 8px 24px rgba(255, 87, 51, 0.35);
}

.btn-secondary {
  width: 100%;
  height: 48px;
  background: transparent;
  border: 1.5px solid #E5E7EB;
  border-radius: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #6B7280;
  font-size: 15px;
  font-weight: 600;
}

.btn-icon {
  font-size: 18px;
}

.safe-area {
  height: 20px;
}

/* 空状态 */
.empty-state {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px;
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 15px;
  color: #9CA3AF;
  margin-bottom: 24px;
}
</style>
