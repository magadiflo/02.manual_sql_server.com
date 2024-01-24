/*-- FUNCIONES DE CONFIGURACIÓN --

Las funciones de configuración devuelve información acerca de las opciones de configuración actuales.

Las funciones de configuración son las siguiente:

Función				Descripción
----------------------------------------------------------------
@@DATEFIRST			Devuelve el valor actual para Set DateFirst
@@OPTIONS			Devuelve información acerca de las opciones SET actuales.
@@DBTS				Devuelve el valor del tipo de datos timestamp actual
@@REMSERVER			Devuelve el nombre del servidor de base de datos remoto de SQL Server, tal y como 
					aparece en el registro de inicio de sesión.
@@LANGID			Devuelve el identificador (Id.) de idioma local del idioma que se está utilizando 
					actualmente.
@@SERVERNAME		Devuelve el nombre del servidor local que ejecuta SQL Server.
@@LANGUAGE			Devuelve el nombre del idioma en uso.
@@SERVICENAME		Devuelve el nombre de la clave del Registro bajo la cual se ejecuta SQL Server.
					@@SERVICENAME devuelve ‘MSSQLSERVER’ Si la instancia actual es la instancia 
					predeterminada, esta función devuelve el nombre de instancia si la instancia actual 
					es una instancia con nombre.
@@LOCK_TIMEOUT		Devuelve el valor actual de tiempo de espera de bloqueo en milisegundos para la sesión 
					actual.
@@SPID				Devuelve el Id. de sesión del proceso de usuario actual.
@@MAX_CONNECTIONS	Devuelve el número máximo de conexiones de usuario simultáneas que se permiten en una 
					instancia de SQL Server.
@@TEXTSIZE			Devuelve el valor actual de la TEXTSIZE opción.
@@MAX_PRECISION		Devuelve el nivel de precisión utilizado por decimal y numérico tipos de datos según 
					lo establecen actualmente en el servidor.
@@VERSION			Devuelve información del sistema y la compilación para la instalación actual de 
					SQL Server.
@@NESTLEVEL			Devuelve el nivel de anidamiento de la ejecución del procedimiento almacenado actual 
					(inicialmente 0) en el servidor local.
*/

--Ver el primer día de la semana: 1 = domingo, 2 = lunes, 3 = martes, ....7 = sábado
SELECT @@DATEFIRST
GO

--Establece el primer día de la semana el jueves
SET DATEFIRST 4
GO

--Listar el primer día de la semana, el número de día de la semana y el nombre del día de la semana
SELECT @@DATEFIRST AS 'Primer día de la semana',
	  DATEPART(DW, GETDATE()) AS 'Día actual',
	  DATENAME(DW, GETDATE()) AS 'Día de la semana'
GO

--Ver el valor decimal de las opciones SET
SELECT @@OPTIONS
GO

--El valor de TimeStamp para Northwind
USE Northwind
GO

SELECT @@DBTS
GO

--Servidor remoto
SELECT @@REMSERVER
GO
--Aparece Null cuando no existe configurado servidores remotos.

--Identificar de idioma, el nombre del idioma y nombre del servidor.
SELECT @@LANGID AS 'id del idioma', @@LANGUAGE AS 'idioma', @@SERVICENAME AS 'instancia'
GO

--Tiempo de espera
SELECT @@LOCK_TIMEOUT
GO

/*NOTA: 
SET_LOCK_TIMEOUT, permite a una aplicación reestablecer el tiempo máximo que espera una instrucción
en un recurso bloqueado. Cuando una instrucción ha esperado más tiempo que el indicado en 
LOCK_TIMEOUT, la instrucción bloqueada se cancela automáticamente y se devuelve un mensaje de error a 
la aplicación. 
@@LOCK_TIMEOUT, devuelve un valor de - 1 si SET LOCK_TIMEOUT aún no se ha ejecutado en la sesión actual
*/
--Id de la sesión
SELECT @@SPID
GO

--Máxima cantidad de conexiones
SELECT @@MAX_CONNECTIONS
GO

--Valor de la opción textsize
SELECT @@TEXTSIZE
GO

-- Precisión para valores decimal y numérico
SELECT @@MAX_PRECISION
GO

--Versión de SQL Server
SELECT @@VERSION
GO

--Nivel de anidamiento
SELECT @@NESTLEVEL
GO
/*
NOTAS:
– Cuando desde un procedimiento almacenado se llama a otro procedimientos almacenado 
  el valor de @@NestLevel aumenta en 1
– El nivel máximo es 32. Al sobrepasarlo la transacción termina automáticamente.
*/