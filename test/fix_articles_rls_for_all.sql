-- 方案B：使用 FOR ALL 策略（生产环境推荐）
-- 如果方案A能工作，用这个替换

-- 1. 启用 RLS
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;

-- 2. 删除所有现有策略
DROP POLICY IF EXISTS "Allow all read published" ON public.articles;
DROP POLICY IF EXISTS "Allow anon read published" ON public.articles;
DROP POLICY IF EXISTS "Allow authenticated read published" ON public.articles;

-- 3. 创建一个对所有角色生效的策略
CREATE POLICY "Allow all read published"
  ON public.articles
  FOR ALL
  USING (status = 'published');

-- 验证
SELECT * FROM pg_policies WHERE tablename = 'articles';
