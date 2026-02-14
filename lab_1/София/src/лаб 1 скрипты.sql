
-- создание учетной записи

USE Ателье;

CREATE USER AtelierUser1 FOR LOGIN AtelierUser1;
CREATE USER AtelierUser2 FOR LOGIN AtelierUser2;
CREATE USER AtelierUser3 FOR LOGIN AtelierUser3;

--создание пользователей

CREATE LOGIN AtelierUser1 WITH PASSWORD = 'Password1', DEFAULT_DATABASE = Ателье;
CREATE LOGIN AtelierUser2 WITH PASSWORD = 'Password2', DEFAULT_DATABASE = Ателье;
CREATE LOGIN AtelierUser3 WITH PASSWORD = 'Password3', DEFAULT_DATABASE = Ателье;


--проверка создания пользователей

SELECT name, type_desc FROM sys.server_principals WHERE name LIKE 'AtelierUser%';
SELECT name, type_desc FROM sys.database_principals WHERE name LIKE 'AtelierUser%';

--назначение ролей

EXEC sp_addrolemember 'db_datareader', 'AtelierUser1';
EXEC sp_addrolemember 'db_datareader', 'AtelierUser2';
EXEC sp_addrolemember 'db_datawriter', 'AtelierUser2';
EXEC sp_addrolemember 'db_datareader', 'AtelierUser3';
DENY SELECT ON dbo.Заказ TO AtelierUser3;

--проверка ролей

EXEC sp_helpuser 'AtelierUser1';
EXEC sp_helpuser 'AtelierUser2';
EXEC sp_helpuser 'AtelierUser3';

