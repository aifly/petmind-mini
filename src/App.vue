<script setup lang="ts">
import { onLaunch, onShow, onHide } from '@dcloudio/uni-app'

onLaunch(() => {
  console.log('App Launch')
})

onShow(() => {
  console.log('App Show')
})

onHide(() => {
  console.log('App Hide')
})
</script>

<style>
/* 全局可爱风格变量 */
:root {
  --primary: #FFB6C1;
  --primary-dark: #FF69B4;
  --secondary: #98D8C8;
  --accent: #F7DC6F;
  --bg: #FFF9FB;
  --card: #FFFFFF;
  --text: #5D4E6D;
  --text-light: #9B8AA6;
  --border: #F0E6F5;
}

page {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', sans-serif;
  background: linear-gradient(180deg, #FFF0F5 0%, #FFF9FB 100%);
  color: var(--text);
}

/* 可爱按钮 */
.btn-cute {
  background: linear-gradient(135deg, #FFB6C1 0%, #FF69B4 100%);
  color: #FFFFFF;
  border: none;
  padding: 14px 32px;
  border-radius: 25px;
  font-size: 15px;
  font-weight: 600;
  box-shadow: 0 4px 15px rgba(255,182,193,0.4);
  transition: all 0.2s;
}

.btn-cute:active {
  transform: scale(0.96);
  box-shadow: 0 2px 8px rgba(255,182,193,0.3);
}

/* 浮动按钮 */
.fab-cute {
  position: fixed;
  right: 20px;
  bottom: 100px;
  width: 56px;
  height: 56px;
  background: linear-gradient(135deg, #FFB6C1 0%, #FF69B4 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 6px 20px rgba(255,182,193,0.4);
  z-index: 100;
}

.fab-cute::before {
  content: '+';
  font-size: 28px;
  color: #FFFFFF;
  font-weight: 300;
}

/* 卡片样式 */
.card-cute {
  background: #FFFFFF;
  border-radius: 20px;
  padding: 20px;
  box-shadow: 0 4px 20px rgba(93,78,109,0.06);
  border: 1px solid var(--border);
}

/* 输入框 */
.input-cute {
  background: #FFF5F8;
  border: 2px solid #F0E6F5;
  border-radius: 16px;
  padding: 14px 18px;
  font-size: 15px;
  color: var(--text);
  transition: all 0.2s;
}

.input-cute:focus {
  border-color: var(--primary);
  background: #FFFFFF;
}

/* 标签 */
.tag-cute {
  background: linear-gradient(135deg, #FFE4E9 0%, #FFF0F3 100%);
  color: var(--primary-dark);
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

/* 空状态 */
.empty-cute {
  text-align: center;
  padding: 60px 40px;
}

.empty-cute-icon {
  font-size: 80px;
  margin-bottom: 20px;
  display: block;
}

.empty-cute-text {
  font-size: 18px;
  font-weight: 600;
  color: var(--text);
  margin-bottom: 8px;
}

.empty-cute-hint {
  font-size: 14px;
  color: var(--text-light);
}

/* TabBar 字体大小调整 */
.uni-tabbar .uni-tabbar__item {
  font-size: 13px !important;
}

.uni-tabbar .uni-tabbar__label {
  font-size: 13px !important;
  font-weight: 500;
}
</style>
