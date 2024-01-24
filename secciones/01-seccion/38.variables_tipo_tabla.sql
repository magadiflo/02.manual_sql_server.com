/*-- VARIABLES TIPO TABLA --*/
/*
- Son tipos de datos que generalmente son utilizados en un lote T-SQL,
  procedimiento almacenado o funci�n definida por el usuario
- Las variables tipo tabla se crea y definen igual a las tablas con la diferencia que tienen 
  una alcance de vida definido.
- Se debe evaluar usando los planes de ejecuci�n de cada opci�n entre Variables tipo tabla y 
  tablas temporales.
- Use las variables tipo tabla o las tablas temporales con conjunto de datos peque�os.

BENEFICIOS
- Duraci�n o alcance. estos objetos viven �nicamente durante la ejecuci�n del lote, funci�n o 
  procedimiento almacenado.
- Tiempos de bloqueos m�s cortos. 
- Cuando se usan en procedimientos almacenados realizan menos re compilaciones.

CONSIDERACIONES
El rendimiento de las variables tipo tabla no es �ptimo cuando el resultado es demasiado grande.

SINTAXIS
DECLARE @nombreVariableTipoTabla TABLE(
	campo1 TIPO_DATOS,....
)
GO

LIMITACIONES
- No se puede usar la opci�n INTO en un SELECT
- No se puede truncar la tabla (TRUNCATE)
- Una vez creadas no se pueden modificar
- Solo permite clave primaria y restricci�n unique
- No se puede usar funciones definidas por el usuario (UDF) en un CHECK CONSTRAINT, columna
  calculada o DEFAULT CONSTRAINT
- No se puede usar tipos de datos definidos por el usuario
- No se puede eliminar la tabla usando DROP TABLE
- Las variables de tipo tabla no se pueden acceder en procedimientos anidados

EJEMPLOS
*/
USE Northwind
GO

/*EJERCICIO 01. Crear una variable tipo tabla y asignar los datos de los productos de categor�a 1*/
/*NOTA: Como es una variable, este �nicamente existe mientras el scrip se est� ejecutando,
por lo tanto para ver el resultado es necesario seleccionar todo el lote, desde el DECLARE 
hasta el GO para ver los resultados*/
--Declarando la variable tipo tabla llamada @productos_categoria
DECLARE @productos_categoria TABLE(
	codigo CHAR(3) PRIMARY KEY,
	descripcion VARCHAR(50)	
)
--Insertando valores en la variable tipo tabla
INSERT INTO @productos_categoria(codigo, descripcion)
SELECT ProductID, ProductName 
FROM Products 
WHERE CategoryID = 1
--Verificando los datos insertados en la variable tipo tabla
SELECT * 
FROM @productos_categoria
GO

/*EJERCICIO 02. Crear una variable tipo tabla con los datos de los clientes y la cantidad
de �rdenes generadas en un a�o determinado. Ejmpl. para el a�o 1997*/
--Declarando la variable tipo tabla
DECLARE @totalOrdenesClientes1997 TABLE(
	cliente_codigo CHAR(10), 
	nombre VARCHAR(80), 
	cantidadOrdenes INT
)
--Insertando datos en la variable tipo tabla
INSERT INTO @totalOrdenesClientes1997
SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS [cantidadOrdenes]
FROM Orders AS o 
	INNER JOIN Customers AS c ON(c.CustomerID = o.CustomerID)
WHERE YEAR(o.OrderDate) = 1997
GROUP BY c.CustomerID, c.CompanyName
--Mostrando datos insertados
SELECT * 
FROM @totalOrdenesClientes1997
ORDER BY cantidadOrdenes DESC
GO

--Usando tabla temporal, el bloque enterior puede ser como sigue
CREATE TABLE #totalOrdenesClientes1997(
	cliente_codigo CHAR(10), 
	nombre VARCHAR(80), 
	cantidadOrdenes INT
)
GO

INSERT INTO #totalOrdenesClientes1997
SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS [cantidadOrdenes]
FROM Orders AS o 
	INNER JOIN Customers AS c ON(c.CustomerID = o.CustomerID)
WHERE YEAR(o.OrderDate) = 1997
GROUP BY c.CustomerID, c.CompanyName
GO

SELECT *
FROM #totalOrdenesClientes1997
ORDER BY cantidadOrdenes DESC
GO

/*
En este caso, queda la tabla temporal creada y se tendr� que eliminar expl�citamente 
usando DROP o cuando el usuario se desconecte se eliminar� de manera autom�tica.

Si analiza los costos de cada opci�n del plan de ejecuci�n podr� notar que para 
este conjunto de resultados es igual al usar variables de tipo tabla o tablas temporales.
*/

/*EJERCICIO 03. Crear una variable tipo tabla e insertar los registros manualmente*/
DECLARE @areas TABLE(
	codigo CHAR(5),
	nombre VARCHAR(100),
	fecha_creacion DATE
)

INSERT INTO @areas
VALUES('98653', 'Gerencia General', '2014-10-15'),
('45732', 'Producci�n', '1996-11-16'),
('57794', 'Ventas', '2015-11-21'),
('35795', 'Log�stica', '2000-10-01'),
('90569', 'Contabilidad', '1999-02-10'),
('34947', 'Proyectos', '1996-02-24')

SELECT * 
FROM @areas 
ORDER BY nombre
GO

/*
IMPORTANTE
Si ejecuta la consulta para mostrar los datos de la variable tipo tabla @areas
fuera del lote, aparecer� un mensaje diciendo que falta declarar la variable
tipo table @areas. Es decir, ejecute a continuaci�n la consulta siguiente:
*/
SELECT *
FROM @areas
ORDER BY nombre
GO
/*
Se observa el siguiente resultado de error: 
	Msg 1087, Level 15, State 2, Line 138
	Must declare the table variable "@areas".
Eso ocurre precisamente por que se est� ejecutando la variable tipo tabla fuera
del lote de instrucci�n. 
Mayor explicaci�n se ve en el EJERCICIO 01.
*/





