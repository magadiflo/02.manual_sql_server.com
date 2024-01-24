/*-- PERSISTED EN CAMPOS CALCULADOS --*/
/*
La cl�usula Persisted se puede utilizar en la definici�n de un campo calculado 
en las tablas de una base de datos en SQL Server.

Los campos calculados en las tablas permiten almacenar los datos que se calculan
en base a los campos de la misma tabla.

En este art�culo se mostrar� como al usar la cl�usula Persisted en un campo calculado 
y luego listar y actualizar los registros mostrando el Plan de ejecuci�n estimado 
tanto en la tabla que tiene la cl�usula Persisted como en otra que no se ha utilizado.
*/

/* USANDO PERSISTED EN CAMPOS CALCULADOS */
/*
Usando la base de datos Nortwind, se va a crear dos tablas y copiar los datos de la 
tabla Products (Productos). En ambas tablas habr� la misma cantidad de registros y 
los mismos campos, en una de las tablas se usar� la clausula Persisted en la creaci�n 
del campo calculado para el valor del Stock y en otra tabla no se usar� Persisted.
*/

USE Northwind
GO

-- La siguiente tabla usar� la cl�usula PERSISTED en el campo calculado del valor del stock
CREATE TABLE productos_con_persisted(
	codigo CHAR(5),
	descripcion VARCHAR(50),
	unidad VARCHAR(30),
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	valor_stock AS (precio * stock) PERSISTED,
	CONSTRAINT pk_productos_con_persisted PRIMARY KEY(codigo)
)
GO

-- La siguiente tabla NO USAR� la cl�usula PERSISTED en el campo calculado valor del stock
CREATE TABLE productos_sin_persisted(
	codigo CHAR(5),
	descripcion VARCHAR(50),
	unidad VARCHAR(30),
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	valor_stock AS (precio * stock),
	CONSTRAINT pk_productos_sin_persisted PRIMARY KEY(codigo)
)
GO

--Llenar las tablas con los registros de Products
--Primero la tabla cuyo campo calculado ha sido creado usando la cl�usula PERSISTED
INSERT INTO productos_con_persisted
SELECT RIGHT('0000' + TRIM(STR(p.productid)), 5), p.productname,
p.quantityperunit, p.unitprice, p.unitsinstock
FROM products AS p
GO

--Segundo, la tabla cuyo campo calculado NO ha sido creado usando la cl�usula PERSISTED
INSERT INTO productos_sin_persisted
SELECT RIGHT('0000' + TRIM(STR(p.productid)), 5), p.productname,
p.quantityperunit, p.unitprice, p.unitsinstock
FROM products AS p
GO

--Ver los datos de las tablas
SELECT * FROM productos_con_persisted
GO

SELECT * FROM productos_sin_persisted
GO


/* ANALIZANDO LOS RESULTADOS */
--Actualizar los datos
--La tabla cuyo campo calculado se incluy� la cl�usula PERSISTED
UPDATE productos_con_persisted
SET precio = precio * 1.1
GO

--La tabla cuyo campo calculado NO se incluy� la cl�usula PERSISTED
UPDATE productos_sin_persisted
SET precio = precio * 1.1
GO

/* CREANDO �NDICES PARA CADA CAMPO CALCULADO EN LAS TABLAS */
CREATE INDEX idx_valor_stock_con_persisted 
ON productos_con_persisted(valor_stock)
GO

CREATE INDEX idx_valor_stock_sin_persisted 
ON productos_sin_persisted(valor_stock)
GO

--Para analizar el resultado mostrando los registros ordenados por el campo calculado
SELECT *
FROM productos_con_persisted
ORDER BY valor_stock DESC
GO

SELECT *
FROM productos_sin_persisted
ORDER BY valor_stock DESC
GO

/*
Si visualizamos el espacio ocupados por las tablas podemos notar que la tabla 
que tiene el campo calculado marcado como Persisted su �ndice ocupa un mayor 
espacio que la tabla que no tiene marcado como Persisted el campo calculado.
*/
SP_SPACEUSED productos_con_persisted
GO

SP_SPACEUSED productos_sin_persisted
GO

--Por �ltimo, una tabla sin campo calculado el cual se presentar� al listar los registros
CREATE TABLE productos_sin_calculado(
	codigo CHAR(5),
	descripcion VARCHAR(50),
	unidad VARCHAR(30),
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	CONSTRAINT pk_productos_sin_calculado PRIMARY KEY(codigo)
)
GO

--Llenar las tablas con los registros de products
INSERT INTO productos_sin_calculado
SELECT RIGHT('0000' + TRIM(STR(p.productid)), 5), p.productname,
p.quantityperunit, p.unitprice, p.unitsinstock
FROM products AS p
GO

--Listado incluyendo el campo calculado
SELECT *, 'Valor del stock' = p.precio * p.stock
FROM productos_sin_calculado AS p
GO

SP_SPACEUSED productos_con_persisted
GO
SP_SPACEUSED productos_sin_persisted
GO
SP_SPACEUSED productos_sin_calculado
GO

/*
Decida usted mismo, la sugerencia es usar los campos calculados para evitar 
tener que realizar c�lculos previos para mostrar los datos totalizados o cuando 
extraiga informaci�n de varias tablas usando Joins y necesite el 
campo calculado.. Evalue siempre las diferentes alternativas.
*/