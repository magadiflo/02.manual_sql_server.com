/*-- LEER CAMPOS XML EN SQLSERVER --

Los datos de tipo XML son muy efectivos cuando se guardan correctamente en las tablas. 
Se pueden usar campos de tipo XML para poder almacenar en la misma tabla datos similares 
a un Maestro – Detalle sin necesidad de otra tabla.

Uso de campos XML en SQL Server
Se va a crear una nueva base de datos, luego crear tablas con los datos de Northwind, 
para esto necesitamos los datos de Clientes, Empleados, Productos, Ordenes y Detalle. 
La información de la tabla Detalle va a ser almacenada en un campo XML en la tabla Ordenes.
*/
CREATE DATABASE bd_prueba_xml
GO

USE bd_prueba_xml
GO

--Tabla clientes
CREATE TABLE clientes(
	codigo CHAR(5),
	nombre VARCHAR(100),
	direccion VARCHAR(200),
	CONSTRAINT pk_clientes PRIMARY KEY(codigo)
)
GO

INSERT INTO clientes(codigo, nombre, direccion)
SELECT c.CustomerID, c.CompanyName, c.Address
FROM Northwind.dbo.Customers AS c
GO

SELECT *
FROM clientes
GO

--Tabla empleados
CREATE TABLE empleados(
	codigo INT,
	nombre VARCHAR(100),
	direccion VARCHAR(200)
	CONSTRAINT pk_empleados PRIMARY KEY(codigo)
)
GO

INSERT INTO empleados(codigo, nombre, direccion)
SELECT e.EmployeeID, CONCAT_WS(' ', e.LastName, e.FirstName), e.Address
FROM Northwind.dbo.Employees AS e
GO

SELECT * 
FROM empleados
GO

--Órdenes, note que en la tabla órdenes el detalle de la orden se encuentra en un campo XML
CREATE TABLE ordenes(
	numero INT,
	cliente_codigo CHAR(5),
	empleado_codigo INT,
	fecha DATETIME,
	total NUMERIC(9,2),
	detalle XML,
	CONSTRAINT pk_ordenes PRIMARY KEY(numero),
	CONSTRAINT fk_clientes_ordenes FOREIGN KEY(cliente_codigo) REFERENCES clientes(codigo),
	CONSTRAINT fk_empleados_ordenes FOREIGN KEY(empleado_codigo) REFERENCES empleados(codigo)
)
GO

--Inicialmente no se va a insertar datos en el campo XML, luego se actualizará
INSERT INTO ordenes(numero, cliente_codigo, empleado_codigo, fecha, total, detalle)
SELECT o.OrderID, o.CustomerID, o.EmployeeID, o.OrderDate, SUM(od.Quantity * od.UnitPrice), ''
FROM Northwind.dbo.Orders AS o
	INNER JOIN Northwind.dbo.[Order Details] AS od ON(o.OrderID = od.OrderID)
GROUP BY o.OrderID, o.CustomerID, o.EmployeeID, o.OrderDate
GO

--Tabla productos
CREATE TABLE productos(
	codigo INT,
	descripcion VARCHAR(100),
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	unidad VARCHAR(50),
	CONSTRAINT pk_productos PRIMARY KEY(codigo)
)
GO

INSERT INTO productos(codigo, descripcion, precio, stock, unidad)
SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, p.QuantityPerUnit
FROM Northwind.dbo.Products AS p
GO

--Tabla detalle
CREATE TABLE detalles(
	orden_numero INT,
	producto_codigo INT,
	precio_venta NUMERIC(9,2),
	cantidad_vendida NUMERIC(9,2),
	importe AS precio_venta * cantidad_vendida,
	CONSTRAINT pk_detalles PRIMARY KEY(orden_numero, producto_codigo),
	CONSTRAINT fk_ordenes_detalles FOREIGN KEY(orden_numero) REFERENCES ordenes(numero),
	CONSTRAINT fk_productos_detalles FOREIGN KEY(producto_codigo) REFERENCES productos(codigo)
)
GO

