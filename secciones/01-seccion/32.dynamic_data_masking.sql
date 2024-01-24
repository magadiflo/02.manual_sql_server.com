/*-- DYNAMIC DATA MASKING (DDM) EN SQL SERVER --*/
/*
SQL Server desde la versi�n 2016 incluye una nueva caracter�stica de enmascaramiento 
de datos din�mico que permite dar cierto grado de seguridad para poder cambiar los 
caracteres que se visualizan por caracteres diferentes.

El enmascaramiento din�mico de datos ayuda a evitar el acceso no autorizado a datos 
confidenciales al permitir que los clientes designen qu� cantidad de datos confidenciales 
se revelar�n con un impacto m�nimo en la capa de aplicaci�n.

El DDM se puede configurar en la base de datos para ocultar datos confidenciales en los 
conjuntos de resultados de consultas en los campos de la base de datos designados, 
mientras que los datos en la base de datos no se modifican. 

El enmascaramiento din�mico de datos es f�cil de usar con las aplicaciones existentes, 
ya que las reglas de enmascaramiento se aplican en los resultados de la consulta.

TIPOS DE ENMASCARAMIENTO DIN�MICO
DDM presenta cuatro tipos de enmascaramiento din�mico de datos, lo que se manejan
de acuerdo a funciones:
- Default
- Email
- Random
- Cadena personalizada

ENMASCARAMIENTO DEFAULT
Enmascaramiento completo seg�n los tipos de datos de los campos designados.

>Para los tipos de datos de cadena, usa XXXX o menos X si el tama�o del campo es inferior 
 a 4 caracteres (char, nchar, varchar, nvarchar, text, ntext).

>Para los tipos de datos num�ricos usa un valor cero
 (bigint, bit, decimal, int, money, numeric, smallint, smallmoney, tinyint, float, real).

>Para los tipos de datos de fecha y hora, usa 01.01.1900 00: 00: 00.0000000
 (Date, datetime2, datetime, datetimeoffset, smalldatetime, time).

>Para los tipos de datos binarios, usa un solo byte de valor ASCII 0 
 (binario, varbinary, imagen).

Ejemplo

Al definir la columna:
Telefono nvarchar(12) MASKED WITH (FUNCTION = �default ()�) NULL
Modificar una columna
ALTER COLUMN Sexo ADD MASKED WITH (FUNCTION = �default ()�)

ENMASCARAMIENTO EMAIL
M�todo de enmascaramiento que expone la primera letra de una direcci�n de correo 
electr�nico y el sufijo constante �.com�, en forma de una direcci�n de correo 
electr�nico. . aXXX@XXXX.com.

Ejemplo

Al definir la columna
CorreoElectronico nvarchar(100) MASKED WITH (FUNCTION = 'email ()') NULL
Modificar la columna
ALTER COLUMN CorreoElectronico ADD MASKED WITH (FUNCTION = 'email ()')

ENMASCARAMIENTO RANDOM
Una funci�n de enmascaramiento aleatorio para usar en cualquier tipo num�rico 
para enmascarar el valor original con un valor aleatorio dentro de un 
rango espec�fico.

Ejemplos

Al definir la columna
NumeroCuenta bigint MASKED WITH (FUNCTION = �random ([rango inicial], [rango final])�)
Modificando la columna
ALTER COLUMN Mes ADD MASKED WITH (FUNCTION = �random (1, 12)�)

ENMASCARAMIENTO CADENA PERSONALIZADA
M�todo de enmascaramiento que expone la primera y la �ltima letra y agrega una 
cadena de relleno personalizada en el medio. 
	prefijo, [relleno], sufijo. 
Si el valor original es demasiado corto para completar toda la m�scara, 
parte del prefijo o sufijo no se expondr�.

Ejemplos

Al definir la columna
EmpleadoNombre nvarchar(100) MASKED WITH (FUNCTION = 'parcial (2, �XXXXXX�, 1)') NULL
Modificando la columna
ALTER COLUMN Fono Add Masked with (FUNCTION = 'parcial (1, �XXXXXXX�, 0)')
ALTER COLUMN Telefono Add Masked with (FUNCTION= 'parcial (5, �XXXXXXX�, 0)')
ALTER COLUMN NumeroSeguro Add Masked with (FUNCTION = 'parcial (0, �XXX-XX -�, 4)')

NOTA: Para dejar en claro el significado de, por ejemplo: 
'parcial (2, �XXXXXX�, 1)'), significa que se mostrar�n los dos primero caracteres
y el �ltimo caracter de la columna que est� siendo enmascarada

PERMISOS PARA USAR EL DDM
Para poder realizar el DDM se deben tener los siguientes permisos:
- CREATE TABLE y ALTER Table
- Alter any mask, Alter table para agregar, reemplazar o eliminar la 
  m�scara de una columna.
- Select para ver los datos
- Las columnas que se definen como enmascaradas, mostrar�n los datos enmascarados.
- Conceda el permiso UNMASK a un usuario para que pueda recuperar los datos 
  enmascarados de las columnas para las que se define el enmascaramiento.
- CONTROL en la base de datos incluye el permiso ALTER ANY MASK como UNMASK.

NOTA: 
Para un administrador de sistemas o db_owner, no hay enmascaramiento
aplicado en absoluto, pero para un usuario con los privilegios m�s b�sicos al
momento de efectuar la consulta a la tabla los datos se enmascarar�n, a menos
que conceda el permiso de UNMASK al usuario.
*/

