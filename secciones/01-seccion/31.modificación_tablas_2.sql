/*-- ALTER TABLE SQL SERVER | AGREGAR CHECK --*/
/*
Las tablas en ocasiones se tienen que modificar ya sea por nuevas funcionalidades en el 
sistema o por nuevas reglas de negocio de los datos en estas, es posible que se agreguen 
tablas nuevas y algunas se tengan que modificar. Las reglas de negocio para las tablas 
existentes pueden cambiar, lo  que hace en ocasiones necesario de agregar restricciones a 
las tablas. En este ejercicio se muestra como agregar campos, restricciones y analizar 
los registros que no cumplan con una restricción de tipo Check.
*/

/*EJERCICIO 01. Crear una base de datos en diferentes unidades*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BD'
GO
XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\BD'
GO
XP_CREATE_SUBDIR 'M:\BD_SQL_SERVER\BD'
GO

CREATE DATABASE bd_sistemas
ON PRIMARY
(NAME='S1', FILENAME='C:\BD_SQL_SERVER\BD\S1.mdf'),
(NAME='S2', FILENAME='M:\BD_SQL_SERVER\BD\S2.ndf'),
FILEGROUP CONTABLE
(NAME='S3', FILENAME='D:\BD_SQL_SERVER\BD\S3.ndf')
LOG ON
(NAME='Log1', FILENAME='C:\BD_SQL_SERVER\BD\Log1.ldf')
GO

USE bd_sistemas
GO

/*EJERCICIO 02. Ejemplo para el módulo de ventas. 
Tabla categorias: Esquema: dbo. Grupo: Primary*/
CREATE TABLE categorias(
	codigo CHAR(4), 
	descripcion VARCHAR(100),
	estado CHAR(1),
	fecha_creacion DATE,
	CONSTRAINT pk_categorias PRIMARY KEY(codigo)
)
GO

/*EJERCICIO 03. Tabla clientes: Esquema Ventas, Grupo Contable*/
CREATE SCHEMA ventas
GO

CREATE TABLE ventas.clientes(
	codigo CHAR(8),
	nombre VARCHAR(200),
	direccion VARCHAR(300),
	fecha_registro DATE,
	CONSTRAINT pk_clientes PRIMARY KEY(codigo)
) ON CONTABLE
GO

/*EJERCICIO 04. Productos en el esquema Comercial: código, descripción, precio,
stock, estado, la categoria a la que pertenece(FK)*/
--En automático la tabla productos se creará en el esquema comercial ya que no le pusimos el GO
CREATE SCHEMA comercial
CREATE TABLE productos(
	codigo CHAR(4),
	categoria_codigo CHAR(4),
	descripcion VARCHAR(100),
	precio NUMERIC(9,2), 
	stock NUMERIC(9,2),
	estado CHAR(1),
	CONSTRAINT pk_productos PRIMARY KEY(codigo),
	CONSTRAINT fk_categorias_productos FOREIGN KEY(categoria_codigo) REFERENCES categorias(codigo)
)
GO

SELECT t.name AS tabla, s.name AS esquema
FROM SYS.TABLES AS t 
	INNER JOIN SYS.SCHEMAS AS s ON(s.schema_id = t.schema_id)
GO
	
/* MODIFICACIÓN DE LAS TABLAS 
Agregar campos			: ADD columna
Modificar				: ALTER COLUMN Columna
Eliminar				: DROP COLUMN NombreColumna

Restricciones:
Agregar					: ADD CONSTRAINT ….
Eliminar				: DROP CONSTRAINT ….
*/

/*EJERCICIO 05. Agregar en la tabla clientes los campos correo y telefono*/
ALTER TABLE ventas.clientes
ADD correo VARCHAR(100) NULL, telefono VARCHAR(15) NULL
GO

--Ver la estructura de la tabla
SP_HELP 'ventas.clientes'
GO

/*EJERCICIO 06. Agregar restriccion para el campo precio en la tabla productos
condición precio >= 0*/
ALTER TABLE comercial.productos
ADD CONSTRAINT ck_precio_prod CHECK(precio >= 0)
GO

/*EJERCICIO 07. Crear la tabla empleados*/
CREATE TABLE empleados(
	codigo CHAR(3),
	nombre VARCHAR(100),
	sueldo NUMERIC(9,2),
	CONSTRAINT pk_empleados PRIMARY KEY(codigo)
)
GO

/*EJERCICIO 08. Insertar registros*/
INSERT INTO empleados
VALUES('890', 'ALICIA FLORES', 930),
('741', 'GABRIELITO DÍAZ', 750)
GO

--Ver los registros
SELECT * FROM empleados
GO

/*EJERCICIO 09. Agregar restricciones para el sueldo >= 1000*/
ALTER TABLE empleados 
WITH NOCHECK ADD CONSTRAINT ck_sueldo_empl CHECK(sueldo >= 1000)
GO

/*EJERCICIO 10. Se puede usar DBCC CHECKCONSTRAINTS para ver los sueldos que no cumplen*/
DBCC CHECKCONSTRAINTS(ck_sueldo_empl)
GO

/*EJERCICIO 11. Listar los constraints tipo check*/
SELECT * 
FROM SYS.CHECK_CONSTRAINTS
GO