/*-- �NDICES PARTICIONADOS --
Los �ndices particionados son tipos de �ndices usados en tablas particionadas

CONCEPTOS PREVIOS
- La partici�n facilita el uso de tablas e �ndices grandes, ya que permite administrar  y 
  tener acceso a subconjuntos de datos de forma r�pida y eficaz, a la vez que mantiene la 
  integridad de la recopilaci�n de datos.
- Si se utilizan las particiones, una operaci�n como la carga de datos desde un sistema OLTP 
  a un sistema OLAP tarda solo unos segundos, en lugar de los minutos y las horas que tardaba 
  en versiones anteriores de SQL Server.
- Las operaciones de mantenimiento que se realizan en los subconjuntos de datos tambi�n se realizan 
  de forma m�s eficaz porque estas operaciones solo afectan a los datos necesarios, en lugar de a 
  toda la tabla.
- Las tablas e �ndices con particiones �nicamente est�n disponibles en las ediciones Enterprise, 
  Developer y Evaluation de SQL Server.
- Los datos de tablas e �ndices con particiones se dividen en unidades que pueden propagarse por 
  m�s de un grupo de archivos de la base de datos.
- Los datos se dividen en sentido horizontal, de forma que los grupos de filas se asignan a 
  particiones individuales.
- La tabla o el �ndice se tratar�n como una sola entidad l�gica cuando se realicen consultas o 
  actualizaciones en los datos. Las particiones de un �ndice o una tabla deben encontrarse en la 
  misma base de datos.
- Las tablas y los �ndices con particiones admiten todas las propiedades y caracter�sticas asociadas 
  con el dise�o y la consulta de tablas e �ndices est�ndar, incluidas las restricciones, los valores
  predeterminados, los valores de identidad y marca de tiempo, as� como los desencadenadores. 
  Por tanto, si desea implementar una vista con particiones local en un servidor, puede interesarle 
  implementar en su lugar una tabla con particiones.
- La decisi�n acerca del uso de las particiones depende b�sicamente del tama�o actual  o futuro de 
  la tabla, la forma en que se utiliza y el rendimiento que presenta en las consultas de usuario y 
  las operaciones de mantenimiento.

EJEMPLO
Para crear �ndices particionados vmos a crear primero una tabla particionada. 
Este ejercicio muestra una tabla con 5 particiones en tres grupos de archivos ,
la base de datos est� creada en las unidades C: y D: 
*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\Parte'
GO

XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\Logica'
GO

DROP DATABASE IF EXISTS bd_sistemas
GO

CREATE DATABASE bd_sistemas
ON PRIMARY(NAME='bd_sistemas01', FILENAME='C:\BD_SQL_SERVER\Parte\bd_sistemas01.mdf'),
FILEGROUP VENTAS
(NAME='bd_sistemas02', FILENAME='C:\BD_SQL_SERVER\Parte\bd_sistemas02.ndf'),
FILEGROUP RECURSOS
(NAME='bd_sistemas03', FILENAME='C:\BD_SQL_SERVER\Parte\bd_sistemas03.ndf')
LOG ON
(NAME='Tran01', FILENAME='C:\BD_SQL_SERVER\Parte\Tran01.ldf')
GO

USE bd_sistemas
GO

/*La tabla particionada, esta requiere una funci�n de partici�n y un esquema de partici�n*/
CREATE PARTITION FUNCTION fp_productos(CHAR(10))
AS RANGE FOR VALUES('E', 'J', 'O', 'T')
GO

CREATE PARTITION SCHEME ep_productos
AS PARTITION fp_productos 
TO(VENTAS, VENTAS, RECURSOS, [PRIMARY], RECURSOS)
GO

CREATE TABLE productos(
	codigo CHAR(10), 
	descripcion VARCHAR(100),
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	CONSTRAINT pk_productos PRIMARY KEY(codigo)
) ON ep_productos(codigo)
GO

/*Insertar datos a la tabla, se tomar�n los datos de la tabla products de Northwind*/
INSERT INTO productos
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Northwind.dbo.Products
GO

/*Generar un nuevo c�digo. Primero mostrar el c�digo*/
SELECT codigo, UPPER(LEFT(descripcion, 4) + RTRIM(LTRIM(IIF(LEN(codigo) = 1, '000' + LTRIM(codigo), '00' + LTRIM(codigo))))) + RTRIM(LTRIM('PR')) AS 'NuevoC�digo'
FROM productos
GO

/*Recorrer los productos y actualizar los c�digos. Usaremos un cursor*/
DECLARE c_actualizar_codigos CURSOR 
FOR SELECT * FROM productos

OPEN c_actualizar_codigos

DECLARE @codigo CHAR(10), @descripcion VARCHAR(100), @precio NUMERIC(9,2), @stock NUMERIC(9,2)

FETCH c_actualizar_codigos INTO @codigo, @descripcion, @precio, @stock
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		UPDATE productos
		SET codigo = UPPER(LEFT(descripcion, 4) + RTRIM(LTRIM(IIF(LEN(codigo) = 1, '000' + LTRIM(codigo), '00' + LTRIM(codigo))))) + RTRIM(LTRIM('PR'))
		WHERE codigo = @codigo
		
		FETCH c_actualizar_codigos INTO @codigo, @descripcion, @precio, @stock
	END

CLOSE c_actualizar_codigos
DEALLOCATE c_actualizar_codigos
GO

/*Ver los datos y las particiones donde se guardaron*/
SELECT codigo, descripcion, $partition.fp_productos(codigo) AS 'particion '
FROM productos
GO

/*�NDICE PARTICIONADO*/
CREATE INDEX idx_productos_codigo 
ON productos(codigo) INCLUDE(descripcion)
ON ep_productos(codigo)
GO

/*
Al final de la creaci�n del �ndice se incluye la cl�usula ON seguido del nombre
del esquema de partici�n y el campo particionado

NOTE: que para hacer m�s eficiente el �ndice se puede incluir (usando include) en 
el campo descripci�n
*/