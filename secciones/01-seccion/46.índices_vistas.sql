/*-- �NDICES EN VISTAS --

Las vistas permiten guardar una consulta en un objeto en la base de datos para poder acceder a ella
a manera de consultas mas r�pidamente. Las vistas al crearse guardan el resultado en una estructura
no indizada lo que posiblemente al consultar estas el resultado no sea �ptimo.

Despu�s de crear una vista, es recomendable crear en esta un �ndice agrupado como su
clave primaria y los �ndices no agrupados necesarios para realizar las consultas en la vista de 
manera mas �ptima.

Para crear �ndices en la vista se utiliza la instrucci�n Create Index de igual forma que se utilizan 
en la creaci�n de �ndices en tablas.

La vista tiene que estar ligada a un esquema, por lo que al crear la vista debemos incluir la cl�usula
With SchemaBinding. 

Note que la crear la vista, si la tabla est� en el esquema dbo, debe incluirse el nombre del esquema. 

Al crear un �ndice agrupado debe ser �nico.
*/
USE Northwind
GO

--En cada ejercicio se va a crear la vista y luego crear �ndices para esta

/*EJERCICIO 01. Crear la vista para los productos*/
CREATE VIEW v_productos_lista_precio
WITH SCHEMABINDING
AS
	SELECT p.ProductID AS 'Codigo',
		   p.ProductName AS 'Descripcion',
		   p.UnitPrice AS 'Precio',
		   p.UnitsInStock AS 'Stock'
	FROM dbo.Products AS p
GO

--Ver la estructura de la vista, puede notarse que no existen �ndices para esta, loq ue har�
--que ls consultas en la vista sean lentas
SP_HELP v_productos_lista_precio
GO

--Creando un �ndice agrupado para la vista
CREATE UNIQUE CLUSTERED INDEX idx_v_productos_lista_precio
ON v_productos_lista_precio(codigo)
GO

--Crear �ndices para otros campos
CREATE INDEX idx_v_productos_descripcion
ON v_productos_lista_precio(Descripcion)
GO

CREATE INDEX idx_v_productos_todos
ON v_productos_lista_precio(Descripcion)
INCLUDE(Precio, Stock)
GO

--Note que se ha incluido en este �ltimo ejercicio el campo Descripci�n.

/*EJERCICIO 02. Crear una vista con los clientes*/
CREATE VIEW v_clientes_lista
WITH SCHEMABINDING
AS
	SELECT c.CustomerID AS 'codigo',
			c.CompanyName AS 'cliente',
			c.ContactName AS 'contacto',
			c.Address AS 'direccion',
			c.Phone AS 'telefono'
	FROM dbo.Customers AS c
GO

--Ver la estructura de la vista
SP_HELP v_clientes_lista
GO

--Creando el �ndice para la vista
CREATE UNIQUE CLUSTERED INDEX idx_v_clientes_lista_codigo
ON v_clientes_lista(codigo)
GO

--�ndices para los otros campos de la vista
CREATE INDEX v_clientes_lista_nombre 
ON v_clientes_lista(cliente)
GO

--Se puede incluir la cl�usula include para optimizar las consultas en la vista
CREATE INDEX v_clientes_lista_nombre_direc_contact
ON v_clientes_lista(cliente)
INCLUDE(direccion, contacto)
GO