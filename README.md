# PetMind 微信小程序

> PetMind 宠物助手 - 微信小程序版本

## 技术栈

- **框架**: uni-app + Vue 3
- **数据**: Supabase (与 PC 版共用)
- **平台**: 微信小程序 (可扩展到支付宝、字节等平台)

## 页面结构

```
pages/
├── index/      # 首页 - 宠物列表 ✅ 已完善
├── feeding/    # 喂养记录 ✅ 已完善
├── health/     # 健康记录 ✅ 已完善
├── calendar/   # 日历 ✅ 已完善
├── photo/      # 相册 ✅ 已完善
└── settings/   # 设置 ✅ 已完善
```

## 功能列表

### 首页 (index)
- [x] 宠物列表展示
- [x] 对接 Supabase 数据库
- [x] 添加宠物入口
- [x] 宠物年龄计算

### 喂养记录 (feeding)
- [x] 喂养记录列表
- [x] 添加喂养记录弹窗
- [x] 食物类型选择
- [x] 数量输入

### 健康记录 (health)
- [x] 健康数据卡片（体重、体温、排便状态）
- [x] 健康记录列表
- [x] 添加健康记录（体重、体温、驱虫、疫苗等）
- [x] 备注功能

### 日历 (calendar)
- [x] 月历视图
- [x] 日期切换
- [x] 事件标记
- [x] 选中日期显示事件
- [x] 添加日程

### 相册 (photo)
- [x] 照片网格展示
- [x] 分类筛选（全部、成长、趣照）
- [x] 图片上传
- [x] 图片预览

### 设置 (settings)
- [x] 通知开关
- [x] 深色模式
- [x] 数据同步状态
- [x] 版本信息

## 快速开始

### 安装依赖

```bash
cd petmind-mini
npm install
```

### 开发微信小程序

```bash
# 微信小程序开发
npm run dev:mp-weixin

# 导入微信开发者工具
# 打开 src/dist/dev/mp-weixin 目录
```

### 构建生产

```bash
npm run build:mp-weixin
```

## 配置说明

### Supabase

配置文件: `src/utils/supabase.ts`

```typescript
const supabaseUrl = 'https://rmikwxfqwjprjttfdujn.supabase.co'
const supabaseAnonKey = 'your-anon-key'
```

### 微信小程序 AppID

在微信公众平台申请后，修改 `src/project.config.json` 中的 `appid`

## 与 PC 版对比

| 功能 | PC Web | 微信小程序 |
|------|--------|-----------|
| 技术栈 | Next.js | uni-app |
| 登录 | 需要 | 无需 |
| 数据 | Supabase | Supabase |
| 变现 | - | 广告接入 |

## 后续规划

- [ ] 完善 Supabase 数据表对接
- [ ] 接入微信广告
- [ ] 编译到支付宝/字节小程序
- [ ] 添加宠物详情页
- [ ] 数据同步功能
