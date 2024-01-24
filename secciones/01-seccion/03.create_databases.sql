/*-- Create databases --*/
/*
FILEGROUP
¿Para qué? Imaginemos que tenemos una gran base de datos
y tenemos dos grandes tablas de millones de registros: facturas y pedidos. 
Estas dos tablas son accedidas constántemente, 
haciendo selects y updates por las aplicaciones…

Si estas dos tablas están en el mismo disco duro, 
las dos compiten por la misma cabeza lectora del disco, 
haciendo que el sistema sea más lento. Una forma de evitar 
esto es separando cada tabla en un filegroup independiente 
y dicho filegroup se asocia a un fichero físico de la base 
de datos independiente y dicho fichero físico a una unidad 
distinta (y un disco físico distinto). Así cuando las aplicaciones 
accedan a la vez a facturas y pedidos, accederán a dos 
discos distintos acelerando considerablemente nuestra base de datos.

En Oracle este mismo concepto lo denominamos tablespace 
y es similar a un filegroup de SQL Server.
*/

/*EJERCICIO 01. Crear una base de datos simple llamada bd_soluciones */
USE master
GO

CREATE DATABASE bd_soluciones
GO
/*
La base de datos se ha creado, y es una copia de model, 
con la misma ubicación, archivos y tamaño.
*/

/*EJERCICIO 02. Crear bd_colegio en C:\BD_SQL_SERVER, 
02 archivos. 
Tamaño inicial: 5 MB c/u, Máximo: 100 c/u,  crecimiento: 20% c/u. 
Primero crear la carpeta */

USE master
GO

IF DB_ID('bd_colegio') IS NOT NULL
	DROP DATABASE bd_colegio
GO

CREATE DATABASE bd_colegio
ON PRIMARY(
	NAME='colegio_data', --Nombre lógico
	FILENAME='C:\BD_SQL_SERVER\bd_colegio.mdf', --Ruta y nombre físico del archivo primario
	SIZE=5MB, --Tamaño inicial
	MAXSIZE=100MB, --Tamaño máximo
	FILEGROWTH=20% --Tasa de crecimiento del archivo
)
LOG ON(
	NAME='colegio_log',
	FILENAME='C:\BD_SQL_SERVER\bd_colegio.ldf',
	SIZE=5MB,
	MAXSIZE=100MB,
	FILEGROWTH=20%
)
GO

/*EJERCICIO 03. Crear la base da datos bd_empresa
El Filegroup Primario con 2 archivos, ubicados en C:\BD_SQL_SERVER\DatosEmpresa
El Filegroup Documentos con 2 archivos ubicados en C:\BD_SQL_SERVER\DatosEmpresa\Sistemas 
Los registros de transacicones 2 archivos ubicados en C:\BD_SQL_SERVER\DatosEmpresa\Sistemas
*/
USE master
GO

IF DB_ID('bd_empresa') IS NOT NULL
	DROP DATABASE bd_empresa
GO

CREATE DATABASE bd_empresa
ON PRIMARY
(NAME='bd_empresa_pri', FILENAME='C:\BD_SQL_SERVER\DatosEmpresa\bd_empresa_01.mdf'), 
(NAME='bd_empresa_sec', FILENAME='C:\BD_SQL_SERVER\DatosEmpresa\bd_empresa_02.ndf'),
FILEGROUP documentos
(NAME='bd_empresa_sec_doc_03', FILENAME='C:\BD_SQL_SERVER\Sistemas\bd_empresa_03.ndf'),
(NAME='bd_empresa_sec_doc_04', FILENAME='C:\BD_SQL_SERVER\Sistemas\bd_empresa_04.ndf')
LOG ON
(NAME='bd_empresa_log_01', FILENAME='C:\BD_SQL_SERVER\Sistemas\bd_empresa_log_01.ldf'),
(NAME='bd_empresa_log_02', FILENAME='C:\BD_SQL_SERVER\Sistemas\bd_empresa_log_02.ldf')
GO

/*Note que para cada archivo solamente se han especificado los 
parámetros Name y Filename, los valores de los parámetros Size, 
MaxSize y Filegrwoth los obtiene de model.*/


/*EJERCICIO 04. Crear la bd bd_sistemas con 4 archivos*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\respaldo'
GO

USE master
GO

IF DB_ID('bd_sistemas') IS NOT NULL
	DROP DATABASE bd_sistemas
GO

CREATE DATABASE bd_sistemas
ON(
	NAME='bd_sistemas_pri',
	FILENAME='C:\BD_SQL_SERVER\respaldo\bd_sistemas.mdf',
	SIZE=40MB,
	MAXSIZE=30GB,
	FILEGROWTH=50%
),(
	NAME='bd_sistemas_sec',
	FILENAME='C:\BD_SQL_SERVER\respaldo\bd_sistemas.ndf',
	SIZE=40MB,
	MAXSIZE=30GB,
	FILEGROWTH=20%
)
LOG ON(
	NAME='bd_sistemas_log',
	FILENAME='C:\BD_SQL_SERVER\respaldo\bd_sistemas.ldf',
	SIZE=40MB,
	MAXSIZE=30GB,
	FILEGROWTH=30%
),(
	NAME='bd_sistemas_log_aux',
	FILENAME='C:\BD_SQL_SERVER\respaldo\bd_sistemas_aux.ldf',
	SIZE=40MB,
	MAXSIZE=30GB,
	FILEGROWTH=60%
)
GO

/*En el ejercicio anterior se han creado dos archivos en en el 'filegroup' PRIMARY 
(note que no se escribió el nombre del grupo), además de especificar 
para cada archivo los parámetros de Size, MaxSize y Filegrowth.

NOTA:
Los archivos de datos secundarios (.ndf), se guardan por defecto dentro del 'Filegroup' PRIMARY, 
pero pueden guardarse en otro 'Filegroup' creado por el usuario sin ningún problema, tal como
se hizo en el EJERCICIO 03

Los archivos de registros (.ldf) no se alojan en ningún 'filegroup'
*/


-- Stored Procedure que permite ver los detalles de la Base de Datos
SP_HELPDB bd_sistemas
GO