<template>
  <view class="container">
    <view class="header">
      <text class="title">宠物详情</text>
    </view>

    <view class="pet-card" v-if="pet">
      <image class="pet-avatar" :src="pet.avatar_url || '/static/default-pet.png'" mode="aspectFill" />
      <view class="pet-info">
        <text class="pet-name">{{ pet.name }}</text>
        <text class="pet-detail">{{ pet.species }} · {{ pet.breed || '未知品种' }}</text>
        <text class="pet-age">{{ calculateAge(pet.birth_date) }}</text>
      </view>
    </view>

    <view class="actions">
      <view class="action-item" @click="goToFeeding">
        <text class="action-icon">🍖</text>
        <text class="action-text">喂养记录</text>
      </view>
      <view class="action-item" @click="goToHealth">
        <text class="action-icon">💊</text>
        <text class="action-text">健康记录</text>
      </view>
      <view class="action-item" @click="goToCalendar">
        <text class="action-icon">📅</text>
        <text class="action-text">日程</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getLocalData, initMockData } from '@/utils/localData'

const pet = ref<any>(null)
const petId = ref('')

onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  petId.value = currentPage.options?.id || ''
  if (petId.value) {
    fetchPetDetail()
  }
})

const fetchPetDetail = async () => {
  initMockData()
  const pets = getLocalData('pets')
  pet.value = pets.find((p: any) => p.id === petId.value) || {
    id: petId.value,
    name: '示例宠物',
    species: '狗',
    breed: '金毛',
    birth_date: '2023-01-01',
    avatar_url: ''
  }
}

const calculateAge = (birthDate: string) => {
  if (!birthDate) return '未知年龄'
  const birth = new Date(birthDate)
  const now = new Date()
  const months = (now.getFullYear() - birth.getFullYear()) * 12 + (now.getMonth() - birth.getMonth())
  if (months < 12) return `${months}个月`
  return `${Math.floor(months / 12)}岁`
}

const goToFeeding = () => {
  uni.switchTab({ url: '/pages/feeding/feeding' })
}

const goToHealth = () => {
  uni.switchTab({ url: '/pages/health/health' })
}

const goToCalendar = () => {
  uni.switchTab({ url: '/pages/calendar/calendar' })
}
</script>

<style scoped>
.container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 20px;
}

.header {
  margin-bottom: 20px;
}

.title {
  font-size: 24px;
  font-weight: bold;
  color: #333;
}

.pet-card {
  background: white;
  border-radius: 16px;
  padding: 20px;
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.pet-avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background-color: #eee;
}

.pet-info {
  margin-left: 20px;
}

.pet-name {
  font-size: 20px;
  font-weight: bold;
  color: #333;
  display: block;
}

.pet-detail {
  font-size: 14px;
  color: #999;
  margin-top: 4px;
  display: block;
}

.pet-age {
  font-size: 14px;
  color: #3cc51f;
  margin-top: 4px;
  display: block;
}

.actions {
  display: flex;
  justify-content: space-around;
  background: white;
  border-radius: 16px;
  padding: 20px;
}

.action-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.action-icon {
  font-size: 32px;
  margin-bottom: 8px;
}

.action-text {
  font-size: 14px;
  color: #666;
}
</style>
