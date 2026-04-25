-- Смотрим все события
SELECT 
    event_time,
    action_id,
    succeeded,
    session_server_principal_name AS Пользователь,
    database_name AS БазаДанных,
    object_name AS Объект,
    statement AS Команда
FROM sys.fn_get_audit_file('C:\SQLAudit\*.sqlaudit', DEFAULT, DEFAULT);
GO