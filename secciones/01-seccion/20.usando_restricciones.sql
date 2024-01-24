/*-- USANDO RESTRICCIONES (CONSTRAINT) EN SQL SERVER --*/
/*
PRIMARY KEY
Hace referencia al campo o campos que forman la clave primaria de la tabla, 
al especificar la clave primaria de una tabla se crea autom�ticamente el 
�ndice agrupado (Ver �ndices). Se recomienda que todas las tablas de la base 
de datos tengan clave primaria. S�lo una clave primaria se puede crear en una 
tabla, esta restricci�n sirve para forzar la integridad de datos.

FOREIGN KEY
Clave for�nea, esta restricci�n permite especificar la integridad de datos entre 
las tablas de la base de datos, la clave for�nea hace referencia al campo que es 
la clave primaria en una tabla y la relaciona con un campo del mismo tipo de dato 
y de preferencia con el mismo nombre donde se especifica la clave for�nea.

Tambi�n se puede especificar una acci�n al eliminar o actualizar el registro que es 
la clave for�nea, no se recomienda el uso de esta opci�n. Estas opciones son 
actualizaci�n o eliminaci�n en cascada.

CHECK
La restricci�n de tipo Check permite especificar una o mas condiciones que debe de 
cumplir los datos para ser permitidos en el campo. Se puede definir con esta restricci�n 
los valores permitidos en un campo, por ejemplo, definir un campo Sexo donde los 
valores posibles son: M para masculino y F para femenino, el campo deber�a ser un 
campo nchar(1). Si se intenta ingresar un valor diferente al especificado (M, F), como
por ejemplo X, Y, etc, o cualquier otro valor que no coincida con el especificado
la restricci�n de tipo check no lo permitir� en ese campo.

UNIQUE
La restricci�n de tipo unique permite restringir los datos de una columna que no es 
la clave primaria (Primary key) a valores que no se repitan. Por ejemplo, una tabla 
con Productos, cuya clave primaria es Codigo, no deber�a permitir productos con 
Descripci�n iguales, para conseguir esto, el campo Descripci�n deber�a tener una
restricci�n de tipo Unique.

Otro ejemplo ser�a, si se tiene un campo email para una tabla usuarios, este campo
email deber�a tener la restricci�n de unique ya que un email pertenece �nicamente
a una persona y no pueden haber el mismo email asociados a distintas personas.

DEFAULT
Permite especificar un valor por defecto cuando el usuario no ingresa ning�n dato en 
el campo, al ingresar los datos en una campo, estos pueden ser especificados como 
obligatorios (Not Null en la definici�n del campo), el campo o los campos de la 
clave primaria y la clave for�nea son por su naturaleza obligatorios, los datos de 
los otros campos pueden especificarse como obligatorios incluyendo en la definici�n 
del campo �Not null�, los campos que no son obligatorios se recomiendan especificar 
una restricci�n de tipo Default que permite ingresar un dato por defecto, cuando el 
usuario no inserta ning�n valor. Se recomienda evitar los valores �Null� en las tablas. 
Por ejemplo, si no se tiene el precio de un producto insertado, se puede especificar 
como CERO, (obviamente el valor 0) y no dejar que se incluya Null en el campo.
*/
USE master
GO

DROP DATABASE IF EXISTS bd_restricciones
GO

CREATE DATABASE bd_restricciones
GO

USE bd_restricciones
GO

CREATE TABLE categorias(
	codigo CHAR(4),
	descripcion VARCHAR(50) NOT NULL,
	estado CHAR(1) CONSTRAINT df_estado DEFAULT 'A',
	CONSTRAINT pk_categorias PRIMARY KEY(codigo),
	CONSTRAINT uq_descripcion_c UNIQUE(descripcion),
	CONSTRAINT ck_estado_c CHECK(estado = 'A' OR estado = 'E') --A: ACTIVA, E: ELIMINA
)
GO

--Para ver la estructura de la tabla
SP_HELP categorias
GO

