/*-- CREDENCIALES EN SQL SERVER MODIFICACIÓN - ELIMINACIÓN --

Una credencial es un objeto de SQL Server que contiene la información de autenticación 
necesaria para acceder a un recurso cuyo acceso está administrado fuera de SQL Server, por 
ejemplo una carpeta, una impresora, un recurso compartido asignado a una cuenta de Windows. 
(Ver credenciales en SQL Server)

Crear Credenciales

Para crear credenciales se utiliza la instrucción Create credencial. Para crear la credencial
llamada TrainerCredencial en base al usuario de Windows TestCredenciales en el equipo CubilTrainer
se utiliza la siguiente instrucción
USE [master]
GO
CREATE CREDENTIAL TrainerCredencial
WITH IDENTITY = ‘CubilTrainer\TestCredenciales’, SECRET = ‘123’
GO

Para listar las credenciales
select * from sys.credentials
go

Modificación de credenciales

Instrucción Alter Credencial
Permite modificar una credencial, las opciones posibles son: cambiar la identidad, es decir, el usuario de Windows de la identidad y cambiar el password.
Sintaxis
ALTER CREDENTIAL NombreCredencial
WITH IDENTITY = ‘NombreIdentidad’
[ , SECRET = ‘password’ ]
go

Importante:
Cuando se cambia una credencial, se restablecen los valores de NombreIdentidad y secret. Si no se especifica el argumento SECRET opcional, el valor del secreto cambiará a NULL.
El Password se encripta utilizando la clave maestra del servicio. Si la clave maestra de servicio se regenera, el Password se vuelve a cifrar utilizando la nueva clave maestra de servicio.
La información sobre las credenciales se puede ver en la vista del catálogo sys.credentials.
Permisos necesarios (Ver Grant para asignar permisos)

Requiere ALTER ANY Credential
Si la credencial es una credencial del sistema, se requiere el permiso CONTROL SERVER.
*/

/*EJERCICIO 01. Cambiar el Password (secret) de la credencial TrainerCredencial*/
ALTER CREDENTIAL TrainerCredencial
WITH IDENTITY = 'CubilTrainer\TestCredenciales',
SECRET = '12345'
GO

/*EJERCICIO 02. Eliminar el password (secret) de la credencial TrainerCredencial*/
ALTER CREDENTIAL TrainerCredential 
WITH IDENTITY = 'CubilTrainer\TestCredenciales'
GO

/*
Eliminación de credenciales

Instrucción Drop Credencial

Permite eliminar una credencial
Sintaxis
DROP CREDENTIAL NombreCredencial
go

Permisos necesarios (Ver Grant para asignar permisos)

Requiere ALTER ANY Credential
Si la credencial es una credencial del sistema, se requiere el permiso CONTROL SERVER.
*/

/*EJERCICIO 03. Eliminar la credencial TrainerCredencial*/
DROP CREDENTIAL TrainerCredencial
GO