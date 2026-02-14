
-- создание учетной записи


CREATE USER User1 FOR LOGIN User1;
CREATE USER User2 FOR LOGIN User2;
CREATE USER User3 FOR LOGIN User3;

--создание пользователей

CREATE LOGIN User1 WITH PASSWORD = 'Password1', DEFAULT_DATABASE = УгольнаяШахта;
CREATE LOGIN User2 WITH PASSWORD = 'Password2', DEFAULT_DATABASE = УгольнаяШахта;
CREATE LOGIN User3 WITH PASSWORD = 'Password3', DEFAULT_DATABASE = УгольнаяШахта;


--проверка создания пользователей

SELECT name, type_desc FROM sys.server_principals WHERE name LIKE 'User%';
SELECT name, type_desc FROM sys.database_principals WHERE name LIKE 'User%';

--назначение ролей

EXEC sp_addrolemember 'db_datareader', 'User1';
EXEC sp_addrolemember 'db_datareader', 'User2';
EXEC sp_addrolemember 'db_datawriter', 'User2';
EXEC sp_addrolemember 'db_datareader', 'User3';
DENY SELECT ON dbo.Учет TO User3;

--проверка ролей

EXEC sp_helpuser 'User1';
EXEC sp_helpuser 'User2';
EXEC sp_helpuser 'User3';

--проверка для 1 пользователя
SELECT * FROM Учет;
INSERT INTO Учет (Код_Участка) VALUES (3);

--проверка для 2 пользователя
SELECT * FROM Добыча;
INSERT INTO Добыча (Дата, Смена, Объем_добычи, Марка_угля, Код_участка, Объем_породы) VALUES ('2026-02-02', 2, 130.00, 'Д', 3, 30.00);
UPDATE Добыча SET Смена = 2 WHERE Дата = '2026-11-01';
DELETE FROM Добыча WHERE Код_участка = 2;

--проверка для 3 пользователя
SELECT * FROM Участки;
SELECT * FROM Учет;
