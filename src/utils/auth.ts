// 用户认证模块 - 云端互通版
import { get, post, put, getDeviceId } from './supabase'
import { supabaseUrl } from './supabase'

// 当前登录用户信息
let currentUser: {
  id: string
  email: string
  device_id: string
} | null = null

// 登录（设备ID关联云端用户）
export const login = async (): Promise<boolean> => {
  try {
    const deviceId = getDeviceId()
    
    // 用设备ID查询对应的用户
    const url = `${supabaseUrl}/rest/v1/users?select=id,email,device_id&device_id=eq.${deviceId}&limit=1`
    const data = await get(url)
    
    if (data && data.length > 0) {
      // 找到关联用户
      currentUser = data[0]
      console.log('找到关联用户:', currentUser.email)
    } else {
      // 没找到关联用户，创建新用户并关联设备ID
      console.log('未找到关联用户，创建设备用户...')
      // 这里暂时先创建本地记录
    }
    
    // 保存登录状态
    uni.setStorageSync('isLoggedIn', true)
    uni.setStorageSync('loginTime', Date.now())
    uni.setStorageSync('currentUser', currentUser)
    
    return true
  } catch (error) {
    console.error('登录失败:', error)
    uni.setStorageSync('isLoggedIn', true)
    uni.setStorageSync('loginTime', Date.now())
    return true
  }
}

// 登出
export const logout = () => {
  currentUser = null
  uni.removeStorageSync('isLoggedIn')
  uni.removeStorageSync('loginTime')
  uni.removeStorageSync('currentUser')
}

// 检查是否已登录
export const isLoggedIn = (): boolean => {
  return uni.getStorageSync('isLoggedIn') || false
}

// 获取设备ID
export const getUserDeviceId = (): string => {
  return getDeviceId()
}

// 获取当前登录用户ID（用于查询数据）
export const getCurrentUserId = (): string | null => {
  if (currentUser) return currentUser.id
  const cached = uni.getStorageSync('currentUser')
  return cached?.id || null
}

// 获取当前用户信息
export const getCurrentUser = () => {
  if (currentUser) return currentUser
  return uni.getStorageSync('currentUser')
}
