Use Природоохранный_фонд;
GO

CREATE TABLE Разрешения (
    Номер_разрешения INT PRIMARY KEY IDENTITY(1,1),
    Период_действия NVARCHAR(50),
    БИН_природопользователя CHAR(12),
    Дата_получения DATE,
    Сумма_налога DECIMAL(12,2)
);
