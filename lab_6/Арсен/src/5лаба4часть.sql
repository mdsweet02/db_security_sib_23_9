USE ПриродоохранныйФонд;
GO

-- 1. SELECT (чтение)
PRINT '=== SELECT ===';
SELECT * FROM Сотрудники;
GO

-- 2. INSERT (добавление)
PRINT '=== INSERT ===';
INSERT INTO Сотрудники (ФИО, Телефон, Email, Зарплата, Возраст)
VALUES ('Аманов Айдос', '+77019998877', 'amanov@mail.kz', 700000, 25);
GO

-- 3. UPDATE (обновление)
PRINT '=== UPDATE ===';
UPDATE Сотрудники 
SET Зарплата = 500000 
WHERE ФИО = 'Иванов Иван';
GO

-- 4. DELETE (удаление)
PRINT '=== DELETE ===';
DELETE FROM Сотрудники WHERE ФИО = 'Сидоров Алексей';
GO

-- Проверяем результат
SELECT * FROM Сотрудники;
GO