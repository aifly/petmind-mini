<template>
  <view class="container">
    <view class="header">
      <text class="title">设置</text>
    </view>

    <view class="settings-list">
      <view class="settings-item">
        <text class="item-label">通知提醒</text>
        <switch checked color="#3cc51f" />
      </view>
      <view class="settings-item">
        <text class="item-label">深色模式</text>
        <switch color="#3cc51f" />
      </view>
      <view class="settings-item">
        <text class="item-label">数据同步</text>
        <text class="item-value">已开启</text>
      </view>
    </view>

    <view class="about-section">
      <text class="about-title">关于</text>
      <text class="version">PetMind v1.0.0</text>
    </view>
  </view>
</template>

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

.settings-list {
  background: white;
  border-radius: 12px;
  overflow: hidden;
}

.settings-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #f0f0f0;
}

.settings-item:last-child {
  border-bottom: none;
}

.item-label {
  font-size: 16px;
  color: #333;
}

.item-value {
  font-size: 14px;
  color: #999;
}

.about-section {
  margin-top: 40px;
  text-align: center;
}

.about-title {
  font-size: 14px;
  color: #999;
  display: block;
  margin-bottom: 8px;
}

.version {
  font-size: 12px;
  color: #ccc;
}
</style>
