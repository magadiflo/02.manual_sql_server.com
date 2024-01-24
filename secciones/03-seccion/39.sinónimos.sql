/*-- SINÓNIMOS --

Se lo puede definir como un identificador de un objeto en la BD.  El objeto del que se crea el 
sinónimo no es necesario que exista al momento de crear el sinónimo, SQL Server  comprueba la 
existencia del objeto en tiempo de ejecución.

Los sinónimos pueden reducir los errores al hacer referencia a los objetos en instrucciones Transact SQL. 
Los sinónimos se crean en la base de datos abierta.

Se pueden crear sinónimos para:

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

--Para listar las categorías
SELECT * 
FROM Northwind.dbo.Categories
GO

--Crear un sinónimo para las categorías llamado cats
CREATE SYNONYM cats FOR Northwind.dbo.Categories
GO

--Listar las categorías usando el sinónimo
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

--Listar los sinónimos de la base de datos
SELECT base_object_name, * 
FROM SYS.SYNONYMS
GO

--Para eliminar un sinónimo
DROP SYNONYM NombreSinónimo
GO