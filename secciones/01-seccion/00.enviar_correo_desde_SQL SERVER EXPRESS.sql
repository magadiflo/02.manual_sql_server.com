/*-- ENVIANDO EMAIL USANDO SQL SERVER EXPRESS | CON CUENTA GMAIL --*/
--Obtenido de: https://geeks.ms/jpussacq/2012/11/06/automatizar-el-envo-de-correo-electrnico-con-sql-server-parte-1/
/*
PASO 1. HABILITAR DATABASEMAIL EN SQLSERVER EN SQL SEVER EXPRESS
-En la versión Express de SQL Server no disponemos del asistente para configurar DatabaseMail, 
por lo cual deberemos hacer el trabajo en forma manual. Primero abrimos SQL Server Management 
Studio y nos conectamos. 

Con el botón derecho del mouse sobre el nombre de nuestro servidor ir a la opción Facets. 
Es posible que esta opción se demore en abrir

-Luego en Facet seleccionamos la opción: Surface Area Configuration,
 en la parte inferior ubicamos DatabaseMailEnabled y ponemos el valor en True.

-Luego reiniciamos SQL Server con el botón derecho del mouse sobre el servidor, 
 haciendo clic en Restart.

PASO 2. CONFIGURAR DATABASEMAIL PARA SER USADO CON GMAIL
Dentro de la base msdb vamos a utilizar un conjunto de procedimientos almacenados 
para configurar el correo, en este caso usando GMail como SMTP. 

1. Utilice el procedimiento almacenado sysmail_add_account_sp de la
   base de datos MSDB para configurar la cuenta de sysmail.
*/
msdb.dbo.sysmail_add_account_sp  
     @account_name		=  'Prueba',
	 @description		=  'Cuenta agregada al SP sysmail de SQL SERVER para enviar usando GMAIL',
     @email_address		=  'sfasdf@gmail.com' ,
     @display_name		=  'Prueba DataBaseMail' ,
     @replyto_address	=  'asdfaasdf@gmail.com', --noresponder@gmail.com
     @mailserver_name	=  'smtp.gmail.com',
     @mailserver_type	=  'SMTP' ,
     @port				=  587,
     @username			=  'asdfasdf@gmail.com',
     @password			=  '********',
     @enable_ssl		=  TRUE
GO

/*
2. Crear perfil de base de datos
   Utilice el procedimiento almacenado sysmail_add_profile_sp de
   Base de datos MSDB para configurar el perfil de la base de datos.
*/
msdb.dbo.sysmail_add_profile_sp 
	@profile_name = 'Profile de prueba',
	@description = 'Perfil usado para enviar email desde cuenta de GMAIL'
GO

/*
3. Agregar cuenta de correo de base de datos al perfil
   Utilice el procedimiento almacenado sysmail_add_profileaccount_sp de
   Base de datos MSDB para asignar la cuenta de correo de la base de datos al perfil.
*/
msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name		= 'Profile de prueba',
    @account_name		= 'Prueba',
    @sequence_number	= 1
GO

/*PASO 3. ENVIAR UN CORREO DE PRUEBA*/
/*
Para enviar un correo de prueba, podemos utilizar un procedimiento 
como el siguiente, siempre dentro de la base de datos msdb:
*/
EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='Profile de prueba',
	@recipients='ssdfasdf@gmail.com',
	@subject='Configuración de SQL Server correcto - Mensaje de prueba',
	@body='Mi primer prueba de Database Mail- Configuración exitosa de SQL Server Express 2017'
GO

/*
Si todo funcionó bien, recibiremos el correo sin problemas. 
Sino, podemos explorar algunas de las opciones de la siguiente sección.
*/

/*PASO 4. ANÁLIS DE PROBLEMAS (si no funcionó)*/
/*
Las siguientes consultas, nos pueden ayudar a hacer un análisis de 
los problemas y a conocer en qué estado quedaron nuestros correos:
*/

SELECT * FROM msdb.dbo.sysmail_sentitems
SELECT * FROM msdb.dbo.sysmail_unsentitems
SELECT * FROM msdb.dbo.sysmail_faileditems
GO

--Esta consulta puede brimar más información si el estado es failed
SELECT
items.subject,
items.last_mod_date,
l.description
FROM msdb.dbo.sysmail_faileditems as items
INNER JOIN msdb.dbo.sysmail_event_log AS l
ON items.mailitem_id = l.mailitem_id
GO

/*
Si reciben un error como el siguiente “The server response was: 5.7.0 
Must issue a STARTTLS command first”, 
lo más probable es que hayamos olvidado configurar 
la opción de SSL en la cuenta.
*/

/*
Para consultar los datos de prueba
*/
SELECT *FROM msdb.dbo.sysmail_account
SELECT *FROM msdb.dbo.sysmail_configuration
SELECT *FROM msdb.dbo.sysmail_principalprofile
SELECT *FROM msdb.dbo.sysmail_profile
SELECT *FROM msdb.dbo.sysmail_profileaccount
SELECT *FROM msdb.dbo.sysmail_profileaccount



