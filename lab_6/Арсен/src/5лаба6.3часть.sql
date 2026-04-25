SELECT 
   *
FROM sys.fn_get_audit_file('C:\SQLAudit\*.sqlaudit', DEFAULT, DEFAULT)
WHERE action_id = 'LGIF';  -- LGIF = Failed Login
GO