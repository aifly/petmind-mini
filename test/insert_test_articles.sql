-- 补充测试文章数据（带封面图、丰富内容）
-- 在 Supabase Dashboard -> SQL Editor 中执行

INSERT INTO public.articles (title, summary, content, category, icon, cover_url, status, published_at) VALUES

-- 带封面图的宠物贴士
(
  '猫咪每日饮水量怎么保证？',
  '猫咪天生不爱喝水，容易引发泌尿系统问题。这几个小技巧能有效增加猫咪的饮水量。',
  '<h2>为什么猫咪不爱喝水？</h2><p>猫咪祖先生活在干旱环境，习惯从食物中获取水分，对饮水需求感不强。但家养猫咪以干粮为主时，饮水不足容易导致<strong>泌尿道结晶、肾脏疾病</strong>等问题。</p><h2>增加饮水量的方法</h2><ul><li>🚿 <strong>使用流水饮水机</strong>：猫咪对流动的水更感兴趣</li><li>🥣 <strong>多放几个水碗</strong>：分散在家中不同位置</li><li>🐟 <strong>湿粮搭配干粮</strong>：湿粮含水量约75%，可补充大量水分</li><li>🧊 <strong>尝试加冰块</strong>：部分猫咪喜欢喝凉水</li></ul><h2>每日饮水目标</h2><p>成年猫每日饮水量约为 <strong>体重(kg) × 50ml</strong>，例如4kg的猫每天需要约200ml水。</p>',
  'tip',
  '🐱',
  'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800&q=80',
  'published',
  NOW() - INTERVAL '1 hour'
),

-- 新闻类
(
  '2026年宠物营养最新研究报告出炉',
  '国际宠物营养协会发布最新研究：高蛋白低碳水饮食对犬猫的长期健康益处被进一步证实。',
  '<h2>研究摘要</h2><p>国际宠物营养协会（IPNA）于2026年3月发布了针对犬猫饮食结构的5年追踪研究报告，共涵盖超过10,000只宠物样本。</p><h2>主要发现</h2><ul><li><strong>高蛋白饮食</strong>可降低猫咪患糖尿病风险约30%</li><li><strong>Omega-3补充</strong>对狗狗关节健康有显著改善</li><li><strong>益生菌添加</strong>能改善宠物肠道菌群多样性</li></ul><h2>专家建议</h2><p>建议宠物主人参考此报告选购宠粮，优先选择<strong>动物蛋白列在配料表前三位</strong>的产品，避免过多谷物填充。</p><blockquote>「宠物的饮食质量直接决定其生命质量。」— IPNA 首席营养师</blockquote>',
  'news',
  '📊',
  'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=800&q=80',
  'published',
  NOW() - INTERVAL '2 hours'
),

-- 活动类
(
  '🎉 PetMind 春季宠物健康打卡活动开启',
  '连续7天记录宠物的饮食和运动，完成打卡即可获得专属勋章！活动时间：4月1日 - 4月30日。',
  '<h2>活动规则</h2><p>参与本次春季健康打卡活动，连续记录宠物健康数据，共同守护毛孩子的健康！</p><h2>如何参与</h2><ol><li>在 PetMind 小程序中添加你的宠物</li><li>每天记录至少一次喂食或健康数据</li><li>连续打卡 7 天即完成任务</li></ol><h2>活动奖励</h2><ul><li>🥇 完成7天打卡：解锁「健康守护者」勋章</li><li>🥈 完成30天打卡：解锁「宠物达人」专属称号</li></ul><h2>活动时间</h2><p><strong>2026年4月1日 00:00 — 2026年4月30日 23:59</strong></p><p>快去给你的毛孩子建立健康档案吧！🐾</p>',
  'activity',
  '🎉',
  'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800&q=80',
  'published',
  NOW() - INTERVAL '30 minutes'
),

-- 提醒类
(
  '4月提醒：宠物体检季来了',
  '建议每年带宠物做一次全面体检，早发现早治疗，把健康风险降到最低。',
  '<h2>为什么要定期体检？</h2><p>宠物无法用语言表达不适，许多疾病在早期几乎没有明显症状。定期体检能帮助早期发现<strong>心脏病、肾病、糖尿病</strong>等常见疾病。</p><h2>体检项目参考</h2><table><tr><th>项目</th><th>频率</th></tr><tr><td>基础体格检查</td><td>每年1次</td></tr><tr><td>血常规 + 生化</td><td>每年1次</td></tr><tr><td>腹部B超</td><td>每1-2年</td></tr><tr><td>口腔检查</td><td>每年1次</td></tr></table><h2>体检前注意事项</h2><ul><li>禁食6-8小时（血液检测前）</li><li>带上历次就诊记录</li><li>记录近期异常行为或饮食变化</li></ul>',
  'reminder',
  '🏥',
  NULL,
  'published',
  NOW() - INTERVAL '3 hours'
);

-- 验证插入结果
SELECT id, title, category, status, published_at
FROM public.articles
WHERE status = 'published'
ORDER BY published_at DESC;
