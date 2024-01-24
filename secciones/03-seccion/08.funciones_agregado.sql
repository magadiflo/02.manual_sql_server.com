/*-- FUNCIONES DE AGREGADO --

Devuelven estad�sticas usando campos num�ricos de las tablas.  
Solamente Count se puede usar con campos que no son num�ricos o se puede usar asterisco (*).

Las funciones de agregado se usan generalmente para obtener informaci�n desde varias tablas (Ver Joins) 
haciendo c�lculos en base a un detalle, por ejemplo, poder calcular la cantidad de facturas o boletas 
generadas por un empleados, el total de compras de un clientes, el promedio de monto de los documentos 
de compra de los proveedores, etc

Las funciones de agregado son las siguientes:

AVG		Devuelve el Promedio de los valores
MIN		Devuelve el valor M�nimo
SUM		Suma los valores
COUNT	Cuenta la cantidad de celdas
STDEV	Devuelve la desviaci�n est�ndar Muestral
STDEVP	Devuelve la desviaci�n est�ndar Poblacional
VAR		Devuelve la Varianza muestral
VARP	Devuelve la Varianza Poblacional
MAX		Devuelve el valor M�ximo
*/
USE Northwind
GO

--El precio m�s alto y m�s bajo de los productos. El total de productos y su promedio
SELECT MAX(UnitPrice) AS 'm�ximo', 
	   MIN(UnitPrice) AS 'minimo',
	   COUNT(*) AS 'total productos', 
	   AVG(UnitPrice) AS 'promedio'
FROM Products
GO

--Cantidad de productos en Stock
SELECT SUM(UnitsInStock)
FROM Products
GO

--Valor total de los productos en stock
SELECT SUM(UnitsInStock * UnitPrice) AS 'Precio total del stock'
FROM Products
GO