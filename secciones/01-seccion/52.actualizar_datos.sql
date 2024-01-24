/*-- ACTUALIZAR DATOS - UPDATE EN SQL SERVER --

- Los registros guardados en las tablas requieren en ocasiones que los datos de sus campos sean actualizados.
- Para actualizar debemos usar la instrucción Update, se asume que se tienen los permisos para hacerlo.
- Al ejecutar la instrucción Update se debe tener mucho cuidado en filtrar exactamente los registros a 
  actualizar, de no utilizar de manera correcta el filtro con Where para los registros a actualizar, 
  los cambios pueden afectar a registros que no se deben modificar y no hay forma de anular los cambios hechos. 
- Asegure de realizar el filtro correcto, tenga en cuenta los diversos operadores de SQL Server.

INSTRUCCIÓN UPDATE
Permite la actualización de los datos de los registros de las tablas

SINTAXIS
La forma de escribir la instrucción UPDATE para sql server es como sigue:

UPDATE [TOP N [PERCENT]] Tabla/Vista
SET {nombreColumn = {expresión | DEFAULT | NULL}}
[FROM {<TablaOrigne>}[, ...n]]
[WHERE {<Condición(es)>}]

DONDE:
TOP N [PERCENT], especifica los primeros registros que se actualizarán, pueden expresarse en porcentaje.
TABLA/VISTA, nombre de la tabla o vista a actualizar. Puede incluir el servidor, el esquema y el 
			nombre de la tabla o vista
SET, permite especificar las columnas de la tabla o vista que se actualizarán. Las columnas con restricciones
     primary key y la que tiene identity no se pueden actualizar. 
	 Las columnas con restricciones Foreign Key, Check y Unique deben cumplir con estas para actualizarse
FROM, especifica la tabla origen para la actualización de los registros
WHERE, especifica la condición o condiciones que deben cumplir los registros para actualizarse
*/

USE Northwind
GO

/*EJERCICIO 01. Cambiar la dirección del cliente Island Trading a "Av. Camino Real 3993"*/
UPDATE customers
SET Address = 'Av. Camino Real 3993'
WHERE CompanyName = 'Island Trading'
GO

/*EJERCICIO 02. Ver el resultado*/
SELECT * FROM customers WHERE CompanyName = 'Island Trading'
GO

/*EJERCICIO 03. Actualizar los precios de los productos de la categoría bebidas(beverages).
Aumentar en 3 unidades cada uno*/
UPDATE Products 
SET UnitPrice = UnitPrice + 3
WHERE CategoryID = (SELECT CategoryID 
					FROM Categories 
					WHERE CategoryName = 'Beverages')
GO
--Note la subconsulta usada en el where

/*EJERCICIO 04. Actualizar los datos del proveedor Tokyo Trades(código 4). Contacto: Sumiko Chavez,
Cargo: Administrador, Dirección: 1005 Oklahoma St., Ciudad: Nagasaky*/
UPDATE Suppliers
SET ContactName = 'Sumiko Chavez', ContactTitle = 'Administrador',
Address = '1005 Oklahoma St.', City = 'Nagazaky'
WHERE SupplierID = 4
GO

/*EJERCICIO 05. Actualizar la region de las órdenes que no han sido especificadas (Null)
Cambiar el Null por una cadena de caracteres en blanco
Las órdenes son que tienen Null en el campo ShipRegion son:*/
SELECT *
FROM Orders
WHERE ShipRegion IS NULL
GO

UPDATE Orders
SET ShipRegion = ''
WHERE ShipRegion IS NULL
GO
--Importante: En las tablas en toda la base de datos no debería aparecer el valor de NULL

/*EJERCICIO 06. Disminuir el precio en 20% de los productos que tienen más de 30 unidades
en stock sin incluir las unidades por atender. (UnitsStock - UnitsOnOrder > 30)*/

UPDATE Products
SET UnitPrice = UnitPrice * 0.80
WHERE UnitsInStock - UnitsOnOrder > 30
GO
