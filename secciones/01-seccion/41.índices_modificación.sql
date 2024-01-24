/*-- MODIFICACI�N DE �NDICES EN SQL Server --

Reindexar o reconstruir un �ndice es una operaci�n que se sugiere para planes de
mantenimiento, esto reordena los registros y permite en ocasiones optimizar las
consultas

Modificaci�n de �ndices
Instrucci�n ALTER INDEX: Modifica un �ndice en una tabla o vista. Al modificar se puede
deshabilitar, reorganizar(reconstruir) o cambiar sus opciones.

- Reconstruir un �ndice
  ALTER INDEX nombreIndice 
  ON Tabla/Vista REBUILD

- Reconstruir un �ndice modificando sus opciones
  ALTER INDEX nombreIndice 
  ON Tabla/Vista REBUILD
  WITH(Opciones)

EJERCICIOS
*/
USE Northwind
GO

--Los �ndices de la tabla Categories, primero obtenemos el object_id de la tabla
SELECT t.object_id
FROM SYS.TABLES AS t
WHERE name = 'Categories'
GO

--Listar los �ndices de una tabla teniendo el valor del object_id de la misma
SELECT *
FROM SYS.INDEXES
WHERE object_id = '661577395'
GO

--Reconstruir el �ndice idx_categorias_nombre
ALTER INDEX idx_categorias_nombre
ON Categories REBUILD
GO

--Reconstruir pk_categories asignando un factor de relleno de 70
ALTER INDEX pk_categories
ON Categories REBUILD
WITH(FILLFACTOR = 70)
GO

--Reconstruir todos los �ndices de products
ALTER INDEX ALL
ON Products REBUILD
GO