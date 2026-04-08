<template>
  <view class="home-page">
    <!-- 顶部渐变头部 -->
    <view class="home-header">
      <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>
      
      <!-- 问候语 -->
      <view class="header-content">
        <view class="greeting-wrap">
          <text class="greeting-hello">🌅 {{ greeting }}</text>
          <text class="greeting-title">魔法<text class="highlight">口袋</text>已就绪</text>
        </view>
        <view class="header-logo">
          <image src="/static/logo.svg" mode="aspectFit" class="logo-img" />
        </view>
      </view>
    </view>

    <!-- 滚动内容区 -->
    <scroll-view class="scroll-area" scroll-y>
      
      <!-- 功能模块入口 横排双列 -->
      <view class="module-cards">
        <!-- 卡片 A：解码器 -->
        <view class="module-card module-card-decode" @click="goToDecode">
          <text class="deco-emoji">🐾</text>
          <text class="deco-icon">✨</text>
          <view class="module-badge">🔥 最热</view>
          <text class="module-title">行为&\n性格解码</text>
          <view class="module-btn">解码 →</view>
        </view>

        <!-- 卡片 B：急救箱 -->
        <view class="module-card module-card-health" @click="goToHealth">
          <text class="deco-emoji">🩺</text>
          <text class="deco-icon">💙</text>
          <view class="module-badge">🛡 专业</view>
          <text class="module-title">健康\n急救箱</text>
          <view class="module-btn" style="background:rgba(255,255,255,0.2)">问诊 →</view>
        </view>
      </view>

      <!-- 精选文章横向滚动 -->
      <view class="section-header">
        <text class="section-title">🌟 精选推荐</text>
        <text class="section-more" @click="goToArticles">更多 ›</text>
      </view>
      
      <scroll-view class="featured-scroll" scroll-x>
        <view class="featured-card" v-for="(article, index) in featuredArticles" :key="index" @click="goToArticle(article.id)">
          <view class="featured-cover" :class="article.coverClass">
            <text class="cover-emoji">{{ article.emoji }}</text>
          </view>
          <view class="featured-body">
            <text class="featured-cat" :class="article.catClass">{{ article.category }}</text>
            <text class="featured-title">{{ article.title }}</text>
          </view>
        </view>
      </scroll-view>

      <!-- 最新文章列表 -->
      <view class="section-header">
        <text class="section-title">📰 最新文章</text>
        <text class="section-more" @click="goToArticles">全部 ›</text>
      </view>
      
      <view class="article-list">
        <view class="article-item" v-for="(article, index) in latestArticles" :key="index" @click="goToArticle(article.id)">
          <view class="article-thumb" :class="article.thumbClass">
            <text class="thumb-emoji">{{ article.emoji }}</text>
          </view>
          <view class="article-meta">
            <text class="a-tag" :class="article.tagClass">{{ article.category }}</text>
            <text class="a-title">{{ article.title }}</text>
            <text class="a-desc">{{ article.desc }}</text>
          </view>
        </view>
      </view>

      <!-- 底部提示 -->
      <view class="home-footer">
        <text>AI 建议仅供参考</text>
        <view class="dot"></view>
        <text>危急情况请立即就医</text>
      </view>
      
      <view class="safe-area"></view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getDeviceId, supabaseUrl, get } from '@/utils/supabase'

// 系统信息
const systemInfo = uni.getSystemInfoSync()
const statusBarHeight = systemInfo.statusBarHeight || 44

// 问候语
const greeting = ref('早上好')

// 精选文章（mock 数据，后续从接口获取）
const featuredArticles = ref([
  { id: '1', emoji: '🐱', coverClass: 'orange', catClass: '', category: '性格解读', title: '猫咪盯着你看是什么意思？' },
  { id: '2', emoji: '🐶', coverClass: 'green', catClass: 'teal', category: '健康知识', title: '狗狗嘴巴发臭的5大原因' },
  { id: '3', emoji: '💊', coverClass: 'blue', catClass: 'blue-cat', category: '用药指南', title: '猫咪绝对不能吃的10种食物' },
  { id: '4', emoji: '🐾', coverClass: 'purple', catClass: 'purple-cat', category: '行为训练', title: '如何让狗狗不再乱叫？' },
])

