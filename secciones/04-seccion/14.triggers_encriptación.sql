/*-- TRIGGERS - ENCRIPTACIÓN --

Este artículo muestra como encriptar un trigger, es importante que en todo nivel exista un cuidado con 
las instrucciones que realiza el trigger, la opción de encriptación evita que de alguna forma se pueda 
visualizar las instrucciones del Trigger usando el procedimiento almacenado sp_helpText.

Los triggers DML son procedimientos que se disparan cuando en una tabla o vista se realizan las 
instrucciones Insert, Update o Delete. Para mayor información Ver Triggers.

Como se describe en el artículo de Triggers, estos permiten ejecutar un conjunto de instrucciones al 
realizar instrucciones de inserción, modificación o eliminación de registros y es importante proteger 
estas instrucciones, para eso podemos encriptarlos usando la opción «with encryption«.

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

Note que después del nombre de la tabla o vista se utiliza la cláusula with encryption.
*/
USE Northwind
GO

--EJERCICIO 01. Crear un trigger para que se dispare cuanso se actualiza una región
CREATE OR ALTER TRIGGER tr_region_actualiza
ON Region WITH ENCRYPTION
FOR UPDATE
AS
	BEGIN
		PRINT 'Se actualizaron los datos de la tabla Región'
	END
GO

--Si se desea ver el texto del Trigger podemos utilizar el procedimiento almacenados sp_helptext.
SP_HELPTEXT tr_region_actualiza
GO

--El mensaje que aparece es: The text for object 'tr_region_actualiza' is encrypted.

/*
Al actualizar los datos de una región se dispara el trigger, mostrando el mensaje.

Primero mostramos los registros para actualizar uno de ellos, el registro
con código 4 se cambiará la descripción por Sur.
*/
SELECT * 
FROM Region
GO

--Actualizar Región
UPDATE Region
SET RegionDescription = 'South'
WHERE RegionID = 4
GO

/*
EJERCICIO 02. Crear un trigger para Region que no permita insertar o modificar una región con la
descripción de una región existente. Inicialmente se creará el trigger sin encriptación
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
				PRINT 'No se realizaó la transacción'
			END
		ELSE
			BEGIN
				PRINT 'Se realizó la inserción o modificación...'
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
				PRINT 'No se realizaó la transacción'
			END
		ELSE
			BEGIN
				PRINT 'Se realizó la inserción o modificación...'
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

--Insertar una región
INSERT INTO Region(RegionID, RegionDescription)
VALUES(266, 'Ica')
GO

/*
Notas adicionales:
Se pueden encriptar también Procedimientos Almacenados, Funciones definidas por el usuario y vistas, esto
va a permitir un grado mayor de seguridad en los objetos.
Para mayor información ver: Procedimientos almacenados, Funciones definidas por el usuario y vistas.
*/