CREATE TABLE productos(
	codigo CHAR(10),
	categoria_codigo CHAR(4),
	descripcion VARCHAR(100) NOT NULL,
	precio NUMERIC(9,2) CONSTRAINT df_precio DEFAULT 0,
	stock NUMERIC(9,2) CONSTRAINT df_stock DEFAULT 0,
	fecha_registro DATE CONSTRAINT df_fecha_registro DEFAULT GETDATE(),
	estado CHAR(1),
	CONSTRAINT pk_productos PRIMARY KEY(codigo),
	CONSTRAINT fk_categorias_productos FOREIGN KEY(categoria_codigo) REFERENCES categorias(codigo),
	CONSTRAINT uq_descripcion_p UNIQUE(descripcion),
	CONSTRAINT ck_estado_p CHECK(estado = 'A' OR estado = 'E'),
	CONSTRAINT ck_precio CHECK(precio >= 0),
	CONSTRAINT ck_stock CHECK(stock >= 0)
)
GO

--Vemos la estructura de la tabla
SP_HELP productos
GO

/*AGREGAR RESTRICCIONES EN UNA TABLA YA CREADA EN SQL SERVER*/
CREATE TABLE clientes(
	codigo CHAR(15),
	razon_social VARCHAR(100),
	direccion VARCHAR(200),
	estado CHAR(1),
	fecha_registro DATE
)
GO

SP_HELP clientes
GO

--Agregando clave primaria
ALTER TABLE clientes
ALTER COLUMN codigo CHAR(15) NOT NULL
GO

ALTER TABLE clientes
ADD CONSTRAINT pk_clientes PRIMARY KEY(codigo)
GO

--Restricci�n unique para la raz�n social
ALTER TABLE clientes
ADD CONSTRAINT uq_razon_social UNIQUE(razon_social)
GO

--Restricci�n default para el estado con valor A
ALTER TABLE clientes
ADD CONSTRAINT df_estado_cli DEFAULT 'A' FOR estado
GO

--Restricci�n check para el estado permitiendo valores A y E
ALTER TABLE clientes
ADD CONSTRAINT ck_estado_cli CHECK(estado = 'A' OR estado = 'E')
GO

--Restricci�n default para la fecha de registro
ALTER TABLE clientes
ADD CONSTRAINT df_fecha_registro_cli DEFAULT GETDATE() FOR fecha_registro
GO

--Restricci�n check para la fecha de registro que no permita valores despu�s de la fecha actual
ALTER TABLE clientes
ADD CONSTRAINT ck_fecha_registro_cli CHECK(fecha_registro <= GETDATE())
GO

SP_HELP clientes
GO

CREATE TABLE facturas(
	serie CHAR(5),
	numero CHAR(7),
	cliente_codigo CHAR(15),
	fecha DATETIME,
	monto_sin_igv NUMERIC(9,2),
	porcentaje_igv NUMERIC(8,5),
	monto_igv AS (monto_sin_igv * porcentaje_igv),
	monto_total AS (monto_sin_igv + monto_sin_igv * porcentaje_igv),
	CONSTRAINT pk_facturas PRIMARY KEY(serie, numero)
)
GO

--Agregando restricciones de tipo foreign key para relacionar la tabla de facturas con clientes
ALTER TABLE facturas
ADD CONSTRAINT fk_clientes_facturas FOREIGN KEY(cliente_codigo) REFERENCES clientes(codigo)
GO

/*C�MO AGREGAR RESTRICCIONES CHECK EN SQL SERVER*/
/*
Agregar restricciones de tipo Check cuando existen datos que no cumplen con las 
condiciones, para este ejemplo se va a crear una tabla para empleados, 
se va a incluir un campo sueldo y se insertar�n valores, dos de los cuales 
son menores a 2500. Luego se agregar� la restricci�n de tipo Check que compruebe 
que los sueldos debe ser mayores o iguales a 2500, como existen algunos que no 
cumplen se debe usar la cl�usula WITH NOCHECK
*/
CREATE TABLE empleados(
	codigo CHAR(5),
	paterno VARCHAR(50),
	materno VARCHAR(50),
	nombres VARCHAR(50),
	fecha_nacimiento DATE,
	sueldo NUMERIC(9,2),
	CONSTRAINT pk_empleados PRIMARY KEY(codigo)
)
GO

