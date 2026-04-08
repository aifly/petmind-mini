-- 完整修复 user_id 字段类型（第二版）
-- 执行位置: Supabase Dashboard -> SQL Editor

-- 步骤1: 检查 growth_records 表结构
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'growth_records';

-- 步骤2: 如果 growth_records 没有 user_id，先添加列
ALTER TABLE public.growth_records ADD COLUMN IF NOT EXISTS user_id TEXT;

-- 步骤3: 删除依赖 user_id 的策略
DROP POLICY IF EXISTS "Users can manage own pets" ON public.pets;
DROP POLICY IF EXISTS "Users can manage own growth records" ON public.growth_records;

-- 步骤4: 修改字段类型
ALTER TABLE public.pets ALTER COLUMN user_id TYPE TEXT;
ALTER TABLE public.growth_records ALTER COLUMN user_id TYPE TEXT;

-- 步骤5: 重新创建策略
CREATE POLICY "Users can manage own pets" ON public.pets
  FOR ALL USING (user_id::text = auth.uid()::text OR user_id LIKE 'device_%');

CREATE POLICY "Users can manage own growth_records" ON public.growth_records
  FOR ALL USING (user_id::text = auth.uid()::text OR user_id LIKE 'device_%');

-- 验证
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name IN ('pets', 'growth_records')
AND column_name = 'user_id';
