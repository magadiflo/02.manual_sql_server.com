/*-- Funciones de base de datos --

Funciones de Base de datos (Roles de Base de Datos)
Permiten administrar los permisos sobre los objetos de la base de datos
La administración de los permisos sobre los asegurables a nivel de base de datos es mas sencilla 
usando funciones de base de datos.

Existen dos tipos de funciones de base de datos

1. Funciones fijas de base de datos, las que se encuentran definidas  en todas las bases de datos.
2. Funciones de base de datos, llamadas también funciones flexibles que son los tipos de funciones 
de base de datos que se pueden crear.

Funciones fijas de base de datos.
Función de Base de datos	Descripción
db_owner					Pueden realizar todas las actividades de configuración y mantenimiento 
							en la base de datos y también pueden quitar la base de datos.
db_backupoperator			Pueden crear copias de seguridad de la base de datos.
db_ddladmin					Pueden ejecutar cualquier comando del lenguaje de definición de datos (DDL)
							en una base de datos.
db_denydatawriter			No pueden agregar, modificar ni eliminar datos de tablas de usuario de una 
							base de datos.
db_denydatareader			No pueden leer datos de las tablas de usuario dentro de una base de datos.
db_datawriter				Pueden agregar, eliminar o cambiar datos en todas las tablas de usuario.
db_datareader				Pueden leer todos los datos de todas las tablas de usuario.
db_securityadmin			Pueden modificar la pertenencia a roles y administrar permisos. Si se 
							agregan entidades de seguridad a este rol, podría habilitarse un aumento 
							de privilegios no deseado.
db_accessadmin				Pueden agregar o quitar el acceso a la base de datos para inicios de 
							sesión de Windows, grupos de Windows e inicios de sesión de SQL Server.

Tabla de las funciones fijas de base de datos en SQL Server

Crear funciones de base de datos
Instrucción: Create Role
Permite crear un rol de base de datos.

Sintaxis:

Crear: Create role NombreRol [Authorization Usuario]

Donde:
NombreRol: es el nombre del rol de base de datos a crear.
Authorization Usuario: Usuario de base de datos o rol que es el dueño del rol creado.  
Si no se especifica el dueño es el usuario que lo crea.

Modificar las funciones de base de datos

Instrucción: Alter Role
Permite modificar un rol de base de datos.

Sintaxis:

Alter role NombreRol
[ ADD MEMBER Principal ]
| [ DROP MEMBER Principal ]
| [ WITH NAME = NuevoNombre ]

Donde:
NombreRol: es el nombre del rol a modificar.
ADD MEMBER Usuario: especifica el usuario o rol creado por el usuario que se incluye como miembro.
DROP MEMBER Usuario: especifica el usuario o rol creado por el usuario que se elimina del rol.
WITH NAME = NuevoNombre: especifica el nuevo nombre del rol de base de datos.

Procedimientos almacenados sp_addrolemember y sp_droprolemember
Permiten agregar o eliminar los miembros de una función de base de datos.

Agregar un usuario a un Rol o función de base de datos.
sp_addrolemember RolBaseDatos, UsuarioBaseDatos

Quitar un usuario de un Rol o función de base de datos.
sp_droprolemember RolBaseDatos, UsuarioBaseDatos

Procedimiento almacenado sp_helprolemember
Permite visualizar los miembros de un rol de servidor
Sintaxis
sp_helprolemember RolDeBaseDatos


Eliminar un rol de base de datos

Instrucción: Drop role NombreRol
Permite eliminar el rol de base de datos creado por el usuario.
Sintaxis:

Drop role NombreRol

Nota: El rol debe ser un rol flexible y no debe tener miembros

Para listar los roles de servidor:
select * from sys.database_principals where type = ‘R’
go

Los roles fijos se pueden listad con el procedimiento almacenado sp_helprole
sp_helprole
go
*/
USE Northwind
GO
/*EJERCICIO 01. Crear un rol de base de datos llamado reportes*/
CREATE ROLE reportes
GO

/*EJERCICIO 02. Crear un rol de base de datos llamado Gestion autorizando a Reportes 
como su propietario*/
CREATE ROLE gestion AUTHORIZATION reportes
GO

/*EJERCICIO 03. Listar los roles de base de datos*/
SELECT * 
FROM SYS.DATABASE_PRINCIPALS
WHERE TYPE = 'R'
GO

/*EJERCICIO 04. Listar los roles fijos de la base de datos*/
SELECT * 
FROM SYS.DATABASE_PRINCIPALS
WHERE TYPE = 'R' AND IS_FIXED_ROLE = 1
GO

/*EJERCICIO 05. Ver los miembros de rol db_owner*/
SP_HELPROLEMEMBER db_owner
GO

/*EJERCICIO 06. Crear un inicio de sesión llamado Jefe, crear un usuario en Northwind 
llamado TrainerSQL (Ver Usuarios de Base de datos)  en base al inicio de sesión Jefe y 
hacerlo miembro de db_securityadmin*/
USE master
GO

CREATE LOGIN jefe WITH PASSWORD = '12345'
GO

USE Northwind
GO

CREATE USER trainersql
FROM LOGIN jefe
GO

ALTER ROLE DB_SECURITYADMIN
ADD MEMBER trainersql
GO

/*EJERCICIO 07. Ver los miembros del rol de base de datos db_securityadmin*/
SP_HELPROLEMEMBER db_securityadmin
GO

/*EJERCICIO 08. Cambiar de nombre el rol de base de datos llamado Gestion por Administracion*/
ALTER ROLE gestion
WITH NAME = administracion
GO

/*EJERCICIO 09. Crear el rol de base de datos llamado servicio_venta, considere si el rol existe*/
IF NOT EXISTS(SELECT * FROM SYS.DATABASE_PRINCIPALS WHERE TYPE = 'R' AND NAME = 'servicio_venta')
	BEGIN
		CREATE ROLE servicio_venta
	END
GO

/*Nota: el código para crear el rol de base de datos llamado ServicioVenta no reporta error
si el rol existe, lo que puede ocurrir con las instruccciones anteriores si el rol a crear existe.*/

/*EJERCICIO 10. Eliminar el rol de base de datos llamado administración*/
DROP ROLE administracion
GO

/*EJERCICIO 11. Quitar el usuario trainersql del rol de base de datos db_securityadmin*/
ALTER ROLE db_securityadmin 
DROP MEMBER trainersql
GO