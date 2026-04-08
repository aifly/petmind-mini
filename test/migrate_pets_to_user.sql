-- 宠物数据迁移脚本
-- 将 device_id 格式的宠物迁移到指定用户的 UUID 下

-- 查看当前所有宠物及其 user_id
SELECT id, name, user_id, created_at FROM public.pets ORDER BY created_at DESC;

-- 查看所有用户
SELECT id, email, device_id FROM public.users ORDER BY created_at DESC;

-- ==================== 迁移示例 ====================
-- 假设要把 device_id = 'device_xxx' 的宠物迁移到用户 UUID = 'user-uuid-xxx'
-- 请根据实际情况修改下面的值：

-- UPDATE public.pets 
-- SET user_id = '目标用户的UUID'
-- WHERE user_id = '原来的device_id';

-- 示例：把 device_1774324148494_opksvb3mj 的宠物迁移到用户 4473b02a-41f1-468b-b1b8-9261629eaea6
-- UPDATE public.pets 
-- SET user_id = '4473b02a-41f1-468b-b1b8-9261629eaea6'
-- WHERE user_id = 'device_1774324148494_opksvb3mj';

-- ==================== 批量迁移所有 device_id 宠物到指定用户 ====================
-- 如果你想把所有 device_id 格式的宠物都迁移到某个用户下，用这个：
-- UPDATE public.pets 
-- SET user_id = '目标用户的UUID'
-- WHERE user_id LIKE 'device_%';
