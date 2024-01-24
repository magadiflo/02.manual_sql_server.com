/*-- Funciones de servidor en SQL Server --

Server Roles en SQL Server

Funciones fijas de servidor

La administraci�n de la seguridad con los elementos de una base de datos es una tarea que necesita de 
mucho cuidado, es necesario que los asegurables presentes en la base de datos tengan los permisos 
requeridos y asignados adecuadamente a las entidades de seguridad.

Niveles de Seguridad en SQL Server
La seguridad se puede administrar para el servidor y tambi�n para una base de datos espec�fica. 
Cada nivel tiene sus elementos asegurables y sus entidades de seguridad.

Los niveles de seguridad son:

1. A nivel de Servidor
	En el nivel de servidor podemos administrar las siguientes entidades de seguridad

	* Funciones de servidor
	* Inicios de sesi�n

2. A nivel de Base de datos
	En el nivel de base de datos podemos trabajar con las siguientes entidades de seguridad

	* Funciones de base de datos
	* Usuarios de base de datos
	* Funciones de aplicaci�n
	
Se recomienda la revisi�n permanente de los cambios en los permisos.


Seguridad a nivel de Servidor
Funciones Fijas de servidor (Roles de Servidor)

Permiten administrar los permisos sobre los objetos del servidor. Desde SQL Server 2012 se pueden 
crear nuevas funciones de servidor y asignar permisos en los asegurables a nivel de servidor.

Las funciones fijas de servidor o roles de servidor son:

Rol fijo de servidor	Descripci�n
bulkadmin				Pueden ejecutar las opciones de copia masiva de datos usando la instrucci�n 
						BULK INSERT.
diskadmin				El rol fijo de servidor diskadmin se usa para administrar archivos de disco.
dbcreator				Pueden crear, modificar, quitar y restaurar cualquier base de datos.
public					Cada inicio de sesi�n de SQL Server pertenece al rol de servidor public.
sysadmin				Son los administradores del servidor y pueden realizar cualquier actividad 
						sin restricciones.
processadmin			Pueden finalizar los procesos que se ejecuten en una instancia de SQL Server.
serveradmin				Pueden cambiar las opciones de configuraci�n del servidor y apagarlo.
securityadmin			Administran los inicios de sesi�n y sus propiedades.  
						Pueden administrar los permisos de los asegurables a nivel de servidor usando 
						GRANT, DENY y REVOKE.

						Pueden administrar los permisos de los asegurables a nivel de base de datos 
						usando GRANT, DENY y REVOKE siempre que tengan acceso a una base de datos.
						A nivel de servidor pueden  restablecer contrase�as para  los inicios de 
						sesi�n de SQL Server.

setupadmin				Pueden agregar y quitar servidores vinculados mediante instrucciones 
						Transact-SQL.

Crear Roles o funciones fijas de servidor
Desde SQL Server 2012 es posible crear nuevos roles de servidor.

Instrucci�n Create server role
Permite crear un rol de servidor.

Sintaxis
Create server role NombreRol [Authorization InicioSesion]
*/

/*EJERCICIO 01. Crear un rol de servidor llamado administradores autorizado a SecurityAdmin*/
USE master
CREATE SERVER ROLE administradores AUTHORIZATION SECURITYADMIN
GO

/*EJERCICIO 02. Crear un rol de servidor llamado vendedores autorizado a gerenteVentas*/
USE master
CREATE SERVER ROLE vendedores AUTHORIZATION GERENTEVENTAS
GO

/*EJERCICIO 03. Listar los roles del servidor*/
SELECT name, type_desc 
FROM SYS.SERVER_PRINCIPALS
WHERE TYPE = 'R'
GO

--Para listar los roles fijos, no incluyen los creados por el usuario
SP_HELPSRVROLE
GO

