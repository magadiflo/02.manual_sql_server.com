/*-- USO DE SELECT INTO EN UN FILEGROUP --

La instrucción Select permite extraer la información guardada en las tablas, en ocasiones es necesario 
conservar los datos de una consulta y para eso podemos crear una tabla con el resultado de la consulta 
usando la opción Into (Ver Opciones de Select) seguido del nombre de la tabla que generalmente puede ser 
una tabla de uso temporal (Ver Tablas Temporales). También se puede guardar el resultado de una consulta 
en una vista, la bondad de la vista es que se actualizará cuando las tablas de las que se creó esta se 
actualicen.

Por otro lado, los archivos de una base de datos (Ver Archivos de base de datos) están ordenados en Grupos 
de archivos (Ver Grupos de archivos), esto permite que podamos elegir la ubicación y nombre del archivos, 
tamaño inicial, tamaño máximo y crecimiento de cada uno de los archivos de la base de datos al crearla 
(Ver Crear Base de datos) y también modificando la base de datos (Ver Modificación de la Base de datos: 
Grupos y archivos).

Una buena práctica es que los objetos temporales se creen en un grupo cuyos archivos estén ubicados en uno de 
los discos más rápidos y donde exista mas espacio, es posible dirigir la creación de las tablas generadas de 
manera temporal con la opción Into de la instrucción Select usando la opción On NombreGrupo.

Versión:
Válido desde SQL Server 2016 en adelante.
Permisos:
Necesita el permiso de Create Table

Crear tablas en un grupo de archivos específico

Sintaxis para create table

Select Campo1, Campo2, … into TablaTemporal on NombreGrupo
from TablaOrigen …
Note después del uso de la opción into el nombre del grupo donde se creará la tabla.
*/

USE Northwind
GO

--Agregar un grupo de archivos y luego un archivo en la unidad B:

--El grupo
ALTER DATABASE Northwind
ADD FILEGROUP temporal
GO

--El archivo
XP_CREATE_SUBDIR 'B:\BD_SQL_SERVER\Temp'
GO

ALTER DATABASE Northwind 
ADD FILE(NAME='Temporal', FILENAME='B:\BD_SQL_SERVER\Temp\temporal.ndf')
TO FILEGROUP temporal
GO

/*EJERICIO 01. Generar una tabla con los productos que tengan unidades por atender*/
IF EXISTS(SELECT name FROM SYS.TABLES WHERE name = 'ProductosPorAtender')
	BEGIN
		DROP TABLE 	ProductosPorAtender	
	END

SELECT p.ProductID AS codigo, p.ProductName AS descripcion, 
	   p.UnitPrice AS precio, p.UnitsOnOrder AS 'por atender'
INTO ProductosPorAtender ON temporal
FROM Products AS p
WHERE p.UnitsOnOrder > 0
ORDER BY p.UnitsOnOrder DESC
GO

--Ver los datos de la tabla 
SELECT * FROM ProductosPorAtender
GO

--Vemos la ubicación de la tabla 
SP_HELP ProductosPorAtender
GO

/*EJERCICIO 02. Crear una tabla con las órdenes de 1997 donde se compraron más de 200 productos*/
IF EXISTS(SELECT name FROM SYS.TABLES WHERE name = 'Ordenes1997Mas200Productos')
	BEGIN
		DROP TABLE Ordenes1997Mas200Productos
	END

SELECT o.OrderID AS orden, FORMAT(o.OrderDate, 'dd/MM/yyyy') AS fecha, SUM(od.Quantity) AS cantidad 
INTO Ordenes1997Mas200Productos ON temporal
FROM Orders AS o 
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
WHERE YEAR(o.OrderDate) = 1997
GROUP BY o.OrderID, o.OrderDate
HAVING SUM(od.Quantity) > 200
GO

--Ver los datos de la tabla 
SELECT * FROM Ordenes1997Mas200Productos
GO

/*LIMITACIONES Y RESTRICCIONES
- No es posible especificar una variable de tabla o un parámetro con valores de tabla como la nueva tabla
- No es posible usar SELECT ...INTO para crear una tabla particionada, incluso cuando la tabla fuente está
  particionada, SELECT ...INTO no usa el esquema de partición de la tabla de origen; en su lugar, la nueva
  tabla se crea en el grupo de archivos predetemrinado. Para insetar filas en una tabla particionada, 
  primoer debe crear la tabla particionada y luego usar la instrucción INSERT INTO ...SELECT ...FROM.
- Los índices, las restricciones y los triggers definidos en la tabla de origen no se transfieresn a la
  nueva tabla, ni se pueden especificar en la isntrucción SELECT ...INTO. Si estos objetos son necesarios,
  puede crearlos depsués de ejecutar la instrucción SELECT ...INTO.
- Especificar una cláusula ORDER BY no garantiza que las filas se inserten en el orden especificado
- Cuando se incluye una columna dispersa en la lista de selección, la propiedad de la columna dispersa 
  no se transfiere a la columna de la nueva tabla. Si la propiedad es necesaria en la neuva tabla, modifique
  la definición de la columna después de ejecutar la instrucción SELECT ...INTO para incluir esa 
  propiedad.
- Cuando se incluye una columna calculada en la lista de selección, la columna correspondiente en la 
  nueva tabla no es una columna calculada. Los valores en la nueva columna son valores que se calcularon
  en el momento en que se ejecutó SELECT ...INTO
*/