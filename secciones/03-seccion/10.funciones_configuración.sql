/*-- FUNCIONES DE CONFIGURACI�N --

Las funciones de configuraci�n devuelve informaci�n acerca de las opciones de configuraci�n actuales.

Las funciones de configuraci�n son las siguiente:

Funci�n				Descripci�n
----------------------------------------------------------------
@@DATEFIRST			Devuelve el valor actual para Set DateFirst
@@OPTIONS			Devuelve informaci�n acerca de las opciones SET actuales.
@@DBTS				Devuelve el valor del tipo de datos timestamp actual
@@REMSERVER			Devuelve el nombre del servidor de base de datos remoto de SQL Server, tal y como 
					aparece en el registro de inicio de sesi�n.
@@LANGID			Devuelve el identificador (Id.) de idioma local del idioma que se est� utilizando 
					actualmente.
@@SERVERNAME		Devuelve el nombre del servidor local que ejecuta SQL Server.
@@LANGUAGE			Devuelve el nombre del idioma en uso.
@@SERVICENAME		Devuelve el nombre de la clave del Registro bajo la cual se ejecuta SQL Server.
					@@SERVICENAME devuelve �MSSQLSERVER� Si la instancia actual es la instancia 
					predeterminada, esta funci�n devuelve el nombre de instancia si la instancia actual 
					es una instancia con nombre.
@@LOCK_TIMEOUT		Devuelve el valor actual de tiempo de espera de bloqueo en milisegundos para la sesi�n 
					actual.
@@SPID				Devuelve el Id. de sesi�n del proceso de usuario actual.
@@MAX_CONNECTIONS	Devuelve el n�mero m�ximo de conexiones de usuario simult�neas que se permiten en una 
					instancia de SQL Server.
@@TEXTSIZE			Devuelve el valor actual de la TEXTSIZE opci�n.
@@MAX_PRECISION		Devuelve el nivel de precisi�n utilizado por decimal y num�rico tipos de datos seg�n 
					lo establecen actualmente en el servidor.
@@VERSION			Devuelve informaci�n del sistema y la compilaci�n para la instalaci�n actual de 
					SQL Server.
@@NESTLEVEL			Devuelve el nivel de anidamiento de la ejecuci�n del procedimiento almacenado actual 
					(inicialmente 0) en el servidor local.
*/

--Ver el primer d�a de la semana: 1 = domingo, 2 = lunes, 3 = martes, ....7 = s�bado
SELECT @@DATEFIRST
GO

--Establece el primer d�a de la semana el jueves
SET DATEFIRST 4
GO

--Listar el primer d�a de la semana, el n�mero de d�a de la semana y el nombre del d�a de la semana
SELECT @@DATEFIRST AS 'Primer d�a de la semana',
	  DATEPART(DW, GETDATE()) AS 'D�a actual',
	  DATENAME(DW, GETDATE()) AS 'D�a de la semana'
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
SET_LOCK_TIMEOUT, permite a una aplicaci�n reestablecer el tiempo m�ximo que espera una instrucci�n
en un recurso bloqueado. Cuando una instrucci�n ha esperado m�s tiempo que el indicado en 
LOCK_TIMEOUT, la instrucci�n bloqueada se cancela autom�ticamente y se devuelve un mensaje de error a 
la aplicaci�n. 
@@LOCK_TIMEOUT, devuelve un valor de - 1 si SET LOCK_TIMEOUT a�n no se ha ejecutado en la sesi�n actual
*/
--Id de la sesi�n
SELECT @@SPID
GO

--M�xima cantidad de conexiones
SELECT @@MAX_CONNECTIONS
GO

--Valor de la opci�n textsize
SELECT @@TEXTSIZE
GO

-- Precisi�n para valores decimal y num�rico
SELECT @@MAX_PRECISION
GO

--Versi�n de SQL Server
SELECT @@VERSION
GO

--Nivel de anidamiento
SELECT @@NESTLEVEL
GO
/*
NOTAS:
� Cuando desde un procedimiento almacenado se llama a otro procedimientos almacenado 
  el valor de @@NestLevel aumenta en 1
� El nivel m�ximo es 32. Al sobrepasarlo la transacci�n termina autom�ticamente.
*/