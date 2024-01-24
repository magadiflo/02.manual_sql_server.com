/*-- WHERE - FILTRADO DE REGISTROS SQL SERVER  --

El filtro de registros al hacer consultas permite seleccionar los datos que 
se requieren usando comparaciones de dos datos del mismo tipo y crear una 
expresi�n l�gica con las condiciones que deben de cumplir los registros a 
seleccionar.

En una consulta usando Select es necesario casi siempre ser lo m�s expl�cito al 
extraer los datos de los registros, tanto en los campos necesarios en la consulta 
como en los registros a mostrar, no se recomienda mostrar, salvo que sea exactamente 
necesario, todos los campos o todos los registros, siempre filtre y para este filtro 
se debe usar la cl�usua Where de Select.

IMPORTANTE
- Al hacer agrupamientos, si se va a filtrar por el campo agrupado se usa la cl�usula
  HAVING
- Se puede usar la expresi�n l�gica de la cl�usula WHERE en la cl�usula HAVING
  cuando en la instrucci�n se usen ambas
- No se puede usar la cl�usula HAVING solamente con la expresi�n l�gica de la cl�usula
  WHERE.
- Se recomienda no usar muchos filtros en una consulta, adem�s de crear �ndices para los
  campos por los cuales se filtra.
- Se sugiere incluir los filtros para campos calculados en la cl�usula HAVING y para los
  campos sin agrupamiento en la cl�usula WHERE
*/
USE Northwind
GO
/*EJERCICIO 01. Mostra rlos clientes de las ciudades de Berlin, Caracas, London y Sevilla.
  No se recomienda usar el s�mbolo * (aster�stico) para mostrar todos los campos, se ha 
  utilizado para enfocar el ejercicio en el filtro
*/
SELECT * 
FROM Customers
WHERE City IN('Berlin', 'Caracas', 'London', 'Sevilla')
GO

/*EJERCICIO 02. FIltrar los clientes cuyo �ltimo d�gito del n�mero de tel�fono es par. 
No incluir los que terminan en cero (0). Mostrar el nombre del cliente y el n�mero de 
tel�fno
*/
SELECT CompanyName, Phone
FROM Customers
WHERE (RIGHT(RTRIM(Phone), 1) % 2) = 0 AND RIGHT(RTRIM(Phone), 1) <> '0'
GO

/*EJERCICIO 03. Filtrar las �rdenes generadas en los �ltimos 15 d�as. 
Como en Northwind las �rdenes registradas est�n entre julio de 1996 y mayo de 1998, se 
va a tomar el 16 de noviembre de 1996 como fecha referencial para mostar las �rdenes de 
los 15 d�as anteriores.

Para mostrar las �rdenes de los �ltimos 15 d�as reemplace la fecha tomada como referencia 
por la fecha actual: Getdate() 
*/
--Tomamos a la fecha: 1996-11-16 (como si fuera fecha actual para el ejercicio)
SELECT OrderID AS [N� Orden], CONVERT(CHAR(10), OrderDate, 103) AS 'Fecha'
FROM Orders
WHERE OrderDate < '1996-11-16' AND  OrderDate >= DATEADD(DAY, -15, '1996-11-16') 
GO

/*IMPORTANTE: La expresi�n l�gica del filtro con la fecha actual ser�a como sigue, 
usando Northwind no aparecen registros
*/
SELECT OrderID AS [N� Orden], CONVERT(CHAR(10), OrderDate, 103) AS 'Fecha'
FROM Orders
WHERE OrderDate >= DATEADD(DAY, -15, GETDATE()) 
GO

/*EJERCICIO 04. Filtrar los clientes cuyo nombre termine en la letra "s"
*/
SELECT * 
FROM Customers
WHERE CompanyName LIKE '%s'
GO

/*EJERCICIO 05. Listar los empleados cuyas edades est�n entre 50 y 80 a�os
*/
SELECT EmployeeID AS [C�digo], LastName AS Apellido, FirstName AS Nombre,
	   DATEDIFF(YEAR, BirthDate, GETDATE()) AS [Solo considera a�os], 
	   FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))) AS [Considera mes de nacimiento],
	   BirthDate
FROM Employees
WHERE FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))) BETWEEN 50 AND 80
GO

/*EJERCICIO 06. Listar los productos que tienen unidades por atender mayores al 
  stock actual
*/
SELECT * 
FROM Products
WHERE UnitsOnOrder > UnitsInStock
GO

/*EJERCICIO 07. Listar los clientes cuyo contacto trabaje en ventas(contiene la 
palabra Sales en el campo ContactTitle)
*/
SELECT * 
FROM Customers
WHERE ContactTitle LIKE '%Sales%'
GO

/*EJERCICIO 08. Listar los productos que no est�n discontinuados, de las categor�as 
2,3,4 y 7 con un precio entre 10 y 50
*/
SELECT * 
FROM Products
WHERE Discontinued = 0 AND 
	  CategoryID IN(2,3,4,7) AND
	  UnitPrice BETWEEN 10 AND 50
GO

/*EJERCICIO 09. Mostrar los productos vendidos entre junio y agosto de 1997, incluir la
cantidad vendida y el monto total
*/
SELECT	p.ProductID,
		p.ProductName, 
		SUM(od.Quantity) AS [Cant. Productos], 
		SUM(od.Quantity * od.UnitPrice) AS [Monto total]
FROM Orders AS o
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID) 
	INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) BETWEEN 6 AND 8
GROUP BY p.ProductID, p.ProductName
ORDER BY p.ProductID
GO

/*EJERCICIO 10. Listar las �rdenes de los clientes de USA, Canad�, Spain y UK. 
Incluir el nombre del empleado y el nombre del cliente. 
*/
SELECT o.OrderID, FORMAT(o.OrderDate, 'dd/MM/yyyy') AS Fecha, 
	   CONCAT(e.FirstName, ' ', e.LastName) AS Empleado,
	   c.CompanyName AS Cliente, c.Country AS Pa�s
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
WHERE c.Country IN('USA', 'Canada', 'Spain','UK')
ORDER BY Pa�s ASC, Cliente ASC, Empleado ASC
GO

/*EJERCICIO 11. Listar las �rdenes que no han sido atendidas (campos ShippedDate es NULL)
de los clientes que tienen asignada una Regi�n (campo Region no es NULL) de los pa�ses de 
Canad�, Brazil, Venezuela y USA. Incluir el nombre del empleado que la gener� as� como el 
nombre del cliente
*/
SELECT o.OrderID, FORMAT(o.OrderDate, 'dd/MM/yyyy') AS Fecha, 
	   CONCAT(e.FirstName, ' ', e.LastName) AS Empleado,
	   c.CompanyName AS Cliente, c.Country AS Pa�s
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
WHERE	o.ShippedDate IS NULL AND 
		c.Region IS NOT NULL AND
		c.Country IN('Canada', 'Brazil', 'Venezuela', 'USA')
ORDER BY Pa�s ASC, Cliente ASC, Empleado ASC
GO