---
name: petmind-regression-test
overview: 修复健康记录添加问题并执行全面回归测试
todos:
  - id: fix-pet-add-userid
    content: 修复 pet-add.vue 的 user_id 问题
    status: completed
  - id: fix-index-userid
    content: 修复 index.vue 的 user_id 问题
    status: completed
  - id: fix-pet-detail-userid
    content: 修复 pet-detail.vue 的 user_id 问题
    status: completed
  - id: build-verify
    content: 构建验证
    status: completed
    dependencies:
      - fix-pet-add-userid
      - fix-index-userid
      - fix-pet-detail-userid
  - id: create-test-plan
    content: 创建详细测试计划
    status: completed
    dependencies:
      - build-verify
  - id: execute-regression-test
    content: 执行回归测试
    status: completed
    dependencies:
      - create-test-plan
  - id: generate-test-report
    content: 生成测试报告
    status: completed
    dependencies:
      - execute-regression-test
---

## 需求概述

1. 修复健康记录添加失败的问题
2. 进行全面的回归测试
3. 生成测试报告

## 问题根因分析

经过代码分析，发现以下导致健康记录添加失败的根本原因：

### 问题1: user_id 不一致（P0 - 高优先级）

- pet-add.vue: user_id = currentUser?.id（未登录时为undefined）
- health.vue: user_id = getCurrentUserId() || getDeviceId()
- feeding.vue: user_id = getCurrentUserId() || getDeviceId()
- pet-detail.vue: user_id = deviceId
- index.vue: user_id = cloudUserId

宠物添加时user_id可能是undefined，而查询时使用deviceId，导致数据无法匹配

### 问题2: getDeviceId() 逻辑问题（P1）

- supabase.ts 中 getDeviceId() 会生成deviceId并缓存
- 但不同页面调用时可能获取到不同的值（缓存失效时）

### 问题3: 权限校验不一致（P1）

- 各页面使用不同的user_id来源，导致数据访问权限混乱

## 技术方案

### 修复方案

统一使用 getDeviceId() 作为 user_id，确保数据一致性：

1. 修复 pet-add.vue:

- 将 user_id: currentUser?.id 改为 user_id: getDeviceId()

2. 修复 index.vue:

- 统一使用 getDeviceId() 替代 cloudUserId

3. 保持 health.vue 和 feeding.vue 使用 getDeviceId()

4. 修复 pet-detail.vue:

- 统一使用 getDeviceId()

### 测试方案

由于是微信小程序，需要使用微信开发者工具进行测试：

1. 单元测试：各函数逻辑验证
2. 集成测试：完整用户流程测试
3. 回归测试：所有核心功能的端到端测试

### 测试环境

- 项目路径：/Users/xuchang/.openclaw/workspace/petmind-mini
- 构建输出：dist/build/mp-weixin/
- 云数据库：Supabase (https://rmikwxfqwjprjttfdujn.supabase.co)
- 测试工具：miniprogram-automator + 微信开发者工具

## 使用的扩展

- 无需使用额外扩展，直接使用代码分析工具进行问题定位