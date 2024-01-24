/*-- ROLES DE APLICACIÓN EN SQL SERVER --

- Una función de aplicación es un objeto de base de datos que permite que una aplicación 
  ejecute con sus propios permisos similares a los de un usuario.
- Puede utilizar funciones de aplicación para permitir el acceso a datos específicos sólo 
  a aquellos usuarios que se conectan a través de una aplicación concreta. A diferencia de 
  las funciones de la base de datos, las  funciones de la aplicación no contienen miembros 
  y están inactivas de forma predeterminada.
- Los roles de aplicación funcionan con ambos modos de autenticación.
- Las funciones de aplicación se habilitan mediante el procedimiento almacenado sp_setapprole, 
  que requiere una contraseña.
- Dado que los roles de aplicación son un principal de nivel de base de datos, pueden acceder 
  a otras bases de datos sólo a través de permisos concedidos en esas bases de datos al invitado. 
  Por lo tanto, cualquier base de datos en la que el invitado se haya inhabilitado será inaccesible 
  a las funciones de la aplicación en otras bases de datos.

Conectarse con un rol de aplicación
Para hacer efectivos los permisos de un rol de aplicación se siguen los siguientes pasos:
1. Un usuario ejecuta una aplicación cliente.
2. La aplicación cliente se conecta a una instancia de SQL Server como el usuario.
3. Desde la aplicación se ejecuta el procedimiento almacenado sp_setapprole guardado con una 
   contraseña conocida únicamente por la aplicación.
4. Si el nombre y la contraseña de la función de aplicación son válidos, se habilita la 
   función de aplicación.
5. En este punto, la conexión pierde los permisos del usuario y asume los permisos de la 
   función de la aplicación.
Los permisos se pierden al desconectarse de la aplicación.

Crear Roles de Aplicación
Instrucción: Create Application Role
Permite crear un rol de aplicación
Sintaxis:

CREATE APPLICATION ROLE NombreRolAplicacion
WITH PASSWORD = ‘password’ [, DEFAULT_SCHEMA = NombreEsquema ]

Donde:
NombreRolAplicacion es el nombre del rol de aplicación a crear.
DEFAULT_SCHEMA = NombreEsquema especifica el esquema por defecto para el rol de aplicación.

Modificar Roles de Aplicación
Instrucción: Alter Application Role
Permite modificar un rol de aplicación
Sintaxis:

ALTER APPLICATION ROLE NombreRolAplicacion
WITH NAME = NuevoNombre
| PASSWORD = ‘password’
| DEFAULT_SCHEMA = NombreEsquema

Donde:
NombreRolAplicacion es el nombre del rol de aplicación a modificar.
With name = NuevoNombre especifica el nuevo nombre para el rol de aplicación.
Password = ‘password’ permite especificar el nuevo password del rol de aplicación.
DEFAULT_SCHEMA = NombreEsquema especifica el esquema por defecto para el rol de aplicación.

Eliminar Roles de Aplicación
Instrucción: Drop Application Role
Permite eliminar un rol de aplicación
Sintaxis:

Drop APPLICATION ROLE NombreRolAplicacion

Donde:
NombreRolAplicacion es el nombre del rol de aplicación a eliminar.
*/
USE AdventureWorks
GO

/*EJERCICIO 01. Crear un rol de aplicación llamado ventas y asignarle el esquema sales*/
CREATE APPLICATION ROLE ventas WITH PASSWORD = '12345',
DEFAULT_SCHEMA = Sales
GO

/*EJERCICIO 02. Crear un rol de aplicación llamado administrador*/
CREATE APPLICATION ROLE administrador WITH PASSWORD = '12345'
GO

/*EJERCICIO 03. Asignar el permiso de lectura al rol Administrador sobre el esquema Production*/
GRANT SELECT ON SCHEMA::Production TO administrador
GO

/*EJERCICIO 04. Cambiar el password del rol de aplicación administrador a 'sinclave'*/
ALTER APPLICATION ROLE administrador WITH PASSWORD = 'sinclave'
GO

/*EJERCICIO 05. Cambiar el esquema del rol de aplicación Ventas a Purchasing*/
ALTER APPLICATION ROLE ventas
WITH DEFAULT_SCHEMA = purchasing
GO

/*EJERCICIO 06. Ver los roles de aplicación*/
SELECT * 
FROM SYS.DATABASE_PRINCIPALS
WHERE TYPE = 'A'
GO

/*
Activar un rol de aplicación
Procedimiento sp_setapprole
Activa los permisos asociados con el rol de aplicación en la base de datos.
Sintaxis:

sp_setapprole [ @rolename = ] ‘NombreRol’,
[ @password = ] { encrypt N’password’ }
[ @fCreateCookie = ] true | false ]
*/

/*EJERCICIO 07. Activar el rol de aplicación ventas*/
EXEC SP_SETAPPROLE ventas, 5286
GO

/*EJERCICIO 08. Crear un rol de aplicación llamado Contador, asignar el esquema 
Person y luego activar el rol de aplicación y crear una Cookie.*/
CREATE APPLICATION ROLE contador WITH PASSWORD = '12345'
GO
DECLARE @cookie VARBINARY(8000)
EXEC SP_SETAPPROLE contador, 12345,
@fCreateCookie = true, @cookie = @cookie OUTPUT
GO

/*
Procedimiento almacenado sp_unsetapprole
Desactiva un rol de aplicación y regresa al contexto de seguridad previo.
Sintaxis:

sp_unsetapprole @cookie

La @Cookie es creada por sp_setapprole
*/

/*EJERCICIO 09. Desactivar el rol de aplicación Contador*/
SP_UNSETAPPROLE @cookie
GO

/*Nota: Esta instrucción no se puede probar desde SQL Server, salvo que
ejecute en el mismo bloque la activación y desactivación del rol de aplicación.
Ejemplo
*/

/*EJERCICIO 10. Crear un rol de aplicación Almacen luego activarlo y desactivarlo 
mostrando el usuario del contexto.*/
CREATE APPLICATION ROLE almacen WITH PASSWORD = '12345'
GO
DECLARE @cookie VARBINARY(8000)
EXEC SP_SETAPPROLE almacen, 12345,
@fCreateCookie = true, @cookie = @cookie OUTPUT
SELECT SUSER_NAME() AS 'contexto aplicación'
EXEC SP_UNSETAPPROLE @cookie
SELECT USER_NAME() AS 'contexto por defecto'
GO

/*EJERCICIO 11. Eliminar el rol de aplicación almacen*/
DROP APPLICATION ROLE almacen
GO