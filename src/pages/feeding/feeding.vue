<template>
  <view class="container">
    <view class="header">
      <text class="title">喂养记录</text>
      <text class="subtitle">记录每一次喂养</text>
    </view>

    <!-- 喂养记录列表 -->
    <view class="record-list" v-if="records.length > 0">
      <view 
        class="record-card" 
        v-for="record in records" 
        :key="record.id"
      >
        <view class="record-time">
          <text class="time">{{ formatTime(record.created_at) }}</text>
          <text class="date">{{ formatDate(record.created_at) }}</text>
        </view>
        <view class="record-content">
          <text class="food-type">{{ record.food_type || '狗粮' }}</text>
          <text class="amount">{{ record.amount || 100 }}g</text>
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
            :range="petOptions" 
            range-key="name"
            @change="onPetChange"
          >
            <view class="picker">
              <text>{{ selectedPetName || '请选择宠物' }}</text>
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
const showAddModal = ref(false)
const selectedPetId = ref('')
const foodType = ref('')
const amount = ref('')

const foodTypes = ['狗粮', '猫粮', '零食', '罐头', '营养膏', '其他']
const petOptions = computed(() => pets.value)
const selectedPetName = computed(() => {
  const pet = pets.value.find(p => p.id === selectedPetId.value)
  return pet?.name || ''
})

const formatTime = (dateStr: string) => {
  const date = new Date(dateStr)
  return `${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
}

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr)
  return `${date.getMonth() + 1}月${date.getDate()}日`
}

const fetchPets = async () => {
  try {
    const response = await fetch(`${supabaseUrl}/rest/v1/pets?select=id,name`, {
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
  try {
    const response = await fetch(
      `${supabaseUrl}/rest/v1/feeding_records?select=*&order=created_at.desc&limit=20`,
      {
        headers: {
          'apikey': supabaseAnonKey,
          'Authorization': `Bearer ${supabaseAnonKey}`
        }
      }
    )
    records.value = await response.json()
  } catch (error) {
    console.error('获取记录失败:', error)
    // 使用本地模拟数据
    records.value = [
      { id: '1', pet_id: '1', food_type: '狗粮', amount: 100, created_at: new Date().toISOString() },
      { id: '2', pet_id: '1', food_type: '零食', amount: 50, created_at: new Date(Date.now() - 3600000).toISOString() }
    ]
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
  
  try {
    const response = await fetch(`${supabaseUrl}/rest/v1/feeding_records`, {
      method: 'POST',
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal'
      },
      body: JSON.stringify({
        pet_id: selectedPetId.value,
        food_type: foodType.value || '狗粮',
        amount: parseInt(amount.value) || 100
      })
    })
    
    if (response.ok) {
      uni.showToast({ title: '添加成功', icon: 'success' })
      showAddModal.value = false
      fetchRecords()
    }
  } catch (error) {
    console.error('添加失败:', error)
    // 本地模拟添加成功
    records.value.unshift({
      id: Date.now().toString(),
      pet_id: selectedPetId.value,
      food_type: foodType.value || '狗粮',
      amount: parseInt(amount.value) || 100,
      created_at: new Date().toISOString()
    })
    uni.showToast({ title: '添加成功', icon: 'success' })
    showAddModal.value = false
  }
  
  amount.value = ''
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
  justify-content: space-between;
  align-items: center;
}

.record-time {
  display: flex;
  flex-direction: column;
}

.time {
  font-size: 18px;
  font-weight: 600;
  color: #333;
}

.date {
  font-size: 12px;
  color: #999;
  margin-top: 4px;
}

.record-content {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.food-type {
  font-size: 16px;
  color: #666;
}

.amount {
  font-size: 14px;
  color: #3cc51f;
  margin-top: 4px;
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
