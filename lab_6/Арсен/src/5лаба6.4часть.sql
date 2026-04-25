SELECT 
    event_time,
    action_id,
    object_name AS Объект,
    statement AS Команда
FROM sys.fn_get_audit_file('C:\SQLAudit\*.sqlaudit', DEFAULT, DEFAULT)
WHERE session_server_principal_name = 'guest';
GO