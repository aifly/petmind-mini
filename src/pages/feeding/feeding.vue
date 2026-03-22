<template>
  <view class="container">
    <view class="header">
      <text class="title">喂养记录</text>
      <text class="subtitle">记录每一次喂养</text>
    </view>

    <!-- 加载状态 -->
    <view v-if="loading" class="loading">
      <text>加载中...</text>
    </view>

    <!-- 喂养记录列表 -->
    <view class="record-list" v-else-if="records.length > 0">
      <view 
        class="record-card" 
        v-for="record in records" 
        :key="record.id"
      >
        <view class="record-icon">
          <text>{{ getFoodIcon(record.food_type) }}</text>
        </view>
        <view class="record-content">
          <text class="food-type">{{ record.food_type || '狗粮' }}</text>
          <text class="pet-name">{{ getPetName(record.pet_id) }}</text>
        </view>
        <view class="record-right">
          <text class="amount">{{ record.amount || 100 }}g</text>
          <text class="time">{{ formatTime(record.created_at) }}</text>
        </view>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <text class="empty-text">暂无喂养记录</text>
      <text class="empty-hint">点击下方按钮添加记录</text>
    </view>

    <!-- 添加记录按钮 -->
    <view class="fab" @click="showAddModal = true">
      <text class="fab-icon">+</text>
    </view>

    <!-- 添加记录弹窗 -->
    <view class="modal-mask" v-if="showAddModal" @click="showAddModal = false">
      <view class="modal" @click.stop>
        <view class="modal-header">
          <text class="modal-title">添加喂养记录</text>
          <text class="modal-close" @click="showAddModal = false">×</text>
        </view>
        
        <view class="form-group">
          <text class="label">宠物</text>
          <picker 
            :range="pets" 
            range-key="name"
            @change="onPetChange"
          >
            <view class="picker">
              <text>{{ selectedPet?.name || '请选择宠物' }}</text>
            </view>
          </picker>
        </view>

        <view class="form-group">
          <text class="label">食物类型</text>
          <picker 
            :range="foodTypes" 
            @change="onFoodTypeChange"
          >
            <view class="picker">
              <text>{{ foodType || '请选择食物' }}</text>
            </view>
          </picker>
        </view>

        <view class="form-group">
          <text class="label">数量 (g)</text>
          <input 
            class="input" 
            type="number" 
            v-model="amount" 
            placeholder="请输入数量"
          />
        </view>

        <button class="submit-btn" @click="addRecord">保存</button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { supabaseUrl, supabaseAnonKey } from '@/utils/supabase'

interface Record {
  id: string
  pet_id: string
  pet_name?: string
  food_type: string
  amount: number
  created_at: string
}

interface Pet {
  id: string
  name: string
}

const records = ref<Record[]>([])
const pets = ref<Pet[]>([])
const loading = ref(true)
const showAddModal = ref(false)
const selectedPetId = ref('')
const foodType = ref('')
const amount = ref('')

const foodTypes = ['狗粮', '猫粮', '零食', '罐头', '营养膏', '其他']

const selectedPet = computed(() => {
  return pets.value.find(p => p.id === selectedPetId.value)
})

const getFoodIcon = (type: string) => {
  const icons: Record<string, string> = {
    '狗粮': '🍖',
    '猫粮': '🐟',
    '零食': '🍪',
    '罐头': '🥫',
    '营养膏': '💊',
    '其他': '🍽️'
  }
  return icons[type] || '🍽️'
}

const getPetName = (petId: string) => {
  const pet = pets.value.find(p => p.id === petId)
  return pet?.name || ''
}

const formatTime = (dateStr: string) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getMonth() + 1}/${date.getDate()} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
}

