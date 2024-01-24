/*-- DYNAMIC DATA MASKING (DDM) EN SQL SERVER --*/
/*
SQL Server desde la versión 2016 incluye una nueva característica de enmascaramiento 
de datos dinámico que permite dar cierto grado de seguridad para poder cambiar los 
caracteres que se visualizan por caracteres diferentes.

El enmascaramiento dinámico de datos ayuda a evitar el acceso no autorizado a datos 
confidenciales al permitir que los clientes designen qué cantidad de datos confidenciales 
se revelarán con un impacto mínimo en la capa de aplicación.

El DDM se puede configurar en la base de datos para ocultar datos confidenciales en los 
conjuntos de resultados de consultas en los campos de la base de datos designados, 
mientras que los datos en la base de datos no se modifican. 

El enmascaramiento dinámico de datos es fácil de usar con las aplicaciones existentes, 
ya que las reglas de enmascaramiento se aplican en los resultados de la consulta.

TIPOS DE ENMASCARAMIENTO DINÁMICO
DDM presenta cuatro tipos de enmascaramiento dinámico de datos, lo que se manejan
de acuerdo a funciones:
- Default
- Email
- Random
- Cadena personalizada

ENMASCARAMIENTO DEFAULT
Enmascaramiento completo según los tipos de datos de los campos designados.

>Para los tipos de datos de cadena, usa XXXX o menos X si el tamaño del campo es inferior 
 a 4 caracteres (char, nchar, varchar, nvarchar, text, ntext).

>Para los tipos de datos numéricos usa un valor cero
 (bigint, bit, decimal, int, money, numeric, smallint, smallmoney, tinyint, float, real).

>Para los tipos de datos de fecha y hora, usa 01.01.1900 00: 00: 00.0000000
 (Date, datetime2, datetime, datetimeoffset, smalldatetime, time).

>Para los tipos de datos binarios, usa un solo byte de valor ASCII 0 
 (binario, varbinary, imagen).

Ejemplo

Al definir la columna:
Telefono nvarchar(12) MASKED WITH (FUNCTION = ‘default ()’) NULL
Modificar una columna
ALTER COLUMN Sexo ADD MASKED WITH (FUNCTION = ‘default ()’)

ENMASCARAMIENTO EMAIL
Método de enmascaramiento que expone la primera letra de una dirección de correo 
electrónico y el sufijo constante «.com», en forma de una dirección de correo 
electrónico. . aXXX@XXXX.com.

Ejemplo

Al definir la columna
CorreoElectronico nvarchar(100) MASKED WITH (FUNCTION = 'email ()') NULL
Modificar la columna
ALTER COLUMN CorreoElectronico ADD MASKED WITH (FUNCTION = 'email ()')

ENMASCARAMIENTO RANDOM
Una función de enmascaramiento aleatorio para usar en cualquier tipo numérico 
para enmascarar el valor original con un valor aleatorio dentro de un 
rango específico.

Ejemplos

Al definir la columna
NumeroCuenta bigint MASKED WITH (FUNCTION = ‘random ([rango inicial], [rango final])’)
Modificando la columna
ALTER COLUMN Mes ADD MASKED WITH (FUNCTION = ‘random (1, 12)’)

ENMASCARAMIENTO CADENA PERSONALIZADA
Método de enmascaramiento que expone la primera y la última letra y agrega una 
cadena de relleno personalizada en el medio. 
	prefijo, [relleno], sufijo. 
Si el valor original es demasiado corto para completar toda la máscara, 
parte del prefijo o sufijo no se expondrá.

Ejemplos

Al definir la columna
EmpleadoNombre nvarchar(100) MASKED WITH (FUNCTION = 'parcial (2, «XXXXXX», 1)') NULL
Modificando la columna
ALTER COLUMN Fono Add Masked with (FUNCTION = 'parcial (1, «XXXXXXX», 0)')
ALTER COLUMN Telefono Add Masked with (FUNCTION= 'parcial (5, «XXXXXXX», 0)')
ALTER COLUMN NumeroSeguro Add Masked with (FUNCTION = 'parcial (0, «XXX-XX -«, 4)')

NOTA: Para dejar en claro el significado de, por ejemplo: 
'parcial (2, «XXXXXX», 1)'), significa que se mostrarán los dos primero caracteres
y el último caracter de la columna que está siendo enmascarada

PERMISOS PARA USAR EL DDM
Para poder realizar el DDM se deben tener los siguientes permisos:
- CREATE TABLE y ALTER Table
- Alter any mask, Alter table para agregar, reemplazar o eliminar la 
  máscara de una columna.
- Select para ver los datos
- Las columnas que se definen como enmascaradas, mostrarán los datos enmascarados.
- Conceda el permiso UNMASK a un usuario para que pueda recuperar los datos 
  enmascarados de las columnas para las que se define el enmascaramiento.
- CONTROL en la base de datos incluye el permiso ALTER ANY MASK como UNMASK.

NOTA: 
Para un administrador de sistemas o db_owner, no hay enmascaramiento
aplicado en absoluto, pero para un usuario con los privilegios más básicos al
momento de efectuar la consulta a la tabla los datos se enmascararán, a menos
que conceda el permiso de UNMASK al usuario.
*/

/*EJERCICIO 01. Crear la base de datos bd_ddm*/
CREATE DATABASE bd_ddm
GO

USE bd_ddm
GO

/*EJERCICIO 02. Crear la tabla empleados, se usarán algunas formas de enmascaramiento*/
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
VALUES('FG0059', 'Díaz', 'Flores', 'Martín', 'magadiflo@gmail.com', 'Las Casuarinas Mz. H2-33')
GO

--Ver los datos
SELECT * FROM empleados
GO

/*EJERCICIO 04. Crear un usuario sólo con permiso para ver los datos*/
CREATE USER tinkler WITHOUT LOGIN
GO

--Asignar el permiso
GRANT SELECT ON OBJECT::dbo.empleados TO tinkler
GO

--Ejecutar el select como tinkler
EXECUTE('SELECT * FROM empleados') AS USER = 'tinkler'
GO

/*EJERCICIO 05. Agregar una máscara al campo dirección*/
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