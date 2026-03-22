// Supabase 请求封装 - 兼容小程序环境
import { supabaseUrl, supabaseAnonKey } from './supabase'

// 统一的请求方法
export const request = (options: any): Promise<any> => {
  return new Promise((resolve, reject) => {
    uni.request({
      url: options.url,
      method: options.method || 'GET',
      header: {
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`,
        'Content-Type': 'application/json',
        ...options.headers
      },
      data: options.data,
      success: (res: any) => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(res.data)
        } else {
          reject(new Error(`HTTP ${res.statusCode}`))
        }
      },
      fail: (err: any) => {
        reject(err)
      }
    })
  })
}

// GET 请求
export const get = (url: string, params?: any) => {
  const queryString = params ? '?' + new URLSearchParams(params).toString() : ''
  return request({
    url: `${supabaseUrl}${url}${queryString}`,
    method: 'GET'
  })
}

// POST 请求
export const post = (url: string, data?: any) => {
  return request({
    url: `${supabaseUrl}${url}`,
    method: 'POST',
    data,
    headers: {
      'Prefer': 'return=minimal'
    }
  })
}
