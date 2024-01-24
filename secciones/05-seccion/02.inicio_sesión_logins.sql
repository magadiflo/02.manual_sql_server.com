/*-- Inicios de sesión - Logins --

Entidad de seguridad que permite iniciar sesión en SQL Server y a los que se les puede asignar 
permisos sobre los asegurables a nivel de servidor. Es posible crear inicios de sesión basados 
en cuentas de Windows o inicios de sesión de SQL Server.

Para poder conectarse con un inicio de sesión de SQL Server se debe implementar el inicio de 
sesión mixto en SQL Server.

Después de crear un inicio de sesión se deben asignar los permisos sobre los asegurables a nivel 
de servidor, si se desea asignar permisos sobre asegurables en una base de datos se debe relacionar 
este inicio de sesión con un usuario de base de datos.

Crear inicios de sesión

Instrucción: Create Login

Crea un inicio de sesión.

Sintaxis

Create login NombreLogin with password = ‘password’
[ MUST_CHANGE ]
| DEFAULT_DATABASE = database
| DEFAULT_LANGUAGE = language
| CHECK_EXPIRATION = { ON | OFF}
| CHECK_POLICY = { ON | OFF}

Donde:

NombreLogin: es el nombre del inicio de sesión
MUST_CHANGE: obliga al inicio de sesión a cambiar su contraseña al iniciar
sesión por primera vez. Esta opción funciona correctamente cuando la opción
CHECK_EXPIRATION es igual a ON. Esta opción es válida solamente para los inicios de 
sesión de SQL Server.
DEFAULT_DATABASE = database especifica la base de datos por defecto.
DEFAULT_LANGUAGE = language especifica el lenguaje por defecto.
CHECK_POLICY = { ON | OFF} establece si rigen las reglas de las políticas implementadas en 
el servidor de Windows Server.

Procedimiento almacenado sp_addlogin
Permite agregar un inicio de sesión al servidor de SQL Server.

Sintaxis

sp_addlogin login, password

Modificar un inicio de sesión
Instrucción Alter Login
Permite modificar las opciones de un inicio de sesión.

Sintaxis:

Alter login NombreLogin Disable | Enable
UNLOCK | with NAME = NuevoNombre

Donde:
Disable | Enable: permite inhabilitar o habilitar un inicio de sesión.
UNLOCK: desbloquea un inicio de sesión.
Name = NuevoNombre permite cambiar el nombre del inicio de sesión.

Eliminar un inicio de sesión
Instrucción: Drop Login
Permite eliminar un inicio de sesión de SQL Server.

Sintaxis
Drop Login NombreLogin

Procedimiento almacenado sp_droplogin
Permite eliminar un inicio de sesión al servidor de SQL Server.
Sintaxis:
sp_droplogin NombreInicioSesion
*/

/*EJERCICIO 01. Crear inicio de sesión llamado asistente*/
USE master
GO
CREATE LOGIN asistente WITH password = '123'
GO

/*EJERCICIO 02. Crear un login llamado apoyo*/
SP_ADDLOGIN apoyo
GO

--NOTA: evite el uso de SP_ADDlOGIN, como puede notar, es posible crear un inicio de sesión
--sin password

/*EJERCICIO 03. Hacer miembro de bulkadmin al inicio llamado Apoyo */
ALTER SERVER ROLE BULKADMIN 
ADD MEMBER apoyo
GO

/*EJERCICIO 04. Ver los miembros del rol bulkadmin*/
SP_HELPSRVROLEMEMBER BULKADMIN
GO

/*EJERCICIO 05. Listado de los administradores del sistema*/
SP_HELPSRVROLEMEMBER SYSADMIN
GO

/*EJERCICIO 06. Miembros de ProcessAdmin*/
SP_HELPSRVROLEMEMBER PROCESSADMIN
GO

/*EJERCICIO 07. Hacer el login asistente miembro del rol de servidor de administradores*/
SP_ADDSRVROLEMEMBER asistente, administradores
GO

/*EJERCICIO 08. Listar las funciones de servidor y los inicios de sesión.*/
SELECT p.name AS [Rol de servidor], r.member_principal_id AS 'código inicio de sesión',
	l.name AS 'nombre de inicio de seesión'
FROM SYS.SERVER_PRINCIPALS AS p
	INNER JOIN SYS.SERVER_ROLE_MEMBERS AS r ON p.principal_id = r.role_principal_id
	INNER JOIN SYS.SQL_LOGINS AS l ON r.member_principal_id = l.principal_id
WHERE p.type = 'R'
ORDER BY [Rol de servidor]
GO

/*EJERCICIO 08. Crear los inicios jefe, auditor y reportes, primero comprobar si existen*/
IF NOT EXISTS(SELECT * FROM SYS.SQL_LOGINS WHERE NAME = 'jefe')
	BEGIN
		CREATE LOGIN jefe WITH PASSWORD = '123'
	END
IF NOT EXISTS(SELECT * FROM SYS.SQL_LOGINS WHERE NAME = 'auditor')
	BEGIN
		CREATE LOGIN auditor WITH PASSWORD = '123'
	END
IF NOT EXISTS(SELECT * FROM SYS.SQL_LOGINS WHERE NAME = 'reportes')
	BEGIN
		CREATE LOGIN reportes WITH PASSWORD = '123'
	END
GO

/*EJERCICIO 09. Agregar al rol de servidor diskadmin el inicio auditor*/
ALTER SERVER ROLE DISKADMIN
ADD MEMBER auditor
GO

/*EJERCICIO 10. Agregar al rol de servidor dbcreator el inicio reportes*/
SP_ADDSRVROLEMEMBER reportes, dbcreator
GO

/*EJERCICIO 11. Crear un login con la cuenta de windows.
Crear un inicio de sesión con una cuenta de Windows TrainerSQL, el servidor es OneServer*/
CREATE LOGIN [OneServer\Trainer] FROM WINDOWS
GO

/*EJERCICIO 12. Crear inicio llamado Secretaria que cambie su clave al autenticarse*/
CREATE LOGIN secretaria WITH PASSWORD = '154'
MUST_CHANGE, 
CHECK_EXPIRATION = ON
GO