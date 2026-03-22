// Supabase 配置
// 使用 PetMind PC 版同样的 Supabase 项目

const supabaseUrl = 'https://rmikwxfqwjprjttfdujn.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtaWt3eGZxd2pwcmp0dGZkdWpuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4MzY0MDMsImV4cCI6MjA4OTQxMjQwM30.PGzwcc6XTrp7JCfEzJD18BWvzQBx43YtvSG1MT3gDno'

// 获取设备ID（作为匿名用户标识）
const getDeviceId = () => {
  let deviceId = uni.getStorageSync('deviceId')
  if (!deviceId) {
    deviceId = 'device_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9)
    uni.setStorageSync('deviceId', deviceId)
  }
  return deviceId
}

// 小程序请求封装
const request = (options: any): Promise<any> => {
  return new Promise((resolve, reject) => {
    uni.request({
      url: options.url,
      method: options.method || 'GET',
      header: {
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`,
        'Content-Type': 'application/json',
        'Prefer': options.prefer || 'return=representation',
        ...options.header
      },
      data: options.data || {},
      success: (res: any) => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(res.data)
        } else {
          reject(new Error(res.data?.message || '请求失败'))
        }
      },
      fail: (err: any) => {
        reject(err)
      }
    })
  })
}

// GET 请求
const get = (url: string, data?: any) => {
  return request({ url, method: 'GET', data })
}

// POST 请求
const post = (url: string, data?: any) => {
  return request({ url, method: 'POST', data, prefer: 'return=minimal' })
}

// PUT 请求
const put = (url: string, data?: any) => {
  return request({ url, method: 'PATCH', data })
}

// DELETE 请求
const del = (url: string) => {
  return request({ url, method: 'DELETE' })
}

export { 
  supabaseUrl, 
  supabaseAnonKey, 
  getDeviceId,
  request, 
  get, 
  post, 
  put, 
  del 
}
