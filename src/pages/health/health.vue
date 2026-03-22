<template>
  <view class="container">
    <view class="header">
      <text class="title">健康记录</text>
      <text class="subtitle">关注宠物健康每一天</text>
    </view>

    <!-- 健康数据卡片 -->
    <view class="health-cards">
      <view class="health-card">
        <text class="card-icon">❤️</text>
        <text class="card-value">{{ stats.weight || '--' }} kg</text>
        <text class="card-label">体重</text>
      </view>
      <view class="health-card">
        <text class="card-icon">🌡️</text>
        <text class="card-value">{{ stats.temperature || '--' }} °C</text>
        <text class="card-label">体温</text>
      </view>
      <view class="health-card">
        <text class="card-icon">💩</text>
        <text class="card-value">{{ stats.poopStatus || '正常' }}</text>
        <text class="card-label">排便</text>
      </view>
    </view>

    <!-- 记录列表 -->
    <view class="section-title">
      <text>健康记录</text>
    </view>

    <view class="record-list" v-if="records.length > 0">
      <view 
        class="record-card" 
        v-for="record in records" 
        :key="record.id"
      >
        <view class="record-icon">
          <text>{{ getHealthIcon(record.health_type) }}</text>
        </view>
        <view class="record-content">
          <text class="record-title">{{ getHealthTypeName(record.health_type) }}</text>
          <text class="record-desc">{{ record.notes || '暂无备注' }}</text>
        </view>
        <text class="record-date">{{ formatDate(record.created_at) }}</text>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <text class="empty-text">暂无健康记录</text>
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
          <text class="modal-title">添加健康记录</text>
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
          <text class="label">健康类型</text>
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
          <input 
            class="input" 
            type="number" 
            v-model="weight" 
            placeholder="请输入体重"
          />
        </view>

        <view class="form-group" v-if="healthType === '体温'">
          <text class="label">体温 (°C)</text>
          <input 
            class="input" 
            type="number" 
            v-model="temperature" 
            placeholder="请输入体温"
          />
        </view>

        <view class="form-group">
          <text class="label">备注</text>
          <textarea 
            class="textarea" 
            v-model="notes" 
            placeholder="请输入备注"
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
  health_type: string
  weight?: number
  temperature?: number
  notes?: string
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
const healthType = ref('')
const weight = ref('')
const temperature = ref('')
const notes = ref('')

const stats = ref({
  weight: '--',
  temperature: '--',
  poopStatus: '正常'
})

const healthTypes = ['体重', '体温', '排便', '驱虫', '疫苗', '生病', '其他']
const petOptions = computed(() => pets.value)
const selectedPetName = computed(() => {
  const pet = pets.value.find(p => p.id === selectedPetId.value)
  return pet?.name || ''
})

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr)
  return `${date.getMonth() + 1}/${date.getDate()}`
}

const getHealthIcon = (type: string) => {
  const icons: Record<string, string> = {
    '体重': '⚖️',
    '体温': '🌡️',
    '排便': '💩',
    '驱虫': '💊',
    '疫苗': '💉',
    '生病': '🤒',
    '其他': '📝'
  }
  return icons[type] || '📝'
}

const getHealthTypeName = (type: string) => {
  return type || '健康记录'
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
      `${supabaseUrl}/rest/v1/health_records?select=*&order=created_at.desc&limit=20`,
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
    // 模拟数据
    records.value = [
      { id: '1', pet_id: '1', health_type: '体重', weight: 5.5, notes: '体重稳定', created_at: new Date().toISOString() },
      { id: '2', pet_id: '1', health_type: '体温', temperature: 38.5, notes: '体温正常', created_at: new Date(Date.now() - 86400000).toISOString() }
    ]
  }
}

const onPetChange = (e: any) => {
  selectedPetId.value = pets.value[e.detail.value].id
}

const onHealthTypeChange = (e: any) => {
  healthType.value = healthTypes[e.detail.value]
}

const addRecord = async () => {
  if (!selectedPetId.value || !healthType.value) {
    uni.showToast({ title: '请填写完整信息', icon: 'none' })
    return
  }
  
  // 本地模拟添加成功
  records.value.unshift({
    id: Date.now().toString(),
    pet_id: selectedPetId.value,
    health_type: healthType.value,
    weight: weight.value ? parseFloat(weight.value) : undefined,
    temperature: temperature.value ? parseFloat(temperature.value) : undefined,
    notes: notes.value,
    created_at: new Date().toISOString()
  })
  
  uni.showToast({ title: '添加成功', icon: 'success' })
  showAddModal.value = false
  
  // 重置表单
  weight.value = ''
  temperature.value = ''
  notes.value = ''
  healthType.value = ''
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

.health-cards {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
}

.health-card {
  flex: 1;
  background: white;
  border-radius: 12px;
  padding: 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.card-icon {
  font-size: 24px;
  margin-bottom: 8px;
}

.card-value {
  font-size: 20px;
  font-weight: bold;
  color: #333;
}

.card-label {
  font-size: 12px;
  color: #999;
  margin-top: 4px;
}

.section-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin-bottom: 12px;
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
  font-size: 24px;
  margin-right: 12px;
}

.record-content {
  flex: 1;
}

.record-title {
  font-size: 16px;
  color: #333;
  display: block;
}

.record-desc {
  font-size: 14px;
  color: #999;
  margin-top: 4px;
  display: block;
}

.record-date {
  font-size: 12px;
  color: #ccc;
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
  max-height: 80vh;
  overflow-y: auto;
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

.picker, .input, .textarea {
  background: #f5f5f5;
  border-radius: 8px;
  padding: 12px;
  font-size: 16px;
  width: 100%;
  box-sizing: border-box;
}

.textarea {
  min-height: 80px;
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
