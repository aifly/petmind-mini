/**
 * PetMind 微信小程序自动化测试脚本
 * 
 * 使用方法：
 * 1. 先用微信开发者工具打开项目：dist/build/mp-weixin
 * 2. 在微信开发者工具中：设置 -> 安全设置 -> 开启"开发环境不效验请求域名"
 * 3. 获取微信开发者工具的 AppID（通常在项目根目录 project.config.json 中）
 * 4. 运行: node test/wechat-test.js
 */

const { Automator } = require('miniprogram-automator');

async function runTest() {
  console.log('🚀 启动微信小程序自动化测试...\n');
  
  let miniProgram;
  
  try {
    // 连接微信开发者工具
    miniProgram = await Automator.launch({
      projectPath: './dist/build/mp-weixin',
      // 如果有多个开发者工具实例，需要指定
      // instanceId: 'xxx'
    });
    
    console.log('✅ 微信小程序启动成功\n');
    
    // 获取首页
    const indexPage = await miniProgram.reLaunch('/pages/index/index');
    await indexPage.waitFor(1000);
    console.log('📱 已打开首页');
    
    // 截图
    await indexPage.screenshot({ path: 'test/screenshot-index.png' });
    console.log('📸 截图已保存: test/screenshot-index.png\n');
    
    // 测试登录页面
    console.log('🔐 测试登录流程...');
    const loginPage = await miniProgram.reLaunch('/pages/login/login');
    await loginPage.waitFor(500);
    
    // 截图
    await loginPage.screenshot({ path: 'test/screenshot-login.png' });
    console.log('📸 登录页面截图: test/screenshot-login.png');
    
    // 检查登录页面元素
    const title = await loginPage.$('.title');
    if (title) {
      const titleText = await title.text();
      console.log(`📝 登录页面标题: ${titleText}`);
    }
    
    // 测试喂养页面
    console.log('\n🍖 测试喂养页面...');
    const feedingPage = await miniProgram.reLaunch('/pages/feeding/feeding');
    await feedingPage.waitFor(500);
    await feedingPage.screenshot({ path: 'test/screenshot-feeding.png' });
    console.log('📸 喂养页面截图: test/screenshot-feeding.png');
    
    // 测试健康页面
    console.log('\n💊 测试健康页面...');
    const healthPage = await miniProgram.reLaunch('/pages/health/health');
    await healthPage.waitFor(500);
    await healthPage.screenshot({ path: 'test/screenshot-health.png' });
    console.log('📸 健康页面截图: test/screenshot-health.png');
    
    // 测试日历页面
    console.log('\n📅 测试日历页面...');
    const calendarPage = await miniProgram.reLaunch('/pages/calendar/calendar');
    await calendarPage.waitFor(500);
    await calendarPage.screenshot({ path: 'test/screenshot-calendar.png' });
    console.log('📸 日历页面截图: test/screenshot-calendar.png');
    
    // 测试设置页面
    console.log('\n⚙️ 测试设置页面...');
    const settingsPage = await miniProgram.reLaunch('/pages/settings/settings');
    await settingsPage.waitFor(500);
    await settingsPage.screenshot({ path: 'test/screenshot-settings.png' });
    console.log('📸 设置页面截图: test/screenshot-settings.png');
    
    console.log('\n🎉 所有页面测试完成！');
    console.log('📁 截图保存在 test/ 目录下\n');
    
    // 输出页面结构
    console.log('📋 页面结构分析:');
    const pages = await miniProgram.pages();
    for (const page of pages) {
      console.log(`  - ${page.path}`);
    }
    
  } catch (error) {
    console.error('❌ 测试失败:', error.message);
    console.log('\n💡 提示:');
    console.log('  1. 确保微信开发者工具已安装并打开');
    console.log('  2. 在微信开发者工具中开启"开发环境不效验请求域名"');
    console.log('  3. 确保项目路径正确: ./dist/build/mp-weixin');
  } finally {
    if (miniProgram) {
      await miniProgram.close();
      console.log('\n👋 已关闭微信小程序');
    }
  }
}

runTest();
