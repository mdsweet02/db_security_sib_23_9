--Задание 1
CREATE DATABASE TestDB;

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50)
);

-- Создание таблицы
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50)
);

-- Добавление значений
INSERT INTO Users (Name) VALUES ('Sofia');
INSERT INTO Users (Name) VALUES ('Ivan');
INSERT INTO Users (Name) VALUES ('Aruzhan');
INSERT INTO Users (Name) VALUES ('Nurlan');
INSERT INTO Users (Name) VALUES ('Alexandr');

BACKUP DATABASE TestDB TO DISK =  'C:\student test\AW.bak'

BACKUP LOG TestDB TO DISK =    'C:\student test\AW1.trn'

BACKUP DATABASE TestDB TO DISK =  'C:\student test\AWDIFF1.bak'  WITH DIFFERENTIAL

BACKUP LOG TestDB TO DISK =   'С:\student test\AW2.TRN'

--задание 2

SELECT * FROM Users;


-- 1. Восстановить полный бэкап
RESTORE DATABASE TestDB 
FROM DISK = 'C:\student test\AW.bak' 
WITH NORECOVERY;

RESTORE DATABASE TestDB
FROM DISK = 'C:\student test\AWDIFF1.bak'
WITH RECOVERY;

RESTORE LOG TestDB FROM DISK = 'C:\student test\AW1.trn' WITH NORECOVERY; 

RESTORE LOG TestDB FROM DISK = 'C:\student test\AW2.trn' WITH RECOVERY;

--задание 3

CREATE DATABASE TestDBExample2

--мастер ключ
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '12345';

--сертификат
CREATE CERTIFICATE MyCert
WITH SUBJECT = 'Certificate for Backup Encryption'; 

--резервная копия
BACKUP MASTER KEY 
TO FILE = 'C:\database2\MasterKeyBackup.key'
ENCRYPTION BY PASSWORD = '12345';

BACKUP CERTIFICATE MyCert 
TO FILE = 'C:\database2\MyCertBackup.cer'
WITH PRIVATE KEY (
    FILE = 'C:\database2\MyCertPrivateKey.pvk',
    ENCRYPTION BY PASSWORD = '12345'
);

--резервная копия с шифрованием 
BACKUP DATABASE TestDBExample
TO DISK = 'C:\database2\TestDBExample_Encrypted.bak'
WITH ENCRYPTION (
    ALGORITHM = AES_256,
    SERVER CERTIFICATE = MyCert
);

--задание 4

--удаление мастер ключа
USE TestDBExample2;
DROP MASTER KEY;

--удаление сертификата
USE TestDBExample2;
DROP CERTIFICATE MyCert;

--УДАЛЕНИЕ БАЗЫ ДАННЫХ
DROP DATABASE TestDBExample2;

--ВОССТАНОВЛЕНИЕ ЗАШИФРОВАННОЙ БАЗЫ ДАННЫХ
RESTORE DATABASE TestDBExample2
FROM DISK = 'C:\database2\TestDBExample_Encrypted.bak'

--ЗАДАНИЕ 5
USE TestDBExample2;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '12345';
GO

CREATE CERTIFICATE MyCert
FROM FILE = 'C:\database2\MyCertBackup.cer'
WITH PRIVATE KEY (
    FILE = 'C:\database2\MyCertPrivateKey.pvk',
    DECRYPTION BY PASSWORD = '12345'
);
GO

RESTORE DATABASE TestDBExample
FROM DISK = 'C:\database2\TestDBExample_Encrypted.bak';
GO




