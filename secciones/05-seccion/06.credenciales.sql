/*-- CREDENCIALES EN SQL SERVER -- 

Credenciales
Una credencial es un objeto de SQL Server que contiene la informaci�n de autenticaci�n necesaria 
para acceder a un recurso cuyo acceso est� administrado fuera de SQL Server, por ejemplo una carpeta, 
una impresora, un recurso compartido asignado a una cuenta de Windows.

Consideraciones:
SQL Server utiliza internamente la informaci�n de la credencial.
Las credenciales incluyen generalmente un nombre de usuario y una contrase�a de Windows.
Si el inicio de sesi�n a SQL Server fue con una cuenta de SQL, se utiliza la credencial para 
permitir al usuario acceder a recursos situados fuera de la instancia del servidor.
Cuando el recurso externo es Windows, el usuario se autentica como el usuario de Windows especificado 
en la credencial.
Varios inicios de sesi�n de SQL Server pueden tener asignadas una �nica credencial, sin embargo, 
un inicio de sesi�n de SQL Server solo se puede asignar a una credencial.
Las credenciales del sistema se crean de forma autom�tica y se asocian a EndPoints espec�ficos.
Los nombres de las credenciales del sistema comienzan por dos signos de n�mero (##).

Creaci�n de Credenciales
Instrucci�n: Create Credential
Crea una credencial en SQL Server
Sintaxis:

Create Credential NombreCredencial WITH IDENTITY = �Identidad�
[ , SECRET = �password� ]
[ FOR CRYPTOGRAPHIC PROVIDER ProveedorCriptogr�fico ]

Donde:

NombreCredencial
Especifica el nombre de la credencial que se va a crear. NombreCredencial no puede comenzar por el signo de n�mero (#). Las credenciales del sistema comienzan por ##.

IDENTITY =�Identidad�
Especifica el nombre de la cuenta que se utilizar� para conectarse fuera del servidor.

SECRET =�password�
Especifica el secreto necesario para la autenticaci�n de salida. Esta cl�usula es opcional.

FOR CRYPTOGRAPHIC PROVIDER ProveedorCriptogr�fico
Especifica el nombre de un Proveedor de administraci�n de claves de la empresa (EKM).
*/
/*EJERCICIO 01. Crear una credencial con la cuenta de windows, el servidor se llama trainersql
y el usuario de windows es testerdba*/
USE master
GO

CREATE CREDENTIAL supervisor WITH IDENTITY = 'trainersql\testerdba', SECRET = '123'
GO

--Para listar las credenciales del servidor
SELECT * 
FROM SYS.CREDENTIALS
GO

/*
Importante
Una vez creada una credencial, puede asignarla a un inicio de sesi�n de SQL Server 
mediante CREATE LOGIN o ALTER LOGIN. (Ver Logins)
Un inicio de sesi�n de SQL Server solamente se puede asignar a una credencial, pero 
una credencial puede asignarse a varios inicios de sesi�n de SQL Server.
*/

/*EJERCICIO 02. Crear un inicio de sesi�n llamado PowerDBA y asignar la credencial Supervisor*/
CREATE LOGIN powerdba WITH password = '123', CREDENTIAL = supervisor
GO
