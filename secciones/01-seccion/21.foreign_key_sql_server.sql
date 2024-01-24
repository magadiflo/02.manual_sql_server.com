/*-- FOREIGN KEY EN SQL SERVER --*/
/*
Relacionando tablas en SQL Server, para relacionar dos tablas en una base 
de datos en SQL Server se debe usar la restricci�n de tipo Foreign Key 
que permite establecer las reglas de negocio entre dos entidades, lo que 
se convierte en la relaci�n entre dos tablas de la base de datos.

En este art�culo se muestran ejemplos de como relacionar tablas haciendo 
uso de la restricci�n de tipo Foreign Key. Este tipo de relaci�n va a asegurar 
la integridad referencial entre las tablas de la base de datos.
*/

USE master
GO

DROP DATABASE IF EXISTS bd_restricciones
GO

CREATE DATABASE bd_restricciones
GO

USE bd_restricciones
GO

/*EJERCICIO 01. RELACI�N UNO - MUCHOS
Creando las tablas y especificando las restricciones al crearlas.
Tablas categorias y productos. Un producto pertenece a una categor�a
*/
CREATE TABLE categorias(
	codigo CHAR(5),
	descripcion VARCHAR(50) NOT NULL,
	estado CHAR(1) CONSTRAINT df_estado_cat DEFAULT 'A',
	fecha_creacion DATE CONSTRAINT df_fecha_creacion_cat DEFAULT GETDATE(),
	CONSTRAINT pk_categorias PRIMARY KEY(codigo),
	CONSTRAINT ck_estado_cat CHECK(estado = 'A' OR estado = 'E'),--Activado, Eliminado
	CONSTRAINT ck_fecha_creacion_cat CHECK(fecha_creacion = CONVERT(DATE, GETDATE()))
)
GO

/*
Note que la tabla tiene la restricci�n primary key con el campo c�digo, 
el estado se ha especificado con dos posibles valores A de Activo y 
E de eliminado, siendo la restricci�n df_estado_cat la que especifica que el 
valor por defecto es A. Para la fecha de creaci�n se ha especificado la 
restricci�n ck_fecha_creacion_cat que �nicamente permite el ingreso de la 
fecha actual para el registro
*/
CREATE TABLE productos(
	codigo CHAR(8),
	categoria_codigo CHAR(5),
	descripcion VARCHAR(50) NOT NULL,
	precio NUMERIC(9,2) CONSTRAINT df_precio_pro DEFAULT 0,
	stock NUMERIC(9,2) CONSTRAINT df_stock_pro DEFAULT 0,
	estado CHAR(1) CONSTRAINT df_estado_pro DEFAULT 'A',
	CONSTRAINT pk_productos PRIMARY KEY(codigo),
	CONSTRAINT fk_categorias_productos FOREIGN KEY(categoria_codigo) REFERENCES categorias(codigo),
	CONSTRAINT ck_estado_pro CHECK(estado = 'A' OR estado = 'E'),
	CONSTRAINT ck_precio_pro CHECK(precio >= 0),
	CONSTRAINT ck_stock_pro CHECK(stock >= 0)
)
GO

/*EJERCICIO 02. RELACI�N DE UNO - MUCHOS CON VARIOS ATRIBUTOS
Clientes, facturas, detalle_facturas y productos
Una factura es generada por un empleado, no se va a crear a�n la tabla
de empleados para luego ver c�mo se agregan campos y restricciones foreign key en 
tablas ya creadas
*/
CREATE TABLE clientes(
	codigo CHAR(15),
	nombre VARCHAR(100) NOT NULL,
	direccion VARCHAR(200),
	CONSTRAINT pk_clientes PRIMARY KEY(codigo)
)
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
	CONSTRAINT pk_facturas PRIMARY KEY(serie, numero),
	CONSTRAINT fk_clientes_facturas FOREIGN KEY(cliente_codigo) REFERENCES clientes(codigo)
)
GO

