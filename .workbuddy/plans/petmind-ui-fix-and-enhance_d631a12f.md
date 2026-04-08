---
name: petmind-ui-fix-and-enhance
overview: 修复登录页面UI为珊瑚橙风格，并完善功能与UX
todos:
  - id: fix-login-ui
    content: 修复登录页面 login.vue 样式为珊瑚橙风格
    status: completed
  - id: build-verify
    content: 构建并验证小程序（npm run build:mp-weixin）
    status: completed
    dependencies:
      - fix-login-ui
  - id: setup-test-tool
    content: 安装微信小程序自动化测试工具
    status: completed
  - id: test-flow
    content: 使用测试工具验证小程序完整流程
    status: completed
    dependencies:
      - build-verify
      - setup-test-tool
  - id: enhance-pet-profile
    content: 完善宠物档案功能（疫苗、驱虫、体重追踪）
    status: completed
  - id: enhance-feeding
    content: 增强喂养记录（定时提醒、喂养计划）
    status: completed
  - id: enhance-health-viz
    content: 健康数据可视化（趋势图表）
    status: completed
  - id: ux-guide
    content: 实现新用户引导流程
    status: completed
  - id: ux-empty-state
    content: 优化空状态提示
    status: completed
  - id: ux-loading
    content: 增加加载状态动画
    status: completed
  - id: ux-feedback
    content: 优化交互反馈效果
    status: completed
---

## 用户需求

1. 修复登录页面 UI 为珊瑚橙风格（仅修改 template/style，不动 script 逻辑）
2. 安装微信小程序测试工具并完整测试小程序流程
3. 功能层面优化：宠物档案完善、喂养智能化、健康数据可视化
4. UX 改进：新用户引导、空状态优化、加载状态优化、交互反馈优化

## 技术现状

- 项目类型：uni-app + Vue 3 + TypeScript 微信小程序
- 云数据库：Supabase (https://rmikwxfqwjprjttfdujn.supabase.co)
- UI 状态：部分页面已改为珊瑚橙风格，登录页仍为紫色系

## 登录页面需修复的样式

| 元素 | 当前值（紫色） | 目标值（珊瑚橙） |
| --- | --- | --- |
| 背景渐变 | #F9FAFB → #EEF2FF | #FFF8F5 → #FFF0E9 |
| 卡片阴影 | rgba(139,92,246,0.1) | rgba(255,123,84,0.1) |
| 标题渐变 | #8B5CF6 → #A78BFA | #FF7B54 → #FFB38A |
| 输入框focus | #8B5CF6 | #FF7B54 |
| 登录按钮 | #8B5CF6 → #7C3AED | #FF7B54 → #FF9A76 |
| 链接文字 | #8B5CF6 | #FF7B54 |


## 技术方案

### 技术栈

- 框架：uni-app + Vue 3 + TypeScript
- 目标平台：微信小程序
- 云数据库：Supabase（已集成）

### 实现方案

#### 1. 登录页面 UI 修复

- 仅修改 login.vue 的 style 部分
- 使用已有设计令牌：主色#FF7B54，背景#FFF8F5，圆角24-36rpx
- 保持 script 逻辑完全不变

#### 2. 微信小程序测试工具

- 安装微信开发者工具 CLI：`npm i miniprogram-automator -D`
- 使用 `npx miniprogram-automator` 进行自动化测试
- 测试流程：登录 → 首页 → 各Tab页面 → 交互操作

#### 3. 功能层面优化

- 宠物档案：增加疫苗记录、驱虫提醒、体重追踪功能
- 喂养记录：支持定时提醒、喂养计划推送
- 健康数据：增加体重/体温趋势图表可视化

#### 4. UX 改进

- 新用户引导：首次使用引导添加宠物
- 空状态优化：各页面无数据时的友好提示和插图
- 加载状态：骨架屏/loading 动画
- 交互反馈：优化 toast 提示和动画效果