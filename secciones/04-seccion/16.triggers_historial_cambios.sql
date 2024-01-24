/*-- TRIGGERS INSERT Y UPDATE - HISTORIAL DE CAMBIOS EN UNA TABLA --

Los triggers DML son procedimientos guardados en la base de datos que se disparan cuando se 
insertan registros, cuando se actualizan los datos de un registro o cuando se eliminan registros.

Este ejercicio muestra como crear un Historial de cambios usando un Trigger, el trigger se disparar� 
cuando se inserte o actualice un registro. Para mayor informaci�n Ver Triggers
*/
USE Northwind
GO

/*EJERCICIO 01. Historial de cambios en la tabla Shippers.

La tabla Shippers (Compa��as de env�o) tiene los campos: ShipperID, Companyname y Phono. 
Primero se crear� una tabla HistorialShippers con los campos C�digo, Nombre, Tel�fono y Fecha.*/
CREATE TABLE historial_shippers(
	codigo CHAR(10),
	nombre VARCHAR(40),
	fono VARCHAR(24),
	fecha DATE
)
GO

--Crear el trigger para la tabla Shippers que se dispara cuando se inserta o modifica un registro
CREATE OR ALTER TRIGGER tr_shippers_historial
ON Shippers 
FOR INSERT, UPDATE
AS
	BEGIN
		SET NOCOUNT ON 
		INSERT historial_shippers(codigo, nombre, fono, fecha)
		SELECT i.ShipperID, i.CompanyName, i.Phone, GETDATE() 
		FROM INSERTED AS i
	END
GO

--Antes de insertar registros, visualizar los registros en las tablas
SELECT * 
FROM Shippers
GO

SELECT * 
FROM historial_shippers
GO

--Insertar un registro en la tabla Shippers, esto har� que se dispare el trigger
--y se inserte un registro en la tabla creada historial_shippers
INSERT INTO Shippers(CompanyName, Phone)
VALUES('Trainer SQL', '87852541')
GO

--Prueba con la actualizaci�n de los datos de un registro. 
--El registro insertado l�neas arriba se gener� con c�digo 4, se cambiar� su nombre y tel�fono
UPDATE Shippers
SET CompanyName = 'Capacitador SQL', Phone = '963258741'
WHERE ShipperID = 4
GO

--Probando con insertar otro registro
INSERT INTO Shippers(CompanyName, Phone)
VALUES('Tracks Moves', '952369985')
GO

--Puede observar que la tabla historial_shippers tiene los datos de los registros insertados y actualizados
SELECT * 
FROM historial_shippers
GO

/*EJERCICIO 02. Se va a crear una tabla Ciudades, el historial de cambios en esta tabla va a 
incluir la operaci�n realizada, si es inserci�n y al realizar una actualizaci�n se va a guardar 
el original, el cambio y el nombre del usuario que realiz� el cambio.*/
CREATE TABLE ciudades(
	codigo CHAR(4),
	nombre VARCHAR(100),
	CONSTRAINT pk_ciudades PRIMARY KEY(codigo)
)
GO

/*Tabla para el historial de cambios en ciudades, se va a incluir la operaci�n que 
puede ser INSERCI�N o MODIFICACI�N, la fecha y el usuario que la realiz�*/
CREATE TABLE historial_ciudades(
	codigo CHAR(4),
	nombre VARCHAR(100),
	operacion VARCHAR(15),
	fecha DATETIME,
	estado VARCHAR(10),
	usuario VARCHAR(128)
)
GO

--Trigger para insertar en la tabla ciudades
CREATE OR ALTER TRIGGER tr_ciudades_insertar
ON ciudades
FOR INSERT
AS
	BEGIN
		SET NOCOUNT ON
		INSERT INTO historial_ciudades(codigo, nombre, operacion, fecha, estado, usuario)
		SELECT i.codigo, i.nombre, 'INSERCI�N', GETDATE(), 'INSERTADO', SYSTEM_USER
		FROM INSERTED AS i
	END
GO

--Trigger para actualizaci�n en la tabla ciudades
CREATE OR ALTER TRIGGER tr_ciudades_actualizacion
ON ciudades
FOR UPDATE
AS
	BEGIN
		SET NOCOUNT ON
		INSERT INTO historial_ciudades(codigo, nombre, operacion, fecha, estado, usuario)
		SELECT d.codigo, d.nombre, 'MODIFICACI�N', GETDATE(), 'ORIGINAL', SYSTEM_USER 
		FROM DELETED AS d

		INSERT INTO historial_ciudades(codigo, nombre, operacion, fecha, estado, usuario)
		SELECT i.codigo, i.nombre, 'MODIFICACI�N', GETDATE(), 'CAMBIADO', SYSTEM_USER 
		FROM INSERTED AS i
	END
GO

--Ver la tabla historial
SELECT * 
FROM historial_ciudades
GO

--El resultado muestra que no existen registros

--Insertar registros en la tabla ciudades
INSERT INTO ciudades(codigo, nombre)
VALUES('2540', 'Chimbote')
GO

--Ver los datos
SELECT * 
FROM ciudades
GO

SELECT * 
FROM historial_ciudades
GO

--Insertar m�s ciudades
INSERT INTO ciudades(codigo, nombre)
VALUES('8521', 'Piura')
GO
INSERT INTO ciudades(codigo, nombre)
VALUES('7458', 'Huaraz')
GO
INSERT INTO ciudades(codigo, nombre)
VALUES('4169', 'Lima')
GO

--Modificar Piura
UPDATE ciudades
SET nombre = 'Piura con calor'
WHERE codigo = '8521'
GO

--Ver los datos
SELECT * 
FROM ciudades
GO

SELECT * 
FROM historial_ciudades
GO
