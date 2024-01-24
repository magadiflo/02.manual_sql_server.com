/*-- TRIGGERS INSTEAD OF EN SQL SERVER --

Los triggers instead of son un tipo de Triggers que reemplazan las instrucciones que hace que 
se dispare, use estos tipos de Triggers cuando es necesario comprobar algunas condiciones 
al momento de realizar transacciones con los registros de tablas o vistas.

Por ejemplo: si se crea un Trigger de tipo instead of para la tabla Clientes al insertar un registro,
al ejecutar un Insert es cuando este tipo de Trigger se va a ejecutar en lugar de la 
instrucción Insert en la tabla o vista.

Notas importantes
1. Estos tipos de triggers cancelan la instrucción que hace que se dispare, reemplazando
   esta por las instrucciones del Trigger.
2. Generalmente se utilizan estos triggers en vistas
3. Las acciones que realice el trigger no deben cancelar la transacción que la dispara sino 
   ejecutar las instrucciones cambiadas que son el cuerpo del trigger.
*/
USE Northwind
GO

/*
Para utilizar un Trigger de tipo instead of crearemos una vista llamada SociosEstrategicos 
con los Clientes (Customers) y los Proveedores (Suppliers)
*/

--Primero: Los clientes
SELECT c.CustomerID AS 'cod. cliente', c.CompanyName AS 'cliente', c.Country AS 'pais'
FROM Customers AS c
GO

--Segundo: Los proveedores
SELECT s.SupplierID AS 'cod. proveedor', s.CompanyName AS 'proveedor', s.Country AS 'pais'
FROM Suppliers AS s
GO

--Al junstar los dos listados en la vista v_socios_estrategicos, la instrucción SELECT para
--la vista es como sigue:
--Incluiremos una columna para diferenciar el tipo de socio, Cliente o Proveedor.  
-- Además de cambiar los nombres de campos
SELECT c.CustomerID AS 'cod. socio', c.CompanyName AS 'socio', 
	   c.Country AS 'pais', 'cliente' AS 'tipo'
FROM Customers AS c

UNION ALL

SELECT CAST(s.SupplierID AS CHAR(5)), s.CompanyName, 
	   s.Country, 'proveedor'
FROM Suppliers AS s
GO

--Creamos la vista
CREATE OR ALTER VIEW v_socios_estrategicos
AS
	SELECT c.CustomerID AS 'cod. socio', c.CompanyName AS 'socio', 
	   c.Country AS 'pais', 'cliente' AS 'tipo'
	FROM Customers AS c

	UNION ALL

	SELECT CAST(s.SupplierID AS CHAR(5)), s.CompanyName, 
		   s.Country, 'proveedor'
	FROM Suppliers AS s
GO

--Si se desea visualizar los socios estratégicos del negocio solamente listamos la vista
SELECT * 
FROM v_socios_estrategicos
GO

--El trigger se creará para la vista, será de tipo INSTEAD OF
CREATE OR ALTER TRIGGER tr_vista_socio_estrategico_insetar
ON v_socios_estrategicos
INSTEAD OF INSERT
AS
	BEGIN
		INSERT INTO Customers(CustomerID, CompanyName, Country)
		SELECT [cod. socio], socio, pais
		FROM INSERTED
		WHERE tipo = 'cliente'

		INSERT INTO Suppliers(CompanyName, Country)
		SELECT socio, pais
		FROM INSERTED
		WHERE tipo = 'proveedor'
	END
GO

--Al ejecutar una inserción en la vista
--Insertar un cliente
INSERT INTO v_socios_estrategicos
VALUES('YT351', 'Sociedad SQL', 'France', 'cliente')
GO

--Listamos los clientes (tabla Customers)
SELECT * 
FROM Customers
WHERE CompanyName LIKE 'Soci%'
GO

--Insertar un proveedor
INSERT INTO v_socios_estrategicos
VALUES('BT599', 'Limbo Almacenes', 'Spain', 'proveedor')
GO

--Listamos los proveedores (tabla Suppliers)
SELECT * 
FROM Suppliers
WHERE CompanyName LIKE 'Limbo%'
GO

--La vista tiene insertados los dos registros
SELECT * 
FROM v_socios_estrategicos
WHERE socio LIKE 'soci%' OR socio LIKE 'Limbo%'
GO

/*NOTA:
Tenga en cuenta que al insertar registros en la vista debemos especificar todos los campos, 
en el Trigger para los proveedores no se especifica el código porque es un campo entero 
y es Identidad. (Ver Identity)
*/