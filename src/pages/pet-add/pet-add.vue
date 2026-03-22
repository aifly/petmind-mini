<template>
  <view class="container">
    <view class="header">
      <text class="title">添加宠物</text>
    </view>

    <view class="form">
      <!-- 宠物名称 -->
      <view class="form-group">
        <text class="label">宠物名称 *</text>
        <input 
          class="input" 
          v-model="pet.name" 
          placeholder="请输入宠物名称"
        />
      </view>

      <!-- 宠物类型 -->
      <view class="form-group">
        <text class="label">宠物类型 *</text>
        <picker 
          :range="petTypes" 
          range-key="name"
          @change="onTypeChange"
        >
          <view class="picker">
            <text>{{ selectedTypeName || '请选择宠物类型' }}</text>
          </view>
        </picker>
      </view>

      <!-- 品种 -->
      <view class="form-group">
        <text class="label">品种</text>
        <input 
          class="input" 
          v-model="pet.breed" 
          placeholder="请输入品种（选填）"
        />
      </view>

      <!-- 性别 -->
      <view class="form-group">
        <text class="label">性别</text>
        <picker 
          :range="genders" 
          @change="onGenderChange"
        >
          <view class="picker">
            <text>{{ pet.gender || '请选择性别' }}</text>
          </view>
        </picker>
      </view>

      <!-- 出生日期 -->
      <view class="form-group">
        <text class="label">出生日期</text>
        <picker 
          mode="date" 
          :value="pet.birth_date" 
          @change="onBirthDateChange"
        >
          <view class="picker">
            <text>{{ pet.birth_date || '请选择出生日期' }}</text>
          </view>
        </picker>
      </view>

      <!-- 体重 -->
      <view class="form-group">
        <text class="label">体重 (kg)</text>
        <input 
          class="input" 
          type="number"
          v-model="pet.weight" 
          placeholder="请输入体重（选填）"
        />
      </view>

      <!-- 备注 -->
      <view class="form-group">
        <text class="label">备注</text>
        <textarea 
          class="textarea" 
          v-model="pet.notes" 
          placeholder="请输入备注（选填）"
        />
      </view>

      <!-- 提交按钮 -->
      <button class="submit-btn" @click="submitPet">保存</button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { supabaseUrl, supabaseAnonKey } from '@/utils/supabase'

const petTypes = [
  { id: 'dog', name: '🐕 狗狗' },
  { id: 'cat', name: '🐱 猫咪' },
  { id: 'bird', name: '🐦 鸟类' },
  { id: 'rabbit', name: '🐰 兔子' },
  { id: 'hamster', name: '🐹 仓鼠' },
  { id: 'fish', name: '🐠 鱼类' },
  { id: 'other', name: '🐾 其他' }
]

const genders = ['公', '母', '未知']

const pet = ref({
  name: '',
  type: '',
  breed: '',
  gender: '',
  birth_date: '',
  weight: '',
  notes: ''
})

const selectedTypeName = computed(() => {
  if (!pet.value.type) return ''
  const found = petTypes.find(t => t.id === pet.value.type)
  return found?.name || ''
})

const onTypeChange = (e: any) => {
  pet.value.type = petTypes[e.detail.value].id
}

const onGenderChange = (e: any) => {
  pet.value.gender = genders[e.detail.value]
}

const onBirthDateChange = (e: any) => {
  pet.value.birth_date = e.detail.value
}

const submitPet = async () => {
  // 验证
  if (!pet.value.name) {
    uni.showToast({ title: '请输入宠物名称', icon: 'none' })
    return
  }
  if (!pet.value.type) {
    uni.showToast({ title: '请选择宠物类型', icon: 'none' })
    return
  }

  uni.showLoading({ title: '保存中...' })

  try {
    // 生成一个匿名的 user_id（小程序没有登录，可以用设备标识）
    const deviceId = uni.getStorageSync('deviceId') || 'anonymous_' + Date.now()
    uni.setStorageSync('deviceId', deviceId)

    const response = await fetch(`${supabaseUrl}/rest/v1/pets`, {
      method: 'POST',
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal'
      },
      body: JSON.stringify({
        name: pet.value.name,
        type: pet.value.type,
        breed: pet.value.breed || null,
        gender: pet.value.gender || null,
        birth_date: pet.value.birth_date || null,
        weight: pet.value.weight ? parseFloat(pet.value.weight) : null,
        notes: pet.value.notes || null,
        user_id: deviceId,
        photo_url: null
      })
    })

    if (response.ok) {
      uni.showToast({ title: '添加成功', icon: 'success' })
      setTimeout(() => {
        uni.navigateBack()
      }, 1500)
    } else {
      const error = await response.json()
      throw new Error(error.message || '添加失败')
    }
  } catch (error: any) {
    console.error('添加宠物失败:', error)
    uni.showToast({ title: error.message || '添加失败', icon: 'none' })
  } finally {
    uni.hideLoading()
  }
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

.form {
  background: white;
  border-radius: 16px;
  padding: 20px;
}

.form-group {
  margin-bottom: 20px;
}

.label {
  font-size: 14px;
  color: #666;
  display: block;
  margin-bottom: 8px;
}

.input, .picker, .textarea {
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
