/*-- FIRMAR UN SP CON CERTIFICADO SQL SERVER --

Firmar los procedimientos almacenados usando un certificado es muy útil si se desea 
asignar permisos para la ejecución del procedimiento almacenado sin conceder 
explícitamente esos derechos al usuario usando Grant (Ver Permisos con Grant).

USO DE EXECUTE AS
El uso de Execute As permite la ejecución de un procedimiento almacenado sin necesidad 
de haber iniciado la sesión con el usuario que tiene permisos para ejecutar el 
procedimiento, los certificados de SQL server permiten realizar un seguimiento para 
buscar al autor de la ejecución original del procedimiento almacenado.

El uso de los procedimientos almacenados firmados permite un alto nivel de auditoría, 
especialmente durante las operaciones de seguridad o de lenguaje de definición de datos 
(DDL) que son las instrucciones Create, Alter o Drop.

NIVELES DE PERMISOS DE LOS CERTIFICADOS
- PERMISO A NIVEL DE SERVIDOR
  Si se crea un certificado en la base de datos «master» se permiten permisos de nivel de servidor.

- PERMISO A NIVEL DE BASE DE DATOS DE USUARIO
  Si se crea un certificado en la base de datos de usuario se asignan los permisos a nivel de la base
  de datos.

PASOS PARA FIRMAR UN PROCEDIMIENTO ALMACENADO
Los pasos para firmar los procedimientos almacenados para conseguir mejor nivel de auditoría y seguridad 
son los que se describen a continuación:

1. Crear un usuario en base a un login para asginar los permisos.
2. Crear un certificado de SQLServer
3. Crear un procedimiento almacenado y firmarlo con el certificado creado
4. Asignar los permisos para ejecutar el SP
*/

/*EJERCICIO 01. Usando la BD de Northwind, crear un SP que listará los productos y firmarlo
con un certificado*/

--1. Crear login y usuario
USE master
GO

CREATE LOGIN trainerSQL WITH password = '123'
GO

USE Northwind
GO

CREATE USER trainerUserConLogin
FROM LOGIN trainerSQL
GO

--2. Crear el certificado
CREATE CERTIFICATE trainerCertificado
ENCRYPTION BY PASSWORD = 'TSQLCertificadoSP'
WITH SUBJECT = 'Certificado para prueba de cifrado SP',
EXPIRY_DATE = '2025-05-15'
GO

--Para listar los certificados
SELECT * FROM SYS.CERTIFICATES
GO

--3. Crear el procedimiento y firmarlo con el certificado
CREATE PROCEDURE sp_productos_listado
AS
	SELECT p.ProductID AS 'código', P.ProductName AS 'descripcion', p.UnitPrice AS 'precio'
	FROM Products AS p

	--Ver el usuario que lo ejecuta no es parte del SP
	SELECT principal_id AS 'codigo usuario', name AS 'nombre'
	FROM SYS.USER_TOKEN
GO

--4. Para asignar el certificado al SP se necesita obviamente el nombre del certificado y su password
ADD SIGNATURE TO sp_productos_listado
BY CERTIFICATE trainerCertificado
WITH PASSWORD = 'TSQLCertificadoSP'
GO

--5. Crear un usuario a partir del certificado
CREATE USER trainerUserConCertificado
FROM CERTIFICATE trainerCertificado
GO

/*Existen dos usuarios, TrainerUserConLogin que no ha sido creado en base al certificado y 
TrainerUserConCertificado que ha sido creado en base al certificado. Si todo funciona correctamente 
TrainerUserConLogin no podrá ejecutar el procedimiento almacenado y TrainerUserConCertificado si.
*/

--Para ver los logins que inician con el nombre Trainer
SELECT * 
FROM SYS.DATABASE_PRINCIPALS 
WHERE name LIKE 'trainer%'
GO

/*Asignar el permiso al usuario trainerUserConLogin para ejecutar el procedimiento almacenado*/
GRANT EXECUTE
ON OBJECT::sp_productos_listado
TO trainerUserConLogin
GO

/*Asignar el permiso al usuario trainerUserConCertificado para ejecutar el procedimiento almacenado*/
GRANT EXECUTE
ON OBJECT::sp_productos_listado
TO trainerUserConCertificado
GO

/*Ejecutar el procediento como el usuario trainerUserConCertificado, se sugiere en este paso conectarse
nuevamente a SQL Server con el usuario para realizar la prueba. Otra forma es cambiar el entorno de
ejecución usando EXECUTE AS*/
EXECUTE AS login = 'TrainerSQL'
GO

--Ahora ejectar el SP
EXECUTE sp_productos_listado
GO

--Para restablecer el entorno de ejecución
REVERT