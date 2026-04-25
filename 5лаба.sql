-- ============================================
-- ВКЛЮЧЕНИЕ АУДИТА
-- ============================================

PRINT '=== 1. Включаем сам аудит СЕРВЕРА ===';

USE master;
GO

ALTER SERVER AUDIT Audit_ПриродФонд WITH (STATE = ON);
GO

PRINT '=== 2. Включаем спецификации СЕРВЕРА ===';

-- Включаем спецификацию входов
ALTER SERVER AUDIT SPECIFICATION Audit_Входы_ПриродФонд WITH (STATE = ON);
GO

-- Включаем спецификацию прав (если есть)
IF EXISTS (SELECT name FROM sys.server_audit_specifications WHERE name = 'Audit_Права_ПриродФонд')
BEGIN
    ALTER SERVER AUDIT SPECIFICATION Audit_Права_ПриродФонд WITH (STATE = ON);
    PRINT 'Audit_Права_ПриродФонд включена';
END
GO

PRINT '=== 3. Включаем спецификации БАЗЫ ДАННЫХ ===';

USE ПриродоохранныйФонд;
GO

-- Включаем спецификацию действий с сотрудниками (если есть)
IF EXISTS (SELECT name FROM sys.database_audit_specifications WHERE name = 'Audit_Действия_Сотрудники')
BEGIN
    ALTER DATABASE AUDIT SPECIFICATION Audit_Действия_Сотрудники WITH (STATE = ON);
    PRINT 'Audit_Действия_Сотрудники включена';
END

-- Включаем спецификацию объектов (если есть)
IF EXISTS (SELECT name FROM sys.database_audit_specifications WHERE name = 'Audit_Объекты_ПриродФонд')
BEGIN
    ALTER DATABASE AUDIT SPECIFICATION Audit_Объекты_ПриродФонд WITH (STATE = ON);
    PRINT 'Audit_Объекты_ПриродФонд включена';
END
GO

PRINT '=== АУДИТ ПОЛНОСТЬЮ ВКЛЮЧЕН ===';
GO