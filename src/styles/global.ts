// PetMind 小程序全局样式
// 参考 PC 端 petmind.vip 的 UI 风格

// 主题色
const theme = {
  primary: '#8B5CF6',      // 紫色主色
  primaryLight: '#A78BFA',  // 浅紫色
  primaryDark: '#7C3AED',   // 深紫色
  success: '#10B981',        // 绿色
  warning: '#F59E0B',       // 橙色
  error: '#EF4444',         // 红色
  bg: '#F9FAFB',            // 背景灰
  card: '#FFFFFF',          // 卡片白
  text: '#1F2937',          // 主文字
  textLight: '#6B7280',    // 次要文字
  border: '#E5E7EB',        // 边框
}

// 全局样式
export const globalStyles = `
  page {
    background-color: ${theme.bg};
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    color: ${theme.text};
    font-size: 28rpx;
  }

  .container {
    min-height: 100vh;
    background-color: ${theme.bg};
    padding: 32rpx;
  }

  // 标题样式
  .title {
    font-size: 48rpx;
    font-weight: 700;
    color: ${theme.text};
    margin-bottom: 8rpx;
  }

  .subtitle {
    font-size: 28rpx;
    color: ${theme.textLight};
    margin-bottom: 32rpx;
  }

  // 卡片样式
  .card {
    background: ${theme.card};
    border-radius: 24rpx;
    padding: 32rpx;
    box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
    margin-bottom: 24rpx;
  }

  // 按钮样式
  .btn {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 96rpx;
    border-radius: 48rpx;
    font-size: 32rpx;
    font-weight: 600;
    transition: all 0.2s ease;
  }

  .btn-primary {
    background: linear-gradient(135deg, ${theme.primary} 0%, ${theme.primaryDark} 100%);
    color: white;
    box-shadow: 0 8rpx 24rpx rgba(139, 92, 246, 0.3);
  }

  .btn-primary:active {
    transform: scale(0.98);
    box-shadow: 0 4rpx 12rpx rgba(139, 92, 246, 0.3);
  }

  .btn-secondary {
    background: ${theme.card};
    color: ${theme.primary};
    border: 2rpx solid ${theme.primary};
  }

  // 输入框样式
  .input-wrap {
    margin-bottom: 32rpx;
  }

  .input-label {
    font-size: 28rpx;
    color: ${theme.textLight};
    margin-bottom: 12rpx;
    display: block;
  }

  .input {
    width: 100%;
    height: 96rpx;
    background: ${theme.bg};
    border-radius: 16rpx;
    padding: 0 24rpx;
    font-size: 30rpx;
    box-sizing: border-box;
    border: 2rpx solid transparent;
    transition: all 0.2s ease;
  }

  .input:focus {
    border-color: ${theme.primary};
    background: ${theme.card};
  }

  .textarea {
    width: 100%;
    min-height: 160rpx;
    background: ${theme.bg};
    border-radius: 16rpx;
    padding: 24rpx;
    font-size: 30rpx;
    box-sizing: border-box;
    border: 2rpx solid transparent;
  }

  // 选择器
  .picker {
    width: 100%;
    height: 96rpx;
    background: ${theme.bg};
    border-radius: 16rpx;
    padding: 0 24rpx;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 30rpx;
  }

  // 标签
  .tag {
    display: inline-flex;
    align-items: center;
    padding: 8rpx 20rpx;
    background: ${theme.primaryLight}20;
    color: ${theme.primary};
    border-radius: 999rpx;
    font-size: 24rpx;
    font-weight: 500;
  }

  // 空状态
  .empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 120rpx 40rpx;
  }

  .empty-icon {
    font-size: 160rpx;
    margin-bottom: 32rpx;
  }

  .empty-text {
    font-size: 32rpx;
    color: ${theme.textLight};
    margin-bottom: 16rpx;
  }

  // 悬浮按钮
  .fab {
    position: fixed;
    right: 32rpx;
    bottom: 48rpx;
    width: 112rpx;
    height: 112rpx;
    background: linear-gradient(135deg, ${theme.primary} 0%, ${theme.primaryDark} 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 12rpx 32rpx rgba(139, 92, 246, 0.4);
  }

  .fab-icon {
    font-size: 56rpx;
    color: white;
    font-weight: 300;
  }

  // 列表项
  .list-item {
    display: flex;
    align-items: center;
    padding: 24rpx;
    background: ${theme.card};
    border-radius: 16rpx;
    margin-bottom: 16rpx;
  }
`

export default globalStyles
