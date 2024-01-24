/*-- VARIABLES EN SQL SERVER --

SQL Server permite el manejo de variables en la implementación de códigos T-SQL en 
cualquiera de los objetos que el usuario necesite crear, pudiendo ser procedimientos 
almacenados, cursores, triggers, funciones definidas por el usuario, etc.

Las variables definidas en SQL Server al igual que cualquier otro programa tienen un 
ámbito, que puede ser desde un conjunto de instrucciones, una estructura condicional 
y una transacción.

Como crear variables en SQL Server
Para definir variables en SQL Server se utiliza la instrucción Declare. 
Toda variable debe iniciar con el símbolo arroba «@» seguido del nombre y 
luego el tipo de dato.

Instrucción Declare
Permite crear una variable, cursor o variable tipo tabla.

Sintaxis
DECLARE @nombreVariable tipoDato[= Valor]

Donde: 
@nombreVariable, es el nombre de la variable a crear.
tipoDato, es el tipo de dato de SQL Server.
[= Valor], es el valor inicial de la variable.

Asignar valor a una variable en SQL Server
Para asignar el valor a una variable en SQL Server se puede usar la 
instrucción SET o puede usarse la instrucción SELECT.

Forma de uso de Set
SET @nombreVariable = valor

Forma de uso de SELECT para asignar valor a la variable
SELECT @nombreVariable = expresion
FROM tabla

o también,

SET @nombreVariable = (SELECT expresion 
					   FROM tabla)
*/

/*EJERCICIO 01. Crear una variable para un precio, asignar un valor y mostrarla.*/
DECLARE @precio NUMERIC(9,2)
SET @precio = 25.90
SELECT @precio
GO

/*Se puede definir varias variables en la misma instrucción DECLARE.

EJERCICIO 02. Usando Northwind, definir variables para capturar la cantidad menor de Stock,
la cantidad mayor del stock y la cantidad de productos.
*/
USE Northwind
GO

DECLARE @mayorStock INT, @menorStock INT, @totalStock INT

SELECT	@mayorStock = MAX(UnitsInStock), 
		@menorStock = MIN(UnitsInStock),
		@totalStock = COUNT(UnitsInStock)
FROM products

SELECT @mayorStock AS 'Mayor Stock', @menorStock AS 'Menor Stock', @totalStock AS 'Total Stock'
GO

/*EJERCICIO 03. Variable de tipo texto*/
DECLARE @nombre VARCHAR(50)
SET @nombre = 'Trainer SQL Server'
SELECT @nombre
GO

/*EJERCICIO 04. Variable para el nombre del empleado*/
DECLARE @empleado VARCHAR(100)

SELECT @empleado = CONCAT_WS(' ', TitleOfCourtesy,FirstName, LastName)
FROM Employees

SELECT @empleado
GO

/*EJERCICIO 05. Variable para almacenar el valor del stock de un producto*/
DECLARE @valorStock NUMERIC(9,2)
SELECT @valorStock = UnitPrice * UnitsInStock
FROM Products
SELECT @valorStock
GO