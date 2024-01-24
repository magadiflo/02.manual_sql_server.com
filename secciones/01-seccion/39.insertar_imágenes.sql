/*-- INSERTAR IMÁGENES EN UN CAMPO IMAGE DESDE SQL SERVER MANAGEMENT STUDIO --*/
/*
Al crear una tabla, es necesario con regularidad almacenar las imágenes de los registros, 
por ejemplo, la imagen de un empleado, la imagen de un producto, la imagen de una 
intervención quirúrgica, las fotos de un auto siniestrado en un sistema de seguros 
vehiculares, etc.

Las imágenes pueden ocupar un poco más de espacio en el disco que los datos de tipo texto o 
los datos numéricos así como las fechas, si van a ser muchos registros, es recomendable 
separar las imágenes en un grupo de archivos diferente de donde están los datos del mismo 
registro usando la partición vertical de la tabla. 

EJEMPLO
En este ejemplo se creará una base de datos y luego crear dos tablas, una con empleados y 
otra con productos. Luego insertaremos los registros incluyendo las fotos de los empleados 
y las imágenes de los productos.

Para que los ejercicios funcionen, antes de ejecutar los scripts, cree las carpetas e 
inserte en ellas las imágenes a insertar. Las fotos de los empleados se ubicarán en la 
carpeta:
	D:\BD_SQL_SERVER\EmpleadosFotos 
, y las imágenes de los productos estarán  en la carpeta :
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
SELECT 'PR3498', 'Díaz', 'Flores', 'Martín', '1989-05-14', 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\EmpleadosFotos\empleado1.jpg', SINGLE_BLOB) AS foto
GO

INSERT INTO empleados(codigo, paterno, materno, nombre, fecha_nacimiento, estado, foto)
SELECT 'TF9085', 'Chávez', 'Terranova', 'Ingrid', '1999-02-10', 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\EmpleadosFotos\empleado2.jpg', SINGLE_BLOB) AS foto
GO

INSERT INTO empleados(codigo, paterno, materno, nombre, fecha_nacimiento, estado, foto)
SELECT 'PW0974', 'Díaz', 'Ardiles', 'Gabrielito', '1989-09-18', 'A', *
FROM OPENROWSET(BULK 'D:\BD_SQL_SERVER\EmpleadosFotos\empleado3.jpg', SINGLE_BLOB) AS foto
GO

--Note el uso de la función OpenRowSet para insertar las imágenes

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
SELECT 'T00599', 'Martillo con cuña saca clavos', 15.60, 40, 'A', *
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
USO DE LA FUNCIÓN OPENROWSET
- Se utiliza la función OPENROWSET para hacer referencia en la cláusula FROM de una 
  consulta como si fuera un nombre de tabla.
- Esta función OPENROWSET puede hacer referencia como la tabla de destino de una INSERT
  , UPDATE o DELETE
- Si la consulta devuelve varios registros, OPENROWSET devuelve sólo el primero.
- OPENROWSET también permite el uso del proveedor BULK incorporado que permite leer los 
  datos de un archivo de imagen y crear el arreglo de bits para almacenarlo en un campo.
*/
