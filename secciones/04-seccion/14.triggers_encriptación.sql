/*-- TRIGGERS - ENCRIPTACI�N --

Este art�culo muestra como encriptar un trigger, es importante que en todo nivel exista un cuidado con 
las instrucciones que realiza el trigger, la opci�n de encriptaci�n evita que de alguna forma se pueda 
visualizar las instrucciones del Trigger usando el procedimiento almacenado sp_helpText.

Los triggers DML son procedimientos que se disparan cuando en una tabla o vista se realizan las 
instrucciones Insert, Update o Delete. Para mayor informaci�n Ver Triggers.

Como se describe en el art�culo de Triggers, estos permiten ejecutar un conjunto de instrucciones al 
realizar instrucciones de inserci�n, modificaci�n o eliminaci�n de registros y es importante proteger 
estas instrucciones, para eso podemos encriptarlos usando la opci�n �with encryption�.

Encriptando un Trigger

Para crear un Trigger DML encriptado se utiliza:
CREATE [ OR ALTER ] TRIGGER [ Esquema . ]NombreTrigger
ON { tabla | vista } with encryption
{ FOR | AFTER | INSTEAD OF }
{ [ INSERT ] [ , ] [ UPDATE ] [ , ] [ DELETE ] }
AS
Begin
Instrucciones T-SQL
End

Note que despu�s del nombre de la tabla o vista se utiliza la cl�usula with encryption.
*/
USE Northwind
GO

--EJERCICIO 01. Crear un trigger para que se dispare cuanso se actualiza una regi�n
CREATE OR ALTER TRIGGER tr_region_actualiza
ON Region WITH ENCRYPTION
FOR UPDATE
AS
	BEGIN
		PRINT 'Se actualizaron los datos de la tabla Regi�n'
	END
GO

--Si se desea ver el texto del Trigger podemos utilizar el procedimiento almacenados sp_helptext.
SP_HELPTEXT tr_region_actualiza
GO

--El mensaje que aparece es: The text for object 'tr_region_actualiza' is encrypted.

/*
Al actualizar los datos de una regi�n se dispara el trigger, mostrando el mensaje.

Primero mostramos los registros para actualizar uno de ellos, el registro
con c�digo 4 se cambiar� la descripci�n por Sur.
*/
SELECT * 
FROM Region
GO

--Actualizar Regi�n
UPDATE Region
SET RegionDescription = 'South'
WHERE RegionID = 4
GO

/*
EJERCICIO 02. Crear un trigger para Region que no permita insertar o modificar una regi�n con la
descripci�n de una regi�n existente. Inicialmente se crear� el trigger sin encriptaci�n
*/
CREATE OR ALTER TRIGGER tr_region_inserta_modifica_sin_suplicado
ON Region
FOR INSERT, UPDATE
AS
	BEGIN
		IF (SELECT COUNT(*) FROM INSERTED, Region 
			WHERE INSERTED.RegionDescription = Region.RegionDescription) > 1
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'No se realiza� la transacci�n'
			END
		ELSE
			BEGIN
				PRINT 'Se realiz� la inserci�n o modificaci�n...'
			END
	END
GO

--Visualizar el texto del objeto (trigger) usando sp_helptext
SP_HELPTEXT tr_region_inserta_modifica_sin_suplicado
GO

--Modificar el Trigger y encriptarlo
CREATE OR ALTER TRIGGER tr_region_inserta_modifica_sin_suplicado
ON Region WITH ENCRYPTION
FOR INSERT, UPDATE
AS
	BEGIN
		IF (SELECT COUNT(*) FROM INSERTED, Region 
			WHERE INSERTED.RegionDescription = Region.RegionDescription) > 1
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'No se realiza� la transacci�n'
			END
		ELSE
			BEGIN
				PRINT 'Se realiz� la inserci�n o modificaci�n...'
			END
	END
GO

--Visualizar el texto del objeto (trigger) usando sp_helptext
SP_HELPTEXT tr_region_inserta_modifica_sin_suplicado
GO

--El mensaje es: The text for object 'tr_region_inserta_modifica_sin_suplicado' is encrypted.

--Probando trigger
--Ver las regiones
SELECT * 
FROM Region
GO

--Insertar una regi�n
INSERT INTO Region(RegionID, RegionDescription)
VALUES(266, 'Ica')
GO

/*
Notas adicionales:
Se pueden encriptar tambi�n Procedimientos Almacenados, Funciones definidas por el usuario y vistas, esto
va a permitir un grado mayor de seguridad en los objetos.
Para mayor informaci�n ver: Procedimientos almacenados, Funciones definidas por el usuario y vistas.
*/