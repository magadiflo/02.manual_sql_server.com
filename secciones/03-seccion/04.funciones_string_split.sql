/*-- FUNCIÓN STRING_SPLIT SQL SERVER -- 

Microsoft SQL Server en la versión 2017 ha incluído algunas funciones interesantes para el 
manejo de cadenas de texto, una de ellas es la función String_agg, la que permitía convertir 
un conjunto de valores de cadena a una cadena separada por un caracter. En este artículo se 
explica como se usa la función String_Split que hace lo inverso de la función String_agg.

Nivel de compatibilidad necesario

Para poder usar la función String_split es necesario el nivel de compatibilidad mínimo de 130, 
que corresponde a SQL Server 2016.

Función String_split
Es una función de valor de tabla que separa una cadena de caracteres en partes basado en un separador.

Sintaxis
String_split(Cadena, Separador)
Donde
Cadena
Es la cadena de caracteres a separar
Separador
Caracter que se usa como base para separar. El caracter es simple y puede ser nvarchar(1), varchar(1), 
nchar(1) o char(1)
*/

/*EJERCICIO 01. Convertir los nombres en un valor de columna*/
DECLARE @personal VARCHAR(100) = 'Martín, Alicia, Tinkler, Raúl, Gabriel, Gabrielito, Gahella'
SELECT VALUE AS nombre
FROM STRING_SPLIT(REPLACE(@Personal,', ',','),',')
GO

/*EJERCICIO 02. Convertir los productos en un valor de columna*/
DECLARE @productos VARCHAR(100) = 'Monitor, Teclado, Mouse, Disco Duro, Impresora, UPS, Scanner'
SELECT VALUE
FROM STRING_SPLIT(REPLACE(@productos, ', ', ','), ',')
GO

USE Northwind
GO

/*EJERCICIO 03. Crear una vista con las categorías y sus productos separados por coma. Esta vista
se va a usar para luego presentar los productos de cada una de las categorías como una columna*/
CREATE VIEW v_categoria_producto
AS
	SELECT c.CategoryID AS 'codigo',
			c.CategoryName AS 'categoria',
			STRING_AGG(p.ProductName, ',') 
			WITHIN GROUP(ORDER BY p.ProductName ASC) AS 'producto'
	FROM Categories AS c
		INNER JOIN Products AS p ON (c.CategoryID = p.CategoryID)
	GROUP BY c.CategoryID, c.CategoryName
GO

--Los registros en la vista
SELECT * 
FROM v_categoria_producto
GO

--Ahora vamos a separar los productos cada uno en filas
SELECT v.codigo, v.categoria, 
	   VALUE AS producto
FROM v_categoria_producto AS v
	CROSS APPLY STRING_SPLIT(v.producto, ',')
GO

--Obtener solamente los productos
SELECT VALUE AS producto 
FROM v_categoria_producto AS v
CROSS APPLY STRING_SPLIT(v.producto, ',')
GO

/*Ordenamiento de los valores
Al aplicar el ordenamiento de valores obtenidos de una cadena separada por coma, debe 
considerar que a partir del segundo valor puede contener un espacio en blanco, se debe 
eliminar el espacio en blanco usando la función Replace para reemplazar los 
caracteres ‘, ‘ (coma y espacio) por solamente la coma.
*/

/*EJERCICIO 04. Listar los productos ordenados en forma ascendente.*/
DECLARE @productos VARCHAR(100) = 'Monitor, Teclado, Mouse, Disco Duro, Impresora, UPS, Scanner'
SELECT RTRIM(value) as productos
FROM STRING_SPLIT(REPLACE(@productos,', ', ','), ',')
ORDER BY value ASC
GO

/*Para realizar el filtrado de los valores usando el campo con los valores a separar, 
se usa la palabra reservada VALUE para hacer referencia al conjunto de valores.
*/

/*EJERCICIO 05. Para mostrar los productos que inician con la letra M*/
DECLARE @productos VARCHAR(100) = 'Monitor, Teclado, Mouse, Disco Duro, Impresora, UPS, Scanner'
SELECT RTRIM(value) as productos
FROM STRING_SPLIT(REPLACE(@productos,', ', ','), ',')
WHERE LOWER(value) LIKE 'm%'
ORDER BY value ASC
GO

/*EJERCICIO 06. Mostrar los productos que inician con las letras C, F y M*/
SELECT v.codigo, v.categoria, value AS producto 
FROM v_categoria_producto AS v
	CROSS APPLY STRING_SPLIT(v.producto, ',')
WHERE UPPER(value) LIKE 'C%' OR UPPER(value) LIKE 'F%' OR UPPER(value) LIKE 'M%'
ORDER BY value
GO
/*Evitando valores en blanco
Al generar la lista de valores puede que alguno de ellos no tengan datos, 
puede evitarse posiblemente de acuerdo a las reglas del negocio usando restricciones de tipo 
default
*/

/*EJERCICIO 07. Listado de productos, alguno con valores en blanco*/

--El resultado mostrará algunos campos en blanco
DECLARE @productos VARCHAR(100) = 'Monitor, Teclado, , , , , Mouse, Disco Duro, , , Impresora, UPS, Scanner'
SELECT RTRIM(value)
FROM STRING_SPLIT(REPLACE(@productos, ', ', ','), ',')
GO

--Evitando valores en blanco
DECLARE @productos VARCHAR(100) = 'Monitor, Teclado, , , , , Mouse, Disco Duro, , , Impresora, UPS, Scanner'
SELECT RTRIM(value)
FROM STRING_SPLIT(REPLACE(@productos, ', ', ','), ',')
WHERE RTRIM(value) <> ''
GO

/*
Generar una tabla con los valores obtenidos con String_Split

Se puede usar la opción Into de la instrucción Select para generar una tabla con los valores
obtenidos usando String_split
*/

/*EJERCICIO 08. Crear una tabla con los productos de la categoría 3, usando la vista 
creada en el ejercicio 03*/

SELECT value AS producto
INTO productos_categoria3
FROM v_categoria_producto AS v
	CROSS APPLY STRING_SPLIT(v.producto, ',')
WHERE v.codigo = 3
GO

SELECT * 
FROM productos_categoria3
GO