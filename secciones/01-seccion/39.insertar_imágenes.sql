/*-- INSERTAR IM�GENES EN UN CAMPO IMAGE DESDE SQL SERVER MANAGEMENT STUDIO --*/
/*
Al crear una tabla, es necesario con regularidad almacenar las im�genes de los registros, 
por ejemplo, la imagen de un empleado, la imagen de un producto, la imagen de una 
intervenci�n quir�rgica, las fotos de un auto siniestrado en un sistema de seguros 
vehiculares, etc.

Las im�genes pueden ocupar un poco m�s de espacio en el disco que los datos de tipo texto o 
los datos num�ricos as� como las fechas, si van a ser muchos registros, es recomendable 
separar las im�genes en un grupo de archivos diferente de donde est�n los datos del mismo 
registro usando la partici�n vertical de la tabla. 

EJEMPLO
En este ejemplo se crear� una base de datos y luego crear dos tablas, una con empleados y 
otra con productos. Luego insertaremos los registros incluyendo las fotos de los empleados 
y las im�genes de los productos.

Para que los ejercicios funcionen, antes de ejecutar los scripts, cree las carpetas e 
inserte en ellas las im�genes a insertar. Las fotos de los empleados se ubicar�n en la 
carpeta:
	D:\BD_SQL_SERVER\EmpleadosFotos 
, y las im�genes de los productos estar�n  en la carpeta :
	D:\BD_SQL_SERVER\ProductosImagenes
*/

--La base de datos
CREATE DATABASE bd_imagenes
GO

USE bd_imagenes
GO

--Tabla empleados
CREATE TABLE empleados(
	codigo CHAR(6),
	paterno VARCHAR(50),
	materno VARCHAR(50),
	nombre VARCHAR(50),
	fecha_nacimiento DATE,
	estado CHAR(1),
	foto IMAGE,
	CONSTRAINT pk_empleados PRIMARY KEY(codigo)
)
GO

--Insertar empleados
INSERT INTO empleados(codigo, paterno, materno, nombre, fecha_nacimiento, estado, foto)
SELECT 'PR3498', 'D�az', 'Flores', 'Mart�n', '1989-05-14', 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\EmpleadosFotos\empleado1.jpg', SINGLE_BLOB) AS foto
GO

INSERT INTO empleados(codigo, paterno, materno, nombre, fecha_nacimiento, estado, foto)
SELECT 'TF9085', 'Ch�vez', 'Terranova', 'Ingrid', '1999-02-10', 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\EmpleadosFotos\empleado2.jpg', SINGLE_BLOB) AS foto
GO

INSERT INTO empleados(codigo, paterno, materno, nombre, fecha_nacimiento, estado, foto)
SELECT 'PW0974', 'D�az', 'Ardiles', 'Gabrielito', '1989-09-18', 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\EmpleadosFotos\empleado3.jpg', SINGLE_BLOB) AS foto
GO

--Note el uso de la funci�n OpenRowSet para insertar las im�genes

--Visualizar los empleados
SELECT * 
FROM empleados
GO

--Tabla productos
CREATE TABLE productos(
	codigo CHAR(6),
	descripcion VARCHAR(100),
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	estado CHAR(1),
	foto IMAGE,
	CONSTRAINT pk_productos PRIMARY KEY(codigo)
)
GO

--Insertar los productos
INSERT INTO productos(codigo, descripcion, precio, stock, estado, foto)
SELECT 'T00799', 'Alicate universal stanling', 25.60, 50, 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\ProductosImagenes\producto1.jpg', SINGLE_BLOB) AS foto
GO

INSERT INTO productos(codigo, descripcion, precio, stock, estado, foto)
SELECT 'T00599', 'Martillo con cu�a saca clavos', 15.60, 40, 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\ProductosImagenes\producto2.jpg', SINGLE_BLOB) AS foto
GO

INSERT INTO productos(codigo, descripcion, precio, stock, estado, foto)
SELECT 'T00777', 'Destornillador plano', 18.60, 8, 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\ProductosImagenes\producto3.jpg', SINGLE_BLOB) AS foto
GO

INSERT INTO productos(codigo, descripcion, precio, stock, estado, foto)
SELECT 'T00800', 'Foco led ultra ahorrador', 45.30, 5, 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\ProductosImagenes\producto4.jpg', SINGLE_BLOB) AS foto
GO

--Ver listado de productos
SELECT * 
FROM productos
GO

/*
USO DE LA FUNCI�N OPENROWSET
- Se utiliza la funci�n OPENROWSET para hacer referencia en la cl�usula FROM de una 
  consulta como si fuera un nombre de tabla.
- Esta funci�n OPENROWSET puede hacer referencia como la tabla de destino de una INSERT
  , UPDATE o DELETE
- Si la consulta devuelve varios registros, OPENROWSET devuelve s�lo el primero.
- OPENROWSET tambi�n permite el uso del proveedor BULK incorporado que permite leer los 
  datos de un archivo de imagen y crear el arreglo de bits para almacenarlo en un campo.
*/
