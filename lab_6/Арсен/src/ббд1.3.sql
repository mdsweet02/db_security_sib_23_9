USE ПриродоохранныйФонд;
GO

-- user_1: только чтение (например, стажер/наблюдатель)
ALTER ROLE db_datareader ADD MEMBER user_1;
GO

-- user_2: чтение и запись (например, сотрудник)
ALTER ROLE db_datareader ADD MEMBER user_2;
ALTER ROLE db_datawriter ADD MEMBER user_2;
GO

-- user_3: полный доступ (например, директор)
ALTER ROLE db_owner ADD MEMBER user_3;
GO