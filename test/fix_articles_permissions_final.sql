-- 修复 articles 表权限问题（最终版）
-- 在 Supabase Dashboard -> SQL Editor 中执行

-- 1. 确保表存在
CREATE TABLE IF NOT EXISTS public.articles (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title        TEXT NOT NULL,
  content      TEXT,
  summary      TEXT,
  category     TEXT NOT NULL DEFAULT 'tip',
  icon         TEXT DEFAULT '📰',
  cover_url    TEXT,
  status       TEXT DEFAULT 'draft',
  published_at TIMESTAMP WITH TIME ZONE,
  created_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 启用 RLS
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;

-- 3. 删除所有现有策略
DROP POLICY IF EXISTS "Public can read published articles" ON public.articles;
DROP POLICY IF EXISTS "Allow public read published articles" ON public.articles;
DROP POLICY IF EXISTS "Allow anon read published" ON public.articles;
DROP POLICY IF EXISTS "Allow authenticated read published" ON public.articles;

-- 4. 为 anon 角色（未登录用户）创建读取策略
CREATE POLICY "Allow anon read published"
  ON public.articles
  FOR SELECT
  TO anon
  USING (status = 'published');

-- 5. 为 authenticated 角色（已登录用户）创建读取策略
CREATE POLICY "Allow authenticated read published"
  ON public.articles
  FOR SELECT
  TO authenticated
  USING (status = 'published');

-- 6. 验证策略是否创建成功
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual
FROM pg_policies 
WHERE tablename = 'articles';
