-- 修复 user_id 字段类型：UUID -> TEXT
-- 执行位置: Supabase Dashboard -> SQL Editor

-- 1. 修改 pets 表的 user_id 为 TEXT 类型
ALTER TABLE public.pets ALTER COLUMN user_id TYPE TEXT;

-- 2. 修改 growth_records 表的 user_id 为 TEXT 类型（如果存在）
ALTER TABLE public.growth_records ALTER COLUMN user_id TYPE TEXT;

-- 确认修改成功
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'pets' 
AND column_name = 'user_id';
