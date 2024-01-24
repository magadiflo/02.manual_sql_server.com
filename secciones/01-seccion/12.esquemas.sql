/*Esquemas: crear, modificar y eliminar */
/*
ESQUEMAS EN SQLSERVER
Los esquemas en SQL Server permiten organizar los elementos
asegurables como tablas, vistas, procedimientos almacenados, etc.
y poder administrar mejor los permisos sobre estos. 

CREAR UN ESQUEMA
La instrucción para crear un esquema tiene la siguiente sintaxis:

CREATE SCHEMA NombreEsquema [AUTORIZATION Usuario]

Notas:

CREATE SCHEMA debe ser la única instrucción del lote.
El esquema por defecto donde se crean los objetos como 
tablas, vistas, procedimientos almacenados, 
etc es el esquema dbo (DataBase Owner).

Si se utilizan instrucciones para crear tablas o vistas 
dentro del mismo bloque de la instrucción Create Schema, 
estos se crean dentro del esquema.

Se pueden usar Grant y Deny para asignar o quitar los permisos 
sobre los asegurables en un esquema.
*/

/*EJERCICIO 01. Crear una base de datos. Supongamos que existen las
unidades C:, D: y M:*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BASES'
GO
XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\BASES'
GO
XP_CREATE_SUBDIR 'M:\BD_SQL_SERVER\BASES'
GO
CREATE DATABASE bd_olimpiadas
ON PRIMARY
(NAME='bd_olimpiadas_01', FILENAME='C:\BD_SQL_SERVER\BASES\bd_olimpiadas_01.mdf'),
FILEGROUP VENTAS
(NAME='bd_olimpiadas_02', FILENAME='D:\BD_SQL_SERVER\BASES\bd_olimpiadas_02.ndf')
LOG ON
(NAME='bd_olimpiadas_03', FILENAME='M:\BD_SQL_SERVER\BASES\bd_olimpiadas_03.ldf')
GO

USE bd_olimpiadas
GO

/*EJERCICIO 02. Crear esquemas ventas, bancos, rrhh*/
CREATE SCHEMA ventas
GO
CREATE SCHEMA bancos
GO
CREATE SCHEMA rrhh
GO

/*EJERCICIO 03.Listar los esquemas*/
SELECT * 
FROM SYS.SCHEMAS
GO

/*EJERCICIO 04. Crear el esquema planeamiento, evitar error si existe*/
IF NOT EXISTS(SELECT * FROM SYS.SCHEMAS WHERE name = 'planeamiento')
	BEGIN
		EXECUTE('CREATE SCHEMA planeamiento')
	END
GO

/*
MODIFICAR UN ESQUEMA
El modificar un esquema permite transferir 
asegurables de un esquema a otro.

ALTER SCHEMA EsquemaDestino TRANSFER EsquemaOrigen.Asegurable

El asegurable del esquema EsquemaOrigen se transfiere al EsquemaDestino

Los ejercicios respecto de este tema se incluyen 
en la creación de tablas, vistas y procedimientos almacenados.


ELIMINAR UN ESQUEMA
Para eliminar un esquema se utiliza la instrucción

DROP SCHEMA NombreEsquema

Para eliminar el esquema debe estar vacío, es decir, sin asegurables.

Importante: Planificar los asegurables en esquemas debe ser al 
inicio de la creación de la BD, los cambios de esquemas de los 
asegurables no actualizan en los scripts en los que se 
hacen referencia a estos objetos.

Por ejemplo, si en un script se hace un listado de la tabla 
empleados que se encuentra en el esquema rrhh debemos escribir:

SELECT * FROM rrhh.empleados
GO

Si se cambia a otro esquema la tabla empleados y no se 
actualiza el script, este dejará de funcionar correctamente.
*/

/*EJERCICIO 05. Crear tabla tiendas en el esquema pruebas*/
CREATE SCHEMA pruebas
GO
CREATE TABLE pruebas.tiendas(
	id INT IDENTITY(1,1) PRIMARY KEY,
	descripcion VARCHAR(200) NOT NULL,
	estado CHAR(1) CONSTRAINT default_estado DEFAULT 'A'
)
GO
/*
Note que luego de crear el esquema pruebas hay un GO
que finaliza el bloque de instrucción. A continuación 
viene otro bloque que es para crear la tabla tiendas.
Esta tabla, para ser creada en el esquema pruebas deberá
primero escribir el nombre del esquema y luego el nombre
de la tabla separadas por un punto
*/

/*EJERCICIO 06. Crear la tabla bodegas en el esquema sucursal*/
CREATE SCHEMA sucursal
CREATE TABLE bodegas(
	id INT IDENTITY(1,1) CONSTRAINT pk_id PRIMARY KEY,
	descripcion VARCHAR(200) NOT NULL
)
GO

/*
Note que después de la instrucción de crear esquema no existe
la instrucción GO y al crear la tabla bodegas, lo normal
sería que se cree en el esquema dbo, pero en este caso se
creará en el esquema sucursal
*/