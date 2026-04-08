-- PetMind events 表权限修复脚本（完整版）
-- 执行此脚本修复日历页面权限问题

-- 1. 删除旧表（如果存在结构问题）
-- DROP TABLE IF EXISTS public.events;

-- 2. 创建 events 表
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

-- 3. 启用 RLS
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

-- 4. 删除所有旧策略
DROP POLICY IF EXISTS "Users can view own events" ON public.events;
DROP POLICY IF EXISTS "Users can insert own events" ON public.events;
DROP POLICY IF EXISTS "Users can update own events" ON public.events;
DROP POLICY IF EXISTS "Users can delete own events" ON public.events;
DROP POLICY IF EXISTS "Allow all operations for device users" ON public.events;

-- 5. 创建宽松策略（允许所有 device_ 开头的用户访问）
CREATE POLICY "Allow all operations for device users"
  ON public.events
  FOR ALL
  USING (user_id LIKE 'device_%')
  WITH CHECK (user_id LIKE 'device_%');

-- 6. 确认表结构
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'events' 
ORDER BY ordinal_position;
