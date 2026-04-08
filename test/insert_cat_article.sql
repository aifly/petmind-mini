-- 先删除可能已插入的重复文章（根据标题）
DELETE FROM public.articles WHERE title = '🐱 新手铲屎官必看！猫咪养护全攻略';

-- 插入猫咪养护文章（使用不同的封面图）
INSERT INTO public.articles (
  id, title, summary, content, category, icon, cover_url, status, published_at, created_at, updated_at
) VALUES (
  gen_random_uuid(),
  '🐱 新手铲屎官必看！猫咪养护全攻略',
  '养猫后才发现，猫咪和狗狗完全不一样——它们更独立、更敏感，也更需要我们细心照顾。今天分享一下这几年总结的猫咪养护经验。',
  '<h2>🐾 一、饮食篇：吃得好才能身体好</h2>
<h3>1. 主食选择</h3>
<ul>
<li><strong>幼猫（1岁以下）</strong>：幼猫粮为主，蛋白质含量要高于35%</li>
<li><strong>成猫（1-7岁）</strong>：成猫粮，注意控制体重</li>
<li><strong>老年猫（7岁以上）</strong>：老年猫粮，易消化为主</li>
</ul>
<h3>2. 喂食原则</h3>
<ul>
<li><strong>定点定量</strong>：每天2-3餐，不要自助餐</li>
<li><strong>新旧粮过渡</strong>：换粮时新旧混合，逐步增加新粮比例（7-10天）</li>
<li><strong>新鲜饮水</strong>：每天换水，猫咪喜欢流动水（可以买饮水机）</li>
</ul>
<h3>3. 千万不能喂的食物</h3>
<p>❌ 巧克力、咖啡因<br>❌ 葡萄、葡萄干<br>❌ 洋葱、大蒜<br>❌ 酒精类<br>❌ 生蛋清（含有抗生素蛋白）<br>❌ 贝类</p>

<h2>🐾 二、环境篇：给猫咪一个安全舒适的家</h2>
<h3>1. 猫砂盆</h3>
<ul>
<li><strong>数量</strong>：N+1原则（猫数量+1）</li>
<li><strong>大小</strong>：猫咪体长的1.5倍</li>
<li><strong>位置</strong>：安静、通风、不易被打扰的地方</li>
<li><strong>清洁</strong>：每天铲屎，每周彻底换猫砂</li>
</ul>
<h3>2. 磨爪子</h3>
<ul>
<li>猫抓板必备！否则家具遭殃</li>
<li>定期修剪指甲（2-3周一次）</li>
</ul>
<h3>3. 安全检查</h3>
<ul>
<li>收好电线、细小物品</li>
<li>确认窗户有纱窗（猫咪喜欢看窗外）</li>
<li>植物检查：绿萝、百合等对猫有毒</li>
</ul>

<h2>🐾 三、健康篇：预防大于治疗</h2>
<h3>1. 疫苗</h3>
<ul>
<li><strong>妙三多（猫三联）</strong>：首年3针，之后每年1针</li>
<li><strong>狂犬疫苗</strong>：每年1针</li>
</ul>
<h3>2. 驱虫</h3>
<ul>
<li><strong>体内驱虫</strong>：3个月1次</li>
<li><strong>体外驱虫</strong>：1个月1次（尤其是夏天）</li>
</ul>
<h3>3. 绝育</h3>
<ul>
<li><strong>公猫</strong>：6个月以上</li>
<li><strong>母猫</strong>：6-8个月</li>
<li>绝育后要控制饮食，容易发胖</li>
</ul>
<h3>4. 体检</h3>
<ul>
<li><strong>7岁前</strong>：每年1次常规体检</li>
<li><strong>7岁后</strong>：半年1次</li>
</ul>

<h2>🐾 四、行为篇：理解猫咪的肢体语言</h2>
<ul>
<li><strong>踩奶</strong>：表示放松、满足</li>
<li><strong>咕噜声</strong>：开心或自我安慰（但也可能是身体不适）</li>
<li><strong>炸毛</strong>：受惊或害怕</li>
<li><strong>缓慢眨眼</strong>：表示信任（猫之吻）</li>
<li><strong>尾巴竖直</strong>：心情好，想和你玩</li>
</ul>

<h2>🐾 五、互动篇：如何和猫咪增进感情</h2>
<h3>1. 陪玩时间</h3>
<ul>
<li>每天至少15-30分钟</li>
<li>用逗猫棒、激光笔互动</li>
<li>结束后给点零食奖励</li>
</ul>
<h3>2. 梳毛</h3>
<ul>
<li>长毛猫每天梳，短毛猫每周2-3次</li>
<li>增进感情，还能减少毛球</li>
</ul>
<h3>3. 安静陪伴</h3>
<ul>
<li>猫咪不喜欢太热情的拥抱</li>
<li>坐在旁边，让它主动来找你</li>
</ul>

<h2>💬 结尾</h2>
<p>养猫不是一时冲动，而是一份长期的责任。<br>它们不会说话，但会用一生陪伴你。<br>希望每一只小猫咪都能遇到爱它的主人❤️</p>
<p>你们家猫咪有什么特别的故事吗？评论区聊聊～</p>',
  'tip',
  '🐱',
  'https://images.unsplash.com/photo-1573865526739-10659fec78a5?w=800&q=80',
  'published',
  NOW(),
  NOW(),
  NOW()
);
