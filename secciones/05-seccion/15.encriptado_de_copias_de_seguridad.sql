/*-- ENCRIPTADO DE COPIAS DE SEGURIDAD --

Una copia de seguridad de las bases de datos en una empresa contiene toda la informaci�n de 
transacciones y movimientos, es importante que los datos no lleguen a manos en las que no deben estar, 
una forma de seguridad con las copias de seguridad es la encriptaci�n.


Tipos de encriptaci�n en SQL Server
1. Transparent Data Encryption o TDE
Llamada Encriptaci�n de Datos Transparente instroducida desde SQL Server 2008, permite la encriptaci�n 
completa de una base de datos.
La encriptaci�n con TDE evita accesos no autorizados a los discos duros donde se encuentran las bases 
de datos o copias de seguridad.
El principal inconveniente del uso de TDE para encriptar es el aumento significativo del uso de CPU 
al realizar las copias de seguridad.

2. Encriptaci�n de Copias de Seguridad
Desde SQL Server 2014 se puede encriptar las copias de seguridad la que se realiza directamente 
desde el motor de la base de datos. Al hacer una copia de seguridad se encripta y al realizar 
la restauraci�n de la copia de seguridad se desencripta. Lo mejor de este m�todo es que no existe 
problemas de consumo de CPU ni desempe�o.

Service Master Key (SMK) y Database Master Key (DMK)

Service Master Key (SMK)
Este servicio se encarga de crear las claves maestras para la instancia de SQL Server, las claves para 
SMK se crean autom�ticamente cuando se inicia la instancia de SQL Server.
SMK cifra la contrase�a del servidor vinculado, las credenciales y la clave maestra de base de datos 
(DMK). SMK se cifra mediante la clave del equipo local conjuntamente con la API de protecci�n de 
datos de Windows (DPAPI), esta DPAPI utiliza una clave derivada de las credenciales de Windows de 
la cuenta de servicio de SQL Server y de las credenciales del equipo. SMK solo se puede descifrar 
con la cuenta de servicio en la que se cre� o con una entidad de seguridad que tenga acceso a 
las credenciales del equipo.

Database Master Key (DMK)
Este servicio es una clave sim�trica que protege las claves privadas de certificados y las claves 
asim�tricas de base de datos. Se utiliza adem�s para cifrar datos, tiene ciertas limitaciones de 
longitud por lo que es m�s pr�ctico utilizar claves sim�tricas. DMK utiliza el algoritmo Triple 
DES adem�s de una contrase�a definida por el usuario.

Encriptando una copia de seguridad

Primero vamos a listar las claves sim�tricas, note que de no haber creado la clave sim�trica 
para el cifrado de las bases de datos, s�lo existe la clave de SMK que se crea al iniciar la 
instancia de SQL Server.
*/

USE master
GO

SELECT * 
FROM SYS.SYMMETRIC_KEYS
GO

--Crear la clave sim�trica para el cifrado.
Create master key encryption by password ='Cl@veS3cr3t@'
go

--Visualizamos nuevamente las claves
select * from sys.symmetric_keys
go

/*
Creamos el certificado
Un certificado es un objeto protegible de nivel de base de datos que usa el est�ndar X.509. 
Para crear un certificado usamos CREATE CERTIFICATE, esta instrucci�n carga un certificado desde 
un archivo o ensamblado. Esta instrucci�n tambi�n puede generar un par de claves y crear un 
certificado con firma personal.
*/
use master
go
Create certificate CertificadoCopiaSeguridad
with subject = 'Trainer SQL Server Certificado'
go

--Listar los certificados
select * from sys.certificates
go

/*
Respaldar los elementos de encriptaci�n

Es muy importante antes de continuar con la encriptaci�n, tener el backup o respaldo de los 
elementos usados en esta, es imperioso realizar el respaldo de la SMK, el respaldo de la 
DMK adem�s del certificado.
*/

--Respaldo de la Clave Maestra de Servicio
use master
go
xp_create_subdir 'C:\Respaldo'
go
Backup service master key
to file = 'C:\Respaldo\TrainerSQL_MasterKeyService.key'
encryption by password = 'TSQLClaveServicioMK'
go

--Respaldar la Clave Maestra de Base de Datos

use master
go
xp_create_subdir 'C:\Respaldo'
go
Backup master key
to file = 'C:\Respaldo\TrainerSQL_BaseDatosMasterKey.key'
encryption by password = 'TSQLClaveMaestraBD'
go

--Respaldar el Certificado
--El certificado creado se llama �CertificadoCopiaSeguridad�, ese nombre 
--debemos utilizar para obtener una copia de seguridad.
use master
go
xp_create_subdir 'C:\Respaldo'
go
Backup certificate CertificadoCopiaSeguridad
to file = 'C:\Respaldo\TrainerSQL_CopiaSeguridadCertificado.cer'
with private key
(file = 'C:\Respaldo\TrainerSQL_KeyCertificado.key'
, ENCRYPTION BY PASSWORD = 'TSQLClaveCertificado')
go

--Copia de seguridad encriptada

--Usando c�digo T-SQL, la copia de seguridad se guardar� en la carpeta CopiasSeguridad de la unidad C:

xp_create_subdir 'C:\CopiasSeguridad'
go
Backup database Northwind
to disk = 'C:\CopiasSeguridad\Northwind.bak'
with format, init,
MediaDescription = 'Trainer SQL Server Medio de Copias',
MediaName = 'Trainer Media',
Name = 'Copia compleato Northwind',
Skip, ENCRYPTION(ALGORITHM = AES_128, SERVER CERTIFICATE = [CertificadoCopiaSeguridad]),
STATS = 25
go
--Note que al obtener la copia de seguridad de la base de datos se ha utilizado el 
--certificado creado previamente adem�s de usar el algoritmo AES_128

--Restaurar la copia de seguridad encriptada

use master
go
Restore Database Northwind
From disk = 'C:\CopiasSeguridad\Northwind.bak'
WITH FILE = 1, NOUNLOAD, STATS = 25
go