/*-- ESTRUCTURA CASE EN SQLSERVER --

Evalua una expresi�n condicional y retorna uno de m�ltiples resultados.

La estructura Case tiene dos formas:
1. La expresi�n CASE simple compara una expresi�n con un conjunto de expresiones simples
   para determinar el resultado.

2. La expresi�n CASE buscada eval�a un conjunto de expresiones booleanas para determinar 
   el resultado.

Ambos formatos admiten un argumento ELSE opcional.
CASE se puede usar en cualquier declaraci�n o cl�usula que permita una expresi�n v�lida.

Por ejemplo, puede usar CASE en sentencias tales como SELECT, UPDATE, DELETE y SET, y en 
cl�usulas como Lista de campo en Select, IN, WHERE, ORDER BY y HAVING.

Sintaxis

Extructura CASE simple
CASE input_expression
WHEN when_expression THEN result_expression [ �n ]
[ ELSE else_result_expression ]
END

Estructura Case buscada
CASE
WHEN Boolean_expression THEN result_expression [ �n ]
[ ELSE else_result_expression ]
END
*/

/*EJERCICIO 01. Usar Case para mostrar el nombre de la estaci�n del a�o, las opciones posible 
son Verano, Oto�o, Invierno, Primavera.*/
SELECT (CASE DATEPART(q, GETDATE())
			WHEN 1 THEN 'Verano'
			WHEN 2 THEN 'Oto�o'
			WHEN 3 THEN 'Invierno'
		ELSE
			'Primavera'
		END)
GO

/*EJERCICIO 02. Listado de los empleados y su estaci�n en que nacieron. 
Para la estaci�n se usar� una Subconsulta.*/
USE Northwind
GO

SELECT e.EmployeeID, e.LastName, e.FirstName, 
	(SELECT CASE DATEPART(q, emp.BirthDate)
				WHEN 1 THEN 'Verano'
				WHEN 2 THEN 'Oto�o'
				WHEN 3 THEN 'Invierno'
			ELSE
				'Primavera'
			END
	 FROM Employees AS emp
	 WHERE emp.EmployeeID = e.EmployeeID) AS estacion
FROM Employees AS e
GO

/*EJERCICIO 03. Usando AdventureWorks, mostrar los productos y la descripci�n de la L�nea a 
la que pertenecen. Las descripciones de las l�neas tiene una propiedad con los valores 
R = Road, M = Mountain, T = Touring, S = Standard
Esta estructura Case muestra una Expresi�n Simple.*/
USE AdventureWorks
GO

SELECT p.ProductID, p.ProductNumber, p.Name, 
	  categoria = (CASE p.ProductLine
						WHEN 'R' THEN 'Road'
						WHEN 'M' THEN 'Mountain'
						WHEN 'T' THEN 'Touring'
						WHEN 'S' THEN 'Standard'
					ELSE
						'No venta'
					END)
FROM Production.Product AS p
ORDER BY p.ProductNumber
GO

/*EJERCICIO 04. Usando Northwind, crear un listado de los productos y establecer 
los rangos de sus precios. Este ejercicio muestra una estructura Case con Expresi�n buscada.*/
USE Northwind
GO

SELECT p.ProductID, p.ProductName, p.UnitPrice, 
	(CASE
		WHEN p.UnitPrice = 0 THEN 'Precio no disponible'
		WHEN p.UnitPrice < 20 THEN 'Menor a 20'
		WHEN p.UnitPrice >= 20 AND p.UnitPrice < 50 THEN 'Menor a 50'
		WHEN p.UnitPrice >= 50 AND p.UnitPrice < 100 THEN 'Menor a 100'
	ELSE
		'Sobre 100'
	END) AS [rango de precios]
FROM Products AS p
GO

/*Case en una instrucci�n Update*/
/*EJERCICIO 05. Usando Northwind, crear una Tabla con los Empleados y la cantidad de �rdenes generadas. 
(Ver Joins y Funciones de Agregado)
Luego agregar un campos para insertar una calificaci�n de acuerdo a lo siguiente:
Si tiene 100 o m�s �rdenes: Cobertura Cumplida
Si tiene entre 60 y 99: Revisi�n de planes
Si tiene menos de 60: Reingenier�a urgente*/
USE Northwind
GO

--Primero generar la tabla, inicialmente no tiene las calificaciones.
IF EXISTS(SELECT * FROM SYS.TABLES WHERE NAME = 'empleados_cantidad_ordenes')
	BEGIN
		DROP TABLE empleados_cantidad_ordenes
	END

SELECT e.EmployeeID, e.FirstName, COUNT(o.OrderID) AS ordenes, calificacion = SPACE(20)
INTO empleados_cantidad_ordenes
FROM Employees AS e
	INNER JOIN Orders AS o ON(e.EmployeeID = o.EmployeeID)
GROUP BY e.EmployeeID, e.FirstName
ORDER BY ordenes DESC
GO

--Visualizaci�n de datos
SELECT * 
FROM empleados_cantidad_ordenes
GO

--Actualizar la calificaci�n
UPDATE empleados_cantidad_ordenes
SET calificacion = (CASE 
						WHEN ordenes >= 100 THEN 'Cobertura cumplida'
						WHEN ordenes >= 60 AND ordenes <= 99 THEN 'Revisi�n de planes'
						WHEN ordenes < 60 THEN 'Reingenier�a urgente'
					END)
GO