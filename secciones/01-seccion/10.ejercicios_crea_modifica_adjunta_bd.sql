/*-- Crear, modificar y adjuntar base de datos --*/

/*EJERCICIO 01. Crear una BD llamada bd_logistica*/
CREATE DATABASE bd_logistica
GO
--Importante: La instrucción anterior crea la BD  en 
--la misma carpeta donde se encuentran las BD del Sistema


/*EJERCICIO 02. Crear BD bd_costos ubicada en
D:\Seminario, con dos archivos Costos.mdf y Costos.ldf.
Ambos archivos deberán tener: tamaño de 4MB, tamaño 
máximo de 30MB y una tasa de crecimiento de 10%*/
CREATE DATABASE bd_costos
ON PRIMARY
(NAME='Costos_pri', FILENAME='D:\Seminario\Costos.mdf', SIZE=4MB, MAXSIZE=30MB, FILEGROWTH=10%)
LOG ON
(NAME='Costos_log', FILENAME='D:\Seminario\Costos.ldf', SIZE=4MB, MAXSIZE=30MB, FILEGROWTH=10%)
GO

/*EJERCICIO 03. Crear la BD llamada bd_sistemas con 4 archivos*/
XP_CREATE_SUBDIR 'D:\Respaldo'
GO

CREATE DATABASE bd_sistemas
ON PRIMARY
(NAME='SistemasData01', FILENAME='D:\Respaldo\SistemasData01.mdf', SIZE=40MB, MAXSIZE=30GB, FILEGROWTH=50%),
(NAME='SistemasData02', FILENAME='D:\Respaldo\SistemasData02.ndf', SIZE=40MB, MAXSIZE=30GB, FILEGROWTH=20%)
LOG ON
(NAME='SistemasLog01', FILENAME='D:\Respaldo\SistemasL01.ldf', SIZE=40MB, MAXSIZE=30GB, FILEGROWTH=30%),
(NAME='SistemasLog02', FILENAME='D:\Respaldo\SistemasL02.ldf', SIZE=40MB, MAXSIZE=30GB, FILEGROWTH=60%)
GO

/*EJERCICIO 04. Crear una BD llamada bd_empresa con 2 archivos en Primary, 
dos archivos en el Filegroup Seguridad y dos en Recursos, además de 
dos archivos Log*/
XP_CREATE_SUBDIR 'F:\BD'
GO

CREATE DATABASE bd_empresa
ON PRIMARY
(NAME='EmpresaData01', FILENAME='F:\BD\EmpresaData01.mdf'),
(NAME='EmpresaData02', FILENAME='F:\BD\EmpresaData02.ndf'),
FILEGROUP Seguridad
(NAME='EmpresaData03', FILENAME='F:\BD\EmpresaData03.ndf'),
(NAME='EmpresaData04', FILENAME='F:\BD\EmpresaData04.ndf'),
FILEGROUP Recursos
(NAME='EmpresaData05', FILENAME='F:\BD\EmpresaData05.ndf'),
(NAME='EmpresaData06', FILENAME='F:\BD\EmpresaData06.ndf')
LOG ON
(NAME='EmpresaLog01', FILENAME='F:\BD\EmpresaLog01.ldf'),
(NAME='EmpresaLog02', FILENAME='F:\BD\EmpresaLog02.ldf')
GO

/*EJERCICIO 05. Crear una base de datos bd_vientos en base al archivo Northwnd.mdf*/
CREATE DATABASE bd_vientos
ON
(FILENAME='F:\ParaAdjuntar\Northwnd.mdf')
FOR ATTACH
GO

/*EJERCICIO 06. Crear la bd_empresa_transporte a partir de la bd_transporte.mdf*/
CREATE DATABASE bd_empresa_transporte
ON
(FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\bd_transporte.mdf')
FOR ATTACH
GO

/*EJERCICIO 07. Crea una instantánea de la BD bd_costos*/
CREATE DATABASE FotoCostos20110408_2053 
ON
(NAME='Costos01', FILENAME='F:\SeminarioB\CostosFoto.mdf')
AS SNAPSHOT OF bd_costos
GO

/*EJERCICIO 08. Crea una instantánea de la BD bd_sistemas llamada SistemasFoto.
La BD bd_sistemas tiene un mdf y un ndf*/
CREATE DATABASE SistemasFoto
ON
(NAME='SistemasData01', FILENAME='F:\SeminarioB\SistemasFoto01.mdf'),
(NAME='SistemasData02', FILENAME='F:\SeminarioB\SistemasFoto01.ndf')
AS SNAPSHOT OF bd_sistemas
GO

/*EJERCICIO 09. Cambiar el nombre lógico de un archivo*/
ALTER DATABASE bd_costos
MODIFY FILE(NAME='Costos01', NEWNAME='CostosData01')
GO

/*EJERCICIO 10. Agregar un filegroup*/
ALTER DATABASE bd_costos
ADD FILEGROUP Cuentas
GO

/*EJERCICIO 11. Agregar un archivo secundario (.ndf) llamado AgregadoCostos 
a bd_costos en el Filegroup creado*/
ALTER DATABASE bd_costos
ADD FILE
(NAME='AgregadoCostos', FILENAME='F:\SeminarioB\AgregadoCostos.ndf')
TO FILEGROUP Cuentas
GO