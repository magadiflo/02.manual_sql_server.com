/*-- CERTIFICADOS EN SQL SERVER --

Certificados en SQL Server
Un certificado es un asegurable a nivel de base de datos que sigue el estándar X.509 y admite campos 
X.509 V1.
La instrucción CREATE CERTIFICATE permite cargar un certificado desde un archivo, una constante binaria
o un ensamblado. Esta declaración también puede generar un par de claves y crear un certificado 
autofirmado.

Características de las claves

La clave privada debe ser <= 2500 bytes en formato cifrado. Las claves privadas generadas por SQL
Server tienen una longitud de 1024 bits hasta SQL Server 2014 (12.x) y una longitud de 2048 bits a
partir de SQL Server 2016 (13.x).
Las claves privadas importadas de una fuente externa tienen una longitud mínima de 384 bits y una 
longitud máxima de 4.096 bits. La longitud de una clave privada importada debe ser un múltiplo entero 
de 64 bits.

Creando certificados en SQL Server

Instrucción Create Certificate

CREATE CERTIFICATE NombreCertificado [ AUTHORIZATION Usuario ]
[ ENCRYPTION BY PASSWORD = ‘password’ ]
WITH SUBJECT = ‘certificate_subject_name’
START_DATE = ‘datetime’ | EXPIRY_DATE = ‘datetime’
go
Donde:
NombreCertificado, especifica el nombre del certificado
[ AUTHORIZATION Usuario ] es el usuario que es dueño del certificado. (Ver usuarios de Base de Datos)
[ ENCRYPTION BY PASSWORD = ‘password’ ], especifica el password.
WITH SUBJECT = ‘Descripción’, especifica la descripción del certificado.
START_DATE = ‘datetime’ | EXPIRY_DATE = ‘datetime’, opciones de fecha de inicio y de finalización 
de la validez del certificado.
*/
USE Northwind
GO

/*EJERCICIO 01. Crear un certificado confecha de vencimiento en el 2025*/
SET DATEFORMAT dmy
GO
CREATE CERTIFICATE trainer_certificado
ENCRYPTION BY PASSWORD = 'tsqlcertificadosp'
WITH SUBJECT = 'Certificado Trainer',
EXPIRY_DATE = '10/05/2025'
GO

--Para ver el certificado creado
SELECT name, subject, issuer_name, start_date, expiry_date
FROM SYS.CERTIFICATES
GO

/*EJERCICIO 02. Crear un certificado sin password, si no se tiene creada una clave maestra no es 
posible crear un certificado sin password.*/
CREATE CERTIFICATE certificado_sin_pass
WITH SUBJECT = 'certificado libre'
GO

--Crear una clave maestra
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '12345'
GO

--Ahora sí se puede crear el certificado sin password
CREATE CERTIFICATE certificado_sin_pass
WITH SUBJECT = 'certificado libre'
GO

/*EJERCCIO 03. Crear un certificado en base a un archivo, este ejercicio hace necesario
que se tenga el certificado y el archivo con la clave. Por obvias razones no se comparte
el archivo*/
CREATE CERTIFICATE CertificadoTrainerVentas
from file = 'E:\Ventas\Certificados\CerVentasT.cer'
WITH private key
(FILE = 'E:\Ventas\Certificados\CerVentasT.pvk',
DECRYPTION BY PASSWORD = 'cl@v3_C3rt1f1c@do_Tr@1n3rSQL')
GO

/*EJERCICIO 04. Crear un certificado en base a un ensamblado.*/
--Primero, crear el ensamblado
CREATE ASSEMBLY ventasenstq
FROM 'E:\ventas\certificados\ventasenstq.dll'
WITH PERMISSION_SET = SAFE
GO

--Ahora se puede crear el certificado
CREATE CERTIFICATE certVentasEnsTQ FROM ASSEMBLY ventasenstq
GO

/*
Modificación de los certificados

Los certificados se puede modificar usando la instrucción Alter Certificate, con esta instrucción 
se puede cambiar la contraseña utilizada para cifrar la clave privada de un certificado, elimina 
la clave privada o importa la clave privada si no hay ninguna. También se puede cambiar la 
disponibilidad de un certificado al Service Broker.

Instrucción Alter certificate
ALTER CERTIFICATE NombreCertificado
REMOVE PRIVATE KEY
| WITH PRIVATE KEY ( )
| WITH ACTIVE FOR BEGIN_DIALOG = { ON | OFF }

::=
{ { FILE = ‘path_to_private_key’ | BINARY = private_key_bits }
[ , DECRYPTION BY PASSWORD = ‘password actual’ ]
[ , ENCRYPTION BY PASSWORD = ‘nuevo password’ ]
} | { [ DECRYPTION BY PASSWORD = ‘password actual’ ]
[ [ , ] ENCRYPTION BY PASSWORD = ‘nuevo password’ ]}
*/

/*EJERCICIO 05. Quitar la clave privada del certificado trainercertificado*/
ALTER CERTIFICATE trainercertificado
REMOVE PRIVATE KEY
GO

/*
Eliminar los certificados

La instrucción Drop Certificate permite eliminar los certificados
Instrucción Drop certificate
Drop certificate NombreCertificado
Donde: NombreCertificado, es el nombre del certificado a eliminar de la base de datos.
*/
/*EJERCICIO 06. Eliminar el certificado trainercertificado*/
DROP CERTIFICATE trainercertificate
GO