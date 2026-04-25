SELECT 
    event_time AS Время,
    CASE action_id 
        WHEN 'SL' THEN 'SELECT'
        WHEN 'IN' THEN 'INSERT'
        WHEN 'UP' THEN 'UPDATE'
        WHEN 'DL' THEN 'DELETE'
        WHEN 'LG' THEN 'LOGIN'
        WHEN 'LGIF' THEN 'FAILED LOGIN'
        WHEN 'LO' THEN 'LOGOUT'
        ELSE action_id
    END AS Действие,
    succeeded AS Успех,
    session_server_principal_name AS Пользователь,
    database_name AS БазаДанных,
    object_name AS Объект,
    statement AS Команда
FROM sys.fn_get_audit_file('C:\SQLAudit\*.sqlaudit', DEFAULT, DEFAULT)
ORDER BY event_time DESC;
GO