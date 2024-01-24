/*-- ROLES DE APLICACI�N EN SQL SERVER --

- Una funci�n de aplicaci�n es un objeto de base de datos que permite que una aplicaci�n 
  ejecute con sus propios permisos similares a los de un usuario.
- Puede utilizar funciones de aplicaci�n para permitir el acceso a datos espec�ficos s�lo 
  a aquellos usuarios que se conectan a trav�s de una aplicaci�n concreta. A diferencia de 
  las funciones de la base de datos, las  funciones de la aplicaci�n no contienen miembros 
  y est�n inactivas de forma predeterminada.
- Los roles de aplicaci�n funcionan con ambos modos de autenticaci�n.
- Las funciones de aplicaci�n se habilitan mediante el procedimiento almacenado sp_setapprole, 
  que requiere una contrase�a.
- Dado que los roles de aplicaci�n son un principal de nivel de base de datos, pueden acceder 
  a otras bases de datos s�lo a trav�s de permisos concedidos en esas bases de datos al invitado. 
  Por lo tanto, cualquier base de datos en la que el invitado se haya inhabilitado ser� inaccesible 
  a las funciones de la aplicaci�n en otras bases de datos.

Conectarse con un rol de aplicaci�n
Para hacer efectivos los permisos de un rol de aplicaci�n se siguen los siguientes pasos:
1. Un usuario ejecuta una aplicaci�n cliente.
2. La aplicaci�n cliente se conecta a una instancia de SQL Server como el usuario.
3. Desde la aplicaci�n se ejecuta el procedimiento almacenado sp_setapprole guardado con una 
   contrase�a conocida �nicamente por la aplicaci�n.
4. Si el nombre y la contrase�a de la funci�n de aplicaci�n son v�lidos, se habilita la 
   funci�n de aplicaci�n.
5. En este punto, la conexi�n pierde los permisos del usuario y asume los permisos de la 
   funci�n de la aplicaci�n.
Los permisos se pierden al desconectarse de la aplicaci�n.

Crear Roles de Aplicaci�n
Instrucci�n: Create Application Role
Permite crear un rol de aplicaci�n
Sintaxis:

CREATE APPLICATION ROLE NombreRolAplicacion
WITH PASSWORD = �password� [, DEFAULT_SCHEMA = NombreEsquema ]

Donde:
NombreRolAplicacion es el nombre del rol de aplicaci�n a crear.
DEFAULT_SCHEMA = NombreEsquema especifica el esquema por defecto para el rol de aplicaci�n.

Modificar Roles de Aplicaci�n
Instrucci�n: Alter Application Role
Permite modificar un rol de aplicaci�n
Sintaxis:

ALTER APPLICATION ROLE NombreRolAplicacion
WITH NAME = NuevoNombre
| PASSWORD = �password�
| DEFAULT_SCHEMA = NombreEsquema

Donde:
NombreRolAplicacion es el nombre del rol de aplicaci�n a modificar.
With name = NuevoNombre especifica el nuevo nombre para el rol de aplicaci�n.
Password = �password� permite especificar el nuevo password del rol de aplicaci�n.
DEFAULT_SCHEMA = NombreEsquema especifica el esquema por defecto para el rol de aplicaci�n.

Eliminar Roles de Aplicaci�n
Instrucci�n: Drop Application Role
Permite eliminar un rol de aplicaci�n
Sintaxis:

Drop APPLICATION ROLE NombreRolAplicacion

Donde:
NombreRolAplicacion es el nombre del rol de aplicaci�n a eliminar.
*/
USE AdventureWorks
GO

/*EJERCICIO 01. Crear un rol de aplicaci�n llamado ventas y asignarle el esquema sales*/
CREATE APPLICATION ROLE ventas WITH PASSWORD = '12345',
DEFAULT_SCHEMA = Sales
GO

/*EJERCICIO 02. Crear un rol de aplicaci�n llamado administrador*/
CREATE APPLICATION ROLE administrador WITH PASSWORD = '12345'
GO

/*EJERCICIO 03. Asignar el permiso de lectura al rol Administrador sobre el esquema Production*/
GRANT SELECT ON SCHEMA::Production TO administrador
GO

/*EJERCICIO 04. Cambiar el password del rol de aplicaci�n administrador a 'sinclave'*/
ALTER APPLICATION ROLE administrador WITH PASSWORD = 'sinclave'
GO

/*EJERCICIO 05. Cambiar el esquema del rol de aplicaci�n Ventas a Purchasing*/
ALTER APPLICATION ROLE ventas
WITH DEFAULT_SCHEMA = purchasing
GO

/*EJERCICIO 06. Ver los roles de aplicaci�n*/
SELECT * 
FROM SYS.DATABASE_PRINCIPALS
WHERE TYPE = 'A'
GO

/*
Activar un rol de aplicaci�n
Procedimiento sp_setapprole
Activa los permisos asociados con el rol de aplicaci�n en la base de datos.
Sintaxis:

sp_setapprole [ @rolename = ] �NombreRol�,
[ @password = ] { encrypt N�password� }
[ @fCreateCookie = ] true | false ]
*/

/*EJERCICIO 07. Activar el rol de aplicaci�n ventas*/
EXEC SP_SETAPPROLE ventas, 5286
GO

/*EJERCICIO 08. Crear un rol de aplicaci�n llamado Contador, asignar el esquema 
Person y luego activar el rol de aplicaci�n y crear una Cookie.*/
CREATE APPLICATION ROLE contador WITH PASSWORD = '12345'
GO
DECLARE @cookie VARBINARY(8000)
EXEC SP_SETAPPROLE contador, 12345,
@fCreateCookie = true, @cookie = @cookie OUTPUT
GO

/*
Procedimiento almacenado sp_unsetapprole
Desactiva un rol de aplicaci�n y regresa al contexto de seguridad previo.
Sintaxis:

sp_unsetapprole @cookie

La @Cookie es creada por sp_setapprole
*/

/*EJERCICIO 09. Desactivar el rol de aplicaci�n Contador*/
SP_UNSETAPPROLE @cookie
GO

/*Nota: Esta instrucci�n no se puede probar desde SQL Server, salvo que
ejecute en el mismo bloque la activaci�n y desactivaci�n del rol de aplicaci�n.
Ejemplo
*/

/*EJERCICIO 10. Crear un rol de aplicaci�n Almacen luego activarlo y desactivarlo 
mostrando el usuario del contexto.*/
CREATE APPLICATION ROLE almacen WITH PASSWORD = '12345'
GO
DECLARE @cookie VARBINARY(8000)
EXEC SP_SETAPPROLE almacen, 12345,
@fCreateCookie = true, @cookie = @cookie OUTPUT
SELECT SUSER_NAME() AS 'contexto aplicaci�n'
EXEC SP_UNSETAPPROLE @cookie
SELECT USER_NAME() AS 'contexto por defecto'
GO

/*EJERCICIO 11. Eliminar el rol de aplicaci�n almacen*/
DROP APPLICATION ROLE almacen
GO