CREATE TABLE detalle_facturas(
	serie CHAR(5),
	numero CHAR(7),
	producto_codigo CHAR(8),
	descripcion VARCHAR(100),
	cantidad_vendida NUMERIC(9,2),
	precio_venta NUMERIC(9,2),
	importe AS (cantidad_vendida * precio_venta),
	CONSTRAINT pk_detalle_facturas PRIMARY KEY(serie, numero, producto_codigo),
	CONSTRAINT fk_facturas_detalle_facturas FOREIGN KEY(serie, numero) REFERENCES facturas(serie, numero),
	CONSTRAINT fk_productos_detalle_facturas FOREIGN KEY(producto_codigo) REFERENCES productos(codigo)
)
GO

/*EJERCICIO 03. RELACI�N RECURSIVA
Una relaci�n recursiva se crea cuando la tabla se relaciona consigo misma. Tabla empleados, 
un empleado es el jefe de otro y est� en la misma tabla, en este caso se va a crear una 
relaci�n recursiva entre el empleado jefe y sus subordinados
*/
CREATE TABLE empleados(
	codigo CHAR(4),
	paterno VARCHAR(50) NOT NULL,
	materno VARCHAR(50) NOT NULL,
	nombres VARCHAR(50) NOT NULL,
	fecha_nacimiento DATE,
	sexo CHAR(1),
	jefe_codigo CHAR(4) NULL, --Esto es por que siempre habr� un registro con NULL pues no tendr� jefe_codigo
	CONSTRAINT pk_empleados PRIMARY KEY(codigo),
	CONSTRAINT fk_jefe_subordinados FOREIGN KEY(jefe_codigo) REFERENCES empleados(codigo),
	CONSTRAINT ck_sexo_emp CHECK(sexo = 'M' OR sexo = 'F')
)
GO
/*
El diagrama para el ejercicio 3 deber� mostrar una relaci�n recursiva. 
Note que se han incluido dos campos codigo y jefe_codigo para crear la relaci�n recursiva.
*/
/*EJERCICIO 04. AGREGAR RESTRICCI�N FK A UNA TABLA EXISTENTE
Relacionar la tabla facturas del ejercicio 2 con empleados. Un empleado registra una factura.
PASO 01: Agregar el campo en la tabla facturas que har� referencia a la tabla empleados. Recordar
		 que el tipo de dato debe ser el mismo del de la tabla empledos.
PASO 02: Agregar la restricci�n fk entre las dos tablas
*/
ALTER TABLE facturas
ADD empleado_codigo CHAR(4) NULL
GO

ALTER TABLE facturas
ADD CONSTRAINT fk_empleados_facturas FOREIGN KEY(empleado_codigo) REFERENCES empleados(codigo)
GO


/*EJERCICIO 05. 
Agregar una restricci�n FK entre tablas con registros, 
considerando que algunos de los registros existentes no cumplen con 
la restricci�n. Lo que es necesario es agregar la restricci�n sin que 
se compruebe la integridad referencial de los registros existentes.

Para este ejercicio se van a agregar registros en la tabla Empleados, 
luego se va a crear la tabla Departamentos y luego establecer la relaci�n, hay 
que resaltar que al establecer la relaci�n en la tabla Empleados no se va a 
especificar el c�digo del departamento que es la clave for�nea.*/


--Registro de empleados sin departamento

/*
Para establecer el orden de las partes de una fecha (dia, mes y a�o) empleamos "set dateformat".
Estos son los formatos:
-mdy: 4/15/96 (mes y d�a con 1 � 2 d�gitos y a�o con 2 � 4 d�gitos),
-myd: 4/96/15,
-dmy: 15/4/1996
-dym: 15/96/4,
-ydm: 96/15/4,
-ydm: 1996/15/4,
Para almacenar valores de tipo fecha se permiten como separadores "/", "-" y ".".

Todos los valores de tipo "datetime" se muestran en formato "a�o-mes-d�a hora:minuto:segundo .milisegundos", 
independientemente del formato de ingreso que hayamos seteado.
*/

