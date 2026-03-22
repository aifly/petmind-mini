<template>
  <view class="container">
    <!-- 页面标题 -->
    <view class="page-header">
      <view class="header-left">
        <text class="page-title">我的毛孩子</text>
        <text class="page-desc">PetMind 宠物助手</text>
      </view>
      <view class="header-icon">🐾</view>
    </view>

    <!-- 宠物列表 -->
    <view class="pet-list" v-if="pets.length > 0">
      <view 
        class="pet-card" 
        v-for="pet in pets" 
        :key="pet.id"
        @click="goToPetDetail(pet.id)"
      >
        <!-- 宠物头像 -->
        <view class="pet-avatar-wrap">
          <image 
            class="pet-avatar" 
            :src="pet.photo_url || '/static/default-pet.png'" 
            mode="aspectFill"
          />
          <view class="pet-type-tag">
            <text>{{ getTypeEmoji(pet.type) }}</text>
          </view>
        </view>
        
        <!-- 宠物信息 -->
        <view class="pet-info">
          <text class="pet-name">{{ pet.name }}</text>
          <view class="pet-tags">
            <text class="pet-tag" v-if="pet.breed">{{ pet.breed }}</text>
            <text class="pet-tag">{{ calculateAge(pet.birth_date) }}</text>
          </view>
        </view>
        
        <!-- 箭头 -->
        <text class="pet-arrow">›</text>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <view class="empty-icon-wrap">
        <text class="empty-emoji">🐱</text>
      </view>
      <text class="empty-title">还没有添加宠物</text>
      <text class="empty-desc">点击下方按钮添加你的第一个宠物</text>
      <button class="empty-btn" @click="addPet">
        <text>✨ 添加宠物</text>
      </button>
    </view>

    <!-- 添加宠物悬浮按钮 -->
    <view class="fab" @click="addPet" v-if="pets.length > 0">
      <text class="fab-icon">+</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabaseUrl, supabaseAnonKey, get } from '@/utils/supabase'

interface Pet {
  id: string
  name: string
  type: string
  breed: string
  birth_date: string
  photo_url: string
}

const pets = ref<Pet[]>([])
const loading = ref(true)

// 宠物类型 Emoji
const getTypeEmoji = (type: string) => {
  const types: Record<string, string> = {
    'dog': '🐕',
    'cat': '🐱',
    'bird': '🐦',
    'rabbit': '🐰',
    'hamster': '🐹',
    'fish': '🐠',
    'other': '🐾'
  }
  return types[type] || '🐾'
}

// 计算宠物年龄
const calculateAge = (birthDate: string) => {
  if (!birthDate) return '年龄未知'
  const birth = new Date(birthDate)
  const now = new Date()
  const months = (now.getFullYear() - birth.getFullYear()) * 12 + (now.getMonth() - birth.getMonth())
  if (months < 12) {
    return `${months}个月`
  }
  const years = Math.floor(months / 12)
  return `${years}岁`
}

// 获取宠物列表
const fetchPets = async () => {
  loading.value = true
  try {
    const deviceId = uni.getStorageSync('deviceId') || ''
    
    let url = `${supabaseUrl}/rest/v1/pets?select=*&order=created_at.desc`
    if (deviceId) {
      url += `&user_id=eq.${deviceId}`
    }
    
    const data = await get(url)
    pets.value = data || []
  } catch (error) {
    console.error('获取宠物列表失败:', error)
    uni.showToast({ title: '获取失败', icon: 'none' })
  } finally {
    loading.value = false
  }
}

// 跳转到宠物详情
const goToPetDetail = (petId: string) => {
  uni.navigateTo({
    url: `/pages/pet-detail/pet-detail?id=${petId}`
  })
}

// 添加宠物
const addPet = () => {
  uni.navigateTo({
    url: '/pages/pet-add/pet-add'
  })
}

onMounted(() => {
  fetchPets()
})
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
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 48rpx;
}

.page-title {
  font-size: 56rpx;
  font-weight: 700;
  color: #1F2937;
  display: block;
}

.page-desc {
  font-size: 28rpx;
  color: #6B7280;
  margin-top: 8rpx;
  display: block;
}

.header-icon {
  font-size: 80rpx;
}

/* 宠物列表 */
.pet-list {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.pet-card {
  background: #FFFFFF;
  border-radius: 28rpx;
  padding: 32rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 4rpx 20rpx rgba(139, 92, 246, 0.08);
  transition: all 0.2s ease;
}

.pet-card:active {
  transform: scale(0.98);
  box-shadow: 0 2rpx 12rpx rgba(139, 92, 246, 0.06);
}

/* 宠物头像 */
.pet-avatar-wrap {
  position: relative;
}

.pet-avatar {
  width: 120rpx;
  height: 120rpx;
  border-radius: 50%;
  background: #F3F4F6;
}

.pet-type-tag {
  position: absolute;
  right: -8rpx;
  bottom: -8rpx;
  width: 44rpx;
  height: 44rpx;
  background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 4rpx solid #FFFFFF;
}

.pet-type-tag text {
  font-size: 24rpx;
}

/* 宠物信息 */
.pet-info {
  flex: 1;
  margin-left: 28rpx;
}

.pet-name {
  font-size: 36rpx;
  font-weight: 600;
  color: #1F2937;
  display: block;
}

.pet-tags {
  display: flex;
  gap: 12rpx;
  margin-top: 12rpx;
}

.pet-tag {
  font-size: 24rpx;
  color: #8B5CF6;
  background: #8B5CF615;
  padding: 6rpx 16rpx;
  border-radius: 999rpx;
}

/* 箭头 */
.pet-arrow {
  font-size: 40rpx;
  color: #D1D5DB;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80rpx 40rpx;
}

.empty-icon-wrap {
  width: 200rpx;
  height: 200rpx;
  background: linear-gradient(135deg, #8B5CF620 0%, #A78BFA20 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 40rpx;
}

.empty-emoji {
  font-size: 100rpx;
}

.empty-title {
  font-size: 36rpx;
  font-weight: 600;
  color: #1F2937;
  margin-bottom: 16rpx;
}

.empty-desc {
  font-size: 28rpx;
  color: #6B7280;
  text-align: center;
  margin-bottom: 48rpx;
}

.empty-btn {
  width: 320rpx;
  height: 88rpx;
  background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%);
  border-radius: 44rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 30rpx;
  font-weight: 600;
  color: #FFFFFF;
  box-shadow: 0 8rpx 24rpx rgba(139, 92, 246, 0.3);
  border: none;
}

/* 悬浮按钮 */
.fab {
  position: fixed;
  right: 40rpx;
  bottom: 56rpx;
  width: 112rpx;
  height: 112rpx;
  background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 12rpx 32rpx rgba(139, 92, 246, 0.4);
}

.fab:active {
  transform: scale(0.95);
}

.fab-icon {
  font-size: 56rpx;
  color: #FFFFFF;
  font-weight: 300;
}
</style>
