/*-- USANDO RESTRICCIONES (CONSTRAINT) EN SQL SERVER --*/
/*
PRIMARY KEY
Hace referencia al campo o campos que forman la clave primaria de la tabla, 
al especificar la clave primaria de una tabla se crea automáticamente el 
índice agrupado (Ver Índices). Se recomienda que todas las tablas de la base 
de datos tengan clave primaria. Sólo una clave primaria se puede crear en una 
tabla, esta restricción sirve para forzar la integridad de datos.

FOREIGN KEY
Clave foránea, esta restricción permite especificar la integridad de datos entre 
las tablas de la base de datos, la clave foránea hace referencia al campo que es 
la clave primaria en una tabla y la relaciona con un campo del mismo tipo de dato 
y de preferencia con el mismo nombre donde se especifica la clave foránea.

También se puede especificar una acción al eliminar o actualizar el registro que es 
la clave foránea, no se recomienda el uso de esta opción. Estas opciones son 
actualización o eliminación en cascada.

CHECK
La restricción de tipo Check permite especificar una o mas condiciones que debe de 
cumplir los datos para ser permitidos en el campo. Se puede definir con esta restricción 
los valores permitidos en un campo, por ejemplo, definir un campo Sexo donde los 
valores posibles son: M para masculino y F para femenino, el campo debería ser un 
campo nchar(1). Si se intenta ingresar un valor diferente al especificado (M, F), como
por ejemplo X, Y, etc, o cualquier otro valor que no coincida con el especificado
la restricción de tipo check no lo permitirá en ese campo.

UNIQUE
La restricción de tipo unique permite restringir los datos de una columna que no es 
la clave primaria (Primary key) a valores que no se repitan. Por ejemplo, una tabla 
con Productos, cuya clave primaria es Codigo, no debería permitir productos con 
Descripción iguales, para conseguir esto, el campo Descripción debería tener una
restricción de tipo Unique.

Otro ejemplo sería, si se tiene un campo email para una tabla usuarios, este campo
email debería tener la restricción de unique ya que un email pertenece únicamente
a una persona y no pueden haber el mismo email asociados a distintas personas.

DEFAULT
Permite especificar un valor por defecto cuando el usuario no ingresa ningún dato en 
el campo, al ingresar los datos en una campo, estos pueden ser especificados como 
obligatorios (Not Null en la definición del campo), el campo o los campos de la 
clave primaria y la clave foránea son por su naturaleza obligatorios, los datos de 
los otros campos pueden especificarse como obligatorios incluyendo en la definición 
del campo «Not null», los campos que no son obligatorios se recomiendan especificar 
una restricción de tipo Default que permite ingresar un dato por defecto, cuando el 
usuario no inserta ningún valor. Se recomienda evitar los valores «Null» en las tablas. 
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

--Restricción unique para la razón social
ALTER TABLE clientes
ADD CONSTRAINT uq_razon_social UNIQUE(razon_social)
GO

--Restricción default para el estado con valor A
ALTER TABLE clientes
ADD CONSTRAINT df_estado_cli DEFAULT 'A' FOR estado
GO

--Restricción check para el estado permitiendo valores A y E
ALTER TABLE clientes
ADD CONSTRAINT ck_estado_cli CHECK(estado = 'A' OR estado = 'E')
GO

--Restricción default para la fecha de registro
ALTER TABLE clientes
ADD CONSTRAINT df_fecha_registro_cli DEFAULT GETDATE() FOR fecha_registro
GO

--Restricción check para la fecha de registro que no permita valores después de la fecha actual
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

/*CÓMO AGREGAR RESTRICCIONES CHECK EN SQL SERVER*/
/*
Agregar restricciones de tipo Check cuando existen datos que no cumplen con las 
condiciones, para este ejemplo se va a crear una tabla para empleados, 
se va a incluir un campo sueldo y se insertarán valores, dos de los cuales 
son menores a 2500. Luego se agregará la restricción de tipo Check que compruebe 
que los sueldos debe ser mayores o iguales a 2500, como existen algunos que no 
cumplen se debe usar la cláusula WITH NOCHECK
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
VALUES('AR996', 'CHAVEZ', 'PÉREZ', 'CARLOS', '2000-09-15', 1800),
('TR467', 'TERRANOVA', 'WONG', 'JOSÉ', '1996-02-24', 3800),
('BN789', 'MARTINEZ', 'ALVA', 'CECILIA', '1983-10-20', 3580),
('VT678', 'SÁNCHEZ', 'LLANOS', 'ARACELY', '2000-09-15', 2980),
('BH789', 'NICOLINI', 'MENDOZA', 'AMALIA', '1970-07-23', 1500)
GO

--Restricción de tipo check para que el sueldo sea mayor o igual que 2500
ALTER TABLE empleados
ADD CONSTRAINT ck_sueldo CHECK(sueldo >= 2500)
GO

/*Si ejecutamos esta última sentencia de ALTER nos mostrará un error
ya que estamos tratando de agregar un check que dice que el sueldo
debe ser mayor o igual a 2500, pero recordemos que ya hay datos en la tabla
clientes con sueldos menores a 2500, por eso es el error. 
¿Cómo solucionarlo?, pues utilizando la cláusula WITH NOCHECK
*/

ALTER TABLE empleados WITH NOCHECK
ADD CONSTRAINT ck_sueldo CHECK(sueldo >= 2500)
GO

--Para ver los valores de los sueldos que no cumplen
DBCC CHECKCONSTRAINTS(empleados)
GO

/*
Esta última sentencia nos mostrará los valores que no cumplen,
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

/*CÓMO ACTIVAR Y DESACTIVAR LAS RESTRICCIONES EN SQL SERVER*/
/*
Activar y desactivar contraints Check y Foreign key
Se pueden activar o desactivar las restricciones de tipo Check y Foreign Key 
para esto debemos usar la claúsula Nocheck para desactivar y Check para activar 
en la instrucción Alter Table.
*/

--Desactivar check para los sueldos
ALTER TABLE empleados NOCHECK CONSTRAINT ck_sueldo
GO

--Probar ingresando un registro que no cumpla con ser sueldo mayor o igual a 2500
INSERT INTO empleados(codigo, paterno, materno, nombres, fecha_nacimiento, sueldo)
VALUES('BY555', 'PALOMINO', 'ANGELES', 'SUSANA', '1977-07-31', 1780)
GO
--Sí se pudo insertar

--Activar la restricción
ALTER TABLE empleados CHECK CONSTRAINT ck_sueldo
GO

SELECT * 
FROM empleados
GO

/*ELIMINAR LAS RESTRICCIONES*/
/*
Para eliminar las restricciones se utiliza la clásula DROP CONSTRAINT de la 
instrucción ALTER TABLE.
*/

ALTER TABLE clientes
DROP CONSTRAINT df_fecha_registro_cli
GO