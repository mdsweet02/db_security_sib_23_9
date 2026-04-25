SELECT 
    event_time,
    session_server_principal_name AS Пользователь,
    object_name AS Таблица,
    statement AS Команда
FROM sys.fn_get_audit_file('C:\SQLAudit\*.sqlaudit', DEFAULT, DEFAULT)
WHERE action_id = 'DL';  -- DL = DELETE
GO