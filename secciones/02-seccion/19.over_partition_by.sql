/*-- OVER PARTITION BY EN SQL SERVER --

La cl�usula Over en una consulta determina la partici�n y el orden de un conjunto de filas antes de que se 
aplique la funci�n de Windows asociada, es decir, la cl�usula OVER define un conjunto de filas especificado 
por el usuario dentro de un conjunto de resultados de la consulta. Luego, una funci�n de Windows calcula un 
valor para cada fila de la consulta.

Puede usar la cl�usula OVER con funciones para calcular valores agregados, como promedios m�viles, agregados 
acumulados, totales acumulados o un N superior por resultados de grupo.

Sintaxis
OVER (
	[ <Partition by Expresi�n> ]
	[ <Order by Columnas>]
	[ Row or Range Cl�usula]
)

Donde
[ Partition by Expresi�n ] 
Partition by, divide el conjunto de resultados de la consulta en particiones. La funci�n de window se aplica
a cada partici�n por separado y el c�lculo se reinicia para cada partici�n. 

Expresi�n
Especifica la columna por la que se particiona el conjunto de filas. la Expresi�n solo puede hacer referencia 
a columnas disponibles mediante la cl�usula FROM. La Expresi�n no puede hacer referencia a expresiones o alias 
en la lista de selecci�n. La Expresi�n puede ser una expresi�n de columna, una subconsulta escalar, una funci�n
escalar o una variable definida por el usuario.

[ <Order by Columnas> ]
Especifica una columna o expresi�n por la que ordenar. Columnas solo puede hacer referencia a las columnas 
disponibles mediante la cl�usula FROM. No se puede especificar un n�mero entero para representar un nombre de 
columna o alias. 

[ Row or Range Cl�usula]
Limita a�n m�s las filas dentro de la partici�n especificando puntos de inicio y finalizaci�n dentro de la partici�n.
Esto se hace especificando un rango de filas con respecto a la fila actual, ya sea por asociaci�n l�gica o asociaci�n
f�sica. La asociaci�n f�sica se logra utilizando la cl�usula ROWS.
La cl�usula ROWS limita las filas dentro de una partici�n al especificar un n�mero fijo de filas que preceden o siguen
a la fila actual. Alternativamente, la cl�usula RANGE limita l�gicamente las filas dentro de una partici�n 
especificando un rango de valores con respecto al valor en la fila actual.

Las filas anteriores y siguientes se definen seg�n el orden de la cl�usula ORDER BY.

Funciones Windows en SQL Server
Las funciones Windows se pueden clasificar en los siguientes grupos:

Funciones de Windows agregadas: Ver Funciones de agregado
Funciones de valores de Windows: Ver Funciones FIRST_VALUE(), LAST_VALUE(), LAG(), LEAD()
Funciones de clasificaci�n de Windows: ROW_NUMBER(), NTILE(), RANK(), DENSE_RANK(),
*/
USE Northwind
GO

/*EJERCICIO 01. La siguiente consulta utiliza la funci�n SUM para calcular el total de unidades compradas por cada
cliente y el total general. La cl�usula OVER define las particiones del c�lculo. El primer c�lculo se divide
en cada cliente, lo que significa que la cantidad total por cliente se reestablecer a cero para cada nuevo cliente.
El segudno c�lculo utiliza la cl�usula OVER sin espeficiar particiones, lo que significa que el c�lculo se realiza
en todos los conjuntos de filas de entrada.*/
SELECT c.CustomerID, c.CompanyName, od.Quantity,
	   SUM(od.Quantity) OVER(PARTITION BY c.CustomerID) AS 'total cliente',
	   SUM(od.Quantity) OVER() AS 'total general'
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
WHERE c.CustomerID IS NOT NULL
ORDER BY c.CustomerID, od.Quantity DESC
GO

/*Explicaci�n: 
El primer cliente, Alfreds Futterkiste tiene 12 productos comprados (no necesariamente productos diferentes),
las cantidades fueron 40, 21, 20, 20, 16, 15, 15, 15, 6, 2, 2 y 2, las que en total suman 174 unidades.

Las �rdenes y las cantidades compradas por el cliente Alfreds Futterkiste se muestran el la siguiente consulta, 
note que las cantidades son las mismas de la consulta usando Over.
*/
SELECT o.OrderID, od.ProductID, od.Quantity
FROM Orders AS o	
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
WHERE o.CustomerID = 'ALFKI'
ORDER BY od.Quantity DESC

