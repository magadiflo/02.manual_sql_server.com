/*-- TIPOS DE DATOS DEFINIDOS POR EL USUARIO - EJERCICIOS --*/
/*EJERCICIO 01. Creamos la base de datos*/
USE master
GO

XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER'
GO

CREATE DATABASE bd_erp
ON PRIMARY 
(NAME='ERP01', FILENAME='C:\BD_SQL_SERVER\ERP01.mdf'),
FILEGROUP VENTAS
(NAME='ERP02', FILENAME='C:\BD_SQL_SERVER\ERP02.ndf'),
FILEGROUP RRHH
(NAME='ERP03', FILENAME='C:\BD_SQL_SERVER\ERP03.ndf')
LOG ON
(NAME='ERP04', FILENAME='C:\BD_SQL_SERVER\ERP04.ldf')
GO

USE bd_erp
GO

/*EJERCICIO 02. Crear los tipos de datos
codigo5, textoLargo100, texto200, numeroGrande*/
CREATE TYPE codigo5 FROM NCHAR(5) NOT NULL
CREATE TYPE textoLargo100 FROM NVARCHAR(100)
CREATE TYPE texto200 FROM NVARCHAR(200)
CREATE TYPE numeroGrande FROM NUMERIC(17,2)
GO

/*EJERCICIO 03. Listar los tipos de datos*/
SELECT * FROM SYS.TYPES WHERE is_user_defined = 1
GO

/*EJERCICIO 04. Crear el tipo numeroGrande, primero 
verificar si el tipo no existe*/
IF NOT EXISTS(SELECT * FROM SYS.TYPES WHERE name = 'numeroGrande')
	BEGIN
		CREATE TYPE numeroGrande FROM NUMERIC(17,2)
		--EXECUTE('CREATE TYPE numeroGrande FROM NUMERIC(17,2)')
	END
ELSE
	PRINT 'EL TIPO DE DATO QUE INTENTA CREAR YA EXISTE'
GO

/*EJERCICIO 05. Crear las tablas facturas, productos, detalle_facturas*/
CREATE TABLE facturas(
	numero_serie codigo5,
	numero_factura NCHAR(7) NOT NULL,
	fecha_emision DATETIME,
	porcentaje_igv NUMERIC(4,2),
	monto_sin_igv numeroGrande,
	monto_igv AS (porcentaje_igv * monto_sin_igv),
	monto_total AS (monto_sin_igv + porcentaje_igv * monto_sin_igv),
	CONSTRAINT pk_facturas PRIMARY KEY(numero_serie, numero_factura)
)
GO

CREATE TABLE productos(
	codigo codigo5,
	descripcion texto200,
	precio  NUMERIC(9,2),
	CONSTRAINT pk_productos PRIMARY KEY(codigo)
)
GO

CREATE TABLE detalle_facturas(
	numero_serie codigo5,
	numero_factura NCHAR(7) NOT NULL,
	codigo codigo5,
	cantidad_vendida NUMERIC(9,2),
	precio_venta NUMERIC(9,2) NOT NULL,
	valor_venta AS (cantidad_vendida * precio_venta),
	CONSTRAINT pk_detalle_facturas PRIMARY KEY(numero_serie, numero_factura, codigo),
	CONSTRAINT fk_det_fact_facturas FOREIGN KEY(numero_serie, numero_factura) REFERENCES facturas(numero_serie, numero_factura),
	CONSTRAINT fk_det_fact_productos FOREIGN KEY(codigo) REFERENCES productos(codigo)
)
GO

/*EJERCICIO 06. Eliminar el tipo de dato codigo5. Para eso deberá
cambiar las tablas que hacen uso de ese tipo de dato*/
ALTER TABLE productos
ALTER COLUMN codigo NCHAR(5) NOT NULL
GO

ALTER TABLE facturas
ALTER COLUMN numero_serie NCHAR(5) NOT NULL
GO

ALTER TABLE detalle_facturas
ALTER COLUMN numero_serie NCHAR(5) NOT NULL
GO

ALTER TABLE detalle_facturas
ALTER COLUMN codigo NCHAR(5) NOT NULL
GO

DROP TYPE codigo5
GO

SELECT * FROM SYS.TYPES WHERE is_user_defined = 1
GO

