/*-- ALTER TABLE SQL SERVER | MODIFICACIÓN DE TABLAS --*/

/*
Las tablas en la base de datos se deben modificar en algunas ocasiones, 
es posible agregar o quitar campos, restricciones y cambiar de nombre los campos.

INSTRUCCIÓN ALTER TABLE
Para modificar una tabla vamos a presentar las opciones de acuerdo a las 
necesidades de cambios

- CAMBIAR NOMBRE DE CAMPOS
EXECUTE SP_RENAME nombre_campo_original, nuevo_nombre, tipo_objeto

- CAMBIAR TIPO DE DATO DE UN CAMPO
Tenga en cuenta si es posible cambiar el tipo de dato. Puede que se pierdan
los datos o no se pueda ejecutar la orden cuando los tipos de datos no son
compatible
	ALTER TABLE nombre_table
	ALTER COLUMN nueva_defincion_campo

- AGREGAR CAMPOS A LA TABLA
ALTER TABLE nombre_tabla
ADD campo1, campo2, campo3,...

- AGREGAR RESTRICCIONES: PK, FK, CHECK, DEFAULT O UNIQUE
ALTER TABLE nombre_tabla
ADD CONSTRAINT nombre_constraint...

- ELIMINAR CAMPO DE LA TABLA
ALTER TABLE nombre_tabla
DROP COLUMN ...

- ELIMINAR RESTRICCIÓN
ALTER TABLE nombre_tabla
DROP CONSTRAINT nombre_constraint

- ACTIVAR O DESACTIVAR UNA RESTRICCIÓN, ESTA OPCIÓN SOLAMENTE ES VÁLIDA
PARA LAS RESTRICCIONES DE TIPO CHECK Y FK

ALTER TABLE nombre_tabla
CHECK CONSTRAINT nombre_constraint

ALTER TABLE nombre_tabla
NOCHECK CONSTRAINT nombre_constraint
*/

USE bd_erp
GO

/*EJERCICIO 01. Crea una tabla*/
CREATE TABLE empleados(
	codigo CHAR(3),
	paterno VARCHAR(20),
	materno VARCHAR(20),
	nombre VARCHAR(20),
	direccion VARCHAR(300),
	fecha_nacimiento DATE,
	CONSTRAINT pk_empleados PRIMARY KEY(codigo)
)
GO

/*EJERCICIO 02. Aumentar el tamaño del campo código de 3 a 8 caracteres
- Al ser la PK, primero debe eliminar la restricción, modificar el campo
y luego aregar la PK
*/
ALTER TABLE empleados
DROP CONSTRAINT pk_empleados
GO

ALTER TABLE empleados
ALTER COLUMN codigo CHAR(8) NOT NULL
GO

ALTER TABLE empleados
ADD CONSTRAINT pk_empleados PRIMARY KEY(codigo)
GO

/*EJERCICIO 03. Agregar el campo correo*/
ALTER TABLE empleados
ADD correo VARCHAR(30) NULL
GO

/*EJERCICIO 04. Cambiar el nombre del campo correo por el campo email*/
EXECUTE SP_RENAME 'empleados.correo', 'email', 'COLUMN'
GO
--Mensaje que arroja: 
--Precaución: Al cambiar cualquier parte del nombre de un objeto pueden 
--dejar de ser scripts válidos y procedimientos almacenados

--Ver la estructura de la tabla
SP_HELP empleados
GO

/*EJERCICIO 05. Aumentar los campos de los apellidos y el nombre a 100 caracteres*/
ALTER TABLE empleados
ALTER COLUMN paterno VARCHAR(100)
GO

ALTER TABLE empleados
ALTER COLUMN materno VARCHAR(100)
GO

ALTER TABLE empleados
ALTER COLUMN nombre VARCHAR(100)
GO

/*EJERCICIO 06. Se puede visualizar los campos de la tabla empleados, 
considerando que siempre al inicio del nombre de campo se incluya el nombre
de la tabla. Para ello podemos usar la vista del sistema COLUMNS del esquema SYS*/
SELECT * 
FROM SYS.COLUMNS
WHERE name LIKE 'empleados%'
GO
--En mi caso no saldrá, ya que mis campos no tienen al inicio el nombre de la tabla
--Esto funcionaria si por ejemplo tengo un campo código para la tabla Empleados
--sería: EmpleadosCodigo, en mi caso es solamente: codigo

/*EJERCICIO 07. Agregar los campos teléfono, pagina web y profesión*/
ALTER TABLE empleados
ADD telefono VARCHAR(50) NULL, web VARCHAR(100) NULL, profesion VARCHAR(70) NULL
GO

/*EJERCICIO 08. Agrega restricciones para email y página web que sean únicas*/
ALTER TABLE empleados
ADD CONSTRAINT uq_email_emp UNIQUE(email), CONSTRAINT uq_web_emp UNIQUE(web)
GO

/*EJERCICIO 09. Ver restricciones de la tabla empleados*/
SELECT *
FROM SYS.KEY_CONSTRAINTS
WHERE name LIKE '%emp%'

/*EJERCICIO 10. Agregar el campo sueldo*/
ALTER TABLE empleados
ADD sueldo DECIMAL(9,2) 
GO

/*EJERCICIO 10. Agregar registros*/
INSERT INTO empleados
VALUES('87005984', 'ZAVALETA', 'WONG', 'CARLOS', 'LAS CASUARINAS', '1989-05-17', 'carlos@gmail.com', '943857456', 'www.carlos.com.pe', 'Administrador', 2600),
('86439064', 'CHAVEZ', 'CAMPOS', 'JOSE', 'LAS CASUARINAS', '1995-07-18', 'chavez@gmail.com', '946856985', 'www.chavez.com.pe', 'Abogado', 1980),
('24567895', 'VILLACORTA', 'SANCHEZ', 'PEDRO', 'LAS CASUARINAS', '1996-04-13', 'villacorta@gmail.com', '946859623', 'www.villacorta.com.pe', 'Contador', 2500)
GO


/*EJERCICIO 11. Agregar restricción para que el sueldo no sea menor a 1200, tenga
en cuenta que existen registros que no cumplen con la restricción a agrear,
además los registros que no cumplen no se van a modificar.*/
SELECT * FROM empleados
GO

ALTER TABLE empleados
WITH NOCHECK ADD CONSTRAINT ck_sueldo_emp CHECK(sueldo >= 1200)
GO

--Para ver los datos que no cumplen con la restricción agregada
DBCC CHECKCONSTRAINTS(ck_sueldo_emp)
GO

/*
Se puede hacer una consulta filtrando los valores de la columna Where para saber 
quienes son los registros con esos sueldos.
*/

--Si tratamos de insertar este registro, con un sueldo de 500 que es menor que 
--el permitido en la restricción check de sueldo (1200), no nos dejará insertarlo
INSERT INTO empleados
VALUES('87005900', 'ERROR', 'ERROR', 'ERROR', 'LAS CASUARINAS', '1989-05-18', 'ERROR@gmail.com', '943857400', 'www.ERROR.com.pe', 'Administrador', 500)
GO