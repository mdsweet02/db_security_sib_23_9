REVOKE UNMASK FROM MaskTestUser;

EXECUTE AS USER = 'MaskTestUser';
SELECT * FROM Сотрудники;
REVERT;
GO

EXECUTE AS USER = 'MaskTestUser';
SELECT * FROM Сотрудники
WHERE Зарплата > 600000;
REVERT;