-- Seteamos el formato de la fecha para que guarde d�a, mes y a�o:
SET DATEFORMAT dmy
INSERT INTO empleados(codigo, paterno, materno, nombres, fecha_nacimiento, sexo, jefe_codigo)
VALUES('0001', 'LUQUE', 'S�NCHEZ', 'FERNANDO', '23/07/1966', 'M', NULL),
('0002', 'MENDOZA', 'CEVALLOS', 'CARLOS', '14/07/1986', 'M', '0001'),
('0003', 'SANDOVAL', 'TERRANOVA', 'RAQUEL', '08/03/1990', 'F', '0001'),
('0004', 'VILLACORTA', 'P�REZ', 'ANTONIO', '13/06/1974', 'M', '0003'),
('0005', 'ESPINOZA', 'CH�VEZ', 'INGRID', '10/02/1999', 'F', '0003'),
('0006', 'ZAPATA', 'S�NCHEZ', 'LUIS', '19/09/1970', 'M', '0003')
GO

/*Crear y agregar registros a la tabla departamentos*/
CREATE TABLE departamentos(
	codigo CHAR(5),
	descripcion VARCHAR(50) NOT NULL,
	estado CHAR(1) CONSTRAINT df_estado_dep DEFAULT 'A',
	CONSTRAINT pk_departamentos PRIMARY KEY(codigo),
	CONSTRAINT ck_estado_dep CHECK(estado = 'A' OR estado = 'E')
)
GO

--Registrando departamentos
INSERT INTO departamentos
VALUES('D0101', 'GERENCIA GENERAL', 'A'),
('D0102', 'aDMINISTRACI�N', 'A'),
('D0201', 'PRODUCCI�N', 'A'),
('D0202', 'VENTAS', 'A'),
('D0203', 'PLANIFICACI�N Y CONTROL', 'A'),
('D0301', 'FINANZAS Y PRESUPUESTO', 'A')
GO

--Agregar la relaci�n (Foreign Key) entre las tablas empleados y departamentos
ALTER TABLE empleados
ADD departamento_codigo CHAR(5)
GO

ALTER TABLE empleados
ADD CONSTRAINT fk_departamentos_empleados FOREIGN KEY(departamento_codigo) REFERENCES departamentos(codigo)
GO

SELECT * FROM empleados
/*
Si hacemos el select de empleados, note que en el c�digo del departamento todos los 
empleados tienen el valor Null. Es necesario corregir uno por uno.
*/

--Insertar un empleado sin departamento
SET DATEFORMAT dmy
INSERT INTO empleados(codigo, paterno, materno, nombres, fecha_nacimiento, sexo, jefe_codigo)
VALUES('0007', 'ROJAS', 'ALVARADO', 'M�NICA', '06/02/1997', 'F', '0001')
GO

--Insertar un empleado con un c�digo de departamento que no existe
SET DATEFORMAT dmy
INSERT INTO empleados(codigo, paterno, materno, nombres, fecha_nacimiento, sexo, jefe_codigo, departamento_codigo)
VALUES('0008', 'CASANOVA', 'LLANOS', 'JULIO', '11/04/1988', 'M', '0001', 'D0010')
GO
/*Nos deber� mostrar el siguiente error: 
Msg 547, Level 16, State 0, Line 225
The INSERT statement conflicted with the FOREIGN KEY constraint "fk_departamentos_empleados". 
The conflict occurred in database "bd_restricciones", table "dbo.departamentos", column 'codigo'.
The statement has been terminated.
*/

--Insertar un empleado con un c�digo de departamento que s� existe
SET DATEFORMAT dmy
INSERT INTO empleados(codigo, paterno, materno, nombres, fecha_nacimiento, sexo, jefe_codigo, departamento_codigo)
VALUES('0008', 'CASANOVA', 'LLANOS', 'JULIO', '11/04/1988', 'M', '0001', 'D0102')
GO

--Listamos los empleados
SELECT * FROM empleados
GO

