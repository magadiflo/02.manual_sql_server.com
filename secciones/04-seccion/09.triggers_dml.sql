/*-- TRIGGERS DML EN SQL SERVER --

Un desencadenador o Trigger es una clase de procedimiento almacenado que se ejecuta automáticamente 
cuando se realiza una transacción en la bases de datos. En este artículo explicamos los tipos de 
Triggers existentes y desarrollamos ejemplos de Triggers DML.

Tipos de Triggers
Existen los siguientes tipos de Triggers

1. Los Triggers DML se ejecutan cuando se realizan operaciones de manipulación de datos (DML). 
   Los eventos DML son instrucciones INSERT, UPDATE o DELETE realizados en una tabla o vista.
2. Los Triggers DDL se ejecutan al realizar eventos de lenguaje de definición de datos (DDL). 
   Estos eventos corresponden a instrucciones CREATE, ALTER y DROP.
3. Los Triggers Logon, que se disparan al ejecutarse un inicio de sesión en SQL Server.


Triggers DML

Consideraciones para el uso de Triggers DML

- Una tabla puede tener un máximo de tres triggers: uno de actualización, uno de inserción y 
  uno de eliminación.
- Cada trigger puede aplicarse a una sola tabla o vista. Por otro lado, un mismo trigger se 
  puede aplicar a las tres acciones: UPDATE, INSERT y DELETE.
- No se puede crear un trigger en una vista ni en una tabla temporal, pero el trigger puede 
  hacer referencia a estos objetos.
- Los trigger no se permiten en las tablas del sistema.

Las tablas Inserted y Deleted
Son tablas especiales que tienen la misma estructura de las tablas que han desencadenado la 
ejecución del trigger. Estas tablas se utilizar para el manejo de la información de los 
registros afectados por las instrucciones Insert, Update o Delete, depende para que acción 
fue creada el Trigger.

Importante
- Al realizar una inserción: se puede usar la tabla INSERTED.
- Al realizar una actualización: la tabla INSERTED tiene los datos nuevos, es decir, 
  los datos que se van a actualizar, y la tabla DELETED los datos originales, los que 
  serán reemplazados.
- Al realizar un borrado, la tabla deleted contiene los datos del registro borrado.

Note que para una operación de actualización, las dos tablas pueden ser utilizadas.

Creando Triggers DML

Para crear un Trigger DML se utiliza:
CREATE [ OR ALTER ] TRIGGER [ Esquema . ]NombreTrigger
ON { tabla | vista }
{ FOR | AFTER | INSTEAD OF }
{ [ INSERT ] [ , ] [ UPDATE ] [ , ] [ DELETE ] }
AS
Begin
Instrucciones T-SQL
End
*/
USE Northwind
GO

/*EJERCICIO 01. Trigger que evita que se borren en la tabla categorías más de un registro*/
CREATE OR ALTER TRIGGER tr_elimina_solo_una_categoria
ON Categories 
FOR DELETE
AS
	BEGIN
		IF (SELECT COUNT(*) FROM DELETED) > 1 
			BEGIN
				RAISERROR('No puede eliminar más de un registro', 16, 1)
				ROLLBACK TRANSACTION
			END
	END
GO
/*
Raiserror, Raiserror(‘Mensaje’,Severidad,Estado)
Genera un mensaje de error e inicia el procesamiento de errores  de la sesión. 
RAISERROR puede hacer referencia a un mensaje definido por el usuario almacenado en la vista de catálogo
sys.messages o puede generar un mensaje dinámicamente.
*/
--Para visualizar los triggers de la Base de Datos
SELECT * 
FROM SYS.TRIGGERS
go

/*
Provocando que el Trigger se dispare

Para probar si el Trigger creado tr_elimina_solo_una_categoria funciona
se insertarán dos categorías con nombre Pisos y Carros
*/

--Insertar Categorias
INSERT INTO Categories(CategoryName)
VALUES('Pisos'), ('Carros')
GO

SELECT * 
FROM Categories
GO

/*Eliminamos una categoría
Se debería eliminar sin inconvenientes porque es una sola categoría.*/
DELETE FROM Categories WHERE CategoryID = 10
GO

--Al eliminar varias categorias el Trigger se dispara y no lo permite.
DELETE FROM Categories WHERE CategoryID IN(9, 11, 12)
GO

/*
Msg 50000, Level 16, State 1, Procedure tr_elimina_solo_una_categoria, Line 8 [Batch Start Line 104]
No puede eliminar más de un registro
Msg 3609, Level 16, State 1, Line 105
The transaction ended in the trigger. The batch has been aborted.
*/

--Borrar una sola categoría. Se observa que le transacción se efectúa correctamente.
DELETE FROM Categories WHERE CategoryID = 9
GO

/*EJERCICIO 02. Crear un trigger que permita comprobar que se inserta una categoría con nombre
diferente. 
La tabla INSERTED será utilizada para comprobar si ya hay una categoría con el mismo nombre 
que la insertada.*/
CREATE OR ALTER TRIGGER tr_categoria_inserta_sin_repetidos
ON Categories
FOR INSERT
AS
	BEGIN
		DECLARE @nueva_categoria VARCHAR(15) = (SELECT CategoryName FROM INSERTED)
		IF (SELECT COUNT(*) FROM INSERTED, Categories WHERE INSERTED.CategoryName = Categories.CategoryName) > 1
			BEGIN
				ROLLBACK TRANSACTION
				--RETURN -1
				PRINT 'La categoría ' + @nueva_categoria + ' ya existe!'
			END
		ELSE
			BEGIN
				PRINT 'La categoría ' + @nueva_categoria + ' se registró en la base de datos!'
				--RETURN 0
			END
	END
GO

--Ver las categorías
SELECT * 
FROM Categories
GO

--Insertar categoría con nombres repetidos: Pisos
INSERT INTO Categories(CategoryName)
VALUES('Pisos')
GO
/*
La categoría Pisos ya existe!
Msg 3609, Level 16, State 1, Line 149
The transaction ended in the trigger. The batch has been aborted.
*/

/*<<<<<<<<<<<<<<< TRIGGER INSTEAD OF <<<<<<<<<<<<<<<<

EJERCICIO 03. Realizar acciones después de la instrucción de un procedimiento o las escritas directamente por
el usuario. Por ejemplo, copiar los datos a una vista de Clientes al insertar uno en la tabla Customers*/

--Primero se crea la vista con los clientes
CREATE OR ALTER VIEW v_clientes 
AS
	SELECT CustomerID, CompanyName, Address, City, Phone 
	FROM Customers
GO

--Al agregar un cliente en Customers se desea que se inserte en el v_clientes
--Crear un trigger INSTEAD OF para la tabla Customers

CREATE OR ALTER TRIGGER tr_cliente_inserta_vista
ON Customers
INSTEAD OF INSERT
AS
	BEGIN
		INSERT INTO v_clientes 
		SELECT CustomerID, CompanyName, Address, City, Phone 
		FROM INSERTED
		PRINT 'Insertado correctamente en la vista'
	END
GO

--Insertar un cliente en Customers
INSERT INTO Customers(CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Phone)
VALUES('AQ885', 'Trainer SQL Pro', 'SQL Professional', 'Gerente General', 'Av. Larco 94994', 'España', 209834534)
GO

--Visualizar la vista para comprobar que el cliente ha sido insertado
SELECT * 
FROM v_clientes
WHERE CustomerID LIKE 'A%'
GO