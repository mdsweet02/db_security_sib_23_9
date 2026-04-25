USE ПриродоохранныйФонд;
GO

-- Создаем аудит для таблицы Сотрудники
CREATE DATABASE AUDIT SPECIFICATION Audit_Действия_Сотрудники
FOR SERVER AUDIT Audit_ПриродФонд
ADD (SELECT ON dbo.Сотрудники BY PUBLIC),     -- чтение
ADD (INSERT ON dbo.Сотрудники BY PUBLIC),     -- вставка
ADD (UPDATE ON dbo.Сотрудники BY PUBLIC),     -- обновление
ADD (DELETE ON dbo.Сотрудники BY PUBLIC)      -- удаление
WITH (STATE = ON);
GO