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
          // 解析 Supabase 错误
          const errMsg = res.data?.msg || res.data?.message || res.data?.error_description || JSON.stringify(res.data)
          reject(new Error(errMsg))
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

// 上传图片到 Supabase Storage
const uploadImage = async (filePath: string, folder: string = 'pets'): Promise<string> => {
  return new Promise((resolve, reject) => {
    // 使用 uni.uploadFile 更可靠
    const fileName = `${folder}/${Date.now()}_${Math.random().toString(36).substr(2, 9)}.jpg`
    
    console.log('开始上传图片:', fileName, '文件路径:', filePath)
    
    uni.uploadFile({
      url: `${supabaseUrl}/storage/v1/object/petmind/${fileName}`,
      filePath: filePath,
      name: 'file',
      header: {
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`,
        'x-upsert': 'true'
      },
      success: (uploadRes: any) => {
        console.log('上传响应:', uploadRes.statusCode, uploadRes.data)
        if (uploadRes.statusCode >= 200 && uploadRes.statusCode < 300) {
          // 返回公开访问 URL
          const publicUrl = `${supabaseUrl}/storage/v1/object/public/petmind/${fileName}`
          console.log('上传成功, URL:', publicUrl)
          resolve(publicUrl)
        } else {
          let errorMsg = `上传失败: ${uploadRes.statusCode}`
          try {
            const data = JSON.parse(uploadRes.data)
            errorMsg = data.message || data.error || errorMsg
          } catch (e) {
            errorMsg = uploadRes.data || errorMsg
          }
          console.error('上传失败:', errorMsg)
          reject(new Error(errorMsg))
        }
      },
      fail: (err) => {
        console.error('请求失败:', err)
        reject(new Error(`上传失败: ${err.errMsg}`))
      }
    })
  })
}

// 执行 SQL（用于数据库结构修改）
const execSql = (sql: string) => {
  // 注意：这是通过 Supabase 的 REST API 执行 SQL
  // 需要 service_role 权限，这里使用 anon key 可能权限不够
  // 实际部署时需要在 Supabase Dashboard 中执行 SQL
  return Promise.reject(new Error('请在 Supabase Dashboard 中执行 SQL'))
}

// Edge Function 调用
const invokeFunction = async (functionName: string, body: any): Promise<any> => {
  const response = await fetch(`${supabaseUrl}/functions/v1/${functionName}`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${supabaseAnonKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  })
  
  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Function error: ${error}`)
  }
  
  return response.json()
}

// Supabase 客户端对象（兼容 Edge Function 调用）
const supabase = {
  functions: {
    invoke: invokeFunction
  }
}

export { 
  supabaseUrl, 
  supabaseAnonKey, 
  getDeviceId,
  request, 
  get, 
  post, 
  put, 
  del,
  uploadImage,
  supabase
}
