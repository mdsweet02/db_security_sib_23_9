SELECT 
    event_time,
    session_server_principal_name AS Пользователь,
    statement AS Команда
FROM sys.fn_get_audit_file('C:\SQLAudit\*.sqlaudit', DEFAULT, DEFAULT)
WHERE statement LIKE '%Зарплата%' OR statement LIKE '%Salary%';
GO