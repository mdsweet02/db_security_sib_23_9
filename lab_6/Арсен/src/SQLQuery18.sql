CREATE PROCEDURE ДобавитьНовыеТипыВыбросов
AS
BEGIN
    DECLARE @Счетчик INT = 1;
    DECLARE @НовоеНаименование NVARCHAR(50);
    
    WHILE @Счетчик <= 3
    BEGIN
        SET @НовоеНаименование = 'Новый тип выброса ' + CAST(@Счетчик AS NVARCHAR(10));
        
        -- Проверяем, нет ли уже такого наименования
        IF NOT EXISTS (SELECT 1 FROM ТипыВыбросов WHERE Наименование = @НовоеНаименование)
        BEGIN
            INSERT INTO ТипыВыбросов (Наименование)
            VALUES (@НовоеНаименование);
        END;
        
        SET @Счетчик = @Счетчик + 1;
    END;
END;
GO

exec ДобавитьНовыеТипыВыбросов

select * from ТипыВыбросов