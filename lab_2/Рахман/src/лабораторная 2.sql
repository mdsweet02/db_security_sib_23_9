-- Задание 1: Создание базы данных и полной резервной копии
Create DATABASE TestDB;
-- Полная резервная копия
BACKUP DATABASE TestDB 
TO DISK = 'C:\TEST\TestDB.bak';
-- Создание таблицы и добавление первой записи
CREATE TABLE Students (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100)
);
--Добавление записи
INSERT INTO Students (Name) VALUES ('Kozhagulov Rakhman');

Select * FROM Students;
-- Резервная копия журнала
BACKUP LOG TestDB TO DISK = 'C:\TEST\AW1.trn';
-- Добавление записи
INSERT INTO Students (Name) VALUES ('Tony Stark');
-- Разностная копия базы данных
BACKUP DATABASE TestDB TO DISK = 'C:\TEST\AWDIFF1.bak' WITH DIFFERENTIAL;
-- Добавление записи
INSERT INTO Students (Name) VALUES ('Captain America');
-- Полная копия базы данных
BACKUP LOG TestDB TO DISK = 'C:\TEST\AW2.TRN';

BACKUP DATABASE TestDB TO DISK = 'C:\TEST\AW.bak';

USE TestDB;
SELECT * FROM Students;


-- Создание тестовой базы данных
CREATE DATABASE TestDBExample;

USE master;



-- Создание главного ключа базы данных master
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Kozh123';

-- Создание сертификата для шифрования
CREATE CERTIFICATE MyCert
WITH SUBJECT = 'Certificate';

-- Создание резервной копии главного ключа
BACKUP MASTER KEY
TO FILE = 'C:\TEST\MasterKeyBackup.key'
ENCRYPTION BY PASSWORD = '123';

-- Создание резервной копии сертификата
BACKUP CERTIFICATE MyCert
TO FILE = 'C:\TEST\MyCertBackup.cer'
WITH PRIVATE KEY (
    FILE = 'C:\TEST\MyCertPrivateKey.pvk',
    ENCRYPTION BY PASSWORD = '123'
);

-- Обычная резервная копия 
BACKUP DATABASE TestDBExample
TO DISK = 'C:\TEST\TestDBExample.bak';


USE master;

-- Удаляем сертификат
DROP CERTIFICATE MyCert;

-- Удаляем мастер ключ
DROP MASTER KEY;
-- Удаление БД
DROP DATABASE TestDBExample;
--Восстановление БД
RESTORE DATABASE TestDBExample
FROM DISK = 'C:\TEST\TestDBExample.bak';

-- Задание 5
USE TestDBExample;
-- Создание главного ключа
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '123';

-- Восстановление сертификата из резервной копии
CREATE CERTIFICATE MyCert
FROM FILE = 'C:\TEST\MyCertBackup.cer'
WITH PRIVATE KEY (
    FILE = 'C:\TEST\MyCertPrivateKey.pvk',
    DECRYPTION BY PASSWORD = '123'
);
-- Восстанавливаем зашифрованную БД 
RESTORE DATABASE TestDBExample
FROM DISK = 'C:\TEST\TestDBExample.bak';