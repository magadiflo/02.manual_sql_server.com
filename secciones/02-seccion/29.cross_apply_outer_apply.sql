/*-- CROSS APPLY Y OUTER APPLY SQL SERVER --


La cl�usula CROSS APPLY de la instrucci�n select se comporta de manera similar a una subconsulta
correlacionada, con la diferencia que nos permite usar la cl�usula ORDER BY dentro de la 
subconsulta.

Esto es muy �til cuando se requiere registros superiores o inferiores de una subconsulta para 
usarlo en una subconsulta externa.

La subconsulta de la cl�usula CROSS APPLY se puede reemplazar por una funci�n definida por el
usuario que reporta una tabla.
*/
USE Northwind
GO

/*EJERCICIO 01. Listado de las compras de un cliente. Las tres compras con mayor cantidad

Primero se va a listar las compras de un cliente. Esta consulta servir� como ejemplo
para el uso de CROSS APPLY*/
SELECT TOP 3 WITH TIES c.CustomerID, c.CompanyName, o.OrderID, od.Quantity
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
WHERE c.CompanyName = 'Alfreds Futterkiste'
ORDER BY od.Quantity DESC
GO
--NOTA:
--Se muestran 4 registros por que los dos �ltimos tienen igual valor y se ha usado WITH TIES

/*Ahora las tres �rdenes por cada Cliente, la consulta previa se usar� como la subconsulta
para aplicar la cl�usula CROSS APPLY*/
SELECT c1.CustomerID, c1.CompanyName,
	   superiores.OrderID, superiores.Quantity
FROM Customers AS c1
CROSS APPLY
(SELECT TOP 3 WITH TIES c.CustomerID, c.CompanyName, o.OrderID, od.Quantity
 FROM Orders AS o
 	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
 	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
 WHERE c.CompanyName = c1.CompanyName
 ORDER BY od.Quantity DESC) AS superiores
 WHERE c1.CustomerID IS NOT NULL
 ORDER BY c1.CustomerID, superiores.Quantity DESC
 GO

--Creando una FDU que retorna una tabla para la subconsulta
CREATE OR ALTER FUNCTION fduRetornaTop3VentasClientes(@nombreCliente NVARCHAR(40))
RETURNS TABLE
AS
	RETURN (SELECT TOP 3 WITH TIES c.CustomerID, c.CompanyName, o.OrderID, od.Quantity
			FROM Orders AS o
				INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
				INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
			WHERE c.CompanyName = @nombreCliente
			ORDER BY od.Quantity DESC)
GO

--Usando la FDU
SELECT c1.CustomerID, c1.CompanyName,
	   superiores.OrderID, superiores.Quantity
FROM Customers AS c1
CROSS APPLY
(SELECT * FROM dbo.fduRetornaTop3VentasClientes(c1.CompanyName)) AS superiores
 WHERE c1.CustomerID IS NOT NULL
 ORDER BY c1.CustomerID, superiores.Quantity DESC
 GO

 /*Listamos todas las �rdenes del cliente BLAUS, podemos ver 14 �rdenes, en las que se pidi�
 m�s cantidad son las mismas que se muestran en la instrucci�n usando CROSS APPLY. 
 Se muestran 5 �rdenes por que se ha incluido la opci�n WITH TIES*/
SELECT c.CustomerID, c.CompanyName, o.OrderID, od.Quantity
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
WHERE c.CustomerID = 'BLAUS'
ORDER BY od.Quantity DESC
GO

/*EJERCICIO 02. Listar las �rdenes y los d�as entre las �rdenes del mismo cliente. 
Note que al usar CROSS APPLY, cuando ya no existe un siguiente registro, es decir, 
cuando no hay una orden siguiente, no muestra otro registro. Lo que s� ocurre usando
OUTER APPLY, resultado que se muestra en el EJERCICIO 03*/
SELECT ord.OrderID AS 'N� orden', FORMAT(ord.OrderDate, 'dd/MM/yyyy') AS 'fecha',
	   (so.OrderID) AS 'N� orden siguiente', FORMAT(so.OrderDate, 'dd/MM/yyyy') AS 'Fecha sig. orden',
	   ord.CustomerID AS 'Id. cliente', c.CompanyName AS 'cliente',
	   DATEDIFF(DAY, ord.OrderDate, so.OrderDate) AS 'D�as entre �rdenes'
