<template>
  <view class="container">
    <!-- 顶部标题 -->
    <view class="header">
      <text class="title">我的宠物</text>
      <text class="subtitle">PetMind 宠物助手</text>
    </view>

    <!-- 宠物列表 -->
    <view class="pet-list" v-if="pets.length > 0">
      <view 
        class="pet-card" 
        v-for="pet in pets" 
        :key="pet.id"
        @click="goToPetDetail(pet.id)"
      >
        <image 
          class="pet-avatar" 
          :src="pet.avatar_url || '/static/default-pet.png'" 
          mode="aspectFill"
        />
        <view class="pet-info">
          <text class="pet-name">{{ pet.name }}</text>
          <text class="pet-breed">{{ pet.breed || '未知品种' }}</text>
        </view>
        <text class="pet-age">{{ calculateAge(pet.birth_date) }}</text>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <image class="empty-icon" src="/static/empty-pets.png" mode="widthFix" />
      <text class="empty-text">还没有添加宠物</text>
      <button class="add-btn" @click="addPet">添加宠物</button>
    </view>

    <!-- 添加宠物按钮 -->
    <view class="fab" @click="addPet" v-if="pets.length > 0">
      <text class="fab-icon">+</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabaseUrl, supabaseAnonKey } from '@/utils/supabase'

interface Pet {
  id: string
  name: string
  species: string
  breed: string
  birth_date: string
  avatar_url: string
}

const pets = ref<Pet[]>([])

// 计算宠物年龄
const calculateAge = (birthDate: string) => {
  if (!birthDate) return '未知'
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
  try {
    const response = await fetch(`${supabaseUrl}/rest/v1/pets?select=*`, {
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`
      }
    })
    const data = await response.json()
    pets.value = data || []
  } catch (error) {
    console.error('获取宠物列表失败:', error)
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
  background-color: #f5f5f5;
  padding: 20px;
}

.header {
  margin-bottom: 20px;
}

.title {
  font-size: 28px;
  font-weight: bold;
  color: #333;
  display: block;
}

.subtitle {
  font-size: 14px;
  color: #999;
  margin-top: 4px;
  display: block;
}

.pet-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.pet-card {
  background: white;
  border-radius: 16px;
  padding: 16px;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.pet-avatar {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  background-color: #eee;
}

.pet-info {
  flex: 1;
  margin-left: 16px;
}

.pet-name {
  font-size: 18px;
  font-weight: 600;
  color: #333;
  display: block;
}

.pet-breed {
  font-size: 14px;
  color: #999;
  margin-top: 4px;
  display: block;
}

.pet-age {
  font-size: 14px;
  color: #666;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
}

.empty-icon {
  width: 200px;
  margin-bottom: 20px;
}

.empty-text {
  font-size: 16px;
  color: #999;
  margin-bottom: 20px;
}

.add-btn {
  background: #3cc51f;
  color: white;
  border: none;
  padding: 12px 40px;
  border-radius: 25px;
  font-size: 16px;
}

.fab {
  position: fixed;
  right: 20px;
  bottom: 40px;
  width: 56px;
  height: 56px;
  background: #3cc51f;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(60, 197, 31, 0.4);
}

.fab-icon {
  font-size: 32px;
  color: white;
  line-height: 1;
}
</style>
