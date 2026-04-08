# PetMind 小程序项目记忆

## 项目概述
- **名称**: PetMind 宠物管理小程序
- **技术栈**: UniApp + Vue3 + TypeScript + Supabase
- **目标平台**: 微信小程序

## UI 设计规范

### 颜色系统
- **珊瑚橙 (主色)**: #FF7B54 - 首页、宠物详情、添加宠物
- **暖黄 (喂养页)**: #FFD166 / #FFB347 - 喂养记录页面
- **薄荷绿 (健康页)**: #06D6A0 / #4ADE80 - 健康记录页面
- **薰衣草紫 (日历页)**: #A78BFA / #C4B5FD - 日历页面

### 圆角规范
- 卡片: 28rpx - 32rpx
- 按钮: 999rpx (全圆角)
- 头像: 50%
- 输入框: 20rpx

### 间距系统
- 页面边距: 32rpx
- 卡片内边距: 28rpx - 40rpx
- 元素间距: 16rpx - 24rpx

## 页面结构

### 首页 (index)
- 顶部渐变头部 (珊瑚橙)
- 快捷入口 (4个图标按钮)
- 宠物横向滚动列表
- 今日动态列表
- 新用户引导弹窗

### 喂养页 (feeding)
- 顶部渐变头部 (暖黄)
- 宠物选择 Chips
- 今日总量卡片 (带进度条)
- 喂养记录列表

### 健康页 (health)
- 顶部渐变头部 (薄荷绿)
- 宠物选择 Chips
- 三列指标卡片 (体重/体温/排便)
- 体重/体温趋势图表
- 记录列表

### 日历页 (calendar)
- 顶部渐变头部 (薰衣草紫)
- 月份导航
- 日历网格
- 选中日期事件列表

### 添加宠物 (pet-add)
- 顶部渐变头部 (珊瑚橙)
- 步骤指示器 (2步)
- 第一步: 基本信息 (头像、名称、类型网格、品种、性别、出生日期、体重)
- 第二步: 健康档案 (疫苗网格、驱虫选择、备注)

### 宠物详情 (pet-detail)
- 顶部渐变导航栏
- 宠物信息卡片 (渐变背景)
- 健康档案 (疫苗、驱虫、体重)
- 备注
- 快捷操作
- 底部操作按钮

### 文章详情页 (article)
- 自定义导航栏（灰底，非彩色）
- 封面图（可选）
- 分类标签 + 发布日期
- 富文本正文（rich-text 渲染 HTML）
- 骨架屏加载态 + 错误态

## 关联项目

### petmind（PC 端 Next.js）
- 路径: `/Users/xuchang/.qclaw/workspace/projects/petmind`
- 技术栈: Next.js 15 + TypeScript + Tailwind + Supabase
- 共用同一个 Supabase 数据库
- 已有 `/admin` 后台页面（密钥: `petmind_admin_secret_2024`）
- 新增 `/admin/articles` 文章管理列表页
- 新增 `/admin/articles/edit` 新建/编辑文章页

## 数据库表

### articles（文章表，2026-03-27 新增）
- 字段: id, title, summary, content(HTML), category, icon, cover_url, status, published_at
- category: tip / news / reminder / activity
- status: draft / published / deleted
- RLS: 公开读取已发布文章（无需认证）
- 建表 SQL: `test/create_articles_table.sql`

### events（日历事件表）
- 字段: id, user_id, pet_id, title, notes, event_date, event_time, icon
- RLS 策略: `user_id LIKE 'device_%'` 全权限访问
- 修复 SQL: `test/fix_events_final.sql`

## V2 产品改造方向（2026-03-31 确认）

### 核心变化
- 从宠物管理工具 → AI 驱动情绪价值产品
- 只保留 2 个 Tab：工具台（首页）、我的
- 砍掉：宠物档案、喂养记录、日历、健康记录、文章功能

### 新页面结构
- `pages/index/index` — 工具台首页（两张模块大卡片）
- `pages/decode/decode` — 行为解码器（输入→AI解读→Canvas海报）
- `pages/health/health` — 健康急救箱（症状→AI分析报告）
- `pages/profile/profile` — 我的（极简，无历史记录）

### 技术选型（已确认）
- AI 接口：MiniMax API（老板已有 Token）
- 后端：继续 Supabase
- 图片上传：wx.chooseMedia → Supabase Storage
- 海报生成：Canvas 2D API（前端渲染）
- 历史记录：V1 不做
- 小程序码：V1 用占位图

### 新增 Supabase 表（待建）
- `users` — openid/nick_name/avatar_url
- `decode_records` — 解码记录（user_openid/input_text/input_image_url/result/poster_url）
- `health_records` — 问诊记录（user_openid/pet_type/symptom_text/result/urgency_level）

### PRD 位置
- brain/349d1a1dd96f4095aa27c8fed95bc873/PRD-petmind-v2.md（v2.1 已确认）

### UI 设计稿位置
- brain/349d1a1dd96f4095aa27c8fed95bc873/ui-prototype.html
- 共 10 屏：工具台首页、解码器输入/加载/结果/海报、急救箱输入/加载/报告、我的未登录/已登录
- 设计风格：深空紫背景首页 + 橙色解码主题 + 蓝绿急救主题

## 更新记录

### 2026-03-26
- 完成所有页面 UI 重构，按设计稿统一各页面主题色
- 修复添加宠物页无法返回问题（添加自定义导航栏）
- 修复 growth_records 表缺少 date/record_type/amount 等字段问题
- 修复 TabBar 页面 navigateBack 报错，改为 switchTab
- 修复宠物详情页双返回按钮问题
- 全站返回按钮样式优化（毛玻璃效果 + 点击动效）
- 修复日历保存日程 event_type 字段不存在问题

### 2026-03-27
- 新增文章管理功能（今日动态内容化）
- petmind PC端：新增 /admin/articles 文章列表页、/admin/articles/edit 编辑页
- petmind-mini：首页今日动态改为从 articles 表拉取真实数据
- petmind-mini：新增文章详情页 /pages/article/article
- 构建验证通过

### 2026-03-30
- 生成 PetMind 品牌 Logo（SVG 格式，矢量可缩放）
  - static/logo.svg — 方形 logo，适合小程序图标/App icon
  - static/logo-horizontal.svg — 横版 logo，适合网站 Header
  - 主色：珊瑚橙 #FF7B54 渐变（#FF9A76 → #FF5733）
  - 图标元素：爪印 + 爱心，寓意智能宠物关爱
  - static/logo-preview.html — 多场景预览页
- Logo 全站替换
  - PC端 Header.tsx：用 /public/logo.svg 替换 PawPrint lucide 图标
  - PC端 admin/layout.tsx：用 SVG logo 替换纯文字 P
  - PC端 AuthForm.tsx：登录页顶部加 72px logo 图片
  - PC端 app/icon.svg：替换为品牌 favicon（Next.js 自动识别）
  - 小程序 首页：头部右侧用 logo.svg 替换 🐾 emoji
  - 小程序 登录页：标题上方加 120rpx logo 图片
  - PC端已部署至 https://petmind.vercel.app
  - 小程序已重新编译构建（dist/build/mp-weixin）
