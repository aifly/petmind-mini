<template>
  <view class="health-page">
    <!-- 头部 -->
    <view class="header">
      <view class="header-bg"></view>
      <view class="header-content">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="header-title">健康急救箱</text>
        <view class="header-placeholder"></view>
      </view>
    </view>

    <!-- 输入表单 -->
    <view v-if="!isLoading && !showResult" class="form-body">
      <!-- 宠物类型选择 -->
      <view class="form-section">
        <text class="section-label">选择宠物类型</text>
        <view class="pet-type-grid">
          <view 
            class="pet-type-chip" 
            :class="{ active: petType === 'cat' }"
            @click="petType = 'cat'"
          >
            <text class="type-emoji">🐱</text>
            <text class="type-label">猫咪</text>
          </view>
          <view 
            class="pet-type-chip" 
            :class="{ active: petType === 'dog' }"
            @click="petType = 'dog'"
          >
            <text class="type-emoji">🐶</text>
            <text class="type-label">狗狗</text>
          </view>
          <view 
            class="pet-type-chip" 
            :class="{ active: petType === 'other' }"
            @click="petType = 'other'"
          >
            <text class="type-emoji">🐰</text>
            <text class="type-label">其他</text>
          </view>
        </view>
      </view>

      <!-- 症状描述 -->
      <view class="form-section">
        <text class="section-label">描述症状</text>
        <view class="input-area">
          <textarea
            v-model="symptomText"
            class="symptom-input"
            placeholder="例如：最近两天食欲不好，精神萎靡，偶尔呕吐..."
            maxlength="500"
          />
          <text class="input-count">{{ symptomText.length }}/500</text>
        </view>
      </view>

      <!-- 免责声明 -->
      <view class="disclaimer-box">
        <text class="disc-icon">⚠️</text>
        <text class="disc-text">AI 建议仅供参考，不能替代专业兽医诊断。紧急情况请立即就医！</text>
      </view>

      <!-- 提交按钮 -->
      <button 
        class="submit-btn" 
        :disabled="!canSubmit"
        :class="{ disabled: !canSubmit }"
        @click="handleSubmit"
      >
        开始分析
      </button>
    </view>

    <!-- 加载状态 -->
    <view v-if="isLoading" class="loading-body">
      <view class="health-orb">🩺</view>
      <text class="loading-title">AI 正在分析...</text>
      <text class="loading-desc">请稍候，正在评估症状</text>
      <view class="loading-steps">
        <view class="loading-step" :class="{ done: step >= 1, active: step === 0 }">
          <view class="step-dot"></view>
          <text>分析症状描述</text>
        </view>
        <view class="loading-step" :class="{ done: step >= 2, active: step === 1 }">
          <view class="step-dot"></view>
          <text>匹配可能原因</text>
        </view>
        <view class="loading-step" :class="{ done: step >= 3, active: step === 2 }">
          <view class="step-dot"></view>
          <text>生成建议方案</text>
        </view>
      </view>
    </view>

    <!-- 结果页 -->
    <view v-if="showResult" class="result-body">
      <!-- 紧急度横幅 -->
      <view class="urgency-banner" :class="result.urgency">
        <text class="urgency-icon">{{ urgencyIcon }}</text>
        <view class="urgency-text">
          <text class="urgency-level" :class="result.urgency">{{ urgencyText }}</text>
          <text class="urgency-desc">{{ urgencyDesc }}</text>
        </view>
      </view>

      <!-- 可能原因 -->
      <view class="result-section">
        <text class="section-title">🔍 可能原因</text>
        <view v-for="(cause, index) in result.causes" :key="index" class="cause-item">
          <view class="cause-rank">{{ index + 1 }}</view>
          <view class="cause-content">
            <text class="cause-name">{{ cause.name }}</text>
            <text class="cause-desc">{{ cause.desc }}</text>
          </view>
        </view>
      </view>

      <!-- 建议措施 -->
      <view class="result-section">
        <text class="section-title">💡 建议措施</text>
        <view class="advice-list">
          <view v-for="(advice, index) in result.advice" :key="index" class="advice-item">
            <text class="advice-bullet">•</text>
            <text class="advice-text">{{ advice }}</text>
          </view>
        </view>
      </view>

      <!-- 安慰卡片 -->
      <view class="comfort-card">
        <text class="comfort-text">{{ result.comfort }}</text>
      </view>

      <!-- 底部免责声明 -->
      <view class="disclaimer-banner">
        <text>⚠️</text>
        <text>以上建议仅供参考，不能替代专业兽医诊断。如症状持续或加重，请立即就医。</text>
      </view>

      <!-- 底部按钮 -->
      <view class="result-actions">
        <button class="btn-primary" @click="resetForm">再测一次</button>
        <button class="btn-secondary" @click="goBack">返回首页</button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const petType = ref<'cat' | 'dog' | 'other'>('cat')
