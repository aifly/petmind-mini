-- 设置 Supabase Storage 存储桶和 RLS 策略
-- 用于 PetMind 图片上传

-- 1. 创建存储桶（在 Supabase Dashboard - Storage 中创建）
-- 桶名: petmind
-- 公开访问: 是 (Public)

-- 2. 创建 RLS 策略（允许匿名用户上传和读取）
-- 注意：这些策略需要在 Supabase Dashboard 中手动创建

-- 策略1: 允许任何人读取 (SELECT)
-- CREATE POLICY "Public can read images" ON storage.objects
--   FOR SELECT USING (bucket_id = 'petmind');

-- 策略2: 允许任何人上传 (INSERT)
-- CREATE POLICY "Public can upload images" ON storage.objects
--   FOR INSERT WITH CHECK (bucket_id = 'petmind');

-- 策略3: 允许任何人删除自己的文件 (DELETE)
-- CREATE POLICY "Public can delete images" ON storage.objects
--   FOR DELETE USING (bucket_id = 'petmind');

-- 3. 或者使用更宽松的策略（开发阶段）
-- 在 Dashboard - Storage - petmind - Policies 中添加:
-- 
-- Name: Allow all operations
-- Allowed operation: ALL
-- Target roles: anon, authenticated
-- Policy definition: bucket_id = 'petmind'

-- 4. 创建文件夹结构（通过 API 自动创建）
-- pets/, articles/, temp/
