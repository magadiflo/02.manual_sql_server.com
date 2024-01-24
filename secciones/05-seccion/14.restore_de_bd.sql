/*-- RESTORE DE UNA BASE DE DATOS --

Restaurar una base de datos en SQL Server
Pueden existir varios escenarios en los que se necesite restaurar una base de datos en SQL Server, 
en este artículo se describe como restaurar la base de datos completa a partir de una copia de 
seguridad completa. (Ver Copias de seguridad)

Restaurar la base de datos desde una copia de seguridad completa

Para restaurar la base de datos AdventureWorks de la que se tiene una copia de seguridad 
completa en la unidad C: en la carpeta Datos se deben seguir los siguientes pasos

1. En la ventana del explorador de objetos de SQL Server Management Studio desplegar el 
nodo «Bases de datos» (Databases), pulsar botón derecho y luego «Restaurar Base de datos» 
(Restore Database).

2. En la ventana del asistente para restaurar una base de datos seleccionar la 
opción «Dispositivo» (Device) y luego pulsar el botón con los Tres puntos.

3. Seleccionar el archivo de copia de seguridad completa. Pulsar Agregar (Add), 
para agregar el archivo de copia de seguridad.

4. Seleccionar la copia de seguridad completa, ubicada para este ejercicio en C:\Datos y pulsar Ok.
El archivo ya se encuetra agregado para ser restaurado. Pulsar Ok

5. Pulsar Ok para realizar la restauración de la copia de seguridad completa.
Debería aparecer el mensaje de confirmación.

Al actualizar las bases de datos en el explorador de objetos aparece AdventureWorks restaurada.

Script para restaurar la base de datos

USE [master]
RESTORE DATABASE [AdventureWorks]
FROM DISK = 'C:\Datos\AdventureWorks.bak'
WITH FILE = 1,
MOVE 'AdventureWorks' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\AdventureWorks.mdf',
MOVE 'AdventureWorks_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\AdventureWorks_log.ldf',
NOUNLOAD, STATS = 5
GO
*/