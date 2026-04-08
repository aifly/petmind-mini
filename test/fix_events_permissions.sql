-- PetMind 数据库权限修复脚本
-- 修复 events 表的访问权限

-- 1. 确保 events 表存在
CREATE TABLE IF NOT EXISTS public.events (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id TEXT NOT NULL,
    pet_id UUID REFERENCES public.pets(id),
    title TEXT NOT NULL,
    notes TEXT,
    event_date DATE NOT NULL,
    event_time TIME,
    icon TEXT DEFAULT '📅',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 启用 RLS (Row Level Security)
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

-- 3. 删除已存在的策略（避免重复创建错误）
DROP POLICY IF EXISTS "Users can view own events" ON public.events;
DROP POLICY IF EXISTS "Users can insert own events" ON public.events;
DROP POLICY IF EXISTS "Users can update own events" ON public.events;
DROP POLICY IF EXISTS "Users can delete own events" ON public.events;
DROP POLICY IF EXISTS "Users can manage own events" ON public.events;

-- 4. 创建新的访问策略
-- 允许用户查看自己的事件
CREATE POLICY "Users can view own events"
  ON public.events
  FOR SELECT
  USING (user_id = auth.uid()::text OR user_id LIKE 'device_%');

-- 允许用户插入自己的事件
CREATE POLICY "Users can insert own events"
  ON public.events
  FOR INSERT
  WITH CHECK (user_id = auth.uid()::text OR user_id LIKE 'device_%');

-- 允许用户更新自己的事件
CREATE POLICY "Users can update own events"
  ON public.events
  FOR UPDATE
  USING (user_id = auth.uid()::text OR user_id LIKE 'device_%');

-- 允许用户删除自己的事件
CREATE POLICY "Users can delete own events"
  ON public.events
  FOR DELETE
  USING (user_id = auth.uid()::text OR user_id LIKE 'device_%');

-- 5. 确认表结构
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'events' 
ORDER BY ordinal_position;
