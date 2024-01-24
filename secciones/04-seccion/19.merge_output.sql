/*-- USANDO OUTPUT DE MERGE --

La instrucci�n Merge realiza instrucciones de inserci�n de registros, actualizaci�n o eliminaci�n de 
registros en una tabla de destino en la misma base de datos o en otra base de datos seg�n los 
resultados de combinar los registros con una tabla de origen.

La instrucci�n Merge realiza instrucciones de inserci�n de registros, actualizaci�n o eliminaci�n de 
registros en una tabla de destino en la misma base de datos o en otra base de datos seg�n los 
resultados de combinar los registros con una tabla de origen.
*/
USE Northwind
GO

/*EJERCICIO 01. Crearemos dos tablas de Clientes, una con los datos no actualizados y otra con los 
datos actualizados. Luego se va a ejecutar el Merge mostrando las acciones usando la cl�usula Output.*/

CREATE TABLE clientes(
	codigo CHAR(5),
	razon_social VARCHAR(100),
	direccion VARCHAR(100),
	monto_credito NUMERIC(9,2),
	CONSTRAINT pk_clientes PRIMARY KEY(codigo)
)
GO

INSERT INTO clientes
VALUES('00001','Fernando Luque','Av. San Bartolo 3994',15000),
('00002','Raquel Terranova','Av. Los Paramos 4456',5000),
('00003','Carlos Mendoza','Av. Brasil 445', 3500),
('00004','Lucas Maldonado','Av. La Rep�blica 643', 10000),
('00005','Ingrid Ch�vez','Av. Loreto 994', 3800),
('00006','Rossana Moreno','Av. La Mar 464', 12000)
GO

SELECT * 
FROM clientes
GO

/*Tabla de Clientes llamada ClientesNueva con actualizaciones, clientes nuevos y clientes 
que no existen en la tabla inicial.*/
CREATE TABLE nuevos_clientes(
	codigo CHAR(5),
	razon_social VARCHAR(100),
	direccion VARCHAR(100),
	monto_credito NUMERIC(9,2),
	CONSTRAINT pk_nuevos_clientes PRIMARY KEY(codigo)
)
GO

/*
Insertar datos en nuevos_clientes, note que existen clientes en la tabla nuevos_clientes que no existen 
en la tabla clientes, otros que est�n con los datos cambiados y hay clientes en la tabla nuevos_clientes 
que no existe en la tabla clientes.
*/
INSERT INTO nuevos_clientes VALUES
('00001','Fernando Luque','Av. San Juan 2123',18000),
('00002','Raquel Terranova Llanos','Av. Los Paramos 4456',8000),
('00004','Lucas Maldonado','Av. La Rep�blica 643', 10000),
('00005','Ingrid Ch�vez','Av. Loreto 994', 25000),
('00006','Rossana Moreno','Av. La Mar 464', 12000),
('00007','Cecilia P�rez Cas�s','Av. Los Laureles 963', 2000),
('00008','Luis Mendiola S�nchez','Av. Policial 1464', 18000)
GO

SELECT * 
FROM nuevos_clientes
GO

/*
Note lo siguiente:
Clientes nuevos: clientes con c�digos 00007 y 00008
Clientes con datos actualizados: clientes con c�digos 00001, 00002 y 00005
Clientes que no figuran en la tabla nueva: cliente con c�digo 00003
*/

/*
Usando el Merge y mostrando las accciones realizadas.
Tabla que se va a sincronizar: Tabla destino Clientes usando como origen nuevos_clientes.
*/
MERGE clientes
USING nuevos_clientes
ON clientes.codigo = nuevos_clientes.codigo
WHEN MATCHED THEN
	UPDATE SET clientes.razon_social = nuevos_clientes.razon_social,
			clientes.direccion = nuevos_clientes.direccion,
			clientes.monto_credito = nuevos_clientes.monto_credito
WHEN NOT MATCHED BY TARGET THEN
	INSERT(codigo, razon_social, direccion, monto_credito)
	VALUES(nuevos_clientes.codigo, nuevos_clientes.razon_social, nuevos_clientes.direccion, nuevos_clientes.monto_credito)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE 
OUTPUT $action AS 'Acci�n',
	INSERTED.codigo AS 'C�digo', INSERTED.razon_social AS 'Nombre',
	INSERTED.direccion AS 'Direcci�n', INSERTED.monto_credito AS 'Cr�dito',
	DELETED.codigo AS 'C�digo', DELETED.razon_social AS 'Nombre',
	DELETED.direccion AS 'Direcci�n', DELETED.monto_credito AS 'Cr�dito';
SELECT @@ROWCOUNT;
GO

/*
NOTE LO SIGUIENTE:
Los clientes con c�digos 00001, 00002, 00004, 00005 y 00006 se han actualizado, en la primera 
columna que muestra la acci�n realizada aparace UPDATE. Los clientes con c�digos 00007 y 00008 
se han insertado, en la columna acci�n aparece INSERT. El cliente con c�digo 00003 se ha eliminado, 
en la columna acci�n aparece DELETE.
*/

--Mostramos las dos tablas
SELECT * 
FROM clientes

SELECT * 
FROM nuevos_clientes
GO
--Note que las dos tablas tiene los mismos registros.

/*EJERCICIO 02. Crearemos dos tablas ubicacion y ubicacion_visita, luego se van a sincronizar
usando MERGE*/
CREATE TABLE ubicacion(
	codigo INT,
	direccion VARCHAR(100)
)
GO

CREATE TABLE ubicacion_visita(
	codigo INT,
	direccion VARCHAR(100)
)
GO

