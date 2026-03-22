<template>
  <view class="container">
    <view class="header">
      <text class="title">日历</text>
      <text class="subtitle">{{ currentYear }}年 {{ currentMonth + 1 }}月</text>
    </view>

    <!-- 月份切换 -->
    <view class="month-nav">
      <view class="nav-btn" @click="prevMonth">
        <text class="nav-icon">‹</text>
      </view>
      <view class="month-display">
        <text class="month-text">{{ currentYear }}-{{ currentMonth + 1 }}</text>
      </view>
      <view class="nav-btn" @click="nextMonth">
        <text class="nav-icon">›</text>
      </view>
    </view>

    <!-- 星期标题 -->
    <view class="weekday-row">
      <text class="weekday" v-for="day in weekDays" :key="day">{{ day }}</text>
    </view>

    <!-- 日历网格 -->
    <view class="calendar-grid">
      <view 
        class="calendar-cell" 
        v-for="(day, index) in calendarDays" 
        :key="index"
        :class="{ 
          'empty': !day.date, 
          'today': isToday(day.date),
          'has-event': hasEvent(day.date)
        }"
        @click="selectDate(day.date)"
      >
        <text class="day-text" :class="{ 'today-text': isToday(day.date) }">
          {{ day.day }}
        </text>
        <view class="event-dot" v-if="hasEvent(day.date)"></view>
      </view>
    </view>

    <!-- 选中日期的事件列表 -->
    <view class="events-section" v-if="selectedDate">
      <view class="events-header">
        <text class="events-title">{{ formatSelectedDate(selectedDate) }}</text>
      </view>
      
      <view class="events-list" v-if="getEventsForDate(selectedDate).length > 0">
        <view 
          class="event-item" 
          v-for="event in getEventsForDate(selectedDate)" 
          :key="event.id"
        >
          <text class="event-icon">{{ event.icon }}</text>
          <text class="event-title">{{ event.title }}</text>
          <text class="event-time">{{ event.time }}</text>
        </view>
      </view>
      
      <view class="no-events" v-else>
        <text class="no-events-text">暂无日程</text>
      </view>

      <button class="add-event-btn" @click="showAddEvent = true">添加日程</button>
    </view>

    <!-- 添加日程弹窗 -->
    <view class="modal-mask" v-if="showAddEvent" @click="showAddEvent = false">
      <view class="modal" @click.stop>
        <view class="modal-header">
          <text class="modal-title">添加日程</text>
          <text class="modal-close" @click="showAddEvent = false">×</text>
        </view>
        
        <view class="form-group">
          <text class="label">日程类型</text>
          <picker 
            :range="eventTypes" 
            @change="onEventTypeChange"
          >
            <view class="picker">
              <text>{{ eventType || '请选择类型' }}</text>
            </view>
          </picker>
        </view>

        <view class="form-group">
          <text class="label">时间</text>
          <picker 
            mode="time" 
            :value="eventTime" 
            @change="onTimeChange"
          >
            <view class="picker">
              <text>{{ eventTime || '请选择时间' }}</text>
            </view>
          </picker>
        </view>

        <view class="form-group">
          <text class="label">备注</text>
          <input 
            class="input" 
            v-model="eventNotes" 
            placeholder="请输入备注"
          />
        </view>

        <button class="submit-btn" @click="addEvent">保存</button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

interface Event {
  id: string
  date: string
  title: string
  icon: string
  time: string
  notes: string
}

const currentDate = new Date()
const currentYear = ref(currentDate.getFullYear())
const currentMonth = ref(currentDate.getMonth())
const selectedDate = ref('')
const showAddEvent = ref(false)
const eventType = ref('')
const eventTime = ref('09:00')
const eventNotes = ref('')

const weekDays = ['日', '一', '二', '三', '四', '五', '六']
const eventTypes = ['喂食', '驱虫', '疫苗', '洗澡', '体检', '其他']

// 模拟事件数据
const events = ref<Event[]>([
  { id: '1', date: getTodayString(), title: '喂食', icon: '🍚', time: '08:00', notes: '早餐' },
  { id: '2', date: getTodayString(), title: '驱虫', icon: '💊', time: '14:00', notes: '月度驱虫' },
])

function getTodayString() {
  const today = new Date()
  return `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`
}

const calendarDays = computed(() => {
  const days = []
  const firstDay = new Date(currentYear.value, currentMonth.value, 1).getDay()
  const daysInMonth = new Date(currentYear.value, currentMonth.value + 1, 0).getDate()
  
  // 填充空白
  for (let i = 0; i < firstDay; i++) {
    days.push({ day: '', date: '' })
  }
  
  // 填充日期
  for (let i = 1; i <= daysInMonth; i++) {
    const date = `${currentYear.value}-${String(currentMonth.value + 1).padStart(2, '0')}-${String(i).padStart(2, '0')}`
    days.push({ day: i, date })
  }
  
  return days
})

