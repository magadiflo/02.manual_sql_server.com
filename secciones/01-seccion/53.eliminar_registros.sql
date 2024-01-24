/*-- ELIMINACIÓN DE REGISTROS --
Eliminar los registros de las tablas o vistas es una transacción donde
se debe tener mucho cuidado al ejercutar

IMPORTANTE
- Es recomendable que los registros tengan una eliminación lógica, utilizar para esto un campo
  para manejar el Estado del registro. El campo podría se un campo nchar que tenga los valores
  E para cuando está eliminado y A cuando no lo está.
- En ocasiones no se podrá eliminar los registros por restricciones de tipo Foreign key.
- En lo posible no implemente el borrado en cascada.
- Puede usar transacciones para la eliminación física de registros para tener la posibilidad de
  anular la eliminación si se comete algún error.
- Puede usar Truncate con algún cuidado especial para eliminar todos los registros de la tabla.
- Recuerde que si se eliminan los registros en una tabla con un campo Identity, se debe restablecer 
  la propiedad al valor inicial. 

INSTRUCCIÓN DELETE
Permite la eliminación de registros en una tabla

SINTAXIS
DELETE [TOP(expresión)[PERCENT]]
[FROM] Tabla
[WHERE <condición>]

DONDE:
TOP n [PERCENT], especifica los primeros registros que se eliminarán, puede expresarse en porcentajes
Tabla, nombre de la cabla donde se encuentran los registros a eliminar. Puede incluir el servidor,
	   el esquema y nombre de la tabla
WHERE, especifica la condición o condiciones que debe de cumplir los registros para eliminarse.
       
EJERCICIOS
Vamos a incluir algunos ejercicios, tenga cuidado con hacer estas pruebas, posiblemente se 
elimine información útil

*/
USE Northwind
GO

--Eliminar los productos descontinuados
DELETE FROM Products WHERE Discontinued = 1
GO

--Eliminar los clientes de españa
DELETE FROM Customers WHERE Country = 'Spain'
GO

--Eliminar los 5 productos más caros
DELETE FROM Products
WHERE ProductID IN(SELECT TOP 5 ProductID
				   FROM Products
				   ORDER BY UnitPrice DESC)
GO

/*La instrucción anterior es correcta, la restricción de tipo Foreign Key con la 
tabla Order_details no permite la eliminación. Se ha incluido una subconsutla
*/