/*-- PARTICI�N HORIZONTAL DE TABLAS --*/
/*
Las tablas que tienen muchos registros es conveniente que se particionen, esto ser� 
beneficioso si la base de datos tiene varios archivos y de preferencia inclusive varios 
grupos en varios discos.

REQUISITOS
1. La base de datos deber�a tener varios archivos en varios grupos para que sea beneficioso. 
   La lectura de varios discos en tablas particionadas que tienen millones de registros es 
   m�s r�pida que si no se particiona.
2. Definir el tipo de dato y los l�mites para los rangos por los cuales se particionar� la tabla.
3. Crear la funci�n de partici�n para definir los l�mites. 
4. Crear el esquema de partici�n para asignar los rangos a cada grupo dentro de la BD.

PROCESO
1. Crear FUNCION DE PARTICION: el objetivo es definir los rangos
CREATE PARTITION FUNCTION Nombre ( TipoDato )
AS RANGE [ LEFT | RIGHT ] FOR VALUES ( l�mites)

2. Crear Esquema de Partici�n: objetivo, repartir los rangos definidos en la funci�n de 
   partici�n en los filegroups
CREATE PARTITION SCHEME Nombre
AS PARTITION NombreFuncion
TO ( Grupos de Archivos)

3. Crear tabla� al finalizar la definici�n de la tabla se debe especificar el esquema de 
   partici�n y el campo por el que se particionar�.
Create table  Nombre Tabla (NombreCampo, � ) on NombreEsquema (NombreCampo)
*/

/*EJERCICIO 01. Para este ejercicio se va a crear una tabla clientes, la base de datos
se va a crear en un solo disco, la unidad C:\, ser�a mejor crear los grupos de archivos en
unidades de disco diferentes. 
Los rangos se definen de acuerdo a las letras con las que comienza el c�digo, se 
han definido los l�mites con los caracteres D, L, Q y V.
*/

--Primero crear la base de datos
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BASES'
GO

DROP DATABASE IF EXISTS bd_erp
GO

CREATE DATABASE bd_erp
ON PRIMARY
(NAME='ERP01', FILENAME='C:\BD_SQL_SERVER\BASES\ERP01.mdf'),
FILEGROUP VENTAS
(NAME='ERP02', FILENAME='C:\BD_SQL_SERVER\BASES\ERP02.ndf'),
FILEGROUP RRHH
(NAME='ERP03', FILENAME='C:\BD_SQL_SERVER\BASES\ERP03.ndf')
LOG ON
(NAME='ERP04', FILENAME='C:\BD_SQL_SERVER\BASES\ERP04.ldf')
GO

USE bd_erp
GO

--Funci�n de partici�n
CREATE PARTITION FUNCTION fp_particion_clientes_codigo(CHAR(15))
AS RANGE LEFT FOR VALUES('D', 'L', 'Q', 'V')
GO

--Esquema de partici�n
CREATE PARTITION SCHEME ep_esquema_particion_clientes_codigo
AS PARTITION fp_particion_clientes_codigo
TO(RRHH, VENTAS, [PRIMARY], [PRIMARY], RRHH)
GO

CREATE TABLE clientes(
	codigo CHAR(15),
	paterno VARCHAR(50),
	materno VARCHAR(50),
	NOMBRES VARCHAR(50),
	CONSTRAINT pk_clientes PRIMARY KEY(codigo)
) ON ep_esquema_particion_clientes_codigo(codigo)
GO

/*
Para verificar lo realizado, vamos a las propiedades de la tabla clientes
opci�n de almacenamiento(storage), y en la parte derecha secci�n 
de Particionamiento(Partitioning) se observa la especificaci�n que es una 
tabla particionada por el campo codigo y el esquema 
ep_esquema_particion_clientes_codigo
*/