/*EJERCICIO 01. Crear la base de datos bd_ddm*/
CREATE DATABASE bd_ddm
GO

USE bd_ddm
GO

/*EJERCICIO 02. Crear la tabla empleados, se usar�n algunas formas de enmascaramiento*/
CREATE TABLE empleados(
	codigo CHAR(6),
	paterno VARCHAR(100) MASKED WITH(FUNCTION = 'partial(1,"XXXXX", 4)') NOT NULL,
	materno VARCHAR(100) MASKED WITH(FUNCTION = 'partial(4,"XXXXX",2)') NOT NULL,
	nombres VARCHAR(100) NOT NULL,
	email VARCHAR(70) MASKED WITH(FUNCTION = 'email()'),
	direccion VARCHAR(200) CONSTRAINT df_direccion_empl DEFAULT 'Sin especificar',
	CONSTRAINT pk_empleados PRIMARY KEY(codigo)
)
GO

/*EJERCICIO 03. Insertar registros*/
INSERT INTO empleados
VALUES('FG0059', 'D�az', 'Flores', 'Mart�n', 'magadiflo@gmail.com', 'Las Casuarinas Mz. H2-33')
GO

--Ver los datos
SELECT * FROM empleados
GO

/*EJERCICIO 04. Crear un usuario s�lo con permiso para ver los datos*/
CREATE USER tinkler WITHOUT LOGIN
GO

--Asignar el permiso
GRANT SELECT ON OBJECT::dbo.empleados TO tinkler
GO

--Ejecutar el select como tinkler
EXECUTE('SELECT * FROM empleados') AS USER = 'tinkler'
GO

/*EJERCICIO 05. Agregar una m�scara al campo direcci�n*/
ALTER TABLE empleados
ALTER COLUMN direccion ADD MASKED WITH(FUNCTION = 'partial(1,"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",3)')
GO

--Ejecutar el select como tinkler
EXECUTE('SELECT * FROM empleados') AS USER = 'tinkler'
GO

/*EJERCICIO 06. Agregar un campo sueldo con DDM con tipo RANDOM*/
ALTER TABLE empleados
ADD sueldo NUMERIC(9,2) MASKED WITH(FUNCTION = 'random(1000, 4000)')
GO

--Actualiar el sueldo del empleado FG0059 a 2500
UPDATE empleados
SET sueldo = 2500
WHERE codigo = 'FG0059'
GO

--Ver los datos
SELECT * FROM empleados
GO

-- Ejecutar el select como tinkler
EXECUTE('SELECT * FROM empleados') AS USER = 'tinkler'
GO