-- 诊断脚本：查看 pets 表的真实数据和 RLS 状态
-- 在 Supabase Dashboard -> SQL Editor 中执行

-- 1. 查看所有宠物数据（绕过 RLS，用 service role 执行）
SELECT id, name, type, user_id, created_at 
FROM public.pets 
ORDER BY created_at DESC
LIMIT 20;

-- 2. 检查这条特定宠物记录的 user_id
SELECT id, name, user_id 
FROM public.pets 
WHERE id = 'bf73b162-8964-4111-abca-78e3d362fbc7';

-- 3. 查看 pets 表的 RLS 策略
SELECT policyname, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'pets';

-- 4. 检查 RLS 是否开启
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'pets';
