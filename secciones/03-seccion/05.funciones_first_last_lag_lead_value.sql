/*-- FUNCION4ES FIRST_VALUE, LAST_VALUE, LAG Y LEAD --

En este art�culo se va a explicar el uso de las funciones First_Value, Last_Value, Lag y Lead, 
estas funciones permiten mostrar un conjunto de resultados para analizarlos de acuerdo a como 
se van presentando.

Funci�n First_Value
Devuelve el primer valor en un conjunto ordenado de valores, la funci�n 
First_Value est� disponible desde SQL Server 2012.

Sintaxis:
FIRST_VALUE ( [Expresi�nNum�rica ] )
OVER ( [Expresi�nPartici�n] Expresi�nOrden [ RangoFilas ] )

Donde
[Expresi�nNum�rica]
Es el valor a devolver, puede ser una columna, una subconsulta u otra
expresi�n que d� como resultado un solo valor.
Otras funciones anal�ticas no est�n permitidas.

OVER ( [Expresi�nPartici�n] Expresi�nOrden [ RangoFilas ] )
Divide el conjunto de resultados producido por la cl�usula FROM en particiones a 
las que se aplica la funci�n. Si no se especifica, la funci�n trata todas las filas 
del conjunto de resultados de la consulta como un solo grupo.

Expresi�nOrden determina el orden l�gico en el que se realiza la operaci�n. 
Esta expresi�n es obligatoria

RangoFilas limita a�n m�s las filas dentro de la partici�n especificando 
los puntos de inicio y final.

Funci�n Last_Value
Devuelve el �ltimo valor en un conjunto ordenado de valores, la funci�n Last_Value est� 
disponible desde SQL Server 2012.

Sintaxis:
Last_Value ( [Expresi�nNum�rica ] )
OVER ( [Expresi�nPartici�n] Expresi�nOrden [ RangoFilas ] )

Donde
[Expresi�nNum�rica]
Es el valor a devolver, puede ser una columna, una subconsulta u otra
expresi�n que d� como resultado un solo valor.
Otras funciones anal�ticas no est�n permitidas.

OVER ( [Expresi�nPartici�n] Expresi�nOrden [ RangoFilas ] )
Divide el conjunto de resultados producido por la cl�usula FROM en particiones a las que se 
aplica la funci�n. Si no se especifica, la funci�n trata todas las filas del conjunto de 
resultados de la consulta como un solo grupo.

Expresi�nOrden determina el orden l�gico en el que se realiza la operaci�n. Esta expresi�n es obligatoria

RangoFilas limita a�n m�s las filas dentro de la partici�n especificando los puntos de inicio y final.
*/
USE Northwind
GO

/*EJERCICIO 01. Listar los productos que son menos costosos y m�s costosos en una determinada
categor�a. Para este ejemplo se muestran los productos de la categor�a 3*/
SELECT p.ProductName AS 'producto', p.UnitPrice AS 'precio',
	  FIRST_VALUE(p.ProductName) OVER(ORDER BY p.UnitPrice ASC) AS 'm�s barato',
	  LAST_VALUE(p.ProductName) OVER(ORDER BY p.UnitPrice ASC) AS 'm�s caro'
FROM Products AS p
WHERE p.CategoryID = 3
ORDER BY p.UnitPrice ASC
GO

/*
Explicaci�n:
Para el primer producto, �Teatime Chocolate Biscuits�, cuyo precio es 9.20, este, al 
ser el primer producto es el m�s barato y a la vez en m�s caro. Al mostrarse el segundo
producto �Zaanse koeken�, cuyo precio es de 9.50, en la columna m�s barato aparece 
�Teatime Chocolate Biscuits� cuyo precio es de 9.20, y el m�s caro aparece el mismo 
producto �Zaanse koeken� como el mas caro. Como han sido ordenados por el precio en
orden ascendente, el primer producto �Teatime Chocolate Biscuits� aparece siempre como 
el m�s barato, luego el producto m�s caro va cambiando de acuerdo a como se muestran el 
resto de productos, hasta llegar al producto �Sir Rodney�s Marmalade� cuyo precio es 81.00 
que es el m�s caro de la categor�a.
*/

