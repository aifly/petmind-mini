<template>
  <view class="container">
    <view class="header">
      <text class="title">相册</text>
      <text class="subtitle">记录宠物的美好瞬间</text>
    </view>

    <!-- 相册分类 -->
    <view class="album-tabs">
      <view 
        class="tab" 
        :class="{ active: activeTab === 'all' }"
        @click="activeTab = 'all'"
      >
        <text>全部</text>
      </view>
      <view 
        class="tab" 
        :class="{ active: activeTab === 'growth' }"
        @click="activeTab = 'growth'"
      >
        <text>成长</text>
      </view>
      <view 
        class="tab" 
        :class="{ active: activeTab === 'funny' }"
        @click="activeTab = 'funny'"
      >
        <text>趣照</text>
      </view>
    </view>

    <!-- 照片网格 -->
    <view class="photo-grid" v-if="filteredPhotos.length > 0">
      <view 
        class="photo-item" 
        v-for="(photo, index) in filteredPhotos" 
        :key="index"
        @click="previewPhoto(photo.url, index)"
      >
        <image 
          class="photo-img" 
          :src="photo.url" 
          mode="aspectFill"
        />
        <view class="photo-overlay">
          <text class="photo-date">{{ photo.date }}</text>
        </view>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <text class="empty-text">暂无照片</text>
      <text class="empty-hint">点击下方按钮上传第一张照片</text>
    </view>

    <!-- 上传按钮 -->
    <view class="fab" @click="chooseImage">
      <text class="fab-icon">+</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

interface Photo {
  url: string
  date: string
  category: string
}

const activeTab = ref('all')

// 模拟照片数据
const photos = ref<Photo[]>([
  { url: 'https://picsum.photos/300/300?random=1', date: '03-22', category: 'growth' },
  { url: 'https://picsum.photos/300/300?random=2', date: '03-20', category: 'funny' },
  { url: 'https://picsum.photos/300/300?random=3', date: '03-18', category: 'growth' },
  { url: 'https://picsum.photos/300/300?random=4', date: '03-15', category: 'funny' },
  { url: 'https://picsum.photos/300/300?random=5', date: '03-10', category: 'growth' },
  { url: 'https://picsum.photos/300/300?random=6', date: '03-05', category: 'funny' },
])

const filteredPhotos = computed(() => {
  if (activeTab.value === 'all') {
    return photos.value
  }
  return photos.value.filter(p => p.category === activeTab.value)
})

const chooseImage = () => {
  uni.chooseImage({
    count: 9,
    sizeType: ['compressed'],
    sourceType: ['album', 'camera'],
    success: (res) => {
      // 模拟添加照片（实际应该上传到服务器）
      res.tempFilePaths.forEach((path, index) => {
        const today = new Date()
        const dateStr = `${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`
        photos.value.unshift({
          url: path,
          date: dateStr,
          category: 'growth'
        })
      })
      uni.showToast({ title: '上传成功', icon: 'success' })
    }
  })
}

const previewPhoto = (url: string, index: number) => {
  const urls = filteredPhotos.value.map(p => p.url)
  uni.previewImage({
    current: index,
    urls: urls
  })
}
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

.album-tabs {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.tab {
  padding: 8px 20px;
  background: white;
  border-radius: 20px;
  font-size: 14px;
  color: #666;
}

.tab.active {
  background: #3cc51f;
  color: white;
}

.photo-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.photo-item {
  width: calc((100% - 16px) / 3);
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
  position: relative;
}

.photo-img {
  width: 100%;
  height: 100%;
}

.photo-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0,0,0,0.5));
  padding: 4px 8px;
}

.photo-date {
  font-size: 10px;
  color: white;
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
</style>
