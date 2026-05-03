--Создан серверный логин и пользователь БД с минимальными правами:
USE master;
CREATE LOGIN AppLogin WITH PASSWORD = 'Str0ngP@ssw0rd!';

USE Ателье;
CREATE USER AppUser FOR LOGIN AppLogin;
ALTER ROLE db_datareader ADD MEMBER AppUser;
GRANT INSERT ON Заказ TO AppUser;

--проверка
SELECT name FROM sys.database_principals WHERE type IN ('S', 'U', 'G');

SET NOCOUNT ON;

-- Объявляем переменные
DECLARE @dbName sysname;
DECLARE @sqlCommand NVARCHAR(500);

-- Создаём временную таблицу для хранения БД с AUTO_CLOSE = ON
CREATE TABLE #DatabasesToFix (
    DatabaseName sysname,
    AutoCloseStatus INT
);

-- Находим все пользовательские БД, у которых AUTO_CLOSE = 1 (ON)
INSERT INTO #DatabasesToFix (DatabaseName, AutoCloseStatus)
SELECT 
    name,
    is_auto_close_on
FROM sys.databases
WHERE 
    name NOT IN ('master', 'tempdb', 'model', 'msdb', 'Resource')  -- исключаем системные
    AND is_auto_close_on = 1;                                      -- только те, где включён

-- Проверяем, есть ли такие БД
IF EXISTS (SELECT 1 FROM #DatabasesToFix)
BEGIN
    PRINT 'Найдены базы данных с AUTO_CLOSE = ON. Начинаем исправление...';
    PRINT '--------------------------------------------------------------';
    
    -- Курсор для перебора БД
    DECLARE db_cursor CURSOR FOR
        SELECT DatabaseName FROM #DatabasesToFix;
    
    OPEN db_cursor;
    FETCH NEXT FROM db_cursor INTO @dbName;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Формируем и выполняем команду ALTER DATABASE
        SET @sqlCommand = 'ALTER DATABASE [' + @dbName + '] SET AUTO_CLOSE OFF;';
        PRINT 'Выполняется: ' + @sqlCommand;
        
        BEGIN TRY
            EXEC sp_executesql @sqlCommand;
            PRINT 'Успешно: AUTO_CLOSE отключён для БД "' + @dbName + '".';
        END TRY
        BEGIN CATCH
            PRINT 'ОШИБКА: Не удалось изменить БД "' + @dbName + '".';
            PRINT '  Код ошибки: ' + CAST(ERROR_NUMBER() AS VARCHAR);
            PRINT '  Сообщение: ' + ERROR_MESSAGE();
        END CATCH
        
        PRINT '--------------------------------------------------------------';
        FETCH NEXT FROM db_cursor INTO @dbName;
    END
    
    CLOSE db_cursor;
    DEALLOCATE db_cursor;
    
    PRINT 'Исправление завершено.';
END
ELSE
BEGIN
    PRINT 'Уязвимость VA1051 не обнаружена. Ни одна пользовательская БД не имеет AUTO_CLOSE = ON.';
END

-- Очистка
DROP TABLE #DatabasesToFix;

-- Финальная проверка: выводим список всех пользовательских БД с их текущим статусом AUTO_CLOSE
PRINT '';

SELECT 
    name AS [Имя базы данных],
    CASE is_auto_close_on
        WHEN 0 THEN 'OFF (безопасно)'
        WHEN 1 THEN 'ON (уязвимость сохраняется)'
    END AS [Статус AUTO_CLOSE]
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb', 'Resource')
ORDER BY name;

--6. Намеренно создайте в базе данных ситуацию, нарушающую одно из правил
ALTER LOGIN AppLogin WITH PASSWORD = '123';

ALTER ROLE db_owner ADD MEMBER AppUser;
