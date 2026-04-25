USE master;
GO

-- Создаем аудит (сохраняем в файл)
CREATE SERVER AUDIT Audit_ПриродФонд
TO FILE
(
    FILEPATH = 'C:\SQLAudit\',     -- путь к папке
    MAXSIZE = 100 MB,
    MAX_ROLLOVER_FILES = 10
);
GO

-- Включаем аудит
ALTER SERVER AUDIT Audit_ПриродФонд
WITH (STATE = ON);
GO