<template>
  <view class="container">
    <!-- 页面标题 -->
    <view class="page-header">
      <text class="page-title">添加宠物</text>
      <text class="page-desc">填写宠物信息，开始记录它的成长</text>
    </view>

    <!-- 表单卡片 -->
    <view class="form-card">
      <!-- 宠物头像 -->
      <view class="avatar-section">
        <view class="avatar-wrap" @click="chooseAvatar">
          <image 
            class="avatar" 
            :src="pet.avatar || '/static/default-avatar.png'" 
            mode="aspectFill"
          />
          <view class="avatar-edit">
            <text class="edit-icon">📷</text>
          </view>
        </view>
        <text class="avatar-hint">点击上传头像</text>
      </view>

      <!-- 宠物名称 -->
      <view class="form-item">
        <text class="form-label">宠物名称 *</text>
        <input 
          class="form-input" 
          v-model="pet.name" 
          placeholder="给它起个名字吧"
          placeholder-class="ph-color"
        />
      </view>

      <!-- 宠物类型 -->
      <view class="form-item">
        <text class="form-label">宠物类型 *</text>
        <picker 
          :range="petTypes" 
          range-key="name"
          @change="onTypeChange"
        >
          <view class="form-picker" :class="{ 'picker-selected': pet.type }">
            <text :class="pet.type ? 'picker-text' : 'picker-placeholder'">
              {{ selectedTypeName || '选择宠物类型' }}
            </text>
            <text class="picker-arrow">›</text>
          </view>
        </picker>
      </view>

      <!-- 品种 -->
      <view class="form-item">
        <text class="form-label">品种</text>
        <input 
          class="form-input" 
          v-model="pet.breed" 
          placeholder="如：柯基、暹罗猫"
          placeholder-class="ph-color"
        />
      </view>

      <!-- 性别 -->
      <view class="form-item">
        <text class="form-label">性别</text>
        <view class="gender-select">
          <view 
            class="gender-btn" 
            :class="{ active: pet.gender === '公' }"
            @click="pet.gender = '公'"
          >
            <text class="gender-emoji">♂️</text>
            <text class="gender-text">公</text>
          </view>
          <view 
            class="gender-btn" 
            :class="{ active: pet.gender === '母' }"
            @click="pet.gender = '母'"
          >
            <text class="gender-emoji">♀️</text>
            <text class="gender-text">母</text>
          </view>
        </view>
      </view>

      <!-- 出生日期 -->
      <view class="form-item">
        <text class="form-label">出生日期</text>
        <picker 
          mode="date" 
          :value="pet.birth_date" 
          @change="onBirthDateChange"
        >
          <view class="form-picker" :class="{ 'picker-selected': pet.birth_date }">
            <text :class="pet.birth_date ? 'picker-text' : 'picker-placeholder'">
              {{ pet.birth_date || '选择出生日期' }}
            </text>
            <text class="picker-arrow">›</text>
          </view>
        </picker>
      </view>

      <!-- 体重 -->
      <view class="form-item">
        <text class="form-label">体重 (kg)</text>
        <input 
          class="form-input" 
          type="digit"
          v-model="pet.weight" 
          placeholder="如：5.5"
          placeholder-class="ph-color"
        />
      </view>

      <!-- 备注 -->
      <view class="form-item">
        <text class="form-label">备注</text>
        <textarea 
          class="form-textarea" 
          v-model="pet.notes" 
          placeholder="它的性格、爱好、习惯..."
          placeholder-class="ph-color"
        />
      </view>
    </view>

    <!-- 提交按钮 -->
    <view class="btn-wrap">
      <button 
        class="submit-btn" 
        :class="{ 'btn-loading': loading }"
        @click="submitPet"
        :disabled="loading"
      >
        <text v-if="!loading">✨ 添加宠物</text>
        <text v-else>保存中...</text>
      </button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { supabaseUrl, supabaseAnonKey, post } from '@/utils/supabase'

const petTypes = [
  { id: 'dog', name: '🐕 狗狗', emoji: '🐕' },
  { id: 'cat', name: '🐱 猫咪', emoji: '🐱' },
  { id: 'bird', name: '🐦 鸟类', emoji: '🐦' },
  { id: 'rabbit', name: '🐰 兔子', emoji: '🐰' },
  { id: 'hamster', name: '🐹 仓鼠', emoji: '🐹' },
  { id: 'fish', name: '🐠 鱼类', emoji: '🐠' },
  { id: 'other', name: '🐾 其他', emoji: '🐾' }
]

const loading = ref(false)
const pet = ref({
  name: '',
  type: '',
  breed: '',
  gender: '',
  birth_date: '',
  weight: '',
  notes: '',
  avatar: ''
})

const selectedTypeName = computed(() => {
  if (!pet.value.type) return ''
  const found = petTypes.find(t => t.id === pet.value.type)
  return found?.name || ''
})

const onTypeChange = (e: any) => {
  pet.value.type = petTypes[e.detail.value].id
}

const onBirthDateChange = (e: any) => {
  pet.value.birth_date = e.detail.value
}

const chooseAvatar = () => {
  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    sourceType: ['album', 'camera'],
    success: (res) => {
      pet.value.avatar = res.tempFilePaths[0]
    }
  })
}

