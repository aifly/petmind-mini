-- PetMind 日程表
-- 用于存储宠物日程/提醒事件

-- 创建 events 表
CREATE TABLE IF NOT EXISTS public.events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,
    pet_id TEXT,
    title TEXT NOT NULL,
    event_type TEXT NOT NULL,
    event_date DATE NOT NULL,
    event_time TEXT,
    notes TEXT,
    icon TEXT DEFAULT '📝',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 添加索引
CREATE INDEX IF NOT EXISTS idx_events_user_id ON public.events(user_id);
CREATE INDEX IF NOT EXISTS idx_events_pet_id ON public.events(pet_id);
CREATE INDEX IF NOT EXISTS idx_events_date ON public.events(event_date);

-- 启用 RLS
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

-- 创建策略：用户可以查看和操作自己的日程
CREATE POLICY "Users can manage own events" ON public.events
    FOR ALL
    USING (user_id::text = auth.uid()::text OR user_id LIKE 'device_%');

-- 添加 pet_id 列（如果需要关联宠物）
-- 注意：如果表已创建但没有 pet_id 列，可以取消注释以下行：
-- ALTER TABLE public.events ADD COLUMN IF NOT EXISTS pet_id TEXT;