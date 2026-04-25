-- ============================================
-- ОТКЛЮЧЕНИЕ АУДИТА
-- ============================================

PRINT '=== 1. Отключаем спецификации БАЗЫ ДАННЫХ ===';

USE ПриродоохранныйФонд;
GO

-- Отключаем спецификацию аудита действий (если есть)
IF EXISTS (SELECT name FROM sys.database_audit_specifications WHERE name = 'Audit_Действия_Сотрудники')
BEGIN
    ALTER DATABASE AUDIT SPECIFICATION Audit_Действия_Сотрудники WITH (STATE = OFF);
    PRINT 'Audit_Действия_Сотрудники отключена';
END

-- Отключаем спецификацию аудита объектов
IF EXISTS (SELECT name FROM sys.database_audit_specifications WHERE name = 'Audit_Объекты_ПриродФонд')
BEGIN
    ALTER DATABASE AUDIT SPECIFICATION Audit_Объекты_ПриродФонд WITH (STATE = OFF);
    PRINT 'Audit_Объекты_ПриродФонд отключена';
END
GO

PRINT '=== 2. Отключаем спецификации СЕРВЕРА ===';

USE master;
GO

-- Отключаем спецификацию входов
IF EXISTS (SELECT name FROM sys.server_audit_specifications WHERE name = 'Audit_Входы_ПриродФонд')
BEGIN
    ALTER SERVER AUDIT SPECIFICATION Audit_Входы_ПриродФонд WITH (STATE = OFF);
    PRINT 'Audit_Входы_ПриродФонд отключена';
END

-- Отключаем спецификацию прав
IF EXISTS (SELECT name FROM sys.server_audit_specifications WHERE name = 'Audit_Права_ПриродФонд')
BEGIN
    ALTER SERVER AUDIT SPECIFICATION Audit_Права_ПриродФонд WITH (STATE = OFF);
    PRINT 'Audit_Права_ПриродФонд отключена';
END
GO

PRINT '=== 3. Отключаем сам аудит ===';

ALTER SERVER AUDIT Audit_ПриродФонд WITH (STATE = OFF);
GO

PRINT '=== АУДИТ ПОЛНОСТЬЮ ОТКЛЮЧЕН ===';
GO