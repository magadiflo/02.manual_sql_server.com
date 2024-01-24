/*-- ELIMINANDO UN ÍNDICE EN SQL SERVER --

La instrucción DROP INDEX permite eliminar los índices de una tabla o vista.
La eliminación de un índice tiene que ser decidida con cuidado, si el índice
permitía que alguna consulta sea más óptima, eliminarlo podría causar que
las consultas y reportes en los sistemas sean más lentos

Sintaxis
DROP INDEX nombreIndice 
ON Tabla/Vista
*/

--Eliminar el índice idx_categorias_nombre de la tabla Categories
DROP INDEX idx_categorias_nombre
ON Categories
GO

--Eliminar varios índices
DROP INDEX CompanyName
ON Customers, 
idx_empleados_full_name
ON Employees
GO
