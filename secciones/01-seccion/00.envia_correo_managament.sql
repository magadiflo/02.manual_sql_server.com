/*-- ENVIANDO EMAIL USANDO EL MANAGAMENT DE MSQLSMS  --
Este proceso no será válido para SQL Server Express ya que no cuenta
con esa interfaz gráfica. Para SQL Server Express lo realizamos a 
puras sentencias

Database Mail nos permite que desde SQL Server enviemos correos electrónicos, 
valiéndonos de un procedimiento almacenado que se llama sp_send_dbmail que lo
podemos incluir dentro de todo nuestro código T-SQL, es decir dentro de un 
Trigger, Stored Procedure

CONFIGURANDO EL DATABASE MAIL
----------------------------------------------
- Vamos a Managament/Database Mail
- Click secundario, Configure Database Mail
- Se abre una ventana de bienvenida y Next
- Ventana: Select Configuration Task
  [check] Set up Database Mail by performing the following tasks (primera opción)
- Next
- Puede que nos salga una ventana preguntando: 
	The Database Mail feature is not available. Would you like to enable this feature?
- Le damos en Yes
- Ventana: New Profile
- Agregamos los siguientes datos: 
	Profile name: Martín Díaz
	Descripción: alguna descripción
- En la parte inferior, lado izquierdo seleccionar Add..., 
  para agregar la cuenta SMTP
  NOTA: para darle la información de nuestra cuenta SMTP
  debemos contar con la información del servidor que nos proveerá
  y si va a ser un SSL

  del servicio del puerto de conexión a ese servidor
- Ventana: New Database Mail Account
- Agregamos los siguientes datos: 
	Account Name: Martín Díaz
	Descripción: Alguna descripción (se puede omitir)
	Outogoing Mail Server (SMTP)
		E-mail address: aquí el correo que se ocupará para hacer el envío de correos
		Display name: Martín Díaz (nombre que se va a mostrar)
		Reply e-mail: dirección de correo de respuesta, puede ser el mismo E-mail address:
		Server Name: escribimos el SMTP del servidor de correo saliente. En el caso de gmail es: smtp.gmail.com
		Port number: agregamos el puerto que utiliza el servidor de correo saliente. En el caso de gmail es 587
	[Check] This server requires a secure connection (SSL)

	[CHECK] Basic authentication
	User name: correo, autenticación del servidor de correo saliente
	Password: escribe la contraseña
	Confirm password: repetir la contraseña
- Damos en OK
- Ventana: New Profile 
  [hasta este punto ya debemos tener configurada nuestra cuenta SMTP asociada
  a nuestro profile]
- Next
- Ventana: Manage Profile Security
- En la pestaña Public Profiles
  Public     Profile Name    Default Profile
  [check]	  prueba		 No					[pública para que todas puedan usarlo]
- Next
- Ventana: Configure System Parameters
- Next
- Ventana: Complete the Wizard
- Next
- Ventana: Configuring...
- Close

1° FORMA PARA PROBAR SERVICIO
------------------------------
- Managament/Database Mail
- Click secundario, Send Test E-mail
- Ventana: Send Test E-Mail from Desktop-VQAR0RN
- Agregamos nuestros datos configurados:  
	Database Mail Profile: Martín Díaz
	To: correo_destino
	Subject: el asunto
	Body: cuerpo del mensaje
- Click en Send Test E-Mail
- Verificar el correo de destino si llegó el correo

2° FORMA PARA PROBAR SERVICIO
------------------------------
- Click secundario en Database Mail/View Database Mail Log
- Verificar si no hay ningún problema

3° FORMA PARA PROBAR SERVICIO
--------------------------------
- Utilizando el sp_send_dbmail
- Utilizamos el siguiente script

EXEC msdb.dbo.sp_send_dbmail 
	 @profile_name			= 'Pedro Pérez',
	 @recipients			= '********@gmail.com', --El correo de destino			
	 @copy_recipients		= @CORREOS_CC,
	 @blind_copy_recipients = 'SOLMAR Sistemas <sistemas@gruposolmar.com.pe>;SOLMAR Proyectos SW <proyectossw@gruposolmar.com.pe>; SOLMAR SW Training <swtraining@gruposolmar.com.pe> ;SOLMAR Sisolmar <sisolmar@gruposolmar.com.pe>',
	 @subject				= @ASUNTO,
	 @body					= @tableHTML, --Cuerpo del mensaje
	 @importance			='HIGH',
	 @body_format			= 'HTML',
	 @file_attachments		= @DIRECTORIO
*/