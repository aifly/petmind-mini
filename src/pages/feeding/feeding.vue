<template>
  <view class="container">
    <!-- 页面标题 -->
    <view class="page-header">
      <text class="page-title">喂养记录</text>
      <text class="page-desc">记录每一次喂食</text>
    </view>

    <!-- 宠物选择 -->
    <view class="pet-select" v-if="pets.length > 0">
      <picker 
        :range="pets" 
        range-key="name"
        @change="onPetChange"
      >
        <view class="pet-picker">
          <text class="pet-picker-label">当前宠物：</text>
          <text class="pet-picker-value">{{ selectedPet?.name || '请选择' }}</text>
          <text class="pet-picker-arrow">›</text>
        </view>
      </picker>
    </view>

    <!-- 喂养记录列表 -->
    <view class="record-list" v-if="records.length > 0">
      <view 
        class="record-card" 
        v-for="record in records" 
        :key="record.id"
      >
        <view class="record-left">
          <text class="record-icon">🍚</text>
          <view class="record-info">
            <text class="record-type">{{ record.food_type || '狗粮' }}</text>
            <text class="record-time">{{ formatTime(record.created_at) }}</text>
          </view>
        </view>
        <view class="record-right">
          <text class="record-amount">{{ record.amount || 100 }}g</text>
        </view>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <text class="empty-title">暂无喂养记录</text>
      <text class="empty-desc">点击下方按钮添加记录</text>
    </view>

    <!-- 添加记录悬浮按钮 -->
    <view class="fab" @click="showAddModal = true" v-if="pets.length > 0">
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
            @change="onModalPetChange"
          >
            <view class="picker">
              <text>{{ selectedPetInModal?.name || '请选择宠物' }}</text>
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
import { ref, onMounted } from 'vue'
import { supabaseUrl, get, post, getDeviceId } from '@/utils/supabase'

interface Pet {
  id: string
  name: string
  type: string
}

interface Record {
  id: string
  pet_id: string
  food_type: string
  amount: number
  created_at: string
}

const pets = ref<Pet[]>([])
const records = ref<Record[]>([])
const selectedPet = ref<Pet | null>(null)
const selectedPetInModal = ref<Pet | null>(null)
const showAddModal = ref(false)
const foodType = ref('')
const amount = ref('')

const foodTypes = ['狗粮', '猫粮', '零食', '罐头', '营养膏', '其他']

// 格式化时间
const formatTime = (dateStr: string) => {
  const date = new Date(dateStr)
  return `${date.getMonth() + 1}月${date.getDate()}日 ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
}

// 获取宠物列表
const fetchPets = async () => {
  try {
    const userId = getDeviceId()
    const url = `${supabaseUrl}/rest/v1/pets?select=id,name,type&user_id=eq.${userId}`
    const data = await get(url)
    pets.value = data || []
    if (pets.value.length > 0 && !selectedPet.value) {
      selectedPet.value = pets.value[0]
      selectedPetInModal.value = pets.value[0]
      fetchRecords()
    }
  } catch (error) {
    console.error('获取宠物失败:', error)
  }
}

// 获取喂养记录
const fetchRecords = async () => {
  if (!selectedPet.value) return
  try {
    const url = `${supabaseUrl}/rest/v1/growth_records?select=*&pet_id=eq.${selectedPet.value.id}&order=created_at.desc&limit=20`
    const data = await get(url)
    records.value = data || []
  } catch (error) {
    console.error('获取记录失败:', error)
  }
}

const onPetChange = (e: any) => {
  selectedPet.value = pets.value[e.detail.value]
  fetchRecords()
}

const onModalPetChange = (e: any) => {
  selectedPetInModal.value = pets.value[e.detail.value]
}

const onFoodTypeChange = (e: any) => {
  foodType.value = foodTypes[e.detail.value]
}

const addRecord = async () => {
  if (!selectedPetInModal.value) {
    uni.showToast({ title: '请选择宠物', icon: 'none' })
    return
  }
  
  try {
    await post(`${supabaseUrl}/rest/v1/growth_records`, {
      pet_id: selectedPetInModal.value.id,
      record_type: 'feeding',
      food_type: foodType.value || '狗粮',
      amount: parseInt(amount.value) || 100,
      notes: '',
      user_id: getDeviceId()
    })
    
    uni.showToast({ title: '添加成功', icon: 'success' })
    showAddModal.value = false
    fetchRecords()
    amount.value = ''
    foodType.value = ''
  } catch (error) {
    console.error('添加失败:', error)
    uni.showToast({ title: '添加失败', icon: 'none' })
  }
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

.page-header {
  margin-bottom: 32rpx;
}

.page-title {
  font-size: 48rpx;
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

/* 宠物选择 */
.pet-select {
  margin-bottom: 24rpx;
}

.pet-picker {
  display: flex;
  align-items: center;
  background: #FFFFFF;
  padding: 24rpx 28rpx;
  border-radius: 20rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
}

.pet-picker-label {
  font-size: 28rpx;
  color: #6B7280;
}

.pet-picker-value {
  flex: 1;
  font-size: 30rpx;
  color: #8B5CF6;
  font-weight: 500;
  margin-left: 8rpx;
}

.pet-picker-arrow {
  font-size: 32rpx;
  color: #9CA3AF;
}

/* 记录列表 */
.record-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.record-card {
  background: #FFFFFF;
  border-radius: 20rpx;
  padding: 24rpx;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
}

.record-left {
  display: flex;
  align-items: center;
}

.record-icon {
  font-size: 48rpx;
  margin-right: 20rpx;
}

.record-info {
  display: flex;
  flex-direction: column;
}

.record-type {
  font-size: 30rpx;
  color: #1F2937;
  font-weight: 500;
}

.record-time {
  font-size: 24rpx;
  color: #9CA3AF;
  margin-top: 4rpx;
}

.record-right {
  display: flex;
  align-items: center;
}

.record-amount {
  font-size: 32rpx;
  color: #8B5CF6;
  font-weight: 600;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 40rpx;
}

.empty-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #1F2937;
  margin-bottom: 16rpx;
}

.empty-desc {
  font-size: 28rpx;
  color: #9CA3AF;
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

.fab-icon {
  font-size: 56rpx;
  color: #FFFFFF;
  font-weight: 300;
}

/* 弹窗 */
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
  background: #FFFFFF;
  border-radius: 32rpx;
  padding: 40rpx;
  width: 80%;
  max-width: 600rpx;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 32rpx;
}

.modal-title {
  font-size: 36rpx;
  font-weight: 600;
  color: #1F2937;
}

.modal-close {
  font-size: 48rpx;
  color: #9CA3AF;
}

.form-group {
  margin-bottom: 24rpx;
}

.label {
  font-size: 28rpx;
  color: #6B7280;
  display: block;
  margin-bottom: 12rpx;
}

.picker, .input {
  width: 100%;
  height: 88rpx;
  background: #F9FAFB;
  border-radius: 16rpx;
  padding: 0 24rpx;
  font-size: 30rpx;
  box-sizing: border-box;
}

.submit-btn {
  width: 100%;
  height: 96rpx;
  background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%);
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32rpx;
  font-weight: 600;
  color: #FFFFFF;
  margin-top: 32rpx;
  border: none;
}
</style>
