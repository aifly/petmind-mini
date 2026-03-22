<template>
  <view class="container">
    <!-- 页面标题 -->
    <view class="page-header">
      <text class="page-title">健康记录</text>
      <text class="page-desc">关注宠物健康每一天</text>
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

    <!-- 健康数据卡片 -->
    <view class="health-cards" v-if="selectedPet">
      <view class="health-card">
        <text class="card-icon">⚖️</text>
        <text class="card-value">{{ latestWeight || '--' }} kg</text>
        <text class="card-label">体重</text>
      </view>
      <view class="health-card">
        <text class="card-icon">🌡️</text>
        <text class="card-value">{{ latestTemp || '--' }} °C</text>
        <text class="card-label">体温</text>
      </view>
      <view class="health-card">
        <text class="card-icon">💩</text>
        <text class="card-value">正常</text>
        <text class="card-label">排便</text>
      </view>
    </view>

    <!-- 健康记录列表 -->
    <view class="section-title" v-if="records.length > 0">
      <text>记录详情</text>
    </view>

    <view class="record-list" v-if="records.length > 0">
      <view 
        class="record-card" 
        v-for="record in records" 
        :key="record.id"
      >
        <view class="record-icon">
          <text>{{ getHealthIcon(record.record_type) }}</text>
        </view>
        <view class="record-content">
          <text class="record-title">{{ getHealthTypeName(record.record_type) }}</text>
          <text class="record-desc" v-if="record.notes">{{ record.notes }}</text>
        </view>
        <text class="record-date">{{ formatDate(record.created_at) }}</text>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <text class="empty-title">暂无健康记录</text>
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
          <text class="modal-title">添加健康记录</text>
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
          <text class="label">记录类型</text>
          <picker 
            :range="healthTypes" 
            @change="onHealthTypeChange"
          >
            <view class="picker">
              <text>{{ healthType || '请选择类型' }}</text>
            </view>
          </picker>
        </view>

        <view class="form-group" v-if="healthType === '体重'">
          <text class="label">体重 (kg)</text>
          <input class="input" type="digit" v-model="weight" placeholder="请输入体重" />
        </view>

        <view class="form-group" v-if="healthType === '体温'">
          <text class="label">体温 (°C)</text>
          <input class="input" type="digit" v-model="temperature" placeholder="请输入体温" />
        </view>

        <view class="form-group">
          <text class="label">备注</text>
          <textarea class="textarea" v-model="notes" placeholder="请输入备注" />
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
}

interface Record {
  id: string
  pet_id: string
  record_type: string
  weight?: number
  temperature?: number
  notes?: string
  created_at: string
}

const pets = ref<Pet[]>([])
const records = ref<Record[]>([])
const selectedPet = ref<Pet | null>(null)
const selectedPetInModal = ref<Pet | null>(null)
const showAddModal = ref(false)
const healthType = ref('')
const weight = ref('')
const temperature = ref('')
const notes = ref('')
const latestWeight = ref('--')
const latestTemp = ref('--')

const healthTypes = ['体重', '体温', '驱虫', '疫苗', '生病', '其他']

// 获取健康图标
const getHealthIcon = (type?: string) => {
  const icons: Record<string, string> = {
    'weight': '⚖️',
    'temperature': '🌡️',
    'deworming': '💊',
    'vaccine': '💉',
    'sick': '🤒',
    'other': '📝'
  }
  return icons[type || ''] || '📝'
}

const getHealthTypeName = (type?: string) => {
  const names: Record<string, string> = {
    'weight': '体重记录',
    'temperature': '体温记录',
    'deworming': '驱虫',
    'vaccine': '疫苗',
    'sick': '生病',
    'feeding': '喂养',
    'other': '其他'
  }
  return names[type || ''] || '健康记录'
}

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr)
  return `${date.getMonth() + 1}/${date.getDate()}`
}

// 获取宠物列表
const fetchPets = async () => {
  try {
    const userId = getDeviceId()
    const url = `${supabaseUrl}/rest/v1/pets?select=id,name&user_id=eq.${userId}`
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

// 获取健康记录
const fetchRecords = async () => {
  if (!selectedPet.value) return
  try {
    // 获取体重和体温记录
    const url = `${supabaseUrl}/rest/v1/growth_records?select=*&pet_id=eq.${selectedPet.value.id}&order=created_at.desc&limit=20`
    const data = await get(url)
    records.value = data || []
    
    // 计算最新体重和体温
    const weightRecord = records.value.find(r => r.record_type === 'weight')
    const tempRecord = records.value.find(r => r.record_type === 'temperature')
    latestWeight.value = weightRecord?.weight?.toString() || '--'
    latestTemp.value = tempRecord?.temperature?.toString() || '--'
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

const onHealthTypeChange = (e: any) => {
  healthType.value = healthTypes[e.detail.value]
}

const addRecord = async () => {
  if (!selectedPetInModal.value || !healthType.value) {
    uni.showToast({ title: '请填写完整信息', icon: 'none' })
    return
  }
  
  try {
    const recordTypes: Record<string, string> = {
      '体重': 'weight',
      '体温': 'temperature',
      '驱虫': 'deworming',
      '疫苗': 'vaccine',
      '生病': 'sick',
      '其他': 'other'
    }
    
    await post(`${supabaseUrl}/rest/v1/growth_records`, {
      pet_id: selectedPetInModal.value.id,
      record_type: recordTypes[healthType.value],
      weight: weight.value ? parseFloat(weight.value) : null,
      temperature: temperature.value ? parseFloat(temperature.value) : null,
      notes: notes.value || null,
      user_id: getDeviceId()
    })
    
    uni.showToast({ title: '添加成功', icon: 'success' })
    showAddModal.value = false
    fetchRecords()
    
    // 重置表单
    healthType.value = ''
    weight.value = ''
    temperature.value = ''
    notes.value = ''
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

/* 健康卡片 */
.health-cards {
  display: flex;
  gap: 16rpx;
  margin-bottom: 32rpx;
}

.health-card {
  flex: 1;
  background: #FFFFFF;
  border-radius: 20rpx;
  padding: 24rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
}

.card-icon {
  font-size: 40rpx;
  margin-bottom: 12rpx;
}

.card-value {
  font-size: 32rpx;
  font-weight: 700;
  color: #1F2937;
}

.card-label {
  font-size: 24rpx;
  color: #9CA3AF;
  margin-top: 8rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #1F2937;
  margin-bottom: 16rpx;
}

.record-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.record-card {
  background: #FFFFFF;
  border-radius: 16rpx;
  padding: 24rpx;
  display: flex;
  align-items: center;
}

.record-icon {
  font-size: 40rpx;
  margin-right: 16rpx;
}

.record-content {
  flex: 1;
}

.record-title {
  font-size: 30rpx;
  color: #1F2937;
  display: block;
}

.record-desc {
  font-size: 26rpx;
  color: #9CA3AF;
  margin-top: 4rpx;
  display: block;
}

.record-date {
  font-size: 24rpx;
  color: #D1D5DB;
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
  max-height: 80vh;
  overflow-y: auto;
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

.picker, .input, .textarea {
  width: 100%;
  background: #F9FAFB;
  border-radius: 16rpx;
  padding: 20rpx;
  font-size: 30rpx;
  box-sizing: border-box;
}

.textarea {
  min-height: 120rpx;
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