/*EJERCICIO 04. Crear un rol de servidor llamado Logistica autorizado a ProcessAdmin.
El Script debe comprobar que el rol no existe.*/
USE master
IF NOT EXISTS(SELECT name, type_desc FROM SYS.SERVER_PRINCIPALS WHERE type = 'R' AND name = 'logistica')
	BEGIN
		CREATE SERVER ROLE logistica AUTHORIZATION PROCESSADMIN
	END
GO

/*Modificar roles de servidor

Instrucci�n: Alter server role
Permite agregar o quitar miembros al rol y cambiarle de nombre.

Sintaxis

Alter server role NombreRol
ADD MEMBER InicioSesion |
DROP MEMBER InicioSesion |
WITH NAME = NuevoNombre

Para agregar o quitar inicios de sesi�n a un rol se pueden usar los siguientes procedimientos almacenados del sistema.
Para agregar
sp_addsrvrolemember InicioSesi�n, Rol
Para quitar
sp_dropsrvrolemember InicioSesi�n, Rol

Ejemplos de modificaci�n de roles de servidor
*/

/*EJERCICIO 05. Crear un inicio de sesi�n llamado EmpresaDBA y hacerlo miembro Sysadmin*/
USE master
CREATE LOGIN EmpresaDBA WITH password = '123'
GO
ALTER SERVER ROLE SYSADMIN 
ADD MEMBER EmpresaDBA
GO

--Para visualizar los miembros del rol Sysadmin
SP_HELPSRVROLEMEMBER SYSADMIN
GO

/*EJERCCIO 06. Cambiar el nombre del rol vendedores por FuerzaVentas*/
USE master
ALTER SERVER ROLE vendedores WITH name = FuerzaVentas
GO

/*EJERCICIO 07. Quitar el inicio de sesi�n EmpresaDBA de sysadmin y hacerlo miembro de SecurityAdmin*/
USE master
ALTER SERVER ROLE SYSADMIN
DROP MEMBER EmpresaDBA

ALTER SERVER ROLE SECURITYADMIN
ADD MEMBER EmpresaDBA
GO

/*
Eliminaci�n de un rol de servidor
Instrucci�n: Drop server role
Permite eliminar un rol creado

Sintaxis:

Drop server role NombreRol

Nota: El rol debe estar vac�o, es decir, no debe tener miembros (Logins).

El listado de los roles de servidor y los inicios de sesi�n de cada uno
*/

SELECT p.name AS 'Rol de servidor', r.member_principal_id AS 'c�digo inicio sesi�n',
	l.name AS 'Nombre inicio sesi�n'
FROM SYS.SERVER_PRINCIPALS AS p
	INNER JOIN SYS.SERVER_ROLE_MEMBERS AS r ON p.principal_id = r.role_principal_id
	INNER JOIN SYS.SQL_LOGINS AS l ON r.member_principal_id = l.principal_id
WHERE p.type = 'R'
GO

/*Ejemplos de eliminaci�n de roles de servidor*/

--Eliminar el rol FuerzaVentas
USE master
DROP SERVER ROLE FuerzaVentas
GO

--Eliminar el rol gerentes
USE master
DROP SERVER ROLE gerentes
GO

--Note que aparece el mensaje: El rol tiene miembros. Debe estar vac�o antes de quitarlo.
--Para ver los miembros se utiliza la siguiente instrucci�n:

SELECT 
P.name As 'Rol de Servidor',
R.member_principal_id AS 'C�digo Inicio de Sesi�n',
L.name As 'Nombre Inicio de Sesi�n'
FROM sys.server_principals AS P
	join sys.server_role_members AS R on P.principal_id = R.role_principal_id
	join sys.sql_logins AS L on R.member_principal_id = L.principal_id
WHERE P.type = 'R'
GO

--El miembro que debemos eliminar es: GerenteVentas
ALTER SERVER ROLE Gerentes
DROP MEMBER GerenteVentas
GO

DROP SERVER ROLE Gerentes
GO