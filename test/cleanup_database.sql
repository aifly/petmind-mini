-- 清空数据库数据（保留 users 和 articles 表）
-- 注意：此操作不可逆，请谨慎执行

-- 1. 清空宠物表
DELETE FROM public.pets;

-- 2. 清空喂养记录表
DELETE FROM public.feeding_records;

-- 3. 清空健康记录表
DELETE FROM public.health_records;

-- 4. 清空成长记录表
DELETE FROM public.growth_records;

-- 5. 清空日历事件表
DELETE FROM public.events;

-- 验证：查看剩余数据
-- SELECT 'users' as table_name, COUNT(*) as count FROM public.users
-- UNION ALL
-- SELECT 'articles', COUNT(*) FROM public.articles
-- UNION ALL
-- SELECT 'pets', COUNT(*) FROM public.pets
-- UNION ALL
-- SELECT 'feeding_records', COUNT(*) FROM public.feeding_records
-- UNION ALL
-- SELECT 'health_records', COUNT(*) FROM public.health_records
-- UNION ALL
-- SELECT 'growth_records', COUNT(*) FROM public.growth_records
-- UNION ALL
-- SELECT 'events', COUNT(*) FROM public.events;
