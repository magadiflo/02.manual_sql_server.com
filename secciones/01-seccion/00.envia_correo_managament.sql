/*-- ENVIANDO EMAIL USANDO EL MANAGAMENT DE MSQLSMS  --
Este proceso no ser� v�lido para SQL Server Express ya que no cuenta
con esa interfaz gr�fica. Para SQL Server Express lo realizamos a 
puras sentencias

Database Mail nos permite que desde SQL Server enviemos correos electr�nicos, 
vali�ndonos de un procedimiento almacenado que se llama sp_send_dbmail que lo
podemos incluir dentro de todo nuestro c�digo T-SQL, es decir dentro de un 
Trigger, Stored Procedure

CONFIGURANDO EL DATABASE MAIL
----------------------------------------------
- Vamos a Managament/Database Mail
- Click secundario, Configure Database Mail
- Se abre una ventana de bienvenida y Next
- Ventana: Select Configuration Task
  [check] Set up Database Mail by performing the following tasks (primera opci�n)
- Next
- Puede que nos salga una ventana preguntando: 
	The Database Mail feature is not available. Would you like to enable this feature?
- Le damos en Yes
- Ventana: New Profile
- Agregamos los siguientes datos: 
	Profile name: Mart�n D�az
	Descripci�n: alguna descripci�n
- En la parte inferior, lado izquierdo seleccionar Add..., 
  para agregar la cuenta SMTP
  NOTA: para darle la informaci�n de nuestra cuenta SMTP
  debemos contar con la informaci�n del servidor que nos proveer�
  y si va a ser un SSL

  del servicio del puerto de conexi�n a ese servidor
- Ventana: New Database Mail Account
- Agregamos los siguientes datos: 
	Account Name: Mart�n D�az
	Descripci�n: Alguna descripci�n (se puede omitir)
	Outogoing Mail Server (SMTP)
		E-mail address: aqu� el correo que se ocupar� para hacer el env�o de correos
		Display name: Mart�n D�az (nombre que se va a mostrar)
		Reply e-mail: direcci�n de correo de respuesta, puede ser el mismo E-mail address:
		Server Name: escribimos el SMTP del servidor de correo saliente. En el caso de gmail es: smtp.gmail.com
		Port number: agregamos el puerto que utiliza el servidor de correo saliente. En el caso de gmail es 587
	[Check] This server requires a secure connection (SSL)

	[CHECK] Basic authentication
	User name: correo, autenticaci�n del servidor de correo saliente
	Password: escribe la contrase�a
	Confirm password: repetir la contrase�a
- Damos en OK
- Ventana: New Profile 
  [hasta este punto ya debemos tener configurada nuestra cuenta SMTP asociada
  a nuestro profile]
- Next
- Ventana: Manage Profile Security
- En la pesta�a Public Profiles
  Public     Profile Name    Default Profile
  [check]	  prueba		 No					[p�blica para que todas puedan usarlo]
- Next
- Ventana: Configure System Parameters
- Next
- Ventana: Complete the Wizard
- Next
- Ventana: Configuring...
- Close

1� FORMA PARA PROBAR SERVICIO
------------------------------
- Managament/Database Mail
- Click secundario, Send Test E-mail
- Ventana: Send Test E-Mail from Desktop-VQAR0RN
- Agregamos nuestros datos configurados:  
	Database Mail Profile: Mart�n D�az
	To: correo_destino
	Subject: el asunto
	Body: cuerpo del mensaje
- Click en Send Test E-Mail
- Verificar el correo de destino si lleg� el correo

2� FORMA PARA PROBAR SERVICIO
------------------------------
- Click secundario en Database Mail/View Database Mail Log
- Verificar si no hay ning�n problema

3� FORMA PARA PROBAR SERVICIO
--------------------------------
- Utilizando el sp_send_dbmail
- Utilizamos el siguiente script

EXEC msdb.dbo.sp_send_dbmail 
	 @profile_name			= 'Pedro P�rez',
	 @recipients			= '********@gmail.com', --El correo de destino			
	 @copy_recipients		= @CORREOS_CC,
	 @blind_copy_recipients = 'SOLMAR Sistemas <sistemas@gruposolmar.com.pe>;SOLMAR Proyectos SW <proyectossw@gruposolmar.com.pe>; SOLMAR SW Training <swtraining@gruposolmar.com.pe> ;SOLMAR Sisolmar <sisolmar@gruposolmar.com.pe>',
	 @subject				= @ASUNTO,
	 @body					= @tableHTML, --Cuerpo del mensaje
	 @importance			='HIGH',
	 @body_format			= 'HTML',
	 @file_attachments		= @DIRECTORIO
*/