/*EJERCICIO 02. La consulta muestra los empleados y la cantidad de �rdenes atendidas por cada empleado, tambi�n
el total general de �rdenes atendidas*/
SELECT DISTINCT e.EmployeeID, CONCAT_WS('', e.LastName, e.FirstName) AS 'empleado',
				COUNT(o.OrderID) OVER(PARTITION BY e.EmployeeID) AS 'cantidad ordenes',
				COUNT(o.OrderID) OVER() AS 'total ordenes'
FROM Employees AS e 
	INNER JOIN Orders AS o ON(e.EmployeeID = o.EmployeeID)
WHERE o.ShippedDate IS NOT NULL
ORDER BY e.EmployeeID
GO

/*La misma consulta se puede obtener usando agrupamientos y para el total de las �rdenes una subconsulta*/
SELECT e.EmployeeID, CONCAT_WS('', e.LastName, e.FirstName) AS 'empleado',
	   COUNT(o.OrderID) AS 'cantidad ordenes',
	   (SELECT COUNT(ord.OrderID) 
	    FROM Orders AS ord 
		WHERE ord.ShippedDate IS NOT NULL) AS 'total ordenes'
FROM Employees AS e 
	INNER JOIN Orders AS o ON(e.EmployeeID = o.EmployeeID)
WHERE o.ShippedDate IS NOT NULL
GROUP BY e.EmployeeID, CONCAT_WS('', e.LastName, e.FirstName)
ORDER BY e.EmployeeID
GO
/*IMPORTANTE
Comparte los tiempos de los planes de ejecuci�n estimados y seleccione el que tenga mejor tiempo.
*/

/*EJERICIO 03. La consulta muestra los productos y la cantidad de unidades vendidas por cada uno as� como
la cantidad por categor�a*/
SELECT DISTINCT c.CategoryID AS 'c�d. categor�a', c.CategoryName AS 'categor�a',
	   p.ProductID AS 'c�d. producto', p.ProductName AS 'descripci�n',
	   SUM(od.Quantity) OVER(PARTITION BY p.ProductID) AS 'total unidades',
	   SUM(od.Quantity) OVER() AS 'total general'
FROM Categories AS c
	INNER JOIN Products AS p ON(c.CategoryID = p.CategoryID)
	INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
ORDER BY c.CategoryID, [total unidades] DESC
GO

/*EJERCICIO 04. Usando ordenamiento en la cl�usula OVER, adem�s de agrupar una cantidad espec�fica
de filas. La consulta muestra los productos totalizando las cantidades de las tres �ltimas �rdenes,
las dos precedentes sumadas a la cantidad de la venta actual. Esto es posible utilizando el operador
BETWEEN, especificando la cantidad de �rdenes precedentes (2 para el ejercicio) y la cantidad
de la orden actual (CURRENT ROW). */
SELECT p.ProductID AS 'c�d. producto', p.ProductName AS 'descripci�n', 
       od.Quantity AS 'unidades', MONTH(o.OrderDate) AS 'mes',
	   SUM(od.Quantity) OVER(PARTITION BY p.ProductID 
							 ORDER BY MONTH(o.OrderDate)
							 ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS '�ltimas 3',
	   SUM(od.Quantity) OVER(PARTITION BY p.ProductID) AS 'total producto'
FROM Products AS p 
	INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
	INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
ORDER BY p.ProductID, mes
GO

/*EXPLICACI�N:
La consulta muestra los productos ordenados, seg�n su id y el mes de la orden.
La columna "�tlimas 3" muestra la suma de los dos registros precedentes y la actual
del campo unidades. As� pues, para el cuarto registro cuyo valor en la columna
"unidades" es de 80, se le sumar�n los valores de las dos unidades que le preceden (anteceden),
es decir 80 + 4 + 24 = 108, y ese valor de 108 es el que ir� en la fila actual y columna
"�ltimos 3" (cuya unidad es 80). 
Para la fila 5, el valor que va en la columna "�ltimas 3" ser� de 104 y eso es por que
el valor actual de la columna "unidades" es 20 y a eso se le suma las 2 anteriores, 
es decir: 20 + 80 + 4 = 104
Y as� con cada fila
*/

/*EJERCICIO 05. Enumerar los registros seg�n la categor�a del producto. 
Reiniciar la enumeraci�n en cada categor�a distinta
*/
SELECT ROW_NUMBER() OVER(PARTITION BY p.CategoryID 
						 ORDER BY p.CategoryID) AS 'N�',
	    P.CategoryID AS 'categor�a', p.ProductName AS 'producto'
FROM Products AS p
ORDER BY p.CategoryID
GO