const symptomText = ref('')
const isLoading = ref(false)
const showResult = ref(false)
const step = ref(0)

const canSubmit = computed(() => symptomText.value.trim().length >= 10)

const urgencyIcon = computed(() => {
  const map: Record<string, string> = { low: '✅', medium: '⚠️', high: '🚨' }
  return map[result.value.urgency] || '⚠️'
})

const urgencyText = computed(() => {
  const map: Record<string, string> = { low: '风险较低', medium: '需要关注', high: '建议尽快就医' }
  return map[result.value.urgency] || '需要关注'
})

const urgencyDesc = computed(() => {
  const map: Record<string, string> = {
    low: '症状看起来不严重，可先观察',
    medium: '建议密切观察，必要时咨询兽医',
    high: '症状较严重，建议尽快就医检查'
  }
  return map[result.value.urgency] || '建议密切观察'
})

// 模拟结果数据
const result = ref({
  urgency: 'medium' as 'low' | 'medium' | 'high',
  causes: [
    { name: '消化不良', desc: '可能因饮食变化或进食过快引起' },
    { name: '轻度肠胃炎', desc: '常见于换季或应激反应' },
    { name: '寄生虫感染', desc: '建议定期驱虫，观察粪便情况' }
  ],
  advice: [
    '暂停喂食12小时，让肠胃休息',
    '提供充足的清水，防止脱水',
    '观察呕吐频率和粪便状态',
    '如24小时内无好转，请就医'
  ],
  comfort: '别太担心，很多小毛病都能自愈。保持观察，有问题及时就医，你是个负责任的铲屎官！💪'
})

const handleSubmit = async () => {
  if (!canSubmit.value) return
  
  isLoading.value = true
  showResult.value = false
  step.value = 0

  // 模拟步骤动画
  const steps = [0, 1, 2]
  for (const s of steps) {
    await new Promise(r => setTimeout(r, 800))
    step.value = s + 1
  }

  await new Promise(r => setTimeout(r, 500))
  isLoading.value = false
  showResult.value = true
}

const resetForm = () => {
  symptomText.value = ''
  showResult.value = false
  step.value = 0
}

const goBack = () => {
  uni.switchTab({ url: '/pages/index/index' })
}
</script>

<style scoped>
.health-page {
  min-height: 100vh;
  background: #f8fafc;
  display: flex;
  flex-direction: column;
}

/* 头部 */
.header {
  position: relative;
  padding-bottom: 30rpx;
  flex-shrink: 0;
}

