/*-- SIN�NIMOS --

Se lo puede definir como un identificador de un objeto en la BD.  El objeto del que se crea el 
sin�nimo no es necesario que exista al momento de crear el sin�nimo, SQL Server  comprueba la 
existencia del objeto en tiempo de ejecuci�n.

Los sin�nimos pueden reducir los errores al hacer referencia a los objetos en instrucciones Transact SQL. 
Los sin�nimos se crean en la base de datos abierta.

Se pueden crear sin�nimos para:

Assembly (CLR) Stored Procedure
Assembly (CLR) Table-valued Function
Assembly (CLR) Scalar Function
Assembly Aggregate (CLR) Aggregate
Functions Replication-filter-procedure
Extended Stored Procedure
SQL Scalar Function (Ver Funciones)
SQL Table-valued Function (Ver FDU con valores de tabla)
SQL Inline-table-valued Function
SQL Stored Procedure (Ver Procedimientos Almacenados)
Vista (Ver Vistas)
Tabla (definida por el usuario) (Ver Tablas)

SINTAXIS
CREATE SYNONYM [Esquema.]NombreSinonimo FOR Objeto
*/

USE Northwind
GO

--Para listar las categor�as
SELECT * 
FROM Northwind.dbo.Categories
GO

--Crear un sin�nimo para las categor�as llamado cats
CREATE SYNONYM cats FOR Northwind.dbo.Categories
GO

--Listar las categor�as usando el sin�nimo
SELECT * 
FROM cats
GO

--La tabla culture en el esquema production de la BD AdventureWorks
CREATE SYNONYM cul FOR AdventureWorks.Production.Culture
GO

--Listar las culturas
SELECT * 
FROM cul
GO

--Listar los sin�nimos de la base de datos
SELECT base_object_name, * 
FROM SYS.SYNONYMS
GO

--Para eliminar un sin�nimo
DROP SYNONYM NombreSin�nimo
GO