-- ============================================
-- 1. СОЗДАНИЕ ТЕСТОВОГО ЛОГИНА И ПОЛЬЗОВАТЕЛЯ
-- ============================================
USE master;
GO

CREATE LOGIN MaskTestUser WITH PASSWORD = 'TestPassword123!';
GO

USE ПриродоохранныйФонд;
GO

CREATE USER MaskTestUser FOR LOGIN MaskTestUser;
GO

GRANT SELECT ON Сотрудники TO MaskTestUser;
GO

-- ============================================
-- 2. ДОБАВЛЯЕМ МАСКИРОВКУ (без переключения на master!)
-- ============================================

-- Маскировка телефона: показываем последние 4 цифры
ALTER TABLE Сотрудники
ALTER COLUMN Телефон NVARCHAR(20)
MASKED WITH (FUNCTION = 'partial(0,"X",4)');
GO

-- Маскировка email
ALTER TABLE Сотрудники
ALTER COLUMN Email NVARCHAR(100)
MASKED WITH (FUNCTION = 'email()');
GO

-- Маскировка зарплаты: показываем 0
ALTER TABLE Сотрудники
ALTER COLUMN Зарплата INT
MASKED WITH (FUNCTION = 'default()');
GO

-- Маскировка возраста: случайное число от 18 до 60
ALTER TABLE Сотрудники
ALTER COLUMN Возраст INT
MASKED WITH (FUNCTION = 'random(18,60)');
GO

-- ============================================
-- 3. ПРОВЕРКА ПОД ПОЛЬЗОВАТЕЛЕМ (БЕЗ UNMASK)
-- ============================================
EXECUTE AS USER = 'MaskTestUser';
SELECT * FROM Сотрудники;
REVERT;
GO

-- ============================================
-- 4. ВЫДАЧА UNMASK
-- ============================================
GRANT UNMASK TO MaskTestUser;

EXECUTE AS USER = 'MaskTestUser';
SELECT * FROM Сотрудники;
REVERT;
GO

-- ============================================
-- 5. ОТЗЫВ UNMASK
-- ============================================
REVOKE UNMASK FROM MaskTestUser;

EXECUTE AS USER = 'MaskTestUser';
SELECT * FROM Сотрудники;
REVERT;
GO

-- ============================================
-- 6. УДАЛЕНИЕ МАСКИРОВКИ
-- ============================================
ALTER TABLE Сотрудники ALTER COLUMN Телефон DROP MASKED;
ALTER TABLE Сотрудники ALTER COLUMN Email DROP MASKED;
ALTER TABLE Сотрудники ALTER COLUMN Зарплата DROP MASKED;
ALTER TABLE Сотрудники ALTER COLUMN Возраст DROP MASKED;
GO

-- ============================================
-- 7. ПРОВЕРКА ОГРАНИЧЕНИЙ
-- ============================================
-- Снова добавляем маскировку для теста
ALTER TABLE Сотрудники ALTER COLUMN Email MASKED WITH (FUNCTION = 'email()');
ALTER TABLE Сотрудники ALTER COLUMN Зарплата MASKED WITH (FUNCTION = 'default()');
GO

EXECUTE AS USER = 'MaskTestUser';
-- Поиск по LIKE (работает, даже если email замаскирован)
SELECT * FROM Сотрудники WHERE Email LIKE 'ivanov%';
-- Поиск по зарплате (работает, даже если видит 0)
SELECT * FROM Сотрудники WHERE Зарплата > 1000000;
REVERT;
GO

-- ============================================
-- 8. ОЧИСТКА (для старых версий SQL Server - без IF)
-- ============================================
ALTER TABLE Сотрудники ALTER COLUMN Email DROP MASKED;
ALTER TABLE Сотрудники ALTER COLUMN Зарплата DROP MASKED;
GO

-- Удаляем пользователя из БД
USE ПриродоохранныйФонд;
GO
DROP USER MaskTestUser;
GO

-- Удаляем логин
USE master;
GO
DROP LOGIN MaskTestUser;
GO