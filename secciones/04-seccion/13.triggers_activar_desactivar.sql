/*-- TRIGGERS ACTIVAR Y DESACTIVAR --

Este art�culo muestra como activar o desactivar un Trigger en SQL Server, los triggers DML 
son procedimientos que se disparan cuando en una tabla se realizan las instrucciones Insert, 
Update o Delete. Para mayor informaci�n Ver Triggers

Desactivar el Trigger
Disable Trigger NombreTrigger on Tabla/Vista

Activar el Trigger
Enable Trigger NombreTrigger on Tabla/Vista

Se puede eliminar un Trigger usando Drop Trigger NombreTrigger
*/
USE Northwind
GO

/*EJERCICIO 01. Crear un trigger para que se dispare cuando se actualiza una regi�n*/
CREATE TRIGGER tr_region_actualiza
ON Region
FOR UPDATE
AS
	BEGIN
		PRINT 'Se actualizaron los datos de la regi�n...'
	END
GO

--Al actualizar los datos de una regi�n se disparar� el trigger, mostrando el mensaje
/*
Primero mostramos los registros para actualizar uno de ellos, el registro
con c�digo 4 se cambiar� la descripci�n por Sur.
*/
SELECT * 
FROM Region
GO

--Acualizar la regi�n
UPDATE Region 
SET RegionDescription = 'Sur'
WHERE RegionID = 4
GO

/*EJERCICIO 02. Crear un trigger para Region que no permita insertar o modificar una 
regi�n con la descripci�n de una regi�n existente.*/
CREATE OR ALTER TRIGGER tr_region_inserta_modifica_sin_duplicado
ON Region
FOR INSERT, UPDATE
AS
	BEGIN
		--Contar la cantidad de registros con la misma descripci�n
		IF (SELECT COUNT(*) FROM INSERTED, Region
			WHERE INSERTED.RegionDescription = Region.RegionDescription) > 1
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'No se realiz� la transacci�n en la tabla Region...'
			END
		ELSE
			BEGIN
				PRINT 'Se realiza� la inserci�n o modificaci�n en la tabla Region.....'
			END
	END
GO

--Ver las regiones
SELECT * 
FROM Region
GO

--Insertar regiones
INSERT INTO Region VALUES(25, 'Ica')
INSERT INTO Region VALUES(34, 'Piura')
INSERT INTO Region VALUES(87, 'La Libertad')
INSERT INTO Region VALUES(88, 'Tumbes')
GO

/*
Insertar una regi�n con la misma descripci�n de una existente (Ica), 
obviamente con un c�digo diferente. La operaci�n no se realiza por el Triggers creado
*/
INSERT INTO Region VALUES(255, 'Ica')
GO

/*EJERCICIO 03. Crear un trigger en Region que no permita borrar mas de un registro*/
CREATE OR ALTER TRIGGER tr_region_borrar_un_registro
ON Region
FOR DELETE
AS
	BEGIN
		IF (SELECT COUNT(*) FROM DELETED) > 1
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'No se puede borrar m�s de un registro...'
			END
	END
GO

--Ver los registros de Region
SELECT * 
FROM Region
GO

--Eliminar un registro de Region
DELETE FROM Region WHERE RegionID = 25
GO

--Eliminar varios registros
DELETE FROM Region WHERE RegionID IN(34, 87, 88)
GO

/*MENSAJE
No se puede borrar m�s de un registro...
Msg 3609, Level 16, State 1, Line 107
The transaction ended in the trigger. The batch has been aborted.
*/

--Si se debe eliminar los registros, hay que desactivar o eliminar el Trigger

--Desactivar el trigger
--DISABLE TRIGGER nombre_del_trigger 
--ON tabla/vista

--Activar el trigger
--ENABLE TRIGGER nombre_del_trigger 
--ON tabla/vista

--Para borrar las regiones con c�digos 34,87,88
--Desactivar el Trigger tr_region_borrar_un_registro, borrar los registros y activar el Trigger
DISABLE TRIGGER tr_region_borrar_un_registro
ON Region
GO

DELETE FROM Region WHERE RegionID IN(4, 87, 88)
GO

ENABLE TRIGGER tr_region_borrar_un_registro
ON Region
GO

--Ver los registros de Region
SELECT * 
FROM Region
GO
