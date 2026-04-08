-- =====================================================
-- 修复图片上传问题：1) 添加 avatar 字段 2) 创建存储桶
-- =====================================================

-- 1. 添加 pets 表的 avatar 字段
ALTER TABLE public.pets ADD COLUMN IF NOT EXISTS avatar TEXT;

-- 2. 添加 articles 表的 cover_url 字段（如果不存在）
ALTER TABLE public.articles ADD COLUMN IF NOT EXISTS cover_url TEXT;

-- 3. 创建 petmind 存储桶（通过 SQL 无法直接创建，需要在 Dashboard 操作）
-- 注意：存储桶需要通过 Supabase Dashboard 创建

-- 4. 添加存储桶的 RLS 策略（创建存储桶后在 Dashboard 配置）
-- 策略1: 允许匿名用户读取
-- CREATE POLICY "Allow public read" ON storage.objects FOR SELECT USING (bucket_id = 'petmind');

-- 策略2: 允许认证用户上传
-- CREATE POLICY "Allow authenticated upload" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'petmind');

-- 策略3: 允许匿名用户上传（小程序未登录时也能上传）
-- CREATE POLICY "Allow anon upload" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'petmind');
