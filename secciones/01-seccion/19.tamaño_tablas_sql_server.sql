/*-- TAMAÑO DE TABLAS EN SQL SERVER --*/
/*
En una base de datos en SQL Server la información es 
almacenada en las tablas, estas pueden llegar a convertirse 
en tablas grandes y es necesario considerar una partición 
horizontal en tablas que son grandes. (Ver partición 
Horizontal de tablas)

En este artículo se va a mostrar como listar las tablas 
y su tamaño de la base de datos abierta, la idea es tener 
un listado de las tablas ordenadas por el tamaño que ocupan 
en el disco, una vez que se obtiene el listado de las tablas 
se pueden tomar decisiones que permitan aumentar la efectividad 
de las consultas.
*/

/*Este procedimiento permite mostrar el espacio que ocupa una tabla*/
USE Northwind
GO

EXECUTE sp_spaceused 'Customers'
GO

/*EJERCICIO: VER EL TAMAÑO DE LAS TABLAS DE LA BD Northwind
Se va a listar todas las tablas de la base de datos y 
las almacenará en un cursor, luego usando el procedimiento 
almacenado sp_spaceused se va a llenar una tabla temporal. 
Para ubicar mejor la tabla se va a incluir el nombre del esquema.*/

USE Northwind
GO

SET NOCOUNT ON

DECLARE c_tablas CURSOR FOR
SELECT s.name + '.' + o.name, s.name
FROM SYS.SCHEMAS AS s 
	INNER JOIN SYS.OBJECTS AS o ON(o.schema_id = s.schema_id)
WHERE o.type = 'U'
-- Tabla temporal para los resultados de las tablas de la BD
-- Tipo de dato sysname se utiliza para los nombres de las tablas
DROP TABLE IF EXISTS #tablas
CREATE TABLE #tablas(
	nombre SYSNAME,
	registros NVARCHAR(50),
	reservado NVARCHAR(20),
	datos	NVARCHAR(20),
	indice NVARCHAR(20),
	no_usado NVARCHAR(20),
	esquema NVARCHAR(128)
)
--Recorremos el cursor obteniendo la información de espacio ocupado
DECLARE @nombreTablaConEsquema AS SYSNAME, @nombreEsquema AS NVARCHAR(128)

OPEN c_tablas

FETCH c_tablas INTO @nombreTablaConEsquema, @nombreEsquema

WHILE (@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO #tablas(nombre, registros, reservado, datos, indice, no_usado)
		EXECUTE SP_SPACEUSED @nombreTablaConEsquema
		-- Actualizar el nombre del esquema
		UPDATE #tablas
		SET esquema = @nombreEsquema
		WHERE nombre = RIGHT(@nombreTablaConEsquema, LEN(@nombreTablaConEsquema) - CHARINDEX('.', @nombreTablaConEsquema))
		
		FETCH c_tablas INTO @nombreTablaConEsquema, @nombreEsquema
	END
CLOSE c_tablas
DEALLOCATE c_tablas
--Los tamaños aparecen con la unidad KB, se van a eliminar los tres últimos
--caracteres para poder obtener los valores
UPDATE #tablas
SET reservado = LEFT(reservado, LEN(reservado) - 3),
datos = LEFT(datos, LEN(datos) - 3),
indice = LEFT(indice, LEN(indice) - 3),
no_usado = LEFT(no_usado, LEN(no_usado) - 3)
--Ordenamos la información por el tamaño ocupado
SELECT nombre, esquema, reservado, registros, datos, indice, no_usado
FROM #tablas
ORDER BY CONVERT(NUMERIC(9,2), reservado) DESC
GO