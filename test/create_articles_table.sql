-- PetMind articles 表创建脚本
-- 用于首页今日动态内容管理

-- 1. 创建 articles 表
CREATE TABLE IF NOT EXISTS public.articles (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title        TEXT NOT NULL,
  content      TEXT,                          -- 富文本 HTML 正文
  summary      TEXT,                          -- 纯文本摘要（首页展示）
  category     TEXT NOT NULL DEFAULT 'tip',   -- tip / news / reminder / activity
  icon         TEXT DEFAULT '📰',             -- 分类图标
  cover_url    TEXT,                          -- 封面图 URL（外链）
  status       TEXT DEFAULT 'draft',          -- draft / published / deleted
  published_at TIMESTAMP WITH TIME ZONE,
  created_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 启用 RLS
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;

-- 3. 公开读取已发布文章（小程序端无需登录）
DROP POLICY IF EXISTS "Public can read published articles" ON public.articles;
CREATE POLICY "Public can read published articles"
  ON public.articles
  FOR SELECT
  USING (status = 'published');

-- 4. 插入几条示例数据
INSERT INTO public.articles (title, summary, content, category, icon, status, published_at) VALUES
(
  '春季宠物驱虫指南',
  '春暖花开，也是跳蚤和蜱虫活跃的季节，记得给毛孩子做好驱虫防护。',
  '<h2>为什么春季要驱虫？</h2><p>春季气温回升，体外寄生虫（跳蚤、蜱虫）开始活跃繁殖。定期驱虫是保护宠物健康的重要措施。</p><h2>推荐驱虫频率</h2><ul><li>体外驱虫：每月一次</li><li>体内驱虫：每3个月一次</li></ul><p>如有疑问，请咨询你的兽医。</p>',
  'tip',
  '💊',
  'published',
  NOW()
),
(
  '狗狗换毛季护理小贴士',
  '春秋换毛季，每天梳毛能减少掉毛烦恼，同时增进和狗狗的感情。',
  '<h2>换毛季注意事项</h2><p>换毛期间，宠物掉毛量明显增加，建议每日梳理毛发，保持皮毛清洁。</p><h2>梳毛技巧</h2><ul><li>顺毛方向梳理，避免打结</li><li>使用适合毛发类型的梳子</li><li>梳毛后可用湿布擦拭，减少浮毛</li></ul>',
  'tip',
  '🐕',
  'published',
  NOW()
),
(
  '宠物疫苗接种提醒',
  '定期疫苗接种是预防传染病的最有效方法，请按时带宠物前往医院。',
  '<h2>核心疫苗</h2><p>狗狗需要接种狂犬疫苗、犬五联/六联疫苗；猫咪需要接种狂犬疫苗、猫三联疫苗。</p><h2>接种时间</h2><p>幼犬幼猫从6-8周龄开始初次免疫，成年后每年加强一次。</p>',
  'reminder',
  '💉',
  'published',
  NOW()
);

-- 5. 确认表结构
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'articles' 
ORDER BY ordinal_position;
