CREATE PROCEDURE Добавить_ТриТипаВыбросов
AS
BEGIN
    DECLARE @Счетчик INT = 1;
    DECLARE @НовоеИмя NVARCHAR(100);
    
    WHILE @Счетчик <= 3
    BEGIN
        -- Создаем уникальное имя
        SET @НовоеИмя = 'Дополнительный выброс ' + CAST(@Счетчик AS NVARCHAR(10));
        
        -- Проверяем, нет ли уже такого имени
        IF NOT EXISTS (SELECT 1 FROM ТипыВыбросов WHERE Наименование = @НовоеИмя)
        BEGIN
            INSERT INTO ТипыВыбросов (Наименование)
            VALUES (@НовоеИмя);
            
            PRINT 'Добавлен тип выброса: ' + @НовоеИмя;
        END
        ELSE
        BEGIN
            PRINT 'Тип выброса уже существует: ' + @НовоеИмя;
        END;
        
        SET @Счетчик = @Счетчик + 1;
    END;
    
    PRINT 'Добавление 3-х новых типов выбросов завершено';
END;
GO