--Insertamos datos
INSERT INTO ubicacion
VALUES(1, 'Trujillo Centro'),
(2, 'Lima la Victoria'),
(3, 'Piura San Cristobal')
GO

INSERT INTO ubicacion_visita
VALUES(1, 'Trujillo Victor Larco'),
(3, 'Cajamarca Ba�os del Inca'),
(4, 'Cusco San Blas')
GO

SELECT * 
FROM ubicacion
SELECT * 
FROM ubicacion_visita
GO

--Usando el Merge y la cl�usula Output
MERGE ubicacion AS d
USING ubicacion_visita AS o
ON d.codigo = o.codigo
WHEN MATCHED THEN
	UPDATE SET direccion = o.direccion
WHEN NOT MATCHED BY TARGET THEN
	INSERT(codigo, direccion)
	VALUES(o.codigo, o.direccion)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE 
OUTPUT DELETED.codigo, DELETED.direccion, $action AS 'Acci�n', 
	INSERTED.codigo, INSERTED.direccion;
GO

/*
El resultado del Output muestra que se ha insertado la ubicaci�n �Cusco San Blas� con el c�digo 4, 
se ha actualizado el registro con c�digo 1, los datos cambiados y borrados fueron �Trujillo Centro� 
y se actualizaron por �Trujillo Victor Larco�, el registro con c�digo 2 fue eliminado y el registro 
on c�digo 3 fue actualizado, el dato de �Piura San Cristobal� fue cambiado por 
�Cajamarca Ba�os del Inca�
*/

/*CONSIDERACIONES IMPORTANTES EN MERGE

Para ejecutar la instrucci�n MERGE debe tener el permiso SELECT en la tabla SOURCE y los 
permisos INSERT, UPDATE y DELETE en la tabla TARGET.

La instrucci�n MERGE requiere un punto y coma (;) al finalizar la instrucci�n. 
De lo contrario, se genera un error cuando una sentencia MERGE no termina con punto y coma.

Se puede usar @@ROWCOUNT despu�s de Merge para obtener el n�mero total de filas insertadas, 
actualizadas y eliminadas.

La instrucci�n MERGE mejora el rendimiento ya que todos los datos se leen y procesan solo una vez,
mientras que en versiones anteriores se deben escribir tres declaraciones diferentes para procesar 
tres actividades diferentes (INSERT, UPDATE o DELETE), en cuyo caso los datos en las tablas de origen 
y destino se eval�an y procesan varias veces; al menos una vez por cada declaraci�n.

Se debe especificar al menos una de las tres cl�usulas MATCHED cuando se usa la instrucci�n MERGE; 
las cl�usulas MATCHED se pueden especificar en cualquier orden.

Para cada acci�n INSERT, UPDATE o DELETE especificada en la instrucci�n MERGE, SQL Server dispara 
los Triggers AFTER correspondientes definidos en la tabla de destino, pero no garantiza el orden. 
Los activadores definidos para la misma acci�n respetan el orden que especifique.
*/

/*EJERCICIO 03. Merge con Output usando variables tipo tabla.
En este ejercicio se va a crear una tabla de productos, luego se va a usar la instrucci�n Merge 
teniendo en cuenta los datos de una variable tipo tabla.*/

CREATE TABLE productos_merge(
	codigo INT,
	descripcion VARCHAR(50),
	stock NUMERIC(9,2),
	precio NUMERIC(9,2),
	CONSTRAINT pk_productos_merge PRIMARY KEY(codigo)
)
GO

INSERT INTO productos_merge
VALUES(1, 'Teclado', 10, 55),
(2, 'Monitor', 5, 220),
(3, 'Mouse', 50, 25),
(4, 'Impresora', 15, 350)
GO

SELECT * 
FROM productos_merge
GO

--Se va a declarar una variable tipo tabla con los datos a actualizar.
DECLARE @productos TABLE(
	codigo INT,
	descripcion VARCHAR(50),
	stock NUMERIC(9,2),
	precio NUMERIC(9,2)
)
INSERT INTO @productos
SELECT 1 AS codigo, 'Teclado Gamer' AS descripcion, 15 AS stock, 70 AS precio
UNION
SELECT 3 AS codigo, 'Mouse Shadow Optical' AS descripcion, 55 AS stock, 30 AS precio
UNION 
SELECT 4 AS codigo, 'Impresora Epson L355' AS descripcion, 12 AS stock, 450 AS precio
UNION
SELECT 5 AS codigo, 'Laptop Samsung Core i7' AS descripcion, 5 AS stock, 1200 AS precio
UNION
SELECT 6 AS codigo, 'Escritorio gerencial 1.40' AS descripcion, 2 AS stock, 650 AS precio

MERGE INTO productos_merge AS d
USING @productos AS o
ON d.codigo  = o.codigo
WHEN MATCHED AND (d.descripcion <> o.descripcion OR d.stock <> o.stock OR d.precio <> o.precio) THEN
	UPDATE SET d.descripcion = o.descripcion, d.stock = o.stock, d.precio = o.precio
WHEN NOT MATCHED BY TARGET THEN
	INSERT VALUES(o.codigo, o.descripcion, o.stock, o.precio)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE 
OUTPUT $action AS 'Acci�n', 
INSERTED.descripcion AS 'Nueva descripci�n',
INSERTED.stock AS 'Nuevo stock',
INSERTED.precio AS 'Nuevo precio',
DELETED.descripcion AS 'Descripci�n anterior',
DELETED.stock AS 'Stock anterior',
DELETED.precio AS 'Precio anterior';
GO

--Listado de la tabla productos_merge
SELECT * 
FROM productos_merge
GO