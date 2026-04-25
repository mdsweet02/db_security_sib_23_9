USE master;
GO

-- Отслеживаем входы и выходы
CREATE SERVER AUDIT SPECIFICATION Audit_Входы_ПриродФонд
FOR SERVER AUDIT Audit_ПриродФонд
ADD (SUCCESSFUL_LOGIN_GROUP),      -- успешные входы
ADD (FAILED_LOGIN_GROUP),          -- неудачные входы
ADD (LOGOUT_GROUP)                 -- выходы
WITH (STATE = ON);
GO