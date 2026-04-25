USE master;
GO

-- Удаляем старую, если есть
IF EXISTS (SELECT name FROM sys.server_audit_specifications WHERE name = 'Audit_Права_ПриродФонд')
BEGIN
    ALTER SERVER AUDIT SPECIFICATION Audit_Права_ПриродФонд WITH (STATE = OFF);
    DROP SERVER AUDIT SPECIFICATION Audit_Права_ПриродФонд;
    PRINT 'Старая спецификация удалена';
END
GO

-- Создаем новую
CREATE SERVER AUDIT SPECIFICATION Audit_Права_ПриродФонд
FOR SERVER AUDIT Audit_ПриродФонд
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP),
ADD (DATABASE_PERMISSION_CHANGE_GROUP)
WITH (STATE = ON);
GO

PRINT 'Спецификация Audit_Права_ПриродФонд создана и включена';
GO