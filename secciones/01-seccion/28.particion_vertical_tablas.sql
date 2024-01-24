/*-- PARTICIÓN VERTICAL DE TABLAS --*/
/*
En el artículo de Tablas particionadas se describió la forma de como particionar 
una tabla de manera horizontal, cuando se proyecta que esta tabla va a tener muchos registros.

En este artículo se explica como se particiona una tabla de manera vertical, esto 
es básicamente dividiendo la cantidad de campos que tiene la tabla en varias tablas y 
ubicarlas en diferentes grupos de archivos.

Con regularidad se usa para separar los campos que ocupan mucho espacio como los de tipo 
Image para ubicarlos en otra tabla relacionadas con claves foráneas.
*/

/* PASOS PARA CREAR UNA TABLA PARTICIONADA VERTICALMENTE */

/*PASO 1. Crear una base de datos que tenga varios grupos de archivos. Las carpetas serán:
C:\BD_SQL_SERVER\BASES 
D:\BD_SQL_SERVER\BASES\IMAGENES
*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BASES'
GO

XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\BASES\IMAGENES'
GO

CREATE DATABASE bd_particion_vertical
ON PRIMARY
(NAME='Data01', FILENAME='C:\BD_SQL_SERVER\BASES\Data01.mdf'),
FILEGROUP VENTAS
(NAME='Data02', FILENAME='C:\BD_SQL_SERVER\BASES\Data02.ndf'),
FILEGROUP CUENTAS
(NAME='Data03', FILENAME='D:\BD_SQL_SERVER\BASES\IMAGENES\Data03.ndf'),
FILEGROUP RECURSOS
(NAME='Data04', FILENAME='D:\BD_SQL_SERVER\BASES\IMAGENES\Data04.ndf')
LOG ON
(NAME='Datalog01', FILENAME='D:\BD_SQL_SERVER\BASES\IMAGENES\Datalog01.ldf')
GO

/*PASO 2. Crear la tabla, crearemos para el ejemplo una tabla de productos, los datos
de los productos en una tabla en el grupo VENTAS y las imágenes de los mismos en el 
grupo RECURSOS*/
USE bd_particion_vertical
GO

--La tabla productos no contiene la imagen de éstos
CREATE TABLE productos(
	codigo CHAR(8),
	descripcion VARCHAR(50) NOT NULL,
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	estado CHAR(1),
	CONSTRAINT pk_productos PRIMARY KEY(codigo),
	CONSTRAINT ck_precio_prod CHECK(precio >= 0)
) ON VENTAS
GO

/*PASO 3. La tabla imagen_productos contiene la foto de cada producto, en una tabla separada
en otro grupo de archivos*/
CREATE TABLE imagen_productos(
	codigo CHAR(8),
	foto IMAGE,
	CONSTRAINT pk_imagen_productos PRIMARY KEY(codigo),
	CONSTRAINT fk_productos_imagen_productos FOREIGN KEY(codigo) REFERENCES productos(codigo)
) ON RECURSOS
GO

/*IMPORTANTE
Para conseguir que los datos de la tabla Productos se particione es necesario crear las 
tablas anteriores en diferentes grupos de archivos. Para nuestro ejemplo se creó la tabla 
Productos en el grupo de archivos VENTAS y la tabla imagen_productos en el grupo
de archivos RECURSOS.
*/

/*PASO 04. Insertar registros
El producto sin la foto en Productos, y luego la foto en imagen_productos*/

--TECLADO
INSERT INTO productos(codigo, descripcion, precio, stock, estado)
VALUES('T0467', 'Teclado', 45, 10, 'A')
GO

INSERT INTO imagen_productos
SELECT 'T0467' AS codigo, *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\BASES\IMAGENES\teclado.jpg', SINGLE_BLOB) AS picture
GO

--MOUSE
INSERT INTO productos
VALUES('T9867', 'Mouse', 65.50, 30, 'A')
GO

INSERT INTO imagen_productos
SELECT 'T9867' AS codigo, *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\BASES\IMAGENES\mouse.jpg', SINGLE_BLOB) AS picture
GO

--MONITOR
INSERT INTO productos
VALUES('T0970', 'Monitor',780.90, 12, 'A')
GO

INSERT INTO imagen_productos
SELECT 'T0970' AS codigo, *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\BASES\IMAGENES\monitor.jpg', SINGLE_BLOB) AS picture
GO

--Si se lista los registros de ambas tablas
SELECT * FROM productos
SELECT * FROM imagen_productos
GO
--Se puede ver los datos de los productos en la tabla productos y sus imágenes en la 
--tabla imagen_productos


/*PASO 5. Para ver los datos se creará una vista*/
CREATE VIEW v_productos
AS
	SELECT p.codigo, p.descripcion, p.precio, p.stock, p.estado, i.foto 
	FROM productos AS p
		INNER JOIN imagen_productos as i ON(i.codigo = p.codigo)
GO

--Para listar los productos y las imágenes de los mismos se utilizará la vista
SELECT * 
FROM v_productos
GO

/*RECOMENDACIÓN
Cuando cree su procedimiento almacenado que guarda el registro en la tabla productos,
debe incluir la instrucción para insertar el mismo registro en la tabla imagen_productos.
Se puede usar Trigger
*/