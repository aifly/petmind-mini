<template>
  <view class="decode-page">
    <!-- 顶部渐变头部 -->
    <view class="decode-header">
      <!-- 状态栏占位 -->
      <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>
      <!-- 导航栏 -->
      <view class="nav-bar">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">性格解码</text>
        <view class="nav-placeholder"></view>
      </view>

      <!-- 图片上传区 -->
      <view class="upload-section">
        <view v-if="!imageUrl" class="upload-zone" @click="chooseImage">
          <text class="upload-icon">📷</text>
          <text class="upload-main">点击上传宠物照片（可选）</text>
          <text class="upload-sub">支持猫咪、狗狗、小宠</text>
        </view>
        <view v-else class="upload-zone uploaded" @click="chooseImage">
          <image :src="imageUrl" class="upload-preview" mode="aspectFill" />
          <view class="upload-info">
            <text class="upload-filename">已上传照片</text>
            <text class="upload-change">点击更换</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 主体内容 -->
    <scroll-view class="decode-body" scroll-y>
      <!-- 行为描述输入 -->
      <view class="input-section">
        <view class="input-label">
          <text>描述一下你家主子的行为</text>
          <text class="required">*</text>
        </view>
        <textarea
          v-model="behaviorText"
          class="input-area"
          placeholder="比如：我家猫每天半夜在家狂奔，还盯着墙角发呆叫唤……"
          :maxlength="300"
          @input="onInput"
        />
        <view class="char-count">{{ behaviorText.length }}/300</view>
      </view>

      <!-- 提示卡片 -->
      <view class="tip-box">
        <text class="tip-icon">💡</text>
        <text class="tip-text">描述越详细，AI 解读越准确。可以包括：发生时间、频率、具体动作、你的猜测等。</text>
      </view>

      <!-- 底部按钮区 -->
      <view class="action-section">
        <button
          class="decode-btn"
          :class="{ disabled: !canDecode }"
          :disabled="!canDecode"
          @click="startDecode"
        >
          <text class="btn-icon">✨</text>
          <text>开始解码</text>
        </button>
      </view>

      <!-- 底部安全区 -->
      <view class="safe-area"></view>
    </scroll-view>

    <!-- 加载弹窗 -->
    <view v-if="isLoading" class="loading-mask">
      <view class="loading-content">
        <view class="loading-anim">
          <view class="pulse-ring"></view>
          <view class="pulse-core"></view>
        </view>
        <text class="loading-text">{{ loadingText }}</text>
        <view class="loading-steps">
          <view
            v-for="(step, index) in loadingSteps"
            :key="index"
            class="step-dot"
            :class="{ active: currentStep >= index }"
          />
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { supabase, uploadImage } from '@/utils/supabase'

// 系统信息
const systemInfo = uni.getSystemInfoSync()
const statusBarHeight = systemInfo.statusBarHeight || 44

// 数据
const imageUrl = ref('')
const behaviorText = ref('')
const isLoading = ref(false)
const currentStep = ref(0)
const loadingTexts = [
  '正在与你的主子建立心灵连接...',
  '正在翻阅行星猫咪行为学档案...',
  '主子的秘密即将揭晓...'
]
const loadingText = ref(loadingTexts[0])
const loadingSteps = [0, 1, 2]

// 计算属性
const canDecode = computed(() => behaviorText.value.length >= 10)

// 选择图片
const chooseImage = () => {
  uni.chooseMedia({
    count: 1,
    mediaType: ['image'],
    sourceType: ['album', 'camera'],
    success: async (res) => {
      const tempFilePath = res.tempFiles[0].tempFilePath
      try {
        uni.showLoading({ title: '上传中...' })
        const url = await uploadImage(tempFilePath, 'decode')
        imageUrl.value = url
        uni.hideLoading()
      } catch (err) {
        uni.hideLoading()
        uni.showToast({ title: '上传失败', icon: 'none' })
      }
    }
  })
}

// 输入处理
const onInput = () => {
  // 可添加防抖保存草稿
}

// 返回
const goBack = () => {
  uni.switchTab({ url: '/pages/index/index' })
}

