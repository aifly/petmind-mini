-- 方案A：禁用 RLS（测试用，不推荐生产环境）
-- 如果这能工作，说明问题在 RLS 策略配置

ALTER TABLE public.articles DISABLE ROW LEVEL SECURITY;

-- 验证
SELECT relname, relrowsecurity 
FROM pg_class 
WHERE relname = 'articles';
