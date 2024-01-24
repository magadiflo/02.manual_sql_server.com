/*-- Modificar una base de datos - manejo de grupo de archivos --*/
/*
Los archivos de las bases de datos en SQL Server se 
agrupan en grupos de archivos (Ver Post), en este 
post aprenderemos como trabajar con los grupos 
de la base de datos.

Para modificar la base de datos y trabajar con grupos se puede:

Agregar: Alter database NombreBaseDatos  
	add filegroup NombreGrupoNuevo
Modificar:  Alter database NombreBaseDatos 
	modify filegroup NombreGrupo,  las opciones 
	posibles son cambiar el nombre y cambiar el grupo por defecto.
Eliminar:  Alter database NombreBaseDatos remove 
	filegroup NombrerupoEliminar (debe estar vacío, 
	es decir sin archivos.)
*/

/*EJERCICIO 01. CREAMOS LA BASE DE DATOS*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BD'
GO

XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\Data\Respaldo'
GO

CREATE DATABASE bd_sistema
ON PRIMARY
(
	NAME='S01',
	FILENAME='C:\BD_SQL_SERVER\BD\S01.mdf',
	SIZE=10MB,
	MAXSIZE=200GB,
	FILEGROWTH=5MB
),(
	NAME='S02',
	FILENAME='D:\BD_SQL_SERVER\Data\S02.ndf'
),
FILEGROUP VENTAS
(
	NAME='S03', 
	FILENAME='D:\BD_SQL_SERVER\Data\Respaldo\S03.ndf'
)
LOG ON
(
	NAME='L01',
	FILENAME='C:\BD_SQL_SERVER\BD\L01.ldf'	
)
GO

/*EJERCICIO 02. AGREGAMOS GRUPOS PERSONAL Y FINANZAS*/
ALTER DATABASE bd_sistema
ADD FILEGROUP PERSONAL
GO

ALTER DATABASE bd_sistema
ADD FILEGROUP FINANZAS
GO

/*EJERCICIO 03. VER LOS GRUPOS*/
SELECT * FROM SYS.FILEGROUPS
GO

/*EJERCICIO 04. Crear grupo PRESUPUESTO, darle consistencia
al script y si existe el grupo no debe reportar error.
NOTA:En el script se ha incluido mensajes solamente para 
comprobar que el script funciona correctamente.*/
IF NOT EXISTS(SELECT * FROM SYS.FILEGROUPS WHERE name = 'PRESUPUESTO')
	BEGIN 
		ALTER DATABASE bd_sistema
		ADD FILEGROUP PRESUPUESTO
		PRINT 'Grupo PRESUPUESTO creado...'			
	END
ELSE
	BEGIN 
		PRINT 'El grupo PRESUPUESTO ya existe'
	END
GO

/*EJERCICIO 05. Cambiar el grupo de archivos por defecto*/
--Primero agregamos un archivo al grupo FINANZAS
ALTER DATABASE bd_sistema
ADD FILE(NAME='Datos01', FILENAME='C:\BD_SQL_SERVER\BD\Datos01.ndf'),
(NAME='Datos02', FILENAME='C:\BD_SQL_SERVER\BD\Datos02.ndf')
TO FILEGROUP FINANZAS
GO

/*EJERCICIO 06. Cambiar el nombre del grupo FINANZAS por BANCOS*/
ALTER DATABASE bd_sistema
MODIFY FILEGROUP FINANZAS NAME=BANCOS
GO

/*EJERCICIO 07. Cambiar el grupo por defecto a BANCOS*/
ALTER DATABASE bd_sistema
MODIFY FILEGROUP BANCOS DEFAULT
GO