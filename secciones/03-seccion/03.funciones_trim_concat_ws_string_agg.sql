/*-- FUNCIONES TRIM, CONCAT_WS Y STRING_AGG --

En este artículo mostramos las nuevas funciones de SQL Server 2017, las que trabajan con datos 
tipo texto y que son de importancia su uso. Las funciones son: Trim, Concat_ws y String_agg.

Función Trim

Elimina los espacios en blanco del inicio y final de una cadena de caracteres.
Elimina los caracteres especificados del inicio y final de una cadena de caracteres.
Sintaxis:
Trim(Cadena Caracteres)
Trim('Caracteres a eliminar' from 'Cadena de Caracteres')
*/

/*EJERCICIO 01. Eliminar los espacios de la cadena de caracteres*/
SELECT TRIM(' martin')
GO

SELECT LEN(TRIM(' martin ')), LEN('martin')
GO

/*EJERCICIO 02. Se puede especificar los caracteres que se desea que se eliminen del inicio
o final de una cadena de caracteres. Elimina la coma del inicio y del final, antes de la palabra
texto hay 3 espacios*/
SELECT TRIM(',' FROM ',,,texto,,,')
GO

SELECT LEN(TRIM(',' FROM ',,,texto,,,'))
GO

/*EJERCICIO 03. Elimina las letras abc del inicio y final. Note que no elimina la letra c porque
se encuentra al inicio la letra r*/
SELECT TRIM('abc' FROM 'abarca poco y hazlo bien abbbcc')
GO

/*EJERCICIO 04. Elimina las letras uf, el punto (.) y la coma (,) del inicio y final.*/
SELECT TRIM('uf.,' FROM 'uff, casi, no temrino.......')
GO

/*
Función Concat_ws

Retorna la concatenación de una o mas cadenas de caracteres especificando el caracter 
o caracteres que lo separan.
Sintaxis
Concat_ws(‘separador’,Cadena1, Cadena2 [,Cadena3… ])
Donde
‘separador’, es el caracter o caracteres que separarán los textos a concatenar
Cadena1, Cadena2 [,Cadena3… ], textos a concatenar.
Por ejemplo
Select concat_ws(‘ ‘,’Trainer’,’SQL’,’Server’)
go
Resultado: Trainer SQL Server
*/

USE AdventureWorks
GO

/*EJERCICIO 05. Listar los registros de persona*/
SELECT RIGHT('0000000000' + TRIM(STR(BusinessEntityID)), 10) AS 'codigo',
	   LastName AS 'apellido',
	   CONCAT_WS(' ', FirstName, MiddleName) AS 'Nombres',
	   CONCAT_WS(' ', FirstName, MiddleName, LastName) AS 'nombre completo'
FROM Person.Person

USE Northwind
GO

/*EJERCICIO 06. Listado de las órdenes de noviembre de 1996, el empleado y el cliente. 
Incluir el total de la orden*/
SELECT o.OrderID AS 'n° orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') as 'fecha', 
	   SUM(od.Quantity * od.UnitPrice)AS 'total orden', 
	   CONCAT_WS(' ', e.TitleOfCourtesy, e.FirstName, e.LastName) AS 'empleado',
	   c.CompanyName AS 'cliente'
FROM Orders AS o
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE MONTH(o.OrderDate) = 11 AND YEAR(o.OrderDate) = 1996
GROUP BY o.OrderID, FORMAT(o.OrderDate, 'dd/MM/yyyy'), 
		CONCAT_WS(' ', e.TitleOfCourtesy, e.FirstName, e.LastName),
		c.CompanyName
GO

/*EJERCICIO 07. Listar los clientes, concatenar la dirección con los campos Country, City y Adress
separadas por coma*/
SELECT c.CustomerID AS 'codigo', c.CompanyName AS 'cliente',
	   CONCAT_WS(', ', c.Country, c.City, c.Address)
FROM Customers AS c
GO

/*
Función STRING_AGG

Concatena un conjunto de valores asignando un caracter entre estos.
Sintaxis
STRING_AGG (Expresión,Separador)
WITHIN GROUP ( ORDER BY [ ASC | DESC ] )
Donde
Expresión es la expresión que se va a concatenar, generalmente un nombre de campo
Separador es el caracter entre los elementos de Expresion
WITHIN GROUP ( ORDER BY [ ASC | DESC ] ) permite mostrar
los datos agrupados y ordenados
*/
USE Northwind
GO

/*EJERCICIO 08. Listar los clientes separados por coma, la función char(44) devuelve la coma*/
SELECT STRING_AGG(CompanyName, CHAR(44)) AS clientes
FROM Customers
GO
--Resultado: se muestra todos los clientes separados por coma.

/*EJERCICIO 09. Cambiando el resultado de la consulta a texo en lugar de cuadrícula. 
Muestra el resultado un dato en cada línea. Se puede cambiar pulstando CONTROL + T.
Listado de los clientes pulsando enter al final de cada uno, CHAR(13) representa ENTER*/
SELECT STRING_AGG(CompanyName, CHAR(13)) AS 'clientes'
FROM Customers
GO


/*EJERCICIO 10. Listado de los empleados*/
SELECT STRING_AGG(CONCAT_WS(' ', FirstName, LastName), CHAR(13))
FROM Employees
GO

/*EJERCICIO 11. Las categorías y productos separados por coma*/
SELECT c.CategoryID AS 'codigo', c.CategoryName AS 'categoría',
	   STRING_AGG(p.ProductName, ',') AS 'productos'
FROM Categories AS c
	INNER JOIN Products AS p ON(c.CategoryID = p.CategoryID)
GROUP BY c.CategoryID, c.CategoryName
GO

/*EJERCICIO 12. El listado anterior se puede ordenar los productos usando la cláusula WITHIN GROUP*/
SELECT c.CategoryID AS 'codigo', c.CategoryName AS 'categoría',
	   STRING_AGG(p.ProductName, ',') 
	   WITHIN GROUP(ORDER BY p.ProductName ASC) AS 'productos'
FROM Categories AS c
	INNER JOIN Products AS p ON(c.CategoryID = p.CategoryID)
GROUP BY c.CategoryID, c.CategoryName
GO