const fetchPets = async () => {
  try {
    const response = await fetch(`${supabaseUrl}/rest/v1/pets?select=id,name&order=created_at.desc`, {
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`
      }
    })
    pets.value = await response.json()
    if (pets.value.length > 0) {
      selectedPetId.value = pets.value[0].id
    }
  } catch (error) {
    console.error('获取宠物失败:', error)
  }
}

const fetchRecords = async () => {
  loading.value = true
  try {
    const deviceId = uni.getStorageSync('deviceId') || 'anonymous'
    
    const response = await fetch(
      `${supabaseUrl}/rest/v1/growth_records?pet_id=eq.${deviceId}&or=(pet_id.null,pet_id.not.is.null)&order=created_at.desc&limit=50`,
      {
        headers: {
          'apikey': supabaseAnonKey,
          'Authorization': `Bearer ${supabaseAnonKey}`
        }
      }
    )
    
    if (response.ok) {
      records.value = await response.json()
      
      // 如果没有数据，显示所有记录（不限制 pet_id）
      if (records.value.length === 0) {
        const allResponse = await fetch(
          `${supabaseUrl}/rest/v1/growth_records?record_type=eq.喂养&order=created_at.desc&limit=20`,
          {
            headers: {
              'apikey': supabaseAnonKey,
              'Authorization': `Bearer ${supabaseAnonKey}`
            }
          }
        )
        if (allResponse.ok) {
          records.value = await allResponse.json()
        }
      }
    }
  } catch (error) {
    console.error('获取记录失败:', error)
  } finally {
    loading.value = false
  }
}

const onPetChange = (e: any) => {
  selectedPetId.value = pets.value[e.detail.value].id
}

const onFoodTypeChange = (e: any) => {
  foodType.value = foodTypes[e.detail.value]
}

const addRecord = async () => {
  if (!selectedPetId.value) {
    uni.showToast({ title: '请选择宠物', icon: 'none' })
    return
  }
  
  uni.showLoading({ title: '保存中...' })
  
  try {
    const deviceId = uni.getStorageSync('deviceId') || 'anonymous'
    
    const response = await fetch(`${supabaseUrl}/rest/v1/growth_records`, {
      method: 'POST',
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal'
      },
      body: JSON.stringify({
        pet_id: selectedPetId.value,
        record_type: '喂养',
        food_type: foodType.value || '狗粮',
        amount: parseInt(amount.value) || 100,
        notes: '',
        user_id: deviceId
      })
    })
    
    if (response.ok) {
      uni.showToast({ title: '添加成功', icon: 'success' })
      showAddModal.value = false
      amount.value = ''
      fetchRecords()
    } else {
      throw new Error('添加失败')
    }
  } catch (error) {
    console.error('添加失败:', error)
    uni.showToast({ title: '添加失败', icon: 'none' })
  } finally {
    uni.hideLoading()
  }
}

onMounted(() => {
  fetchPets()
  fetchRecords()
})
</script>

<style scoped>
.container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 20px;
  padding-bottom: 100px;
}

.header {
  margin-bottom: 20px;
}

.title {
  font-size: 24px;
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

.loading {
  text-align: center;
  padding: 40px;
  color: #999;
}

.record-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.record-card {
  background: white;
  border-radius: 12px;
  padding: 16px;
  display: flex;
  align-items: center;
}

.record-icon {
  font-size: 28px;
  margin-right: 12px;
}

.record-content {
  flex: 1;
}

.food-type {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  display: block;
}

.pet-name {
  font-size: 14px;
  color: #999;
  margin-top: 4px;
  display: block;
}

.record-right {
  text-align: right;
}

.amount {
  font-size: 16px;
  color: #3cc51f;
  display: block;
}

.time {
  font-size: 12px;
  color: #ccc;
  margin-top: 4px;
  display: block;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 60px 20px;
}

.empty-text {
  font-size: 16px;
  color: #999;
}

.empty-hint {
  font-size: 14px;
  color: #ccc;
  margin-top: 8px;
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

.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}

.modal {
  background: white;
  border-radius: 16px;
  padding: 24px;
  width: 80%;
  max-width: 320px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.modal-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.modal-close {
  font-size: 24px;
  color: #999;
}

.form-group {
  margin-bottom: 16px;
}

.label {
  font-size: 14px;
  color: #666;
  display: block;
  margin-bottom: 8px;
}

.picker, .input {
  background: #f5f5f5;
  border-radius: 8px;
  padding: 12px;
  font-size: 16px;
}

.input {
  width: 100%;
  box-sizing: border-box;
}

.submit-btn {
  background: #3cc51f;
  color: white;
  border: none;
  padding: 14px;
  border-radius: 25px;
  font-size: 16px;
  margin-top: 20px;
  width: 100%;
}
</style>
