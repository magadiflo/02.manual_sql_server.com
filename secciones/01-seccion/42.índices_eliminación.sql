/*-- ELIMINANDO UN �NDICE EN SQL SERVER --

La instrucci�n DROP INDEX permite eliminar los �ndices de una tabla o vista.
La eliminaci�n de un �ndice tiene que ser decidida con cuidado, si el �ndice
permit�a que alguna consulta sea m�s �ptima, eliminarlo podr�a causar que
las consultas y reportes en los sistemas sean m�s lentos

Sintaxis
DROP INDEX nombreIndice 
ON Tabla/Vista
*/

--Eliminar el �ndice idx_categorias_nombre de la tabla Categories
DROP INDEX idx_categorias_nombre
ON Categories
GO

--Eliminar varios �ndices
DROP INDEX CompanyName
ON Customers, 
idx_empleados_full_name
ON Employees
GO
