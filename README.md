# PetMind 微信小程序

> PetMind 宠物助手 - 微信小程序版本

## 技术栈

- **框架**: uni-app + Vue 3
- **数据**: Supabase (与 PC 版共用)
- **平台**: 微信小程序 (可扩展到其他平台)

## 页面结构

```
pages/
├── index/          # 首页 - 宠物列表
├── feeding/        # 喂养记录
├── health/         # 健康记录
├── calendar/       # 日历
├── photo/          # 相册
└── settings/       # 设置
```

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

- [ ] 完善各页面功能
- [ ] 接入微信广告
- [ ] 编译到支付宝/字节小程序
