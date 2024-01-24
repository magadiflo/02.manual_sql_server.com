/*-- Escenario disco duro lleno --*/
/*
En este post aprenderemos como solucionar el problema
cuando uno de los discos donde se encuentra la base de 
datos llena el mismo. La idea es que se tenga espacio 
para poder crear un archivo en otro disco que haya espacio, 
dar la posibilidad que la información de los sistemas en uso 
se pueda guardar y luego proceder a corregir el problema.

Es necesario anotar que este post muestra una de las posibles 
soluciones, existe otra forma que se incluirá en otro post. 
La otra forma de corregir es problema de un disco duro lleno 
es que se transfiera la información del archivo de la base 
de datos que está llenando el disco a otro archivo del mismo 
grupo ubicado en un disco duro diferente. Para este proceso se 
utiliza DBCC Shrinkfile con la opción EmptyFile.
*/

/*PRIMER PASO: Crearemos la base de datos*/
--La base de datos bd_sistemas será repartida en los discos C: y D:
XP_CREATE_SUBDIR 'C:\BD'
GO

XP_CREATE_SUBDIR 'D:\DATA\Respaldo'
GO

CREATE DATABASE bd_sistemas
ON PRIMARY
(NAME='S01', FILENAME='C:\BD\S01.mdf', SIZE=10MB, MAXSIZE=200GB, FILEGROWTH=5MB),
(NAME='S02', FILENAME='D:\DATA\S02.ndf'),
FILEGROUP VENTAS
(NAME='S03', FILENAME='D:\DATA\Respaldo\S03.ndf')
LOG ON
(NAME='L01', FILENAME='C:\BD\L01.ldf')
GO

/*ESCENARIO: La base de datos bd_sistemas está en C: y el disco está lleno*/
/*
SOLUCIÓN
---------
1. Crear un grupo de archivos nuevo, agregar un archivo al grupo nuevo creado
en un disco donde haya espacio y hacer el grupo nuevo por defecto
2. Cambiar la ubicación de los archivos
*/

/*PARTE 1. Se supone que en la unidad D: hay espacio, crear un grupo, 
agregar un archivo y hacer el grupo por defecto*/
XP_CREATE_SUBDIR 'D:\Temporal'
GO

ALTER DATABASE bd_sistemas
ADD FILEGROUP EMERGENCIA
GO

ALTER DATABASE bd_sistemas
ADD FILE(NAME='E01', FILENAME='D:\Temporal\E01.ndf')
TO FILEGROUP EMERGENCIA
GO

ALTER DATABASE bd_sistemas
MODIFY FILEGROUP EMERGENCIA DEFAULT
GO

/*PARTE 2. Cambie la ubicación de los archivos del disco C:
El archivo que se deben cambiar de ubicación es S01.mdf*/

ALTER DATABASE bd_sistemas
MODIFY FILE(NAME='S01', FILENAME='D:\Temporal\S01.mdf')
GO

/*
Mensaje: Se ha modificado el archivo «S01»  en el 
catálogo del sistema. La nueva ruta se usará la próxima 
vez que se inicie la base de datos.
*/

/*PASOS FINALES. 
1. Poner sin conexión la base de datos, para esto desde el Management Studio de SQL
Server pulsar el botón derecho de la BD, seleccioanr Tareas y luego poner sin conexión

2. Separar la BD, pulsar el botón derecho en la BD, luego seleccionar Tarea y luego separar
--Se puede usar el sp: sp_detach nombre_de_la_bd

3. Copiar el archivo a la nueva ubicación. Desde el explorador de window copiar el
archivo de la unidad C: ubicado en la carpeta C:\BD a la nueva ubicación D:\Temporal

4. Para finalizar, adjuntar  la base de datos, se debe especificar la nueva ubicación
del archivo movido
*/

USE master
GO

CREATE DATABASE bd_sistemas
ON
( FILENAME = 'D:\Temporal\S01.mdf' ),
( FILENAME = 'C:\BD\L01.ldf' ),
( FILENAME = 'D:\Data\S02.ndf' ),
( FILENAME = 'D:\Data\Respaldo\S03.ndf' )
FOR ATTACH
GO