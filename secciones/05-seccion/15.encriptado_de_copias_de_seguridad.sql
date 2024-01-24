/*-- ENCRIPTADO DE COPIAS DE SEGURIDAD --

Una copia de seguridad de las bases de datos en una empresa contiene toda la información de 
transacciones y movimientos, es importante que los datos no lleguen a manos en las que no deben estar, 
una forma de seguridad con las copias de seguridad es la encriptación.


Tipos de encriptación en SQL Server
1. Transparent Data Encryption o TDE
Llamada Encriptación de Datos Transparente instroducida desde SQL Server 2008, permite la encriptación 
completa de una base de datos.
La encriptación con TDE evita accesos no autorizados a los discos duros donde se encuentran las bases 
de datos o copias de seguridad.
El principal inconveniente del uso de TDE para encriptar es el aumento significativo del uso de CPU 
al realizar las copias de seguridad.

2. Encriptación de Copias de Seguridad
Desde SQL Server 2014 se puede encriptar las copias de seguridad la que se realiza directamente 
desde el motor de la base de datos. Al hacer una copia de seguridad se encripta y al realizar 
la restauración de la copia de seguridad se desencripta. Lo mejor de este método es que no existe 
problemas de consumo de CPU ni desempeño.

Service Master Key (SMK) y Database Master Key (DMK)

Service Master Key (SMK)
Este servicio se encarga de crear las claves maestras para la instancia de SQL Server, las claves para 
SMK se crean automáticamente cuando se inicia la instancia de SQL Server.
SMK cifra la contraseña del servidor vinculado, las credenciales y la clave maestra de base de datos 
(DMK). SMK se cifra mediante la clave del equipo local conjuntamente con la API de protección de 
datos de Windows (DPAPI), esta DPAPI utiliza una clave derivada de las credenciales de Windows de 
la cuenta de servicio de SQL Server y de las credenciales del equipo. SMK solo se puede descifrar 
con la cuenta de servicio en la que se creó o con una entidad de seguridad que tenga acceso a 
las credenciales del equipo.

Database Master Key (DMK)
Este servicio es una clave simétrica que protege las claves privadas de certificados y las claves 
asimétricas de base de datos. Se utiliza además para cifrar datos, tiene ciertas limitaciones de 
longitud por lo que es más práctico utilizar claves simétricas. DMK utiliza el algoritmo Triple 
DES además de una contraseña definida por el usuario.

Encriptando una copia de seguridad

Primero vamos a listar las claves simétricas, note que de no haber creado la clave simétrica 
para el cifrado de las bases de datos, sólo existe la clave de SMK que se crea al iniciar la 
instancia de SQL Server.
*/

USE master
GO

SELECT * 
FROM SYS.SYMMETRIC_KEYS
GO

--Crear la clave simétrica para el cifrado.
Create master key encryption by password ='Cl@veS3cr3t@'
go

--Visualizamos nuevamente las claves
select * from sys.symmetric_keys
go

/*
Creamos el certificado
Un certificado es un objeto protegible de nivel de base de datos que usa el estándar X.509. 
Para crear un certificado usamos CREATE CERTIFICATE, esta instrucción carga un certificado desde 
un archivo o ensamblado. Esta instrucción también puede generar un par de claves y crear un 
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
Respaldar los elementos de encriptación

Es muy importante antes de continuar con la encriptación, tener el backup o respaldo de los 
elementos usados en esta, es imperioso realizar el respaldo de la SMK, el respaldo de la 
DMK además del certificado.
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
--El certificado creado se llama «CertificadoCopiaSeguridad», ese nombre 
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

--Usando código T-SQL, la copia de seguridad se guardará en la carpeta CopiasSeguridad de la unidad C:

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
--certificado creado previamente además de usar el algoritmo AES_128

--Restaurar la copia de seguridad encriptada

use master
go
Restore Database Northwind
From disk = 'C:\CopiasSeguridad\Northwind.bak'
WITH FILE = 1, NOUNLOAD, STATS = 25
go