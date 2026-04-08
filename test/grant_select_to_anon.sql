-- 修复：授予 anon 角色对 articles 表的 SELECT 权限
-- 在 Supabase Dashboard -> SQL Editor 中执行

-- 1. 授予 anon 角色 SELECT 权限
GRANT SELECT ON public.articles TO anon;

-- 2. 授予 authenticated 角色 SELECT 权限（如果需要）
GRANT SELECT ON public.articles TO authenticated;

-- 3. 验证权限
SELECT 
  grantee,
  table_schema,
  table_name,
  privilege_type
FROM information_schema.table_privileges 
WHERE table_name = 'articles'
  AND grantee = 'anon'
ORDER BY privilege_type;
