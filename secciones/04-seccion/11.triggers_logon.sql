/*-- TRIGGERS LOGON --

Los tipos de Triggers Logon se disparan en respuesta a un evento LOGON o de inicio de sesi�n en 
una instancia de SQL Server. El Trigger de tipo Logon se desencadena despu�s de que finaliza la 
fase de autenticaci�n del inicio de sesi�n, pero antes de que se establezca realmente la sesi�n 
del usuario. Por lo tanto, todos los mensajes que se originan dentro del desencadenador que 
normalmente llegar�an al usuario, como los mensajes de error y los mensajes de la instrucci�n 
PRINT si es que el Trigger los tiene, se desv�an al registro de errores de SQL Server.

Los disparadores de inicio de sesi�n no se activan si falla la autenticaci�n. Puede usar los 
Triggers Logon para auditar y controlar las sesiones del servidor, como el seguimiento de la 
actividad de inicio de sesi�n, restringir los inicios de sesi�n en SQL Server o limitar el 
n�mero de sesiones para un inicio de sesi�n espec�fico.
*/

/*EJERCICIO 01. Crear un Trigger Logon que rechaza los intentos de inicio de sesi�n en 
SQL Server si ya existen dos sesiones de usuario creadas por ese inicio de sesi�n.*/

--Primero crear el inicio de sesi�n para hacer la prueba (Ver Logins)
USE master
GO

CREATE LOGIN trainer_prueba
WITH PASSWORD = '123'
GO

GRANT VIEW SERVER STATE TO trainer_prueba
GO

--Crear el trigger para probar las conexiones
CREATE TRIGGER tr_limitar_conexion_2
ON ALL SERVER WITH EXECUTE AS 'trainer_prueba'
FOR LOGON
AS
	BEGIN
		IF ORIGINAL_LOGIN() = 'trainer_prueba' AND 
		   (SELECT COUNT(*) FROM SYS.DM_EXEC_SESSIONS WHERE IS_USER_PROCESS = 1 AND
			ORIGINAL_LOGIN_NAME = 'trainer_prueba') > 2
			ROLLBACK
	END
GO

/*
Para probar que el Trigger Logon creado funciona primero vamos a conectarnos dos veces 
a la misma instancia de SQL Server. La imagen muestra dos conexiones activas a la 
instancia de SQL Server.
*/