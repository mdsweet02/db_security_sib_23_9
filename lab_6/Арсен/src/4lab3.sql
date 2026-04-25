-- Подключитесь под sa
USE master;
GO

-- Создаем тестового пользователя БЕЗ права UNMASK
CREATE LOGIN MaskTestUser WITH PASSWORD = 'TestPassword123!';
GO

-- Переключаемся на твою БД
USE ПриродоохранныйФонд;
GO

-- Создаем пользователя в БД
CREATE USER MaskTestUser FOR LOGIN MaskTestUser;
GO

-- Даем права на чтение (маскировка работает даже при SELECT)
GRANT SELECT ON Банки TO MaskTestUser;
GRANT SELECT ON Разрешения TO MaskTestUser;
GRANT SELECT ON УчетВыбросов TO MaskTestUser;
GRANT SELECT ON ТипыВыбросов TO MaskTestUser;
GO

-- Проверяем, что пользователь создан
SELECT name, type_desc FROM sys.database_principals WHERE name = 'MaskTestUser';
GO