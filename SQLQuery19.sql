CREATE PROCEDURE КоличествоРазрешенийНаДату
    @Дата DATE
AS
BEGIN
    SELECT 
        COUNT(DISTINCT БИН) AS КоличествоПриродопользователей,
        COUNT(*) AS ОбщееКоличествоРазрешений
    FROM Разрешения
    WHERE ДатаПолучения = @Дата;
END;
GO

exec КоличествоРазрешенийНаДату '2024-02-20'

select *  FROM Разрешения