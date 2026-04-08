-- PetMind 数据库表结构更新脚本
-- 执行位置: Supabase Dashboard -> SQL Editor

-- 为 pets 表添加缺失的列

-- 疫苗相关字段
ALTER TABLE public.pets ADD COLUMN IF NOT EXISTS vaccines TEXT;
ALTER TABLE public.pets ADD COLUMN IF NOT EXISTS vaccine_date TEXT;

-- 驱虫相关字段
ALTER TABLE public.pets ADD COLUMN IF NOT EXISTS deworm_type TEXT;
ALTER TABLE public.pets ADD COLUMN IF NOT EXISTS deworm_date TEXT;

-- 确认列已添加
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'pets' 
AND column_name IN ('vaccines', 'vaccine_date', 'deworm_type', 'deworm_date');
