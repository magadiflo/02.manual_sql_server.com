/*-- Modificando archivos de base de datos --*/
/*
Los archivos de las bases de datos en SQL Server puede 
ubicarse en diferentes discos y carpetas, además de 
agruparlos en Grupos de archivos. En este post aprenderemos
a agregar, modificar y eliminar estos archivos.

Los archivos de la base de datos son de tres tipos, el primario, 
los secundarios y los archivos de transacciones, en los dos 
primeros se almacenarán los datos guardados en la base de datos, 
se recomienda que sean mas de uno en cada grupo cuando se proyecta 
un crecimiento acelerado de la base de datos.

Los archivos de transacciones no se ubican en grupos de archivos.

Ningún archivo puede tener un tamaño inicial menor al que se ha 
especificado en la base de datos model.

Es recomendable que el nombre que usará SQL Server sea igual al 
que se visualiza en el sistema operativo, estos se especifican en 
los parámetros Name para el nombre de SQL Server y Filename para 
el que se visualiza en el Sistema Operativo
*/

/*EJERCICIO 01. Creamos primero la base de datos*/
XP_CREATE_SUBDIR 'C:\BD'
GO

XP_CREATE_SUBDIR 'C:\Data\Respaldo'
GO

CREATE DATABASE bd_sistema
ON PRIMARY
(NAME='S01', FILENAME='C:\BD\S01.mdf', SIZE=10MB, MAXSIZE=200GB, FILEGROWTH=5MB),
(NAME='S02', FILENAME='C:\Data\S02.ndf'),
FILEGROUP VENTAS
(NAME='S03', FILENAME='D:C\Data\Respaldo\S03.ndf')
LOG ON
(NAME='L01', FILENAME='C:\BD\L01.ldf')
GO


/*EJERCICIO 02. Agregar grupos PERSONAL y FINANZAS*/
ALTER DATABASE bd_sistema
ADD FILEGROUP PERSONAL
GO

ALTER DATABASE bd_sistema
ADD FILEGROUP FINANZAS
GO

/*EJERCICIO 03. Agregar dos archivos al grupo FINANZAS*/
ALTER DATABASE bd_sistema
ADD FILE
(NAME='Datos01', FILENAME='C:\BD\Datos01.ndf'),
(NAME='Datos02', FILENAME='C:\BD\Datos02.ndf')
TO FILEGROUP FINANZAS
GO

/*EJERCICIO 04. Para listar los Grupos y Archivos*/
SELECT * FROM SYS.FILEGROUPS
GO

SELECT * FROM SYS.DATABASE_FILES
GO

/*EJERCICIO 05. Cambiar el nombre del archivo Datos01 a Finanzas01*/
ALTER DATABASE bd_sistema
MODIFY FILE(NAME='Datos01', NEWNAME='Finanzas01')
GO

/*EJERCICIO 06. Asignar el tamaño de 30MB al archivo de Finanzas01*/
ALTER DATABASE bd_sistema
MODIFY FILE(NAME='Finanzas01', SIZE=30MB)
GO

/*EJERCICIO 07. Ver los archivos del grupo FINANZAS*/
SP_HELPFILEGROUP FINANZAS
GO

/*EJERCICIO 08. Reducir el archivo Finanzas01 a 10MB*/
DBCC ShrinkFile(Finanzas01, 10)
GO

/*EJERCICIO 09. Agregar el archivo de registro de transacciones Pasos.ldf*/
IF NOT EXISTS(SELECT * FROM SYS.DATABASE_FILES WHERE name = 'Pasos')
	BEGIN
		ALTER DATABASE bd_sistema
		ADD LOG FILE(NAME='Pasos', FILENAME='C:\BD\Pasos.ldf')
	END
GO