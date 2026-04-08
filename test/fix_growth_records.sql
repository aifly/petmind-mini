-- PetMind 数据库表结构更新脚本
-- 为 growth_records 表添加所有缺失的列

-- 添加 record_type 列 (记录类型: feeding/weight/health)
ALTER TABLE public.growth_records ADD COLUMN IF NOT EXISTS record_type TEXT;

-- 添加 amount 列 (喂养数量)
ALTER TABLE public.growth_records ADD COLUMN IF NOT EXISTS amount INTEGER;

-- 添加 food_type 列 (食物类型)
ALTER TABLE public.growth_records ADD COLUMN IF NOT EXISTS food_type TEXT;

-- 添加 weight 列 (体重)
ALTER TABLE public.growth_records ADD COLUMN IF NOT EXISTS weight NUMERIC;

-- 添加 notes 列 (备注)
ALTER TABLE public.growth_records ADD COLUMN IF NOT EXISTS notes TEXT;

-- 添加 temperature 列 (体温)
ALTER TABLE public.growth_records ADD COLUMN IF NOT EXISTS temperature NUMERIC;

-- 添加 stool_type 列 (排便类型)
ALTER TABLE public.growth_records ADD COLUMN IF NOT EXISTS stool_type TEXT;

-- 确认列已添加
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'growth_records' 
ORDER BY ordinal_position;
