USE ПриродоохранныйФонд;
GO

-- Создаем спецификацию для отслеживания изменений объектов
CREATE DATABASE AUDIT SPECIFICATION Audit_Объекты_ПриродФонд
FOR SERVER AUDIT Audit_ПриродФонд
ADD (SCHEMA_OBJECT_CHANGE_GROUP)
WITH (STATE = ON);
GO

PRINT 'Спецификация Audit_Объекты_ПриродФонд создана и включена';
GO

-- Проверка: создаем и удаляем тестовую таблицу
PRINT '=== СОЗДАЕМ ТЕСТОВУЮ ТАБЛИЦУ ===';
CREATE TABLE ТестТаблица (ID INT);
GO

PRINT '=== УДАЛЯЕМ ТЕСТОВУЮ ТАБЛИЦУ ===';
DROP TABLE ТестТаблица;
GO

-- Смотрим результат в аудите
SELECT 
    event_time,
    action_id,
    session_server_principal_name AS Пользователь,
    database_name AS БазаДанных,
    object_name AS Объект,
    statement AS Команда
FROM sys.fn_get_audit_file('C:\SQLAudit\*.sqlaudit', DEFAULT, DEFAULT)
WHERE database_name = 'ПриродоохранныйФонд'
ORDER BY event_time DESC;
GO