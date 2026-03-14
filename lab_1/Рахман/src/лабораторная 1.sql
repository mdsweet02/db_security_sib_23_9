
-- ЗАДАНИЕ 1. Создание 3 логинов 


CREATE LOGIN Admin WITH PASSWORD = '123', DEFAULT_DATABASE = master;
CREATE LOGIN User4 WITH PASSWORD = '123', DEFAULT_DATABASE = master;
CREATE LOGIN Guest WITH PASSWORD = '123', DEFAULT_DATABASE = master;
GO


-- ЗАДАНИЕ 2. Создание пользователей в БД на основе логинов

USE Аптека2;
GO

CREATE USER Admin FOR LOGIN Admin;
CREATE USER User4 FOR LOGIN User4;
CREATE USER Guest FOR LOGIN Guest;
GO

-- Проверка созданных пользователей
SELECT name, type_desc
FROM sys.database_principals
WHERE type = 'S'
  AND name NOT IN ('INFORMATION_SCHEMA', 'sys');
GO


-- ЗАДАНИЕ 3. Назначение ролей каждому пользователю

USE Аптека2;
GO

-- Admin получает роль db_owner (полный доступ)
EXEC sp_addrolemember 'db_owner', 'Admin';

-- User4 получает роль db_datareader (только чтение)
EXEC sp_addrolemember 'db_datareader', 'User4';

-- Guest получает роль db_datareader (только чтение, с ограничениями в задании 4)
EXEC sp_addrolemember 'db_datareader', 'Guest';
GO

-- Проверка назначенных ролей
SELECT
    r.name AS RoleName,
    m.name AS UserName
FROM sys.database_role_members rm
JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
WHERE m.name IN ('Admin', 'User4', 'Guest')
ORDER BY UserName, RoleName;
GO


-- ЗАДАНИЕ 4. Определение разрешений доступа (3 уровня)

USE Аптека2;
GO

-- Admin получает полный доступ через роль db_owner
EXEC sp_addrolemember 'db_owner', 'Admin';

-- User4 получает только чтение через роль db_datareader
EXEC sp_addrolemember 'db_datareader', 'User4';

-- Guest получает чтение, но с запретом на таблицу Продажа
EXEC sp_addrolemember 'db_datareader', 'Guest';
DENY SELECT, INSERT, UPDATE, DELETE ON Продажа TO Guest;
GO


-- ЗАДАНИЕ 5. Доказательство правильности выполненных действий

USE Аптека2;
GO

-- Проверка логинов на уровне сервера
SELECT name, type_desc
FROM sys.server_principals
WHERE name IN ('Admin', 'User4', 'Guest');
GO

-- Проверка пользователей на уровне БД
SELECT name, type_desc
FROM sys.database_principals
WHERE name IN ('Admin', 'User4', 'Guest');
GO

-- Проверка назначенных ролей
EXEC sp_helprolemember 'db_owner';
EXEC sp_helprolemember 'db_datareader';
GO

-- Тест от имени Admin (полный доступ: SELECT, INSERT, UPDATE, DELETE)
EXECUTE AS USER = 'Admin';
    SELECT * FROM Препараты;
    SELECT * FROM Продажа;
    INSERT INTO Препараты (Код_препарата, Наименование, Код_типа, Код_вида, Статус)
    VALUES (999, 'Тестовый препарат', 1, 1, 'свободная продажа');
    UPDATE Препараты SET Наименование = 'Обновлённый тест' WHERE Код_препарата = 999;
    DELETE FROM Препараты WHERE Код_препарата = 999;
REVERT;
GO

-- Тест от имени User4 (только чтение, INSERT вызовет ошибку)
EXECUTE AS USER = 'User4';
    SELECT * FROM Препараты;
    SELECT * FROM Продажа;
    INSERT INTO Препараты (Код_препарата, Наименование, Код_типа, Код_вида, Статус)
    VALUES (999, 'Тест', 1, 1, 'свободная продажа');
REVERT;
GO

-- Тест от имени Guest (чтение Препараты разрешено, Продажа запрещена)
EXECUTE AS USER = 'Guest';
    SELECT * FROM Препараты;
    SELECT * FROM Продажа;
REVERT;
GO