USE ПриродоохранныйФонд;
GO

-- 1. Типы выбросов (справочник)
CREATE TABLE ТипыВыбросов (
    КодТипаВыброса INT IDENTITY(1,1) PRIMARY KEY,
    Наименование NVARCHAR(50) NOT NULL CHECK (Наименование IN ('в атмосферу', 'в воду', 'отходы производства'))
);
GO

-- 2. Вредные вещества
CREATE TABLE Вещества (
    КодВещества INT IDENTITY(1,1) PRIMARY KEY,
    Наименование NVARCHAR(100) NOT NULL,
    КлассОпасности INT NOT NULL CHECK (КлассОпасности BETWEEN 1 AND 5),
    КоэффициентПриведения DECIMAL(10,4) NOT NULL
);
GO

-- 3. Тарифы
CREATE TABLE Тарифы (
    КодВещества INT NOT NULL FOREIGN KEY REFERENCES Вещества(КодВещества),
    КодТипаВыброса INT NOT NULL FOREIGN KEY REFERENCES ТипыВыбросов(КодТипаВыброса),
    СтавкаЗаУсловнуюТонну DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (КодВещества, КодТипаВыброса)
);
GO

-- 4. Налоговые комитеты
CREATE TABLE НалоговыеКомитеты (
    КодКомитета INT IDENTITY(1,1) PRIMARY KEY,
    Наименование NVARCHAR(100) NOT NULL
);
GO

-- 5. Банки
CREATE TABLE Банки (
    КодБанка INT IDENTITY(1,1) PRIMARY KEY,
    Наименование NVARCHAR(100) NOT NULL,
    Адрес NVARCHAR(200) NULL
);
GO

-- 6. Природопользователи (основная таблица)
CREATE TABLE Природопользователи (
    БИН BIGINT PRIMARY KEY,
    Наименование NVARCHAR(200) NOT NULL,
    Адрес NVARCHAR(200) NULL,
    КодНалоговогоКомитета INT NOT NULL FOREIGN KEY REFERENCES НалоговыеКомитеты(КодКомитета),
    ЛицевойСчетВБанке NVARCHAR(50) NULL,
    КодБанка INT NULL FOREIGN KEY REFERENCES Банки(КодБанка)
);
GO

-- 7. Разрешения
CREATE TABLE Разрешения (
    НомерРазрешения NVARCHAR(50) PRIMARY KEY,
    ПериодДействия INT NOT NULL, -- в месяцах
    БИН BIGINT NOT NULL FOREIGN KEY REFERENCES Природопользователи(БИН),
    ДатаПолучения DATE NOT NULL,
    СуммаНалога DECIMAL(15,2) NULL
);
GO

-- 8. Лимиты выбросов
CREATE TABLE Лимиты (
    НомерРазрешения NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Разрешения(НомерРазрешения),
    КодТипаВыброса INT NOT NULL FOREIGN KEY REFERENCES ТипыВыбросов(КодТипаВыброса),
    КодВещества INT NOT NULL FOREIGN KEY REFERENCES Вещества(КодВещества),
    ОбъемВУсловныхТоннах DECIMAL(12,3) NOT NULL,
    PRIMARY KEY (НомерРазрешения, КодТипаВыброса, КодВещества)
);
GO

-- 9. Учет фактических выбросов
CREATE TABLE УчетВыбросов (
    КодЗаписи INT IDENTITY(1,1) PRIMARY KEY,
    НомерРазрешения NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Разрешения(НомерРазрешения),
    Дата DATE NOT NULL,
    Квартал INT NOT NULL CHECK (Квартал BETWEEN 1 AND 4),
    Год INT NOT NULL,
    КодВещества INT NOT NULL FOREIGN KEY REFERENCES Вещества(КодВещества),
    ОбъемВыбросовВУсловныхТоннах DECIMAL(12,3) NOT NULL,
    КодТипаВыброса INT NOT NULL FOREIGN KEY REFERENCES ТипыВыбросов(КодТипаВыброса)
);
GO

-- 10. Плановые платежи
CREATE TABLE ПлановыеПлатежи (
    НомерДокумента NVARCHAR(50) PRIMARY KEY,
    БИН BIGINT NOT NULL FOREIGN KEY REFERENCES Природопользователи(БИН),
    НомерРазрешения NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Разрешения(НомерРазрешения),
    Дата DATE NOT NULL,
    Квартал INT NOT NULL CHECK (Квартал BETWEEN 1 AND 4),
    Год INT NOT NULL,
    СуммаПлатежа DECIMAL(15,2) NOT NULL
);
GO