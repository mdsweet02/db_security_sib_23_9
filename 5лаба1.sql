-- на уровне сервера
USE master;
GO

CREATE LOGIN Testing 
WITH PASSWORD = '123456', 
DEFAULT_DATABASE = ПриродоохранныйФонд;
GO

-- для бд
USE ПриродоохранныйФонд;
GO

CREATE USER Testing 
FOR LOGIN Testing;
GO
