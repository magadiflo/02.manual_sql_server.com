/*-- MERGE EN SQL SERVER --

Instrucción Merge

Realiza instrucciones de inserción de registros, actualización o eliminación de registros en una 
tabla de destino en la misma base de datos o en otra base de datos según los resultados de combinar 
los registros con una tabla de origen.

Sintaxis
La forma de usar Merge es la siguiente:

MERGE
[ TOP ( n ) [ PERCENT ] ]
[ INTO ] <Tabla_Destino> [ [ AS ] AliasTablaDestino ]
USING <Tabla_Origen> [ [ As ] AliasTablaOrigen]
ON <CondiciónMergeComparación>
[ WHEN MATCHED [ AND <Condición> ]
THEN <Isntrucción Si encuentra> ] [ …n ]
[ WHEN NOT MATCHED [ BY TARGET ] [ AND <Condición> ]
THEN <Instrucción Si NO Encuentra en Destino> ]
[ WHEN NOT MATCHED BY SOURCE [ AND <Condición> ]
THEN <Instrucción Si NO Encuentra en Origen> ] [ …n ]
*/

/*EJERCICIO 01. En este ejemplo, se tienen dos bases de datos cada una con una tabla de Productos.
La base de datos bd_planes, con la tabla planes_productos y la base de datos bd_desarrollo con la 
tabla desarrollo_productos.*/
--BASE DE DATOS PLANES
CREATE DATABASE bd_planes
GO

USE bd_planes
GO

CREATE TABLE planes_productos(
	codigo CHAR(4),
	descripcion VARCHAR(100),
	precio_unitario NUMERIC(10,2),
	stock_actual NUMERIC(10,2),
	CONSTRAINT pk_productos PRIMARY KEY(codigo)
)
GO

INSERT INTO planes_productos
VALUES('8856', 'Lámpara personal', 25.4, 100),
('8636', 'Auriculares Deluxe', 98.4, 20),
('4685', 'Escritorio Gerencial', 525, 6),
('5780', 'Marco Foto', 20, 80),
('0665', 'Impresora HP', 65, 15)
GO

--BASE DE DATOS DESARROLLO
CREATE DATABASE bd_desarrollo
GO

USE bd_desarrollo
GO

CREATE TABLE desarrollo_productos(
	codigo CHAR(4),
	descripcion VARCHAR(100),
	precio_unitario NUMERIC(10,2),
	stock_actual NUMERIC(10,2),
	CONSTRAINT pk_productos PRIMARY KEY(codigo)
)
GO

--Insertar los registros en la tabla desarrollo_productos
/*Note los cambios, se han insertado registros y las coincidencias o diferencias se notan en la 
siguiente figura:
— Primer registro «Lámpara Personal» con un valor del Stock de 80
— Segundo registro «Auriculares Deluxe» con precio de 115
— Tercer y cuarto registros nuevos
— Quinto registro «Impresora HP» tiene la descripción cambiada y nuevo Stock de 15 a 25*/
INSERT INTO desarrollo_productos
VALUES('8856', 'Lámpara personal', 25.4, 80),
('8636', 'Auriculares Deluxe', 115, 20),
('9879', 'Switch Ethernet 993', 85, 3),
('4567', 'Memoria USB 16GB', 50, 10),
('0665', 'Impresora HP Multifuncional', 65, 25)
GO

--Antes del MERGE
SELECT * 
FROM bd_planes.dbo.planes_productos
GO

SELECT * 
FROM bd_desarrollo.dbo.desarrollo_productos
GO

/*Haciendo MERGE
La tabla origen es productos de la base de datos bd_desarrollo y la tabla destino
en productos en la base de datos bd_planes*/
MERGE INTO bd_planes.dbo.planes_productos AS tabla_destino
USING bd_desarrollo.dbo.desarrollo_productos AS tabla_origen
ON(tabla_destino.codigo = tabla_origen.codigo)
WHEN NOT MATCHED THEN
	INSERT VALUES(tabla_origen.codigo, tabla_origen.descripcion, tabla_origen.precio_unitario,
	tabla_origen.stock_actual)
WHEN MATCHED THEN
	UPDATE SET descripcion = tabla_origen.descripcion,
	precio_unitario = tabla_origen.precio_unitario,
	stock_actual = tabla_origen.stock_actual;
GO

--Visualizar los resultados

--En la tabla planes_productos se han insertado dos registros
SELECT * 
FROM bd_planes.dbo.planes_productos
GO

--En la tabla origen de la bd_desarrollo los registros son los mismos
SELECT * 
FROM bd_desarrollo.dbo.desarrollo_productos
GO