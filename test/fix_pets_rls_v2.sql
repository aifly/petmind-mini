-- 修复 pets 表 RLS 策略
-- 问题：anon key 请求时 auth.uid() 为 null，导致 device_ 用户也被拦截
-- 解决：对 device_ 前缀的 user_id 完全放开，不依赖 auth.uid()
-- 在 Supabase Dashboard -> SQL Editor 中执行

-- 1. 先删除旧策略
DROP POLICY IF EXISTS "Users can manage own pets" ON public.pets;
DROP POLICY IF EXISTS "Allow device users full access" ON public.pets;
DROP POLICY IF EXISTS "pets_device_policy" ON public.pets;

-- 2. 确保 RLS 开启
ALTER TABLE public.pets ENABLE ROW LEVEL SECURITY;

-- 3. 创建新策略：device_ 前缀用户可以访问自己的记录
--    使用 USING 控制读取，WITH CHECK 控制写入
CREATE POLICY "device_users_own_pets" ON public.pets
  FOR ALL
  TO anon, authenticated
  USING (user_id LIKE 'device_%')
  WITH CHECK (user_id LIKE 'device_%');

-- 4. 如果需要登录用户也能访问自己的数据，额外加一条
CREATE POLICY "auth_users_own_pets" ON public.pets
  FOR ALL
  TO authenticated
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

-- 5. 确保 anon 角色有表权限
GRANT ALL ON public.pets TO anon;
GRANT ALL ON public.pets TO authenticated;

-- 6. 验证
SELECT policyname, cmd, qual, with_check, roles
FROM pg_policies 
WHERE tablename = 'pets';
