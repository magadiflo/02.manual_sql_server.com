/*-- INSERTAR REGISTROS
Para insertar registros en una tabla se utiliza la instrucción INSERT.
Se pueden agregar registros también utilizando una consulta como origen de datos
INSERT permite agregar uno o más registros a la vez

INSTRUCCIÓN: INSERT
Permite insertar registros en una tabla

SINTAXIS
Insert [into] NombreTabla [ ( Lista de columnas ) ]
VALUES ( DEFAULT | NULL | expression } [ ,…n] ) | Select….)

Donde: 
INTO: Palabra clave inicial para indicar a qué tabla se insertarán los registros
NOMBRETABLA: Nombre de la tabla a insertar los registros
VALUES: Palabra reservada para especificar los valores de cada campo en la lista de columnas

NOTAS IMPORTANTES: 
- La columna que tiene activada la propiedad Identity no se espacifica en la lista de campos a insertar.
- En lo posible se debe evitar los datos Null, los que ocurren cuando en una campo no se escribe el dato a ingresar.
- Si no se especifican los campos a insertar los datos, SQL Server supone que se van a insertar todos los campos 
  de la tabla.
- Si la tabla tienen campos calculados, estos no se ingresan al usar Insert.
- Es recomendable usar restricciones de tipo Default para evitar en las tablas los valores Null.
- Los campos que deben de ser obligatorios al insertar un registro se deben crear usando la cláusula Not Null.
*/
USE Northwind
GO

/*EJERCICIO 01. Insertar un registro en customers. En este ejercicio se insertará los datos
de todos los campos*/
INSERT INTO Customers(CustomerID, CompanyName, ContactName, 
ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
VALUES('IRLUP', 'Iris Lupulo Luna Park', 'Ingrid Huamancondor', 'Manager', 
'Av. El Sol 456', 'Madrid', 'SP', '05432-043', 'España', '(91)5559346', '(91)6664482')
GO


/*EJERCICIO 02. Los campos puden escribirse en cualquier orden*/
INSERT INTO Customers(CustomerID, CompanyName, PostalCode, Country, Phone, Fax,
ContactName, ContactTitle, Address, City, Region)
VALUES('ARAMT','Aracnis Management Co.','05432-043','España','(91) 555 93 46','(91) 666 44 92',
'Esmeralda Vics','Sales Manager','Av. Los Algarrobos 4678', 'Barcelona','SP')
--Importante: Si se escriben los datos de todos los campos, se pueden obviar la lista de estos
--Pero en este caso el orden sí importa. Es decir, se deben ingresar los datos según se tengan
--ordenada los campos en la tabla 

/*EJERCICIO 03. Insertar dos nuevas regiones, la tabla region solamente tiene los campos
RegionID de tipo INT y RegionDescripcion de tipo NCHAR(50)*/
INSERT INTO Region
VALUES(6, 'Antártida'),
(7, 'Bosques Albinos')
GO

/*EJERCICIO 04. Crear una tabla con los productos descontinuados y luego inserta los registros*/
--Los productos descontinuados son
SELECT * FROM Products WHERE Discontinued = 1
GO

--Con esta consulta estamos creando directamente la tabla 'descontinuados' al mismo tiempo que
--le vamos insertando todos los productos discontinuados
SELECT * INTO descontinuados FROM Products WHERE Discontinued = 1
GO

--Visualizamos los registros
SELECT * FROM descontinuados
GO

/*EJERCICIO 05. Una tabla con campos calculados. Crearemos una tabla con campos calculados.
Luego insertar registros*/
CREATE TABLE promedios(
	codigo CHAR(4),
	primer_valor NUMERIC(4,2),
	segundo_valor NUMERIC(4,2),
	tercer_valor NUMERIC(4,2),
	resultado AS ((primer_valor + segundo_valor + tercer_valor)/3)
)
GO

--Insertar registros
INSERT INTO promedios
VALUES('8588', 12, 16, 14)
GO

--Insertar varios al mismo tiempo
INSERT INTO promedios
VALUES('6789', 15, 18, 13),
('9984', 5, 16, 11),
('5737', 18, 10, 7)
GO

--Al listar los registros puede verse que el campo calculado (resultado) se llenó automáticamente
SELECT * FROM promedios
GO