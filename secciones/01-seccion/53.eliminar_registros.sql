/*-- ELIMINACI�N DE REGISTROS --
Eliminar los registros de las tablas o vistas es una transacci�n donde
se debe tener mucho cuidado al ejercutar

IMPORTANTE
- Es recomendable que los registros tengan una eliminaci�n l�gica, utilizar para esto un campo
  para manejar el Estado del registro. El campo podr�a se un campo nchar que tenga los valores
  E para cuando est� eliminado y A cuando no lo est�.
- En ocasiones no se podr� eliminar los registros por restricciones de tipo Foreign key.
- En lo posible no implemente el borrado en cascada.
- Puede usar transacciones para la eliminaci�n f�sica de registros para tener la posibilidad de
  anular la eliminaci�n si se comete alg�n error.
- Puede usar Truncate con alg�n cuidado especial para eliminar todos los registros de la tabla.
- Recuerde que si se eliminan los registros en una tabla con un campo Identity, se debe restablecer 
  la propiedad al valor inicial. 

INSTRUCCI�N DELETE
Permite la eliminaci�n de registros en una tabla

SINTAXIS
DELETE [TOP(expresi�n)[PERCENT]]
[FROM] Tabla
[WHERE <condici�n>]

DONDE:
TOP n [PERCENT], especifica los primeros registros que se eliminar�n, puede expresarse en porcentajes
Tabla, nombre de la cabla donde se encuentran los registros a eliminar. Puede incluir el servidor,
	   el esquema y nombre de la tabla
WHERE, especifica la condici�n o condiciones que debe de cumplir los registros para eliminarse.
       
EJERCICIOS
Vamos a incluir algunos ejercicios, tenga cuidado con hacer estas pruebas, posiblemente se 
elimine informaci�n �til

*/
USE Northwind
GO

--Eliminar los productos descontinuados
DELETE FROM Products WHERE Discontinued = 1
GO

--Eliminar los clientes de espa�a
DELETE FROM Customers WHERE Country = 'Spain'
GO

--Eliminar los 5 productos m�s caros
DELETE FROM Products
WHERE ProductID IN(SELECT TOP 5 ProductID
				   FROM Products
				   ORDER BY UnitPrice DESC)
GO

/*La instrucci�n anterior es correcta, la restricci�n de tipo Foreign Key con la 
tabla Order_details no permite la eliminaci�n. Se ha incluido una subconsutla
*/