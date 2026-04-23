--подготовка среды
CREATE DATABASE AuditLab;
GO
USE AuditLab;
GO

--создание таблицы
CREATE TABLE Employees
(
 EmployeeID INT PRIMARY KEY,
 FullName NVARCHAR(100),
 Department NVARCHAR(100),
 Salary INT
);

--ввод значений в таблицу
INSERT INTO Employees
VALUES
(1, 'Иванов Иван', 'IT', 800000),
(2, 'Петров Петр', 'Finance', 900000),
(3, 'Сидоров Алексей', 'HR', 650000);

--часть1
USE master;
GO
CREATE SERVER AUDIT Audit_UserActions
TO FILE
(
 FILEPATH = 'C:\sqlaudit\',
 MAXSIZE = 100 MB,
 MAX_ROLLOVER_FILES = 10,
 RESERVE_DISK_SPACE = OFF
);
GO
 --включение аудита
ALTER SERVER AUDIT Audit_UserActions
WITH (STATE = ON);
GO

--ЧАСТЬ 2
CREATE SERVER AUDIT SPECIFICATION Audit_LoginEvents
FOR SERVER AUDIT Audit_UserActions
ADD (SUCCESSFUL_LOGIN_GROUP),
ADD (FAILED_LOGIN_GROUP),
ADD (LOGOUT_GROUP)
WITH (STATE = ON);
GO

--
USE master;
GO
CREATE SERVER AUDIT Audit_UserActions2
TO FILE
(
 FILEPATH = 'C:\sqlaudit\two',
 MAXSIZE = 100 MB,
 MAX_ROLLOVER_FILES = 10,
 RESERVE_DISK_SPACE = OFF
);
GO
 --включение аудита
ALTER SERVER AUDIT Audit_UserActions2
WITH (STATE = ON);
GO


--часть3
USE AuditLab;
GO

CREATE DATABASE AUDIT SPECIFICATION Audit_EmployeeActions
FOR SERVER AUDIT Audit_UserActions2
ADD (SELECT ON dbo.Employees BY PUBLIC),
ADD (INSERT ON dbo.Employees BY PUBLIC),
ADD (UPDATE ON dbo.Employees BY PUBLIC),
ADD (DELETE ON dbo.Employees BY PUBLIC)
WITH (STATE = ON);
GO

--часть4
SELECT * FROM Employees;
INSERT INTO Employees
VALUES
(4, 'Касымов Ержан', 'IT', 750000);
UPDATE Employees
SET Salary = 850000
WHERE EmployeeID = 1;
DELETE FROM Employees
WHERE EmployeeID = 3;

--часть5
SELECT *
FROM sys.fn_get_audit_file
(
 'C:\sqlaudit\*',
 DEFAULT,
 DEFAULT
);

--часть6
SELECT event_time,
 server_principal_name,
 object_name,
 statement
FROM sys.fn_get_audit_file
(
 'C:\sqlaudit\*',
 DEFAULT,
 DEFAULT
)
WHERE action_id = 'DL';

--часть6
SELECT event_time,
 server_principal_name,
 statement
FROM sys.fn_get_audit_file
(
 'C:\sqlaudit\*',
 DEFAULT,
 DEFAULT
)
WHERE statement LIKE '%Salary%';

--часть6
SELECT event_time,
 server_principal_name,
 succeeded,
 statement
FROM sys.fn_get_audit_file
(
 'C:\sqlaudit\*',
 DEFAULT,
 DEFAULT
)
WHERE action_id = 'LGIF';


--часть6
SELECT event_time,
 action_id,
 object_name,
 statement
FROM sys.fn_get_audit_file
(
 'C:\sqlaudit\*',
 DEFAULT,
 DEFAULT
)
WHERE server_principal_name = 'TestUser';


--
USE master;
GO
CREATE SERVER AUDIT Audit_UserActions3
TO FILE
(
 FILEPATH = 'C:\sqlaudit\three',
 MAXSIZE = 100 MB,
 MAX_ROLLOVER_FILES = 10,
 RESERVE_DISK_SPACE = OFF
);
GO
 --включение аудита
ALTER SERVER AUDIT Audit_UserActions3
WITH (STATE = ON);
GO

--
USE master;
GO
CREATE SERVER AUDIT Audit_UserActions4
TO FILE
(
 FILEPATH = 'C:\sqlaudit\four',
 MAXSIZE = 100 MB,
 MAX_ROLLOVER_FILES = 10,
 RESERVE_DISK_SPACE = OFF
);
GO
 --включение аудита
ALTER SERVER AUDIT Audit_UserActions4
WITH (STATE = ON);
GO

--часть7
USE master;
GO

CREATE SERVER AUDIT SPECIFICATION Audit_PermissionChanges
FOR SERVER AUDIT Audit_UserActions4
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP),
ADD (DATABASE_PERMISSION_CHANGE_GROUP)
WITH (STATE = ON);
GO


--
USE master;
GO
CREATE SERVER AUDIT Audit_UserActions5
TO FILE
(
 FILEPATH = 'C:\sqlaudit\five',
 MAXSIZE = 100 MB,
 MAX_ROLLOVER_FILES = 10,
 RESERVE_DISK_SPACE = OFF
);
GO
 --включение аудита
ALTER SERVER AUDIT Audit_UserActions5
WITH (STATE = ON);
GO

--часть8
USE AuditLab;
GO
CREATE DATABASE AUDIT SPECIFICATION Audit_ObjectChanges
FOR SERVER AUDIT Audit_UserActions5
ADD (SCHEMA_OBJECT_CHANGE_GROUP)
WITH (STATE = ON);
GO


--часть9
ALTER DATABASE AUDIT SPECIFICATION Audit_EmployeeActions
WITH (STATE = OFF);

ALTER SERVER AUDIT SPECIFICATION Audit_LoginEvents
WITH (STATE = OFF);

