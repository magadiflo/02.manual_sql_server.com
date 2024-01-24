/*-- Adjuntar base de datos --*/

/*
Adjuntar una base de datos a una instancia de SQL Server 
va a ser posible si se tienen todos los archivos de una 
base de datos separada del servidor. 
Al usar la instrucción
	Create Database 
se utiliza la cláusula 
	For Attach.
Requisitos
----------
- La base de datos a adjuntar debe haber sido separada previamente
- Todos los archivos de la base de datos deben estar
  disponibles, primario, secundarios y de transacciones
  Hay que incluir la unidad y carpeta donde se encuentra cada archivo
- Al adjuntar una base de datos, los archivos no pueden
  estar ubicados en el directorio raíz de la unidad
*/

/*EJERCICIO 01. Crear una base de datos, luego separarla y adjuntarla*/
-- PASO 01. Crear la base de datos
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BasesContable'
GO
XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\RRHH\Bases'
GO
XP_CREATE_SUBDIR 'M:\BD_SQL_SERVER\BasesFinanzas'
GO

CREATE DATABASE bd_empresa
ON PRIMARY(
	NAME='bd_empresa_pri',
	FILENAME='D:\BD_SQL_SERVER\RRHH\Bases\bd_empresa_pri.mdf',
	SIZE=10MB,
	MAXSIZE=30GB,
	FILEGROWTH=10MB
),
FILEGROUP CONTABILIDAD(
	NAME='bd_empresa_sec',
	FILENAME='C:\BD_SQL_SERVER\BasesContable\bd_empresa_sec.ndf'
),
FILEGROUP VENTAS(
	NAME='bd_empresa_ventas_sec',
	FILENAME='M:\BD_SQL_SERVER\BasesFinanzas\bd_empresa_ventas_sec.ndf',
	SIZE=30MB,
	MAXSIZE=20GB,
	FILEGROWTH=30%
)
LOG ON(
	NAME='bd_empresa_log',
	FILENAME='C:\BD_SQL_SERVER\BasesContable\bd_empresa_log.ldf'
)
GO

-- PASO 02. Separar la base de datos
EXEC SP_DETACH_DB bd_empresa
GO

-- PASO 03. Adjuntar la base de datos separada
USE master
GO

CREATE DATABASE bd_empresa 
ON
(FILENAME = 'D:\BD_SQL_SERVER\RRHH\Bases\bd_empresa_pri.mdf'),
(FILENAME='C:\BD_SQL_SERVER\BasesContable\bd_empresa_log.ldf'),
(FILENAME='C:\BD_SQL_SERVER\BasesContable\bd_empresa_sec.ndf'),
(FILENAME='M:\BD_SQL_SERVER\BasesFinanzas\bd_empresa_ventas_sec.ndf')
FOR ATTACH
GO

--Note que para adjuntar una base de datos se debe 
--incluir la cláusula For Attach.