/*EJERCICIO 02. Mostrar el m�s caro y el m�s barado de toda la categor�a usando la cl�usula ROWS*/
SELECT p.ProductName AS 'producto', p.UnitPrice AS 'precio',
	  FIRST_VALUE(p.ProductName) OVER(ORDER BY p.UnitPrice ASC) AS 'm�s barato',
	  LAST_VALUE(p.ProductName) OVER(ORDER BY p.UnitPrice ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'm�s caro'
FROM Products AS p
WHERE p.CategoryID = 3
ORDER BY p.UnitPrice ASC
GO
/*
Explicaci�n:
Compare el listado con la imagen anterior, en esta, usando la opci�n Rows se muestra para cada 
uno de los art�culos el m�s barato de todos �Teatime Chocolate Biscuits� que tiene un precio 
de 9.20 y el m�s caro de todos �Sir Rodney�s Marmalade� con un precio de 81.00.
*/

/*Podemos incluir los productos de otra categor�a y mostrar el c�digo de la categor�a para ver 
el resultado.
*/
SELECT p.ProductName AS 'producto', p.UnitPrice AS 'precio', p.CategoryID AS 'C�d. categor�a',
	  FIRST_VALUE(p.ProductName) OVER(ORDER BY p.UnitPrice ASC) AS 'm�s barato',
	  LAST_VALUE(p.ProductName) OVER(ORDER BY p.UnitPrice ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'm�s caro'
FROM Products AS p
WHERE p.CategoryID = 3 OR p.CategoryID = 4
ORDER BY p.CategoryID ASC, p.UnitPrice ASC
GO
/*
Explicaci�n:
En este ejecicio, usando tambi�n la opci�n Rows, se muestra
para cada uno de los art�culos el m�s barato de todos �Geitost� que tiene un precio de 2.50 y el 
m�s caro de todos �Sir Rodney�s Marmalade� con un precio de 81.00.
*/

/*EJERCICIO 03. Particionando por categor�a los que tienen menor y mayor unidades en Stock de las
categor�as 6 y 7*/
SELECT p.ProductName AS 'producto', p.UnitPrice AS 'precio', 
       p.UnitsInStock AS 'stock', p.CategoryID AS 'C�d. categor�a',
	  FIRST_VALUE(p.ProductName) OVER(PARTITION BY p.categoryID ORDER BY p.UnitsInStock ASC) AS 'menor stock',
	  LAST_VALUE(p.ProductName) OVER(PARTITION BY p.categoryID ORDER BY p.UnitsInStock ASC) AS 'mayor stock'
FROM Products AS p
WHERE p.CategoryID IN(6,7)
ORDER BY p.CategoryID ASC, p.UnitsInStock ASC
GO

/*
EXPLICACI�N
Note que el art�culo con menor stock es �Alice Mutton� con un valor de CERO para la categor�a 6 y 
el de mayor stock es �P�t� chinois� con un valor de 115. Luego aparecen los art�culos de la categor�a 7, 
el de menor stock con 4 unidades es �Longlife Tofu� y el de mayor stock con 35 unidades es �Tofu�.
*/

/*FUNCI�N LAG
Accede a los datos de una fila anterior en el mismo conjunto de resultados
sin el uso de una uni�n autom�tica. LAG proporciona acceso a una fila en un desplazamiento 
f�sico dado que viene antes de la fila actual.
Utilice esta funci�n anal�tica en una instrucci�n SELECT para comparar valores en la fila 
actual con valores en una fila anterior.

Sintaxis:
Lag ( Expresi�nNum�rica [,offset] [,default] )
OVER ( [Expresi�nPartici�n] Expresi�nOrden )

Donde
[Expresi�nNum�rica]
Es el valor a devolver, puede ser una columna, una subconsulta u otra
expresi�n que d� como resultado un solo valor.
Otras funciones anal�ticas no est�n permitidas.

OffSet
El n�mero de filas desde la fila actual desde la que se obtiene un valor.
Si no se especifica, el valor predeterminado es 1. el desplazamiento puede
ser una columna, subconsulta u otra expresi�n que se eval�e como un entero 
positivo o se pueda convertir impl�citamente a bigint. offset no puede ser un 
valor negativo o una funci�n anal�tica.

Default
El valor a devolver cuando el desplazamiento est� fuera del alcance de la
partici�n. Si no se especifica un valor predeterminado, se devuelve NULL.
el valor predeterminado puede ser una columna, una subconsulta u otra expresi�n, pero 
no puede ser una funci�n anal�tica. el valor predeterminado debe ser compatible con el 
tipo con scalar_expression.

OVER ( [Expresi�nPartici�n] Expresi�nOrden)
Divide el conjunto de resultados producido por la cl�usula FROM en particiones a las que 
se aplica la funci�n. Si no se especifica, la funci�n trata todas las filas del conjunto 
de resultados de la consulta como un solo grupo.
Expresi�nOrden determina el orden l�gico en el que se realiza la operaci�n. 
Esta expresi�n es obligatoria

FUNCI�N LEAD

Accede a datos de una fila posterior en el mismo conjunto de resultados
sin el uso de una uni�n autom�tica que comienza con SQL Server 2012 (11.x).
LEAD proporciona acceso a una fila en un desplazamiento f�sico dado que sigue a la fila actual.
Use esta funci�n anal�tica en una instrucci�n SELECT para comparar valores en la fila actual con 
valores en la siguiente fila.

Sintaxis:
Lead ( Expresi�nNum�rica [,offset] [,default] )
OVER ( [Expresi�nPartici�n] Expresi�nOrden )

Donde
[Expresi�nNum�rica]
Es el valor a devolver, puede ser una columna, una subconsulta u otra
expresi�n que d� como resultado un solo valor.
Otras funciones anal�ticas no est�n permitidas.

OffSet
El n�mero de filas desde la fila actual desde la que se obtiene un valor.
Si no se especifica, el valor predeterminado es 1. el desplazamiento puede
ser una columna, subconsulta u otra expresi�n que se eval�e como un entero positivo o se 
pueda convertir impl�citamente a bigint. offset no puede ser un valor negativo o una funci�n anal�tica.

Default
El valor a devolver cuando el desplazamiento est� fuera del alcance de la
partici�n. Si no se especifica un valor predeterminado, se devuelve NULL.
el valor predeterminado puede ser una columna, una subconsulta u otra expresi�n, pero no puede ser una 
funci�n anal�tica. el valor predeterminado debe ser compatible con el tipo con scalar_expression.

OVER ( [Expresi�nPartici�n] Expresi�nOrden)
Divide el conjunto de resultados producido por la cl�usula FROM en particiones a las que se aplica 
la funci�n. Si no se especifica, la funci�n trata todas las filas del conjunto de resultados de 
la consulta como un solo grupo.

Expresi�nOrden determina el orden l�gico en el que se realiza la operaci�n. Esta expresi�n es obligatoria
*/

/*EJERCICIO 04. Este ejemplo utiliza una variable tipo tabla. Se insertan datos de �rdenes en 
fechas determinadas, c�digo del producto y cantidad vendida en la orden. Luego se muestran los
datos mostrando la fecha m�s antigua y la m�s actual ordenados de acuerdo a la cantidad de producto
vendido, as� como las fechas l�mites teniendo en cuenta ordenamiento seg�n fecha.*/
DECLARE @ordenes AS TABLE(fecha DATE, codigo INT, producto VARCHAR(40), cantidad NUMERIC(9,2))
INSERT INTO @ordenes 
VALUES('2013-07-23', 142,'Impresora', 74),
('2013-08-06', 123, 'Teclado', 95),
('2013-08-15', 101, 'Mouse', 38),
('2013-09-11', 130, 'Monitor', 12),
('2013-07-30', 142, 'Impresora', 29),
('2013-06-18', 142, 'Impresora', 100),
('2013-02-10', 142, 'Impresora', 40),
('2013-11-16', 101, 'Mouse', 28),
('2013-11-21', 123, 'Teclado', 57),
('2013-11-23', 101, 'Mouse', 12)
--Listado de �rdenes
SELECT FORMAT(fecha, 'dd/MM/yyyy') AS 'fecha', codigo AS 'c�digo', producto AS 'descripci�n', cantidad,
       'fecha menor venta' = FORMAT(FIRST_VALUE(fecha) OVER(PARTITION BY codigo ORDER BY cantidad), 'dd/MM/yyyy'),
	   'fecha mayor venta' = FORMAT(LAST_VALUE(fecha) OVER(PARTITION BY codigo ORDER BY cantidad ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 'dd/MM/yyyy'),
	   'previo' = FORMAT(LAG(fecha, 1, fecha) OVER(PARTITION BY codigo ORDER BY cantidad), 'dd/MM/yyyy'),
	   'siguiente' = FORMAT(LEAD(fecha, 1, fecha) OVER(PARTITION BY codigo ORDER BY cantidad), 'dd/MM/yyyy')
FROM @ordenes
ORDER BY codigo, cantidad
GO

/*
EXPLICACI�N:
Para explicar el conjunto de resultados se analizar� los datos de cada producto. Para el primer 
producto que aparece que es �Mouse�, tiene registradas tres fechas de ventas: 23/11/2013, 16/11/2013 
y 15/08/2013 ordenadas de acuerdo a la cantidad vendida en orden descedente 12.00, 28.00 y 38.00 
respectivamente.

Usando las funciones First_Value y Last_Value se muestran las fechas en que se realiz� la menor venta 
de 12 unidades (23/11/2013) y la de mayor venta de 38 unidades (15/08/2013).

Las funciones LAG y LEAD muestran el valor Previo (LAG) y el Siguiente (LEAD) respecto de las fechas 
de compra ordenados NO POR FECHA sino por la cantidad vendida, para la primera l�nea, con una venta 
de 12 unidades, no existe valor previo y se muestra la misma fecha (23/11/2013), la fecha siguiente 
en que se vendi� mas unidades es 16/11/2013 con una cantidad de 28.00 unidades. La segunda l�nea de 
los resultados muestra la fecha de la venta previa (23/11/2013) y la fecha de la siguiente venta 15/08/2013. 

La tercera l�nea, siempre con las venta de Mouse muestra la fecha previa que se vendi� 28.00 unidades 
y la siguiente muestra la misma fecha de compra 15/08/2013 como la siguiente porque el siguiente producto 
ya no es Mouse, sino Teclado.

Para el caso del producto Monitor note que las fechas todas son iguales porque hay un solo registro.
*/

USE AdventureWorks
GO
/*EJERCICIO 05. El siguiente ejemplo utiliza la funci�n LEAD para comparar las ventas anuales entre empleados.
La cl�usula PARTITION BY se especifica para dividir las filas en el conjunto de resultados por territorio
de ventas. La funci�n LEAD se aplica a cada partici�n por separado y la computaci�n se reinicia para cada
partici�n. La cl�usula ORDER BY especificada en la cl�usula OVER ordena las filas e n cada partici�n antes de
que se aplique la funci�n. La cl�usula ORDER BY e la instrucci�n SELECT ordena las filas en todo el 
conjutno de resultados. Tenga en cuenta que debido a que no hay un valor inicial disponible para la �ltima
fila de cada partici�n, se devuelve el valor predeterminado de cero (0).

Primero se va a mostrar los empleados y sus ventas anuales en cada uno de las regiones
*/
SELECT s.BusinessEntityID AS 'c�digo',
	   Empleado = CONCAT_WS(' ', s.FirstName, s.LastName),
	   TerritoryName AS 'territorio', 
	   SalesYTD AS 'ventas anuales'
FROM Sales.vSalesPerson AS s
WHERE TerritoryName = 'Northwest'
GO

SELECT s.BusinessEntityID AS 'c�digo',
	   Empleado = CONCAT_WS(' ', s.FirstName, s.LastName),
	   TerritoryName AS 'territorio', 
	   SalesYTD AS 'ventas anuales'
FROM Sales.vSalesPerson AS s
WHERE TerritoryName = 'Southwest'
GO

--Ahora la comparaci�n de las ventas por empleado
SELECT s.BusinessEntityID AS 'c�digo',
	   Empleado = CONCAT_WS(' ', s.FirstName, s.LastName),
	   TerritoryName AS 'territorio', 
	   SalesYTD AS 'ventas anuales',
	   LEAD(SalesYTD, 1, 0) OVER(PARTITION BY TerritoryName ORDER BY SalesYTD DESC) AS 'ventas siguiente empleado'
FROM sales.vSalesPerson AS s
WHERE TerritoryName IN('Southwest','Northwest')
GO

/*EXPLICACI�N
Al mostrar los empleados y las ventas por territorio se puede ver que existen tres empleados
del territorio Northwest, el empleado �Tete Mensa-Annan� tiene ventas anuales por el monto de 1576562,1966,
se puede ver que el empleado �David Campbell�, que es el siguiente empleado tiene una ventas anuales de
1573012,9383, que es el valor que aparece en la columna �Ventas siguiente Empleado�.
Para el empleado David Campbell, las ventas que aparecen en la columna �Ventas siguiente Empleado� pertenecen
a la empleada �Pamela Ansman-Wolfe�. Para el empleado �Pamela Ansman-Wolfe� las ventas del siguiente empleado
aparecen en CERO porque el siguiente empleado pertenece a otro territorio que es �Southwest�.
*/