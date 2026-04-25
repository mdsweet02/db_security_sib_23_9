select name, type_desc from sys.server_principals where name like 'User_%'
select name, type_desc from sys.database_principals where name like 'User_%'