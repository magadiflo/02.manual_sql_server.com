/*-- Ver tamaño de las bases de datos SQL Server --*/

/*Para visualizar las bases de datos existentes en una instancia
de SQLServer se usa la siguiente instrucción*/
SELECT *
FROM SYS.DATABASES AS d
GO

/*Mostrar los archivos de todas las bases de datos*/
SELECT *
FROM SYS.MASTER_FILES
GO

/*Listar los archivos de una base de datos*/
SP_HELPDB Northwind
GO

/*Listar una base de datos y el tamaño de sus archivos*/
SELECT
db_name(database_id) AS 'Base de datos',
isNull(iif(type = 0, 'Archivo de datos','Archivo de Transacciones'),'Total')
As 'Tipo de archivo',
Format((SUM(Size)* 8 / 1024.0),'###,##0.00') As 'Tamaño MB'
FROM sys.master_files
Where database_id = DB_ID('Northwind')
Group by Grouping sets (
(db_name(database_id),
iif(type = 0, 'Archivo de datos','Archivo de Transacciones')), (db_name(database_id)))
Order by db_name(database_id),
iif(type = 0, 'Archivo de datos','Archivo de Transacciones') DESC
go