FROM Orders AS ord
	INNER JOIN Customers AS c ON(ord.CustomerID = c.CustomerID)
CROSS APPLY
(SELECT TOP 1 o.OrderDate, o.OrderID
 FROM Orders AS o
 WHERE o.CustomerID = ord.CustomerID AND o.OrderID > ord.OrderID
 ORDER BY o.OrderID) AS so
ORDER BY ord.CustomerID, ord.OrderID
GO
/*
Note que la orden 11011 del cliente Alfreds Futterkiste es la �ltima, 
no tiene una siguiente orden.

El uso de CROSS APPLY permite unir los registros de Ordenes (Orders As Ord) con la subconsulta 
de tabla derivada llamada SO (Siguiente Orden). Note que se usa el ordenamiento en la 
subconsulta (ORDER BY o.OrderID) para poder identificar la primera orden (Top 1).
*/

/*-- USANDO OUTER APPLY --
La cl�usula OUTER APPLY produce un resultado similar al OUTER JOIN

EJERCICIO 03. El siguiente ejemplo muestra las �rdenes de los clientes hasta llegar a la 
�ltima registrada donde se muestran valores NULL por que no se registra una siguiente 
orden.
*/
SELECT ord.OrderID AS 'N� orden', FORMAT(ord.OrderDate, 'dd/MM/yyyy') AS 'fecha',
	   (so.OrderID) AS 'N� orden siguiente', FORMAT(so.OrderDate, 'dd/MM/yyyy') AS 'Fecha sig. orden',
	   ord.CustomerID AS 'Id. cliente', c.CompanyName AS 'cliente',
	   DATEDIFF(DAY, ord.OrderDate, so.OrderDate) AS 'D�as entre �rdenes'
FROM Orders AS ord
	INNER JOIN Customers AS c ON(ord.CustomerID = c.CustomerID)
OUTER APPLY
(SELECT TOP 1 o.OrderDate, o.OrderID
 FROM Orders AS o
 WHERE o.CustomerID = ord.CustomerID AND o.OrderID > ord.OrderID
 ORDER BY o.OrderID) AS so
ORDER BY ord.CustomerID, ord.OrderID
GO

--Usando CROSS APPLY y FDU que retorna una tabla
CREATE OR ALTER FUNCTION dbo.fduObtenerDatosCliente(@ciudad VARCHAR(15))
RETURNS @datosClientesPorCiudad TABLE(codigo CHAR(5), nombre VARCHAR(40), 
									  contacto VARCHAR(30), direccion VARCHAR(60))
AS
	BEGIN
		INSERT INTO @datosClientesPorCiudad
		SELECT c.CustomerID, c.CompanyName, c.ContactName, c.Address 
		FROM Customers AS c
		WHERE c.City = @ciudad

		RETURN
	END
GO

--Para visualizar los clientes de la ciudad de London
SELECT * 
FROM dbo.fduObtenerDatosCliente('London')
GO

--Para mostrar las �rdenes, incluyendo fechas de las �rdenes de cada cliente
SELECT o.OrderID AS 'N� de orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS 'fecha',
	 c1.*
FROM Orders AS o
	INNER JOIN Customers AS c ON (o.CustomerID = c.CustomerID)
CROSS APPLY dbo.fduObtenerDatosCliente(c.City) AS c1
GO

/*IMPORTANTE:
- En muchos casos se puede usar JOIN y CROSS APPLY retornando el mismo resultado, 
seleccione la que consume menos recursos, usndo para esto el plan de ejecuci�n estimado.
- Cuando se usa JOIN con muchas condiciones se recomienda el comparar el resultado
  con el uso de CROSS APPLY
- Use OUTER APPLY cuando la funci�n definida por el usuario retorna una tabla
*/