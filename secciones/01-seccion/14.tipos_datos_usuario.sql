/*-- TIPOS DE DATOS DEFINIDOS POR EL USUARIO UDT --*/
/*
SQL Server permite crear tipos de datos que el usuario 
puede definir en base a los tipos de datos nativos o 
propios de SQL Server.

La creación de tipos de datos definidos por el usuario va a 
permitir el uso de los datos nativos de SQL Server de manera 
mas fácil, por ejemplo, para datos de tipo caracter que 
tengan una longitud variable entre 2 a 80 caracteres, se 
pueden definir un tipo de datos con una longitud de 100 para 
que alcance cualquier texto que pase los 80 caracteres y ponerle 
un nombre de fácil recuerdo como Texto100.

Los tipos de datos creados podrán ser utilizados en la 
base de datos que se crean.

INSTRUCCIÓN CREATE TYPE
CREATE TYPE NombreTipoDato FROM TipoDatoSQLServer

ELIMINAR 
DROP TYPE nombreTipoDato
*/

/*EJERCICIO 01. Crear los tipos de datos para nchar de 10 de ancho,
nvarchar de 100 de ancho y otro para precio*/
CREATE TYPE codigo10 FROM NCHAR(10) NOT NULL
CREATE TYPE textoObligatorio100 FROM NVARCHAR(100) NOT NULL
CREATE TYPE texto100 FROM NVARCHAR(100)
CREATE TYPE precio FROM NUMERIC(9,2)
GO

/*EJERCICIO 02. Listar los datos definidos por el usuario*/
SELECT * FROM SYS.TYPES WHERE is_user_defined = 1
GO

/*EJERCICIO 03. Ver si existe el tipo de dato FechaObligatoria*/
SELECT * FROM SYS.TYPES WHERE name = 'FechaObligatoria'
GO

/*EJERCICIO 04. Crear un script para el tipo de dato
FechaObligatoria sin que se reporte error si existe*/
IF NOT EXISTS(SELECT * FROM SYS.TYPES WHERE name = 'FechaObligatoria')
	BEGIN
		CREATE TYPE FechaObligatoria FROM DATE NOT NULL
	END
GO

/*----- USO DE LOS TIPOS DE DATOS DEFINIDOS POR EL USUARIO -----*/

/*EJERCICIO 05. Crear tabla agencias*/
CREATE TABLE agencias(
	codigo codigo10,
	descripcion textoObligatorio100,
	responsable NVARCHAR(150),
	direccion texto100 CONSTRAINT default_direccion DEFAULT ''
)
GO

/*EJERCICIO 06. Eliminar el tipo de datos codigo10*/
DROP TYPE codigo10
GO

/*
Para poder eliminar es necesario que la tabla Agencias 
no use el tipo Codigo10, es decir, cambiar el tipo de dato de la tabla.
*/
ALTER TABLE agencias
ALTER COLUMN codigo NCHAR(10)
GO

DROP TYPE codigo10
GO