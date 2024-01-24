/*-- MODIFICACIÓN DE ÍNDICES EN SQL Server --

Reindexar o reconstruir un índice es una operación que se sugiere para planes de
mantenimiento, esto reordena los registros y permite en ocasiones optimizar las
consultas

Modificación de índices
Instrucción ALTER INDEX: Modifica un índice en una tabla o vista. Al modificar se puede
deshabilitar, reorganizar(reconstruir) o cambiar sus opciones.

- Reconstruir un índice
  ALTER INDEX nombreIndice 
  ON Tabla/Vista REBUILD

- Reconstruir un índice modificando sus opciones
  ALTER INDEX nombreIndice 
  ON Tabla/Vista REBUILD
  WITH(Opciones)

EJERCICIOS
*/
USE Northwind
GO

--Los índices de la tabla Categories, primero obtenemos el object_id de la tabla
SELECT t.object_id
FROM SYS.TABLES AS t
WHERE name = 'Categories'
GO

--Listar los índices de una tabla teniendo el valor del object_id de la misma
SELECT *
FROM SYS.INDEXES
WHERE object_id = '661577395'
GO

--Reconstruir el índice idx_categorias_nombre
ALTER INDEX idx_categorias_nombre
ON Categories REBUILD
GO

--Reconstruir pk_categories asignando un factor de relleno de 70
ALTER INDEX pk_categories
ON Categories REBUILD
WITH(FILLFACTOR = 70)
GO

--Reconstruir todos los índices de products
ALTER INDEX ALL
ON Products REBUILD
GO