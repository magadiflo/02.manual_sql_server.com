/*-- WHERE - FILTRADO DE REGISTROS SQL SERVER  --

El filtro de registros al hacer consultas permite seleccionar los datos que 
se requieren usando comparaciones de dos datos del mismo tipo y crear una 
expresión lógica con las condiciones que deben de cumplir los registros a 
seleccionar.

En una consulta usando Select es necesario casi siempre ser lo más explícito al 
extraer los datos de los registros, tanto en los campos necesarios en la consulta 
como en los registros a mostrar, no se recomienda mostrar, salvo que sea exactamente 
necesario, todos los campos o todos los registros, siempre filtre y para este filtro 
se debe usar la cláusua Where de Select.

IMPORTANTE
- Al hacer agrupamientos, si se va a filtrar por el campo agrupado se usa la cláusula
  HAVING
- Se puede usar la expresión lógica de la cláusula WHERE en la cláusula HAVING
  cuando en la instrucción se usen ambas
- No se puede usar la cláusula HAVING solamente con la expresión lógica de la cláusula
  WHERE.
- Se recomienda no usar muchos filtros en una consulta, además de crear índices para los
  campos por los cuales se filtra.
- Se sugiere incluir los filtros para campos calculados en la cláusula HAVING y para los
  campos sin agrupamiento en la cláusula WHERE
*/
USE Northwind
GO
/*EJERCICIO 01. Mostra rlos clientes de las ciudades de Berlin, Caracas, London y Sevilla.
  No se recomienda usar el símbolo * (asterístico) para mostrar todos los campos, se ha 
  utilizado para enfocar el ejercicio en el filtro
*/
SELECT * 
FROM Customers
WHERE City IN('Berlin', 'Caracas', 'London', 'Sevilla')
GO

/*EJERCICIO 02. FIltrar los clientes cuyo último dígito del número de teléfono es par. 
No incluir los que terminan en cero (0). Mostrar el nombre del cliente y el número de 
teléfno
*/
SELECT CompanyName, Phone
FROM Customers
WHERE (RIGHT(RTRIM(Phone), 1) % 2) = 0 AND RIGHT(RTRIM(Phone), 1) <> '0'
GO

/*EJERCICIO 03. Filtrar las órdenes generadas en los últimos 15 días. 
Como en Northwind las órdenes registradas están entre julio de 1996 y mayo de 1998, se 
va a tomar el 16 de noviembre de 1996 como fecha referencial para mostar las órdenes de 
los 15 días anteriores.

Para mostrar las órdenes de los últimos 15 días reemplace la fecha tomada como referencia 
por la fecha actual: Getdate() 
*/
--Tomamos a la fecha: 1996-11-16 (como si fuera fecha actual para el ejercicio)
SELECT OrderID AS [N° Orden], CONVERT(CHAR(10), OrderDate, 103) AS 'Fecha'
FROM Orders
WHERE OrderDate < '1996-11-16' AND  OrderDate >= DATEADD(DAY, -15, '1996-11-16') 
GO

/*IMPORTANTE: La expresión lógica del filtro con la fecha actual sería como sigue, 
usando Northwind no aparecen registros
*/
SELECT OrderID AS [N° Orden], CONVERT(CHAR(10), OrderDate, 103) AS 'Fecha'
FROM Orders
WHERE OrderDate >= DATEADD(DAY, -15, GETDATE()) 
GO

/*EJERCICIO 04. Filtrar los clientes cuyo nombre termine en la letra "s"
*/
SELECT * 
FROM Customers
WHERE CompanyName LIKE '%s'
GO

/*EJERCICIO 05. Listar los empleados cuyas edades están entre 50 y 80 años
*/
SELECT EmployeeID AS [Código], LastName AS Apellido, FirstName AS Nombre,
	   DATEDIFF(YEAR, BirthDate, GETDATE()) AS [Solo considera años], 
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

/*EJERCICIO 08. Listar los productos que no estén discontinuados, de las categorías 
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

/*EJERCICIO 10. Listar las órdenes de los clientes de USA, Canadá, Spain y UK. 
Incluir el nombre del empleado y el nombre del cliente. 
*/
SELECT o.OrderID, FORMAT(o.OrderDate, 'dd/MM/yyyy') AS Fecha, 
	   CONCAT(e.FirstName, ' ', e.LastName) AS Empleado,
	   c.CompanyName AS Cliente, c.Country AS País
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
WHERE c.Country IN('USA', 'Canada', 'Spain','UK')
ORDER BY País ASC, Cliente ASC, Empleado ASC
GO

/*EJERCICIO 11. Listar las órdenes que no han sido atendidas (campos ShippedDate es NULL)
de los clientes que tienen asignada una Región (campo Region no es NULL) de los países de 
Canadá, Brazil, Venezuela y USA. Incluir el nombre del empleado que la generó así como el 
nombre del cliente
*/
SELECT o.OrderID, FORMAT(o.OrderDate, 'dd/MM/yyyy') AS Fecha, 
	   CONCAT(e.FirstName, ' ', e.LastName) AS Empleado,
	   c.CompanyName AS Cliente, c.Country AS País
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
WHERE	o.ShippedDate IS NULL AND 
		c.Region IS NOT NULL AND
		c.Country IN('Canada', 'Brazil', 'Venezuela', 'USA')
ORDER BY País ASC, Cliente ASC, Empleado ASC
GO