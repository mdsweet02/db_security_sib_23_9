--задание 1
--создание базы данных
CREATE DATABASE TestDB;

--резервное копирование бд
BACKUP DATABASE TestDB 
TO DISK =  'C:\TEST\AW.bak';

--внесение изменений в бд
USE TestDB
CREATE TABLE Student (
StudentId INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(100) NOT NULL,
Age INT
);

INSERT INTO Student (Name, Age) VALUES ('Калынюк София', 20);

SELECT * FROM Student;

ALTER DATABASE TestDB
SET RECOVERY FULL;

--резервное копирование 2

BACKUP DATABASE TestDB 
TO DISK =  'C:\TEST\AW.bak';

INSERT INTO Student (Name, Age) VALUES ('Лопастинский Александр', 20);

BACKUP LOG TestDB 
TO DISK =  'C:\TEST\AW.bak';

--разностная резервная копия

INSERT INTO Student (Name, Age) VALUES ('Иванов Иван', 20);

BACKUP DATABASE TestDB 
TO DISK =  'C:\TEST\AWDIFF1.bak'  WITH DIFFERENTIAL

--полная резервная копия

INSERT INTO Student (Name, Age) VALUES ('Илья Ильич', 20);

--задание 3
CREATE DATABASE TestDBExample

--мастер ключ
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Sonya052005@';

--сертификат
CREATE CERTIFICATE MyCert
WITH SUBJECT = 'Certificate for Backup Encryption'; 

--резервная копия
BACKUP MASTER KEY 
TO FILE = 'C:\Database\MasterKeyBackup.key'
ENCRYPTION BY PASSWORD = 'Sonya052005@';

BACKUP CERTIFICATE MyCert 
TO FILE = 'C:\Database\MyCertBackup.cer'
WITH PRIVATE KEY (
    FILE = 'C:\Database\MyCertPrivateKey.pvk',
    ENCRYPTION BY PASSWORD = 'Sonya052005@'
);

--резервная копия с шифрованием 
BACKUP DATABASE TestDBExample
TO DISK = 'C:\Database\TestDBExample_Encrypted.bak'
WITH ENCRYPTION (
    ALGORITHM = AES_256,
    SERVER CERTIFICATE = MyCert
);

--задание 4
--удаление мастер ключа
USE TestDBExample;
DROP MASTER KEY;

--удаление сертификата
USE TestDBExample;
DROP CERTIFICATE MyCert;

--УДАЛЕНИЕ БАЗЫ ДАННЫХ
DROP DATABASE TestDBExample;

--ВОССТАНОВЛЕНИЕ ЗАШИФРОВАННОЙ БАЗЫ ДАННЫХ
RESTORE DATABASE TestDBExample
FROM DISK = 'C:\Database\TestDBExample_Encrypted.bak'

--ЗАДАНИЕ 5
USE TestDBExample;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Sonya052005@';
GO

CREATE CERTIFICATE MyCert
FROM FILE = 'C:\Database\MyCertBackup.cer'
WITH PRIVATE KEY (
    FILE = 'C:\Database\MyCertPrivateKey.pvk',
    DECRYPTION BY PASSWORD = 'Sonya052005@'
);
GO

RESTORE DATABASE TestDBExample
FROM DISK = 'C:\Database\TestDBExample_Encrypted.bak';
GO