// 最新文章
const latestArticles = ref([
  { id: '1', emoji: '🐈', thumbClass: 'th-orange', tagClass: '', category: '小贴士', title: '怎么判断猫咪是否开心？', desc: '耳朵、尾巴、叫声都是信号...' },
  { id: '2', emoji: '🦷', thumbClass: 'th-green', tagClass: 'green', category: '健康提醒', title: '宠物每年必做的4项检查', desc: '别等生病了才后悔没早做...' },
  { id: '3', emoji: '🏠', thumbClass: 'th-blue', tagClass: 'blue', category: '生活方式', title: '养宠新手必看的准备清单', desc: '第一次养宠之前先看这篇...' },
])

// 获取问候语
const getGreeting = () => {
  const hour = new Date().getHours()
  if (hour < 6) return '晚上好'
  if (hour < 9) return '早上好'
  if (hour < 12) return '上午好'
  if (hour < 14) return '中午好'
  if (hour < 18) return '下午好'
  return '晚上好'
}

// 获取文章列表
const fetchArticles = async () => {
  try {
    const url = `${supabaseUrl}/rest/v1/articles?select=id,title,summary,icon,category,cover_url,published_at&status=eq.published&order=published_at.desc&limit=10`
    const data = await get(url)
    if (data && data.length > 0) {
      // 映射到组件数据格式
      // TODO: 根据实际数据格式调整
    }
  } catch (error) {
    console.error('获取文章失败:', error)
  }
}

// 页面跳转
const goToDecode = () => {
  uni.navigateTo({ url: '/pages/decode/decode' })
}

const goToHealth = () => {
  uni.navigateTo({ url: '/pages/health/health' })
}

const goToArticle = (id: string) => {
  // TODO: 文章详情页
  uni.showToast({ title: '文章详情开发中', icon: 'none' })
}

const goToArticles = () => {
  // TODO: 文章列表页
  uni.showToast({ title: '文章列表开发中', icon: 'none' })
}

onMounted(() => {
  greeting.value = getGreeting()
  fetchArticles()
})
</script>

<style scoped>
.home-page {
  min-height: 100vh;
  background: #F7F8FA;
  display: flex;
  flex-direction: column;
}

