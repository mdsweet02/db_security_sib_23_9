USE master
GO

ALTER DATABASE arsenchik SET SINGLE_USER WITH ROLLBACK IMMEDIATE
EXEC sp_detach_db 'arsenchik'