.header-bg {
  position: absolute;
  inset: 0;
  background: linear-gradient(165deg, #5ECFB5, #2D9CDB);
}

.header-content {
  position: relative;
  height: 120rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 30rpx;
  padding-top: var(--status-bar-height, 0);
}

.back-btn {
  width: 64rpx;
  height: 64rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.back-icon {
  color: white;
  font-size: 40rpx;
  font-weight: 300;
}

.header-title {
  font-size: 36rpx;
  font-weight: 600;
  color: white;
}

.header-placeholder {
  width: 64rpx;
}

/* 表单 */
.form-body {
  flex: 1;
  padding: 30rpx;
  display: flex;
  flex-direction: column;
  gap: 30rpx;
}

.form-section {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.section-label {
  font-size: 30rpx;
  font-weight: 600;
  color: #1f2937;
}

.pet-type-grid {
  display: flex;
  gap: 20rpx;
}

.pet-type-chip {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
  padding: 24rpx 16rpx;
  background: white;
  border-radius: 20rpx;
  border: 2rpx solid #e5e7eb;
}

.pet-type-chip.active {
  border-color: #2bb598;
  background: rgba(43, 181, 152, 0.08);
}

.type-emoji {
  font-size: 48rpx;
}

.type-label {
  font-size: 26rpx;
  font-weight: 600;
  color: #6b7280;
}

.pet-type-chip.active .type-label {
  color: #2bb598;
}

.input-area {
  position: relative;
  background: white;
  border-radius: 20rpx;
  border: 2rpx solid #e5e7eb;
  padding: 20rpx;
}

.symptom-input {
  width: 100%;
  height: 240rpx;
  font-size: 28rpx;
  line-height: 1.6;
  color: #1f2937;
}

.input-count {
  position: absolute;
  right: 20rpx;
  bottom: 16rpx;
  font-size: 24rpx;
  color: #9ca3af;
}

.disclaimer-box {
  background: rgba(255, 140, 66, 0.08);
  border: 2rpx solid rgba(255, 140, 66, 0.3);
  border-radius: 16rpx;
  padding: 20rpx;
  display: flex;
  gap: 16rpx;
  align-items: flex-start;
}

.disc-icon {
  font-size: 36rpx;
}

.disc-text {
  flex: 1;
  font-size: 26rpx;
  color: #c25a00;
  line-height: 1.5;
  font-weight: 500;
}

.submit-btn {
  height: 96rpx;
  background: linear-gradient(135deg, #2bb598 0%, #2d9cdb 100%);
  color: white;
  font-size: 32rpx;
  font-weight: 600;
  border-radius: 48rpx;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: auto;
}

.submit-btn.disabled {
  background: #d1d5db;
}

.submit-btn::after {
  border: none;
}

/* 加载状态 */
.loading-body {
  flex: 1;
  background: linear-gradient(180deg, #ebf9f5 0%, #fff 100%);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60rpx 48rpx;
}

.health-orb {
  width: 220rpx;
  height: 220rpx;
  border-radius: 50%;
  background: linear-gradient(135deg, #5ECFB5, #2D9CDB);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 96rpx;
  box-shadow: 0 0 0 28rpx rgba(43, 184, 156, 0.1), 0 0 0 56rpx rgba(43, 184, 156, 0.05);
  animation: pulse-teal 2s ease-in-out infinite;
  margin-bottom: 56rpx;
}

@keyframes pulse-teal {
  0%, 100% { transform: scale(1); box-shadow: 0 0 0 28rpx rgba(43, 184, 156, 0.1), 0 0 0 56rpx rgba(43, 184, 156, 0.05); }
  50% { transform: scale(1.04); box-shadow: 0 0 0 40rpx rgba(43, 184, 156, 0.12), 0 0 0 80rpx rgba(43, 184, 156, 0.06); }
}

.loading-title {
  font-size: 40rpx;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 12rpx;
}

.loading-desc {
  font-size: 28rpx;
  color: #6b7280;
}

.loading-steps {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 16rpx;
  margin-top: 56rpx;
}

.loading-step {
  display: flex;
  align-items: center;
  gap: 20rpx;
  padding: 20rpx 28rpx;
  background: white;
  border-radius: 16rpx;
  font-size: 28rpx;
  color: #9ca3af;
}

.loading-step.done {
  color: #2bb598;
}

.loading-step.active {
  color: #1a6fa8;
  font-weight: 600;
}

.step-dot {
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
  background: #e5e7eb;
}

.loading-step.done .step-dot {
  background: #2bb598;
}

.loading-step.active .step-dot {
  background: #1a6fa8;
  animation: blink 1s ease-in-out infinite;
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}

/* 结果页 */
.result-body {
  flex: 1;
  padding: 0 30rpx 40rpx;
  display: flex;
  flex-direction: column;
  gap: 30rpx;
  overflow-y: auto;
}

.urgency-banner {
  margin-top: 20rpx;
  border-radius: 20rpx;
  padding: 28rpx 32rpx;
  display: flex;
  align-items: center;
  gap: 24rpx;
}

.urgency-banner.medium {
  background: rgba(247, 201, 72, 0.15);
  border: 2rpx solid rgba(247, 201, 72, 0.5);
}

.urgency-banner.high {
  background: rgba(255, 71, 87, 0.1);
  border: 2rpx solid rgba(255, 71, 87, 0.5);
  animation: border-pulse 1.5s ease-in-out infinite;
}

.urgency-banner.low {
  background: rgba(38, 208, 124, 0.1);
  border: 2rpx solid rgba(38, 208, 124, 0.4);
}

@keyframes border-pulse {
  0%, 100% { border-color: rgba(255, 71, 87, 0.5); }
  50% { border-color: rgba(255, 71, 87, 1); }
}

.urgency-icon {
  font-size: 56rpx;
}

.urgency-level {
  font-size: 32rpx;
  font-weight: 700;
}

.urgency-level.medium {
  color: #d4900a;
}

.urgency-level.high {
  color: #ff4757;
}

.urgency-level.low {
  color: #1a9457;
}

.urgency-desc {
  font-size: 24rpx;
  color: #6b7280;
  margin-top: 4rpx;
}

.result-section {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.section-title {
  font-size: 28rpx;
  font-weight: 700;
  color: #6b7280;
}

.cause-item {
  background: white;
  border-radius: 20rpx;
  padding: 28rpx;
  display: flex;
  gap: 24rpx;
  align-items: flex-start;
  border: 1rpx solid #e5e7eb;
}

.cause-rank {
  width: 48rpx;
  height: 48rpx;
  border-radius: 50%;
  background: rgba(43, 181, 152, 0.1);
  color: #2bb598;
  font-size: 24rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.cause-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 6rpx;
  display: block;
}

.cause-desc {
  font-size: 26rpx;
  color: #6b7280;
  line-height: 1.5;
}

.advice-list {
  background: white;
  border-radius: 20rpx;
  padding: 28rpx;
  border: 1rpx solid #e5e7eb;
}

.advice-item {
  display: flex;
  gap: 16rpx;
  align-items: flex-start;
  margin-bottom: 16rpx;
}

.advice-item:last-child {
  margin-bottom: 0;
}

.advice-bullet {
  color: #2bb598;
  font-weight: 700;
  font-size: 32rpx;
  line-height: 1;
}

.advice-text {
  flex: 1;
  font-size: 28rpx;
  color: #374151;
  line-height: 1.6;
}

.comfort-card {
  background: linear-gradient(135deg, rgba(43, 184, 156, 0.06), rgba(45, 156, 219, 0.06));
  border: 1rpx solid rgba(43, 184, 156, 0.2);
  border-radius: 24rpx;
  padding: 32rpx;
}

.comfort-text {
  font-size: 28rpx;
  color: #1a6e5a;
  line-height: 1.7;
  font-style: italic;
}

.disclaimer-banner {
  background: rgba(255, 71, 87, 0.06);
  border: 2rpx solid rgba(255, 71, 87, 0.2);
  border-radius: 16rpx;
  padding: 24rpx;
  font-size: 24rpx;
  color: #b71c1c;
  line-height: 1.5;
  font-weight: 500;
  display: flex;
  gap: 16rpx;
  align-items: flex-start;
}

.result-actions {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  margin-top: 20rpx;
}

.btn-primary {
  height: 96rpx;
  background: linear-gradient(135deg, #2bb598 0%, #2d9cdb 100%);
  color: white;
  font-size: 32rpx;
  font-weight: 600;
  border-radius: 48rpx;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-primary::after {
  border: none;
}

.btn-secondary {
  height: 96rpx;
  background: white;
  color: #6b7280;
  font-size: 32rpx;
  font-weight: 600;
  border-radius: 48rpx;
  border: 2rpx solid #e5e7eb;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-secondary::after {
  border: none;
}
</style>