INSERT INTO detalles(orden_numero, producto_codigo, precio_venta, cantidad_vendida)
SELECT od.OrderID, od.ProductID, od.UnitPrice, od.Quantity
FROM Northwind.dbo.[Order Details] AS od
GO

SELECT * 
FROM detalles
GO

--Incluir los registros de la tabla detalles en el campo detalles de la tabla ordenes

--Listado de detalle en formato XML
SELECT d.orden_numero, d.producto_codigo, d.precio_venta, d.cantidad_vendida, d.importe
FROM detalles AS d 
FOR XML AUTO
GO

--Actualizar la tabla ordenes con los datos de detalle
UPDATE o
SET o.detalle = (SELECT d.orden_numero, d.producto_codigo, d.precio_venta, d.cantidad_vendida, d.importe
				 FROM detalles AS d 
				 WHERE d.orden_numero = o.numero
				 FOR XML AUTO)
FROM ordenes AS o
	INNER JOIN detalles AS d ON(o.numero = d.orden_numero)
GO

SELECT * 
FROM ordenes
GO

/*
Como convertir los datos XML en formato de Tabla

Para presentar los datos de un campo XML en el formato tabla se tendrá que usar variables de tipo XML. 
Por ejemplo, para ver el detalle de la orden 10248
*/
DECLARE @detalle XML
SET @detalle = (SELECT o.detalle 
				FROM ordenes AS o 
				WHERE o.numero = 10248)
SELECT numero = detalle.columna.value('@orden_numero', 'int'),
	   codigo = detalle.columna.value('@producto_codigo', 'int'),
	   precio_venta = detalle.columna.value('@precio_venta', 'NUMERIC(9,2)'),
	   cantidad_vendida = detalle.columna.value('@cantidad_vendida', 'NUMERIC(9,2)'),
	   importe = detalle.columna.value('@importe', 'NUMERIC(9,2)')
FROM @detalle.nodes('d') AS detalle(columna)
GO

/*
Como usar OpenXML en SQL Server
La funcionalidad de OpenXML permite extraer los datos de formato XML a un formato de tabla.

Usando los dependientes de un seguro en formato XML
*/
DECLARE @dependientes XML, @i INT
SET @dependientes = 
'<dependientes>
    <dependiente codigo="5285" parentesco="Esposa" nombre="Carla" fechaNacimiento="1975-02-01"/>
    <dependiente codigo="7852" parentesco="Hijo" nombre="Marco" fechaNacimiento="1997-02-24"/>
    <dependiente codigo="4785" parentesco="Hija" nombre="Liliana" fechaNacimiento="1999-02-10"/>
</dependientes>'
EXECUTE SP_XML_PREPAREDOCUMENT @i OUTPUT, @dependientes
SELECT * 
FROM OPENXML(@i, '/dependientes/dependiente')
WITH(codigo INT, parentesco VARCHAR(50), nombre VARCHAR(50), fechaNacimiento DATE)
GO

/*
Mostrando los datos de un archivo XML
Usando el archivo de mascotas ubicado en la siguiente ruta:
M:\PROGRAMACION\DESARROLLO_BASE_DE_DATOS\SQL_SERVER\05_manualsqlserver.com\03.Manual SQL Server\mascotas.xml
Utilizando OpenRowSet para leer los datos de una variable
*/
DECLARE @datos_mascotas XML, @i INT
SELECT @datos_mascotas = m 
FROM OPENROWSET(BULK 'M:\PROGRAMACION\DESARROLLO_BASE_DE_DATOS\SQL_SERVER\05_manualsqlserver.com\03.Manual SQL Server\mascotas.xml', SINGLE_BLOB) AS mascotas(m)
EXECUTE SP_XML_PREPAREDOCUMENT @i OUTPUT, @datos_mascotas
SELECT * 
FROM OPENXML(@i, '/Mascotas/Mascota', 2)
WITH(Codigo INT, Nombre VARCHAR(50), Tipo VARCHAR(50), Fecha DATE)
GO