--Agregando registros, note que algunos de los ingresos tienen un sueldo menor a 2500
INSERT INTO empleados(codigo, paterno, materno, nombres, fecha_nacimiento, sueldo)
VALUES('AR996', 'CHAVEZ', 'P�REZ', 'CARLOS', '2000-09-15', 1800),
('TR467', 'TERRANOVA', 'WONG', 'JOS�', '1996-02-24', 3800),
('BN789', 'MARTINEZ', 'ALVA', 'CECILIA', '1983-10-20', 3580),
('VT678', 'S�NCHEZ', 'LLANOS', 'ARACELY', '2000-09-15', 2980),
('BH789', 'NICOLINI', 'MENDOZA', 'AMALIA', '1970-07-23', 1500)
GO

--Restricci�n de tipo check para que el sueldo sea mayor o igual que 2500
ALTER TABLE empleados
ADD CONSTRAINT ck_sueldo CHECK(sueldo >= 2500)
GO

/*Si ejecutamos esta �ltima sentencia de ALTER nos mostrar� un error
ya que estamos tratando de agregar un check que dice que el sueldo
debe ser mayor o igual a 2500, pero recordemos que ya hay datos en la tabla
clientes con sueldos menores a 2500, por eso es el error. 
�C�mo solucionarlo?, pues utilizando la cl�usula WITH NOCHECK
*/

ALTER TABLE empleados WITH NOCHECK
ADD CONSTRAINT ck_sueldo CHECK(sueldo >= 2500)
GO

--Para ver los valores de los sueldos que no cumplen
DBCC CHECKCONSTRAINTS(empleados)
GO

/*
Esta �ltima sentencia nos mostrar� los valores que no cumplen,
puede notar que son los valores de 1500 y 1800
*/

/*VISUALIZAR LAS RESTRICCIONES DE LA BASE DE DATOS*/

--Ver las restricciones de tipo check
SELECT * 
FROM SYS.CHECK_CONSTRAINTS
GO

--Ver las restricciones de tipo foreign key
SELECT * 
FROM SYS.FOREIGN_KEYS
GO

--Ver las restricciones de tipo unique
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'UNIQUE'
GO

--Ver las restricciones de tipo primary key
SELECT * 
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
GO

--Ver las restricciones de tipo default
SELECT * 
FROM SYS.DEFAULT_CONSTRAINTS
GO

/*C�MO ACTIVAR Y DESACTIVAR LAS RESTRICCIONES EN SQL SERVER*/
/*
Activar y desactivar contraints Check y Foreign key
Se pueden activar o desactivar las restricciones de tipo Check y Foreign Key 
para esto debemos usar la cla�sula Nocheck para desactivar y Check para activar 
en la instrucci�n Alter Table.
*/

--Desactivar check para los sueldos
ALTER TABLE empleados NOCHECK CONSTRAINT ck_sueldo
GO

--Probar ingresando un registro que no cumpla con ser sueldo mayor o igual a 2500
INSERT INTO empleados(codigo, paterno, materno, nombres, fecha_nacimiento, sueldo)
VALUES('BY555', 'PALOMINO', 'ANGELES', 'SUSANA', '1977-07-31', 1780)
GO
--S� se pudo insertar

--Activar la restricci�n
ALTER TABLE empleados CHECK CONSTRAINT ck_sueldo
GO

SELECT * 
FROM empleados
GO

/*ELIMINAR LAS RESTRICCIONES*/
/*
Para eliminar las restricciones se utiliza la cl�sula DROP CONSTRAINT de la 
instrucci�n ALTER TABLE.
*/

ALTER TABLE clientes
DROP CONSTRAINT df_fecha_registro_cli
GO