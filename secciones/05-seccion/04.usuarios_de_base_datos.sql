/*-- Usuarios de base de datos en SQL Server --

Usuarios de Base de datos
Conceptos 

El usuario de la base de datos es la identidad del inicio de sesión cuando está conectado 
a una base de datos.

El usuario de la base de datos puede utilizar el mismo nombre que el inicio de sesión, 
pero no es necesario.

El usuario es la entidad de seguridad a la que se les puede asignar permisos sobre los 
objetos de la base de datos.

Un inicio de sesión se puede asignar a bases de datos diferentes como usuarios diferentes 
pero solo se puede asignar como un usuario en cada base de datos.

Se pueden crear usuarios de base de datos sin inicios de sesión, estos no podrán iniciar 
sesión pero si se pueden asignar permisos.

Crear Usuarios
Instrucción: Create user
Permite crear un usuario de base de datos.
Sintaxis:

Para crear un usuario en base a un inicio de sesión de SQL Server

Create user NombreUsuario from Login InicioSesion

Para crear un usuario en base a una cuenta de Windows

Create user NombreUsuario for Login UsuarioWindows

Para especificar el usuario de Windows se escribe el nombre del equipo, el backslash y 
el nombre del usuario. El siguiente código crea un usuario de base de datos Fernando en 
base al usuarios de Windows FernandoLuque del servidor LondonPRO

CREATE USER [Fernando] FOR LOGIN [LondonPRO\FernandoLuque]
GO

Procedimiento almacenado sp_adduser

Permite añadir un usuario a la base de datos
Sintaxis:

sp_adduser [ @loginame = ] ‘login’
[ , [ @name_in_db = ] ‘user’ ]
[ , [ @grpname = ] ‘rol_de_BaseDatos’ ]

Donde:
@loginame = ‘login’ especifica el nombre del inicio de sesión.
@name_in_db = ‘user’ especifica el nombre del usuario a crear.
@grpname = ‘rol_de_BaseDatos’ especifica el nombre del rol de base de datos del que se hace miembro.

Modificar el usuario
Instrucción: Alter user
Permite la modificación de un usuario, donde es posible cambiar el nombre, asignarle un login o inicio de sesión y cambiarle el password.
Sintaxis:

ALTER USER userName
WITH NAME = NuevoNombre
| LOGIN = NombreLogin
| PASSWORD = ‘password’ [ OLD_PASSWORD = ‘oldpassword’ ]

Donde:
WITH NAME = NuevoNombre permite especificar el nuevo nombre del usuario.
LOGIN = NombreLogin permite asignar un login al usuario.
PASSWORD = ‘password’ [ OLD_PASSWORD = ‘oldpassword’ ] permite cambiar el password al usuario.

Eliminar usuarios
Instrucción: Drop user
Permite eliminar un usuario de base de datos.
Sintaxis:

Drop user NombreUsuario

Consideraciones:

El usuario no se puede eliminar si se encuentra iniciada su sesión.
El usuario no se puede eliminar si es propietario de alguna base de datos.
El usuario no se puede eliminar si la cuenta está deshabilitad
*/
/*EJERCICIO 01. Crear un usuario para Northwind llamado Capataz en base al mismo login
Asignar permisos de Lectura, Inserción y Actualización en toda la BD*/
USE master
GO

CREATE LOGIN capataz WITH PASSWORD = '12345'
GO

USE Northwind
GO

CREATE USER capataz FROM LOGIN capataz
GO

GRANT SELECT, INSERT, UPDATE TO capataz
DENY DELETE to capataz
GO

/*EJERCICIO 02. Crear un usuario en base a la cuenta de Windows, el servidor es OneServer 
y la cuenta de inicio de Windows es TeamServer, asignarle el esquema db_ddladmin*/
USE Northwind
GO

CREATE USER trainersql FOR LOGIN [OneServer\TeamServer] WITH DEFAULT_SCHEMA = [db_ddladmin]
GO

/*EJERCICIO 03. Crear en AdventureWorks un usuario AsistenteRH en base a un login del mismo  
nombre que tenga permisos de lectura y escritura en el esquema Person*/
USE master
GO

CREATE LOGIN asistenterh WITH PASSWORD = '12345'
GO

USE AdventureWorks
GO

CREATE USER asistenterh FROM LOGIN asistenterh
GO

--Permisos
GRANT SELECT, UPDATE ON SCHEMA::Person TO asistenterh
DENY INSERT, DELETE ON SCHEMA::Person TO asistenterh
GO
/*
Crear en AdventureWorks un usuario AsistenteRH en base a un login del mismo  nombre que tenga 
permisos de lectura y escritura en el esquema Person
*/

/*EJERCICIO 04. Crear un usuario en AdventureWorks llamado Vendedor en base al mismo login y 
asignar permisos de lectura, escritura y modificación en el esquema Sales.*/
USE master
GO

CREATE LOGIN vendedor WITH PASSWORD = '12345'
GO

USE AdventureWorks
GO

SP_ADDUSER vendedor, vendedor
GO

--Los permisos
GRANT SELECT, INSERT, UPDATE ON SCHEMA::Sales TO vendedor
DENY DELETE ON SCHEMA::Sales TO vendedor
GO

/*EJERCICIO 05. Listar los usuarios de la base de datos AdventureWorks*/
USE AdventureWorks
GO

SELECT name, principal_id, type, type_desc, default_schema_name
FROM SYS.DATABASE_PRINCIPALS WHERE TYPE = 'S'
GO

/*EJERCICIO 06. Crear un usuario JefeRecursos en AdventureWorks
en base al mismo login y asignar permisos en el esquema HumanResources.
Permisos: Select, Insert, Update, Denegar: Delete*/
USE master
GO

CREATE LOGIN jefe_recursos WITH PASSWORD = '12345'
GO

USE AdventureWorks
GO

CREATE USER jefe_recursos FROM LOGIN jefe_recursos
GO

--Permisos
GRANT SELECT, INSERT, UPDATE ON SCHEMA::HumanResources TO jefe_recursos
DENY DELETE ON SCHEMA::HumanResources TO jefe_recursos
GO

/*Ejercicio 07. Crear un usuario user_copias en base al login alta_disponibilidad
y hacerlo miembro de db_backupoperator*/
USE master
GO

CREATE LOGIN alta_disponibilidad WITH PASSWORD='12345'
GO

USE AdventureWorks
GO

CREATE USER user_copias FROM LOGIN alta_disponibilidad
GO

ALTER ROLE db_backupoperator 
ADD MEMBER user_copias
GO

/*EJERCICIO 08. Usuario en base al de windows - trainersqlwin. Se supone que 
el suuario de windows existe. El equipo donde se creará es serverLondres*/
USE [Northwind]
GO
CREATE USER [Jose] FOR LOGIN [ServerLondres\TrainerSQLWin]
WITH DEFAULT_SCHEMA=[dbo]
GO