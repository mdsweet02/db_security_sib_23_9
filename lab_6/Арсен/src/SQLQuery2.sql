Use Природоохранный_фонд;
GO
CREATE TABLE Вещества (
    Код_вещества INT PRIMARY KEY IDENTITY(1,1),
    Наименование NVARCHAR(100),
    Класс_опасности INT,
    Кэфф_приведения DECIMAL(10,2)
);