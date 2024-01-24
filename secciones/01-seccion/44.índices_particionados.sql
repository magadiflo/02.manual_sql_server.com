/*-- ÍNDICES PARTICIONADOS --
Los índices particionados son tipos de índices usados en tablas particionadas

CONCEPTOS PREVIOS
- La partición facilita el uso de tablas e índices grandes, ya que permite administrar  y 
  tener acceso a subconjuntos de datos de forma rápida y eficaz, a la vez que mantiene la 
  integridad de la recopilación de datos.
- Si se utilizan las particiones, una operación como la carga de datos desde un sistema OLTP 
  a un sistema OLAP tarda solo unos segundos, en lugar de los minutos y las horas que tardaba 
  en versiones anteriores de SQL Server.
- Las operaciones de mantenimiento que se realizan en los subconjuntos de datos también se realizan 
  de forma más eficaz porque estas operaciones solo afectan a los datos necesarios, en lugar de a 
  toda la tabla.
- Las tablas e índices con particiones únicamente están disponibles en las ediciones Enterprise, 
  Developer y Evaluation de SQL Server.
- Los datos de tablas e índices con particiones se dividen en unidades que pueden propagarse por 
  más de un grupo de archivos de la base de datos.
- Los datos se dividen en sentido horizontal, de forma que los grupos de filas se asignan a 
  particiones individuales.
- La tabla o el índice se tratarán como una sola entidad lógica cuando se realicen consultas o 
  actualizaciones en los datos. Las particiones de un índice o una tabla deben encontrarse en la 
  misma base de datos.
- Las tablas y los índices con particiones admiten todas las propiedades y características asociadas 
  con el diseño y la consulta de tablas e índices estándar, incluidas las restricciones, los valores
  predeterminados, los valores de identidad y marca de tiempo, así como los desencadenadores. 
  Por tanto, si desea implementar una vista con particiones local en un servidor, puede interesarle 
  implementar en su lugar una tabla con particiones.
- La decisión acerca del uso de las particiones depende básicamente del tamaño actual  o futuro de 
  la tabla, la forma en que se utiliza y el rendimiento que presenta en las consultas de usuario y 
  las operaciones de mantenimiento.

EJEMPLO
Para crear índices particionados vmos a crear primero una tabla particionada. 
Este ejercicio muestra una tabla con 5 particiones en tres grupos de archivos ,
la base de datos está creada en las unidades C: y D: 
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

/*La tabla particionada, esta requiere una función de partición y un esquema de partición*/
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

/*Insertar datos a la tabla, se tomarán los datos de la tabla products de Northwind*/
INSERT INTO productos
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Northwind.dbo.Products
GO

/*Generar un nuevo código. Primero mostrar el código*/
SELECT codigo, UPPER(LEFT(descripcion, 4) + RTRIM(LTRIM(IIF(LEN(codigo) = 1, '000' + LTRIM(codigo), '00' + LTRIM(codigo))))) + RTRIM(LTRIM('PR')) AS 'NuevoCódigo'
FROM productos
GO

/*Recorrer los productos y actualizar los códigos. Usaremos un cursor*/
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

/*ÍNDICE PARTICIONADO*/
CREATE INDEX idx_productos_codigo 
ON productos(codigo) INCLUDE(descripcion)
ON ep_productos(codigo)
GO

/*
Al final de la creación del índice se incluye la cláusula ON seguido del nombre
del esquema de partición y el campo particionado

NOTE: que para hacer más eficiente el índice se puede incluir (usando include) en 
el campo descripción
*/