// 开始解码
const startDecode = async () => {
  if (!canDecode.value) return

  isLoading.value = true
  currentStep.value = 0

  // 轮播加载文案
  const textInterval = setInterval(() => {
    currentStep.value = (currentStep.value + 1) % 3
    loadingText.value = loadingTexts[currentStep.value]
  }, 1500)

  try {
    // 调用 Supabase Edge Function
    const { data, error } = await supabase.functions.invoke('ai-decode', {
      body: {
        inputText: behaviorText.value,
        inputImageUrl: imageUrl.value
      }
    })

    clearInterval(textInterval)
    isLoading.value = false

    if (error || !data?.success) {
      throw new Error(error?.message || '解码失败')
    }

    // 跳转到结果页，传递 AI 结果
    const resultData = encodeURIComponent(JSON.stringify(data.data))
    uni.navigateTo({
      url: `/pages/decode/result?text=${encodeURIComponent(behaviorText.value)}&image=${encodeURIComponent(imageUrl.value)}&result=${resultData}`
    })
  } catch (err) {
    clearInterval(textInterval)
    isLoading.value = false
    console.error('Decode error:', err)
    uni.showToast({ title: '解码失败，请重试', icon: 'none' })
  }
}
</script>

<style scoped>
.decode-page {
  min-height: 100vh;
  background: #F7F8FA;
  display: flex;
  flex-direction: column;
}

/* 顶部渐变头部 */
.decode-header {
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
  padding: 8px 16px 12px;
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

/* 上传区 */
.upload-section {
  padding: 0 16px 20px;
}

.upload-zone {
  border: 2px dashed rgba(255, 255, 255, 0.5);
  border-radius: 16px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  background: rgba(255, 255, 255, 0.1);
}

.upload-zone.uploaded {
  border-style: solid;
  border-color: rgba(255, 255, 255, 0.6);
  flex-direction: row;
  padding: 16px;
  gap: 12px;
}

.upload-icon {
  font-size: 32px;
}

.upload-main {
  font-size: 14px;
  color: #fff;
  font-weight: 600;
}

.upload-sub {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
}

.upload-preview {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.3);
}

.upload-info {
  flex: 1;
}

.upload-filename {
  font-size: 14px;
  color: #fff;
  font-weight: 600;
  display: block;
}

.upload-change {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.8);
  text-decoration: underline;
  margin-top: 4px;
  display: block;
}

/* 主体内容 */
.decode-body {
  flex: 1;
  padding: 20px 16px;
}

.input-section {
  margin-bottom: 16px;
}

.input-label {
  font-size: 14px;
  font-weight: 600;
  color: #1A1A2E;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.required {
  color: #FF5733;
}

.input-area {
  width: 100%;
  min-height: 140px;
  background: #fff;
  border-radius: 16px;
  padding: 16px;
  font-size: 14px;
  color: #1A1A2E;
  line-height: 1.6;
  border: 1px solid transparent;
}

.input-area:focus {
  border-color: #FF9A76;
}

.char-count {
  text-align: right;
  font-size: 12px;
  color: #9CA3AF;
  margin-top: 8px;
}

/* 提示卡片 */
.tip-box {
  background: rgba(255, 154, 118, 0.08);
  border: 1px solid rgba(255, 154, 118, 0.2);
  border-radius: 12px;
  padding: 14px;
  display: flex;
  gap: 10px;
  align-items: flex-start;
  margin-bottom: 24px;
}

.tip-icon {
  font-size: 16px;
  flex-shrink: 0;
}

.tip-text {
  font-size: 12px;
  color: #6B7280;
  line-height: 1.6;
  flex: 1;
}

/* 按钮 */
.action-section {
  margin-top: auto;
}

.decode-btn {
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

.decode-btn.disabled {
  background: #E5E7EB;
  color: #9CA3AF;
  box-shadow: none;
}

.btn-icon {
  font-size: 18px;
}

.safe-area {
  height: 20px;
}

/* 加载弹窗 */
.loading-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(26, 26, 46, 0.95);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.loading-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24px;
}

.loading-anim {
  position: relative;
  width: 80px;
  height: 80px;
}

.pulse-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: rgba(255, 154, 118, 0.3);
  animation: pulse 2s ease-out infinite;
}

.pulse-core {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #FF9A76 0%, #FF5733 100%);
  box-shadow: 0 0 30px rgba(255, 154, 118, 0.6);
}

@keyframes pulse {
  0% { transform: translate(-50%, -50%) scale(1); opacity: 0.6; }
  100% { transform: translate(-50%, -50%) scale(1.5); opacity: 0; }
}

.loading-text {
  font-size: 15px;
  color: #fff;
  font-weight: 500;
}

.loading-steps {
  display: flex;
  gap: 8px;
}

.step-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  transition: all 0.3s;
}

.step-dot.active {
  background: #FF9A76;
  box-shadow: 0 0 10px rgba(255, 154, 118, 0.5);
}
</style>
