/*-- TIPOS DE DATOS DEFINIDOS POR EL USUARIO CON FORMATO DE TABLA --*/
/*EJERCICIO 01. Para el ejemplo se creará una base de datos 
con  una tabla de personas*/
USE master
GO

CREATE DATABASE bd_tipos
GO

USE bd_tipos
GO

CREATE TABLE personas(
	codigo CHAR(8) NOT NULL,
	paterno VARCHAR(100) NOT NULL,
	materno VARCHAR(100) NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	fecha_nacimiento DATE,
	CONSTRAINT pk_personas PRIMARY KEY(codigo)
)
GO

/*EJERCICIO 02. Crear el tipo de dato definido por el usuario
con la misma estructura de tabla*/
CREATE TYPE udt_personas_tipo_tabla AS TABLE(
	codigo CHAR(8) NOT NULL,
	paterno VARCHAR(100) NOT NULL,
	materno VARCHAR(100) NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	fecha_nacimiento DATE
)
GO

/*EJERCICIO 03. Visualiza los datos definidos por el usuario*/
SELECT * FROM SYS.TYPES WHERE is_user_defined = 1
GO

-- USO DEL TIPO DE DATOS DEFINIDO POR EL USUARIO TIPO TABLA

/*EJERCICIO 03. Insertar varios registros en el tipo de dato*/
DECLARE @nuevasPersonas AS udt_personas_tipo_tabla
INSERT @nuevasPersonas 
VALUES ('TFR97089', 'Campos', 'Pérez', 'Carlos', '1983-11-21'),
('TRG97098','Terranova','Chavez','Lizeth','1980-06-12'),
('FTG88699','Sandoval','Villacorta','Elena','1996-08-16'),
('DEF48885','Silva','Alvarado','Fernando','1990-09-12'),
('WSE59970','Sánchez','Vargas','Víctor','1966-11-21')
INSERT INTO personas
SELECT * FROM @nuevasPersonas
GO
-- Visualizar el resultado en la tabla personas
SELECT * FROM personas
GO

/*USO DEL UDT DE TIPO TABLA EN UN PROCEDIMIENTO ALMACENADO*/
/*Crear un procedimiento almacenado que inserte datos a la tabla 
personas usando el tipo de dato creado llamado udt_personas_tipo_tabla

En el procedimietno almacenado se usará en tipo de dato con formato
de tabla, este debe crearse de tipo SOLO LECTURA
*/
CREATE PROCEDURE sp_insertar_multiples_personas
(@nuevasPersonas AS udt_personas_tipo_tabla READONLY)
AS
	BEGIN
		SET NOCOUNT ON --No mostraré el mensaje de "'tantas' filas afectadas"
		INSERT INTO personas(codigo, paterno, materno, nombre, fecha_nacimiento)
		SELECT * FROM @nuevasPersonas
	END
GO

/*Ejecutar el SP, pero para eso debemos declarar una variable 
con el tipo de dato definido por el usuario con formado de tabla
e insertar datos, luego enviar esa variable en la ejecución del SP
*/
DECLARE @nuevosRegistros AS udt_personas_tipo_tabla
INSERT INTO @nuevosRegistros
VALUES('NHP47585', 'Espinoza', 'García', 'Leonardo', '1975-08-17'),
('NDE09803', 'Plasencia', 'Llanos', 'César', '1997-12-15'),
('SCD48859', 'Carranza', 'Pérez', 'María Fernanda', '1985-10-01')
EXECUTE sp_insertar_multiples_personas @nuevosRegistros
GO

SELECT * FROM personas
GO