const isToday = (date: string) => {
  return date === getTodayString()
}

const hasEvent = (date: string) => {
  return events.value.some(e => e.date === date)
}

const getEventsForDate = (date: string) => {
  return events.value.filter(e => e.date === date)
}

const selectDate = (date: string) => {
  if (date) {
    selectedDate.value = date
  }
}

const formatSelectedDate = (date: string) => {
  if (!date) return ''
  const [year, month, day] = date.split('-')
  return `${parseInt(month)}月${parseInt(day)}日`
}

const prevMonth = () => {
  if (currentMonth.value === 0) {
    currentMonth.value = 11
    currentYear.value--
  } else {
    currentMonth.value--
  }
}

const nextMonth = () => {
  if (currentMonth.value === 11) {
    currentMonth.value = 0
    currentYear.value++
  } else {
    currentMonth.value++
  }
}

const onEventTypeChange = (e: any) => {
  eventType.value = eventTypes[e.detail.value]
}

const onTimeChange = (e: any) => {
  eventTime.value = e.detail.value
}

const addEvent = () => {
  if (!selectedDate.value || !eventType.value) {
    uni.showToast({ title: '请填写完整信息', icon: 'none' })
    return
  }
  
  const icons: Record<string, string> = {
    '喂食': '🍚',
    '驱虫': '💊',
    '疫苗': '💉',
    '洗澡': '🛁',
    '体检': '🏥',
    '其他': '📝'
  }
  
  events.value.push({
    id: Date.now().toString(),
    date: selectedDate.value,
    title: eventType.value,
    icon: icons[eventType.value] || '📝',
    time: eventTime.value,
    notes: eventNotes.value
  })
  
  uni.showToast({ title: '添加成功', icon: 'success' })
  showAddEvent.value = false
  eventType.value = ''
  eventNotes.value = ''
  eventTime.value = '09:00'
}
</script>

<style scoped>
.container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 20px;
}

.header {
  margin-bottom: 16px;
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

.month-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.nav-btn {
  width: 40px;
  height: 40px;
  background: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-icon {
  font-size: 24px;
  color: #333;
}

.month-display {
  padding: 8px 20px;
  background: white;
  border-radius: 20px;
}

.month-text {
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.weekday-row {
  display: flex;
  background: white;
  border-radius: 12px 12px 0 0;
  padding: 12px 0;
}

.weekday {
  flex: 1;
  text-align: center;
  font-size: 14px;
  color: #999;
}

.calendar-grid {
  display: flex;
  flex-wrap: wrap;
  background: white;
  border-radius: 0 0 12px 12px;
  padding-bottom: 12px;
}

.calendar-cell {
  width: calc(100% / 7);
  height: 44px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
}

.calendar-cell.empty {
  pointer-events: none;
}

.day-text {
  font-size: 14px;
  color: #333;
}

.today-text {
  color: #3cc51f;
  font-weight: bold;
}

.today {
  background: rgba(60, 197, 31, 0.1);
  border-radius: 50%;
}

.event-dot {
  width: 4px;
  height: 4px;
  background: #3cc51f;
  border-radius: 50%;
  position: absolute;
  bottom: 4px;
}

.events-section {
  margin-top: 24px;
  background: white;
  border-radius: 12px;
  padding: 16px;
}

.events-header {
  margin-bottom: 12px;
}

.events-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.events-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.event-item {
  display: flex;
  align-items: center;
  padding: 12px;
  background: #f9f9f9;
  border-radius: 8px;
}

.event-icon {
  font-size: 20px;
  margin-right: 12px;
}

.event-title {
  flex: 1;
  font-size: 14px;
  color: #333;
}

.event-time {
  font-size: 12px;
  color: #999;
}

.no-events {
  padding: 20px;
  text-align: center;
}

.no-events-text {
  font-size: 14px;
  color: #ccc;
}

.add-event-btn {
  background: #3cc51f;
  color: white;
  border: none;
  padding: 12px;
  border-radius: 25px;
  font-size: 14px;
  margin-top: 16px;
  width: 100%;
}

.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}

.modal {
  background: white;
  border-radius: 16px;
  padding: 24px;
  width: 80%;
  max-width: 320px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.modal-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.modal-close {
  font-size: 24px;
  color: #999;
}

.form-group {
  margin-bottom: 16px;
}

.label {
  font-size: 14px;
  color: #666;
  display: block;
  margin-bottom: 8px;
}

.picker, .input {
  background: #f5f5f5;
  border-radius: 8px;
  padding: 12px;
  font-size: 16px;
}

.submit-btn {
  background: #3cc51f;
  color: white;
  border: none;
  padding: 14px;
  border-radius: 25px;
  font-size: 16px;
  margin-top: 20px;
  width: 100%;
}
</style>
