USE ПриродоохранныйФонд;
GO

ALTER TABLE [Сотрудники]
ALTER COLUMN Телефон NVARCHAR(20)
MASKED WITH (FUNCTION = 'partial(0,"XXXXXXX",4)');
GO