const submitPet = async () => {
  // 验证
  if (!pet.value.name.trim()) {
    uni.showToast({ title: '请输入宠物名称', icon: 'none' })
    return
  }
  if (!pet.value.type) {
    uni.showToast({ title: '请选择宠物类型', icon: 'none' })
    return
  }

  loading.value = true

  try {
    // 生成设备标识
    let deviceId = uni.getStorageSync('deviceId')
    if (!deviceId) {
      deviceId = 'device_' + Date.now()
      uni.setStorageSync('deviceId', deviceId)
    }

    const data = await post(`${supabaseUrl}/rest/v1/pets`, {
      name: pet.value.name.trim(),
      type: pet.value.type,
      breed: pet.value.breed || null,
      gender: pet.value.gender || null,
      birth_date: pet.value.birth_date || null,
      weight: pet.value.weight ? parseFloat(pet.value.weight) : null,
      notes: pet.value.notes || null,
      user_id: deviceId,
      photo_url: pet.value.avatar || null
    })

    uni.showToast({ title: '添加成功 🎉', icon: 'success' })
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  } catch (error: any) {
    console.error('添加宠物失败:', error)
    uni.showToast({ title: error.message || '添加失败', icon: 'none' })
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.container {
  min-height: 100vh;
  background: linear-gradient(180deg, #F9FAFB 0%, #EEF2FF 100%);
  padding: 32rpx;
  padding-bottom: 200rpx;
}

/* 页面标题 */
.page-header {
  margin-bottom: 40rpx;
}

.page-title {
  font-size: 56rpx;
  font-weight: 700;
  color: #1F2937;
  display: block;
  background: linear-gradient(135deg, #8B5CF6 0%, #A78BFA 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-desc {
  font-size: 28rpx;
  color: #6B7280;
  margin-top: 8rpx;
  display: block;
}

/* 表单卡片 */
.form-card {
  background: #FFFFFF;
  border-radius: 32rpx;
  padding: 40rpx;
  box-shadow: 0 4rpx 24rpx rgba(139, 92, 246, 0.08);
}

/* 头像 */
.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 48rpx;
}

.avatar-wrap {
  position: relative;
  width: 180rpx;
  height: 180rpx;
}

.avatar {
  width: 180rpx;
  height: 180rpx;
  border-radius: 50%;
  background: #F3F4F6;
  border: 6rpx solid #FFFFFF;
  box-shadow: 0 8rpx 24rpx rgba(139, 92, 246, 0.15);
}

.avatar-edit {
  position: absolute;
  right: 0;
  bottom: 0;
  width: 56rpx;
  height: 56rpx;
  background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 4rpx solid #FFFFFF;
}

.edit-icon {
  font-size: 24rpx;
}

.avatar-hint {
  font-size: 24rpx;
  color: #9CA3AF;
  margin-top: 16rpx;
}

/* 表单项 */
.form-item {
  margin-bottom: 36rpx;
}

.form-label {
  font-size: 28rpx;
  font-weight: 500;
  color: #374151;
  display: block;
  margin-bottom: 16rpx;
}

.form-input {
  width: 100%;
  height: 96rpx;
  background: #F9FAFB;
  border-radius: 20rpx;
  padding: 0 28rpx;
  font-size: 30rpx;
  color: #1F2937;
  box-sizing: border-box;
  border: 2rpx solid transparent;
  transition: all 0.2s ease;
}

.form-input:focus {
  background: #FFFFFF;
  border-color: #8B5CF6;
}

.ph-color {
  color: #9CA3AF;
}

.form-picker {
  width: 100%;
  height: 96rpx;
  background: #F9FAFB;
  border-radius: 20rpx;
  padding: 0 28rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-sizing: border-box;
}

.picker-selected {
  background: #FFFFFF;
  border: 2rpx solid #8B5CF6;
}

.picker-placeholder {
  color: #9CA3AF;
  font-size: 30rpx;
}

.picker-text {
  color: #1F2937;
  font-size: 30rpx;
}

.picker-arrow {
  font-size: 36rpx;
  color: #9CA3AF;
}

.form-textarea {
  width: 100%;
  min-height: 160rpx;
  background: #F9FAFB;
  border-radius: 20rpx;
  padding: 24rpx;
  font-size: 30rpx;
  color: #1F2937;
  box-sizing: border-box;
  border: 2rpx solid transparent;
}

/* 性别选择 */
.gender-select {
  display: flex;
  gap: 24rpx;
}

.gender-btn {
  flex: 1;
  height: 96rpx;
  background: #F9FAFB;
  border-radius: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12rpx;
  border: 2rpx solid transparent;
  transition: all 0.2s ease;
}

.gender-btn.active {
  background: linear-gradient(135deg, #8B5CF620 0%, #A78BFA20 100%);
  border-color: #8B5CF6;
}

.gender-emoji {
  font-size: 36rpx;
}

.gender-text {
  font-size: 28rpx;
  color: #6B7280;
}

.gender-btn.active .gender-text {
  color: #8B5CF6;
  font-weight: 600;
}

/* 提交按钮 */
.btn-wrap {
  position: fixed;
  left: 32rpx;
  right: 32rpx;
  bottom: 48rpx;
}

.submit-btn {
  width: 100%;
  height: 104rpx;
  background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%);
  border-radius: 52rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 34rpx;
  font-weight: 600;
  color: #FFFFFF;
  box-shadow: 0 12rpx 32rpx rgba(139, 92, 246, 0.35);
  border: none;
}

.submit-btn:active {
  transform: scale(0.98);
}

.submit-btn[disabled] {
  opacity: 0.7;
}
</style>
