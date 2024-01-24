/*EJERCICIO 01. bd_empresa distribuida en barios discos*/
USE master
GO

XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BasesContables'
GO

XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\RRHH\Bases'
GO

XP_CREATE_SUBDIR 'M:\BD_SQL_SERVER\BasesFinanzas'
GO

CREATE DATABASE bd_empresa
ON PRIMARY(
	NAME='bd_empresa_prim',
	FILENAME='D:\BD_SQL_SERVER\RRHH\Bases\bd_empresa_prim.mdf',
	SIZE=10MB,
	MAXSIZE=30GB,
	FILEGROWTH=10MB
),
FILEGROUP contabilidad(
	NAME='bd_empresa_sec_01',
	FILENAME='C:\BD_SQL_SERVER\BasesContables\bd_empresa_sec_01.ndf'
),
FILEGROUP ventas(
	NAME='bd_empresa_sec_02',
	FILENAME='M:\BD_SQL_SERVER\BasesFinanzas\bd_empresa_sec_02.ndf',
	SIZE=30MB,
	MAXSIZE=20GB,
	FILEGROWTH=30%
)
LOG ON(
	NAME='bd_empresa_log',
	FILENAME='C:\BD_SQL_SERVER\BasesContables\bd_empresa_log.ldf'
)
GO


/*EJERCICIO 02. Las extensiones de los archivos pueden
ser diferentes a las que reconoce el sistema operativo
para los archivos primarios, secundarios y de transacciones*/

XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BasesContables'
GO

XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\RRHH\Bases'
GO

XP_CREATE_SUBDIR 'M:\BD_SQL_SERVER\BasesFinanzas'
GO

CREATE DATABASE lab
ON PRIMARY(
	NAME='lab01',
	FILENAME='D:\BD_SQL_SERVER\RRHH\Bases\lab01.bmp'
),
FILEGROUP ventaslab(
	NAME='V1',
	FILENAME='M:\BD_SQL_SERVER\BasesFinanzas\V1.xlsx'
)
LOG ON(
	NAME='FOTO',
	FILENAME='C:\BD_SQL_SERVER\BasesContables\foto.gif'
)
GO
--Note que los archivos tienen extensiones de archivos bmp, xlsx y gif

/*EJERCICIO 03. Dos ejemplos más. Note que de preferencia se
debe ejecutar la instrucción que crea las carpetas*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BasesContables'
GO

XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\RRHH\Bases'
GO

XP_CREATE_SUBDIR 'M:\BD_SQL_SERVER\BasesFinanzas'
GO

CREATE DATABASE bd_fabrica
ON PRIMARY(
	NAME='F01',
	FILENAME='C:\BD_SQL_SERVER\BasesContables\F01.mdf',
	SIZE=10MB,
	MAXSIZE=200MB,
	FILEGROWTH=20MB
),
FILEGROUP FINANZAS(
	NAME='Finanzas01',
	FILENAME='D:\BD_SQL_SERVER\RRHH\Bases\Finanzas01.ndf'
),
(
	NAME='Finanzas02',
	FILENAME='M:\BD_SQL_SERVER\BasesFinanzas\Finanzas02.ndf',
	SIZE=100MB,
	MAXSIZE=2GB,
	FILEGROWTH=20MB
),
FILEGROUP VENTAS(
	NAME='Ventas01',
	FILENAME='D:\BD_SQL_SERVER\RRHH\Bases\Ventas01.ndf'
)
LOG ON(
	NAME='Transacciones01',
	FILENAME='C:\BD_SQL_SERVER\BasesContables\Transacciones01.ldf'
)
GO

--Las extensiones de los archivos pueden ser cualquiera, 
--tal como se vio en el EJERCICIO 02. Pero para
--seguir una convención se recomienda usar Primario(.mdf), 
--Secundario(.ndf) y de Transacciones (.ldf)