/*-- USO DE SELECT INTO EN UN FILEGROUP --

La instrucci�n Select permite extraer la informaci�n guardada en las tablas, en ocasiones es necesario 
conservar los datos de una consulta y para eso podemos crear una tabla con el resultado de la consulta 
usando la opci�n Into (Ver Opciones de Select) seguido del nombre de la tabla que generalmente puede ser 
una tabla de uso temporal (Ver Tablas Temporales). Tambi�n se puede guardar el resultado de una consulta 
en una vista, la bondad de la vista es que se actualizar� cuando las tablas de las que se cre� esta se 
actualicen.

Por otro lado, los archivos de una base de datos (Ver Archivos de base de datos) est�n ordenados en Grupos 
de archivos (Ver Grupos de archivos), esto permite que podamos elegir la ubicaci�n y nombre del archivos, 
tama�o inicial, tama�o m�ximo y crecimiento de cada uno de los archivos de la base de datos al crearla 
(Ver Crear Base de datos) y tambi�n modificando la base de datos (Ver Modificaci�n de la Base de datos: 
Grupos y archivos).

Una buena pr�ctica es que los objetos temporales se creen en un grupo cuyos archivos est�n ubicados en uno de 
los discos m�s r�pidos y donde exista mas espacio, es posible dirigir la creaci�n de las tablas generadas de 
manera temporal con la opci�n Into de la instrucci�n Select usando la opci�n On NombreGrupo.

Versi�n:
V�lido desde SQL Server 2016 en adelante.
Permisos:
Necesita el permiso de Create Table

Crear tablas en un grupo de archivos espec�fico

Sintaxis para create table

Select Campo1, Campo2, � into TablaTemporal on NombreGrupo
from TablaOrigen �
Note despu�s del uso de la opci�n into el nombre del grupo donde se crear� la tabla.
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

--Vemos la ubicaci�n de la tabla 
SP_HELP ProductosPorAtender
GO

/*EJERCICIO 02. Crear una tabla con las �rdenes de 1997 donde se compraron m�s de 200 productos*/
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
- No es posible especificar una variable de tabla o un par�metro con valores de tabla como la nueva tabla
- No es posible usar SELECT ...INTO para crear una tabla particionada, incluso cuando la tabla fuente est�
  particionada, SELECT ...INTO no usa el esquema de partici�n de la tabla de origen; en su lugar, la nueva
  tabla se crea en el grupo de archivos predetemrinado. Para insetar filas en una tabla particionada, 
  primoer debe crear la tabla particionada y luego usar la instrucci�n INSERT INTO ...SELECT ...FROM.
- Los �ndices, las restricciones y los triggers definidos en la tabla de origen no se transfieresn a la
  nueva tabla, ni se pueden especificar en la isntrucci�n SELECT ...INTO. Si estos objetos son necesarios,
  puede crearlos depsu�s de ejecutar la instrucci�n SELECT ...INTO.
- Especificar una cl�usula ORDER BY no garantiza que las filas se inserten en el orden especificado
- Cuando se incluye una columna dispersa en la lista de selecci�n, la propiedad de la columna dispersa 
  no se transfiere a la columna de la nueva tabla. Si la propiedad es necesaria en la neuva tabla, modifique
  la definici�n de la columna despu�s de ejecutar la instrucci�n SELECT ...INTO para incluir esa 
  propiedad.
- Cuando se incluye una columna calculada en la lista de selecci�n, la columna correspondiente en la 
  nueva tabla no es una columna calculada. Los valores en la nueva columna son valores que se calcularon
  en el momento en que se ejecut� SELECT ...INTO
*/