/* 顶部渐变头部 */
.home-header {
  background: linear-gradient(165deg, #1A1A3E 0%, #2D1B69 50%, #1A1A2E 100%);
  flex-shrink: 0;
  position: relative;
  overflow: hidden;
}

.home-header::before {
  content: '';
  position: absolute;
  top: -60px;
  right: -40px;
  width: 200px;
  height: 200px;
  background: radial-gradient(circle, rgba(255, 123, 84, 0.3) 0%, transparent 70%);
  border-radius: 50%;
}

.home-header::after {
  content: '';
  position: absolute;
  bottom: -30px;
  left: -20px;
  width: 150px;
  height: 150px;
  background: radial-gradient(circle, rgba(67, 184, 156, 0.25) 0%, transparent 70%);
  border-radius: 50%;
}

.status-bar {
  width: 100%;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 8px 16px 28px;
  position: relative;
  z-index: 1;
}

.greeting-hello {
  display: block;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
  margin-bottom: 4px;
}

.greeting-title {
  display: block;
  font-size: 22px;
  font-weight: 700;
  color: #fff;
  letter-spacing: -0.3px;
}

.greeting-title .highlight {
  color: #FF9A76;
}

.header-logo {
  width: 40px;
  height: 40px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.logo-img {
  width: 28px;
  height: 28px;
}

/* 滚动区 */
.scroll-area {
  flex: 1;
}

/* 功能模块入口 */
.module-cards {
  padding: 16px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.module-card {
  border-radius: 20px;
  padding: 16px 14px 14px;
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: transform 0.2s ease;
}

.module-card:active {
  transform: scale(0.97);
}

.module-card-decode {
  background: linear-gradient(145deg, #FF9A76 0%, #FF5733 100%);
  box-shadow: 0 8px 24px rgba(255, 87, 51, 0.30);
}

.module-card-health {
  background: linear-gradient(145deg, #5ECFB5 0%, #2D9CDB 100%);
  box-shadow: 0 8px 24px rgba(45, 156, 219, 0.30);
}

.deco-emoji {
  position: absolute;
  right: -10px;
  bottom: -10px;
  font-size: 60px;
  opacity: 0.15;
  line-height: 1;
  transform: rotate(-10deg);
}

.deco-icon {
  font-size: 28px;
  margin-bottom: 8px;
  display: block;
}

.module-badge {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  background: rgba(255, 255, 255, 0.22);
  color: #fff;
  font-size: 10px;
  font-weight: 600;
  padding: 2px 8px;
  border-radius: 999px;
  margin-bottom: 8px;
  backdrop-filter: blur(4px);
}

.module-title {
  display: block;
  font-size: 15px;
  font-weight: 700;
  color: #fff;
  margin-bottom: 10px;
  line-height: 1.35;
}

.module-btn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  background: rgba(255, 255, 255, 0.22);
  backdrop-filter: blur(8px);
  color: #fff;
  font-size: 12px;
  font-weight: 600;
  padding: 6px 12px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

/* 区块标题 */
.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px 16px 10px;
}

.section-title {
  font-size: 15px;
  font-weight: 700;
  color: #1A1A2E;
  display: flex;
  align-items: center;
  gap: 6px;
}

.section-more {
  font-size: 12px;
  color: #9CA3AF;
  display: flex;
  align-items: center;
  gap: 2px;
}

/* 精选文章横向滚动 */
.featured-scroll {
  padding: 0 16px;
  white-space: nowrap;
}

.featured-card {
  display: inline-block;
  width: 160px;
  border-radius: 16px;
  overflow: hidden;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  margin-right: 10px;
  vertical-align: top;
}

.featured-cover {
  width: 100%;
  height: 90px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cover-emoji {
  font-size: 36px;
}

.featured-cover.orange { background: linear-gradient(135deg, #FFD166, #FF9A76); }
.featured-cover.green { background: linear-gradient(135deg, #B7F5D8, #43B89C); }
.featured-cover.blue { background: linear-gradient(135deg, #BFD7FF, #2D9CDB); }
.featured-cover.purple { background: linear-gradient(135deg, #E9D5FF, #9B59B6); }

.featured-body {
  padding: 10px;
}

.featured-cat {
  display: block;
  font-size: 10px;
  font-weight: 600;
  color: #FF7B54;
  margin-bottom: 4px;
  text-transform: uppercase;
  letter-spacing: 0.3px;
}

.featured-cat.teal { color: #43B89C; }
.featured-cat.blue-cat { color: #2D9CDB; }
.featured-cat.purple-cat { color: #9B59B6; }

.featured-title {
  display: block;
  font-size: 12px;
  font-weight: 600;
  color: #1A1A2E;
  line-height: 1.4;
  white-space: normal;
}

/* 文章列表 */
.article-list {
  padding: 4px 16px 16px;
}

.article-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 1px solid #E5E7EB;
}

.article-item:last-child {
  border-bottom: none;
}

.article-thumb {
  width: 68px;
  height: 52px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.thumb-emoji {
  font-size: 24px;
}

.article-thumb.th-orange { background: #FFF0E8; }
.article-thumb.th-green { background: #E6FBF4; }
.article-thumb.th-blue { background: #E8F4FF; }

.article-meta {
  flex: 1;
  min-width: 0;
}

.a-tag {
  display: inline-block;
  font-size: 10px;
  font-weight: 600;
  color: #FF7B54;
  background: rgba(255, 123, 84, 0.1);
  padding: 2px 7px;
  border-radius: 999px;
  margin-bottom: 4px;
}

.a-tag.green { color: #43B89C; background: rgba(67, 184, 156, 0.1); }
.a-tag.blue { color: #2D9CDB; background: rgba(45, 156, 219, 0.1); }

.a-title {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #1A1A2E;
  line-height: 1.4;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.a-desc {
  display: block;
  font-size: 11px;
  color: #9CA3AF;
  margin-top: 2px;
  line-height: 1.4;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 底部提示 */
.home-footer {
  padding: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
}

.home-footer text {
  font-size: 11px;
  color: #9CA3AF;
}

.dot {
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: #9CA3AF;
}

.safe-area {
  height: 20px;
}
</style>
