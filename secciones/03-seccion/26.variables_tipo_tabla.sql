/*-- VARIABLES TIPO TABLA EN SQL SERVER --

- Las Variables Tipo Tabla son tipos de datos que generalmente son utilizados en un lote T-SQL,  
  procedimiento almacenado o funci�n definida por el usuario.
- Las variables tipo tabla se crea y definen igual a las tablas con la diferencia que tienen una 
  alcance de vida definido.
- Se debe evaluar usando los planes de ejecuci�n de cada opci�n entre Variables tipo tabla y 
  tablas temporales.
- Use las variables tipo tabla o las tablas temporales con conjunto de datos peque�os.

Beneficios
- Duraci�n o alcance. estos objetos viven �nicamente durante la ejecuci�n del lote, funci�n o 
  procedimiento almacenado.
- Tiempos de bloqueo m�s cortos.
- Cuando se usan en procedimientos almacenados realizan menos re compilaciones.

Consideraciones
El rendimiento de las variable tipo tabla no es �ptimo cuando el resultado es demasiado grande.

Sintaxis
DECLARE @nombreVariableTipoTabla TABLE(
	campo1 tipoDato....
)

Limitaciones
- No se puede usar la opci�n Into en un Select (Ver Consultas Opciones)
- No se puede truncar la tabla (Truncate)
- Una vez creadas no se pueden modificar (Ver Alter Table)
- S�lo permite clave primaria y restricci�n Unique.
- No se puede usar funciones definidas por el usuario (UDF) en un check constraint, 
  columna calculada o default constraint. (Ver FDU)
- No se puede usar tipos de datos definidos por el usuario (Ver Tipos de datos definidos por el usuario)
- No se puede eliminar la tabla usando Drop Table
- Las variables de tipo tabla no se pueden acceder en procedimientos anidados

*/
USE Northwind
GO

/*EJERCICIO 01. Crear una tabla tipo variable y asignar los datos de los productos de
categor�a 1*/
DECLARE @productos_categoria_1 TABLE(
	codigo CHAR(3) PRIMARY KEY,
	descripcion VARCHAR(50)
)

INSERT INTO @productos_categoria_1(codigo, descripcion)
SELECT p.ProductID, p.ProductName
FROM Products AS p
WHERE p.CategoryID = 1

SELECT * 
FROM @productos_categoria_1
GO

/*EJERCICIO 02. Crear variable de tipo tabla con los datos de los clientes y la cantidad de �rdenes 
generadas en un a�o determinado. Para 1997*/
DECLARE @totalOrdenesClientes1997 TABLE(
	codigo CHAR(5),
	cliente VARCHAR(100),
	cantidad_ordenes NUMERIC(9,0)
)
INSERT INTO @totalOrdenesClientes1997(codigo, cliente, cantidad_ordenes)
SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS cantidadOrdenes
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE YEAR(o.OrderDate) = 1997
GROUP BY c.CustomerID, c.CompanyName

SELECT * 
FROM @totalOrdenesClientes1997
ORDER BY cantidad_ordenes DESC
GO

--Usando tabla temporal, para el ejercicio anterior ser�a as�: 
CREATE TABLE #totalOrdenesClientes1997(
	codigo CHAR(5),
	cliente VARCHAR(100),
	cantidad_ordenes NUMERIC(9,0)
)
GO

INSERT INTO #totalOrdenesClientes1997(codigo, cliente, cantidad_ordenes)
SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS cantidadOrdenes
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE YEAR(o.OrderDate) = 1997
GROUP BY c.CustomerID, c.CompanyName
GO

SELECT * 
FROM #totalOrdenesClientes1997
ORDER BY cantidad_ordenes DESC
GO

/*En este caso, queda la tabla temporal creada y se tendr� que eliminar expl�citamente 
usando Drop o cuando el usuario se desconecte se eliminar� de manera autom�tica.

Si analiza los costos de cada opci�n del plan de ejecuci�n podr� notar que para este conjunto 
de resultados es igual al usar variables de tipo tabla o tablas temporales.*/

/*EJERCICIO 03. Crear una variable tipo tabla e insertar los registros manualmente.*/
DECLARE @areas TABLE(
	codigo CHAR(5), 
	nombre VARCHAR(100),
	fecha_creacion DATE
)

INSERT INTO @areas(codigo, nombre, fecha_creacion)
VALUES('45732', 'Producci�n', '2014-05-14'),
('57794', 'Ventas', '2015-11-21'),
('90569', 'Contabilidad', '1999-02-10'),
('35795', 'Log�stica', '2000-01-10'),
('34947', 'Proyectos', '1996-02-24')

SELECT codigo, nombre, FORMAT(fecha_creacion, 'dd/MM/yyyy') AS creacion
FROM @areas
ORDER BY nombre ASC
GO

/*
Importante
Si ejecuta la consulta para mostrar los datos de la tabla @areas fuera del lote,
aparecer� un mensaje que falta declarar la variable de tabla @Areas

SELECT *
FROM @areas
ORDER BY nombre ASC
GO
*/

DECLARE @ID NVARCHAR(max) = N'0E984725-C51C-4BF4-9960-E1C80E27ABA0wrong';
SELECT @ID, CONVERT(uniqueidentifier, @ID) AS TruncatedValue;