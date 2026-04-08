-- 修复 articles 表 RLS 权限问题
-- 允许匿名用户进行增删改操作（管理后台使用）

-- 1. 删除现有的 SELECT policy（如果有）
DROP POLICY IF EXISTS "Public can read published articles" ON public.articles;

-- 2. 创建新的 SELECT policy - 允许读取所有非删除状态的文章
CREATE POLICY "Public can read articles"
  ON public.articles
  FOR SELECT
  USING (status != 'deleted');

-- 3. 创建 INSERT policy - 允许匿名用户插入
DROP POLICY IF EXISTS "Public can insert articles" ON public.articles;
CREATE POLICY "Public can insert articles"
  ON public.articles
  FOR INSERT
  WITH CHECK (true);

-- 4. 创建 UPDATE policy - 允许匿名用户更新
DROP POLICY IF EXISTS "Public can update articles" ON public.articles;
CREATE POLICY "Public can update articles"
  ON public.articles
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- 5. 创建 DELETE policy - 允许匿名用户删除
DROP POLICY IF EXISTS "Public can delete articles" ON public.articles;
CREATE POLICY "Public can delete articles"
  ON public.articles
  FOR DELETE
  USING (true);

-- 6. 授予 anon 角色所有权限
GRANT ALL ON public.articles TO anon;
GRANT ALL ON public.articles TO authenticated;

-- 7. 确认权限设置
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'articles';