--Actualizar el registro con c�digo 001 asignando el departamento de Gerencia General con c�digo D0101
UPDATE empleados
SET departamento_codigo = 'D0101'
WHERE codigo = '0001'
GO

/*EJERCICIO 06. RELACI�N DE MUCHOS - MUCHOS
En una relaci�n muchos � muchos se deben crear tres tablas, en una de estas se establecen 
las claves for�neas de las otras dos adicionando los atributos propios de la relaci�n.

Para el tipo de relaci�n muchos a muchos se va a crear una tabla de Proyectos, donde varios 
empleados pueden ser asignados a un proyecto y varios proyectos pueden ser asignados a un empleado. 
Se crear� la tabla de proyectos y empleados_proyectos
*/
CREATE TABLE proyectos(
	codigo CHAR(6),
	descripcion VARCHAR(50) NOT NULL,
	estado CHAR(1) CONSTRAINT df_estado_proy DEFAULT 'A',
	fecha_inicio DATE,
	durecion_meses NUMERIC(9,2),
	CONSTRAINT pk_proyectos PRIMARY KEY(codigo),
	CONSTRAINT ck_estado_proy CHECK(estado = 'A' OR estado = 'E')
)
GO

--La tabla empleados ya est� creada en el ejercicio 3

--Creando la tabla empleados_proyectos, que ser� la tabla intermedia
CREATE TABLE empleados_proyectos(
	empleado_codigo CHAR(4),
	proyecto_codigo CHAR(6),
	estado CHAR(1) CONSTRAINT df_estado_emp_proy DEFAULT 'A',
	rol VARCHAR(20),
	metodologia VARCHAR(30),
	CONSTRAINT pk_empleados_proyectos PRIMARY KEY(empleado_codigo, proyecto_codigo),
	CONSTRAINT ck_estado_emp_proy CHECK(estado = 'A' OR estado = 'E'),
	CONSTRAINT fk_empleados_empleados_proyectos FOREIGN KEY(empleado_codigo) REFERENCES empleados(codigo),
	CONSTRAINT fk_proyectos_empleados_proyectos FOREIGN KEY(proyecto_codigo) REFERENCES proyectos(codigo)
)
GO

/*DESACTIVAR UNA RESTRICCI�N FOREIGN KEY
No se recomienda desactivar las restricciones de tipo Foreign key, pero la 
forma de desactivar es usando la cl�usula NOCHECK en la instrucci�n ALTER TABLE.
*/

--Desactivar la FK fk_departamentos_empleados
ALTER TABLE empleados 
NOCHECK CONSTRAINT fk_departamentos_empleados
GO

/*
El inconveniente es que se pueden insertar o editar registros con c�digos de departamentos que no existen.
*/

--Se va a insertar un empleado con el departamento con c�digo D1234, que no existe en la tabla Departamentos.
SET DATEFORMAT dmy
INSERT INTO empleados(codigo, paterno, materno, nombres, fecha_nacimiento, sexo, jefe_codigo, departamento_codigo)
VALUES('0009', 'CAMPOS', 'SEGURA', 'CARMELA', '01/05/1977', 'F', '0002', 'D1234')
GO

--Listamos los empleados
SELECT * FROM empleados
GO

/*Se observa que se registr� el empleado con un c�digo de departamento que no existe en 
la tabla departamentos*/

/*ACTIVAR UNA RESTRICCI�N FOREIGN KEY
Para activar la restricci�n de tipo FK se usa la cl�usula CHECK CONSTRAINT de la instrucci�n ALTER TABLE.
*/
ALTER TABLE empleados
CHECK CONSTRAINT fk_departamentos_empleados
GO

/*ELIMINA UNA RESTRICCI�N FOREIGN KEY
No se recomienda eliminar las restricciones FK.
Para eliminar se utiliza la cl�usula DROP CONSTRAINT de la instrucci�n ALTER TABLE.
*/
ALTER TABLE empleados
DROP CONSTRAINT fk_departamentos_empleados
GO