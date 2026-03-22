// 本地模拟数据存储
const STORAGE_KEY = 'petmind_local_data'

// 获取本地数据
export const getLocalData = (key: string) => {
  try {
    const data = uni.getStorageSync(STORAGE_KEY)
    return data?.[key] || []
  } catch (e) {
    return []
  }
}

// 保存本地数据
export const setLocalData = (key: string, value: any) => {
  try {
    const data = uni.getStorageSync(STORAGE_KEY) || {}
    data[key] = value
    uni.setStorageSync(STORAGE_KEY, data)
    return true
  } catch (e) {
    return false
  }
}

// 添加数据
export const addLocalData = (key: string, item: any) => {
  const list = getLocalData(key)
  item.id = Date.now().toString()
  item.created_at = new Date().toISOString()
  list.unshift(item)
  setLocalData(key, list)
  return item
}

// 初始化示例数据
export const initMockData = () => {
  const pets = getLocalData('pets')
  if (pets.length === 0) {
    setLocalData('pets', [
      { id: '1', name: '豆豆', species: '狗', breed: '金毛', birth_date: '2023-01-15', avatar_url: '' },
      { id: '2', name: '咪咪', species: '猫', breed: '布偶', birth_date: '2022-06-20', avatar_url: '' }
    ])
  }
  
  const feedingRecords = getLocalData('feeding_records')
  if (feedingRecords.length === 0) {
    setLocalData('feeding_records', [
      { id: '1', pet_id: '1', food_type: '狗粮', amount: 100, created_at: new Date().toISOString() },
      { id: '2', pet_id: '1', food_type: '零食', amount: 50, created_at: new Date(Date.now() - 3600000).toISOString() },
      { id: '3', pet_id: '2', food_type: '猫粮', amount: 80, created_at: new Date(Date.now() - 7200000).toISOString() }
    ])
  }
  
  const healthRecords = getLocalData('health_records')
  if (healthRecords.length === 0) {
    setLocalData('health_records', [
      { id: '1', pet_id: '1', health_type: '体重', weight: 25, notes: '体重正常', created_at: new Date().toISOString() },
      { id: '2', pet_id: '1', health_type: '驱虫', notes: '已完成体内驱虫', created_at: new Date(Date.now() - 86400000).toISOString() }
    ])
  }
}
