/*-- ENVIANDO EMAIL USANDO SQL SERVER EXPRESS --*/
/*
Create Sysmail Account
1. Use sysmail_add_account_sp stored procedure of MSDB 
database to configure sysmail   account.
*/
EXECUTE msdb.dbo.sysmail_add_account_sp
@account_name = 'EnviandoCorreo_GMAIL',
@description = 'Enviando email usando cuenta de GMAIL',
@email_address = '******@gmail.com',
@display_name = 'Roberta',
@username='******@gmail.com',
@password='********',
@mailserver_name = 'smtp.gmail.com',
@port = 587

/*2.Creating Database Profile
Use sysmail_add_profile_sp stored procedure of 
MSDB database to configure Database Profile.
*/
EXECUTE msdb.dbo.sysmail_add_profile_sp
@profile_name = 'PerfilTest',
@description = 'Perfil usado para enviar email'

/*
3. Add database Mail account to profile
Use sysmail_add_profileaccount_sp stored procedure of 
MSDB database to map database mail account to Profile.
*/

EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
@profile_name = 'PerfilTest',
@account_name = 'EnviandoCorreo_GMAIL',
@sequence_number = 1

/*
4. Grants permission for a database user or role to 
use a Database Mail profile.
To Grants permission for a database user or role to use 
a Database Mail profile use
sysmail_add_principalprofile_sp.
*/
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
@profile_name = 'PerfilTest',
@principal_name = 'public',
@is_default = 1 ;

--A principal_name of 'public' makes this profile a public profile, 
--granting access to all principals in the database.

/*5. You can query to test data
*/
SELECT *FROM msdb.dbo.sysmail_account
SELECT *FROM msdb.dbo.sysmail_configuration
SELECT *FROM msdb.dbo.sysmail_principalprofile
SELECT *FROM msdb.dbo.sysmail_profile
SELECT *FROM msdb.dbo.sysmail_profileaccount
SELECT *FROM msdb.dbo.sysmail_profileaccount

/*6. Send Mail using Created Profile
*/
exec msdb.dbo.sp_send_dbmail 
@profile_name = 'PerfilTest',
@recipients = '******@gmail.com', 
@subject = 'Probando envio de email', 
@body = 'El correo fue enviado correctamente!', 
@body_format = 'text'

/*
If all things are going right,Mail sent successfully.
But when I tried I found this error.

Msg 15281, Level 16, State 1, Procedure sp_send_dbmail, Line 0
SQL Server blocked access to procedure 'dbo.sp_send_dbmail' of 
component 'Database Mail XPs' because this component is turned 
off as part of the security configuration for this server. 
A system administrator can enable the use of 'Database Mail XPs' 
by using sp_configure. For more information about enabling '
Database Mail XPs', see "Surface Area Configuration" in SQL Server 
Books Online.
*/

/*7. This error occured due to 'Database Mail XPs' disabled.
To enable this use this code
*/
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO

/*8. Try to send mail again.I hope it works successfully.
But If you tried this using Microsoft Exchange Server Mail ID,
It will not work properly.Because maybe This is turned out to 
be an issue with a rule on the exchange server. 
*/