-- 检查 pets 和 articles 表的权限配置对比

-- 1. 检查表的基本信息
SELECT 
  schemaname,
  tablename,
  tableowner,
  hasindexes,
  hasrules,
  hastriggers,
  rowsecurity
FROM pg_tables 
WHERE tablename IN ('pets', 'articles');

-- 2. 检查 RLS 策略
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual
FROM pg_policies 
WHERE tablename IN ('pets', 'articles')
ORDER BY tablename, policyname;

-- 3. 检查表权限（GRANT）
SELECT 
  grantee,
  table_schema,
  table_name,
  privilege_type
FROM information_schema.table_privileges 
WHERE table_name IN ('pets', 'articles')
ORDER BY table_name, grantee;
