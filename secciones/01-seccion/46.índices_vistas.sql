/*-- ÍNDICES EN VISTAS --

Las vistas permiten guardar una consulta en un objeto en la base de datos para poder acceder a ella
a manera de consultas mas rápidamente. Las vistas al crearse guardan el resultado en una estructura
no indizada lo que posiblemente al consultar estas el resultado no sea óptimo.

Después de crear una vista, es recomendable crear en esta un índice agrupado como su
clave primaria y los índices no agrupados necesarios para realizar las consultas en la vista de 
manera mas óptima.

Para crear índices en la vista se utiliza la instrucción Create Index de igual forma que se utilizan 
en la creación de índices en tablas.

La vista tiene que estar ligada a un esquema, por lo que al crear la vista debemos incluir la cláusula
With SchemaBinding. 

Note que la crear la vista, si la tabla está en el esquema dbo, debe incluirse el nombre del esquema. 

Al crear un índice agrupado debe ser único.
*/
USE Northwind
GO

--En cada ejercicio se va a crear la vista y luego crear índices para esta

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

--Ver la estructura de la vista, puede notarse que no existen índices para esta, loq ue hará
--que ls consultas en la vista sean lentas
SP_HELP v_productos_lista_precio
GO

--Creando un índice agrupado para la vista
CREATE UNIQUE CLUSTERED INDEX idx_v_productos_lista_precio
ON v_productos_lista_precio(codigo)
GO

--Crear índices para otros campos
CREATE INDEX idx_v_productos_descripcion
ON v_productos_lista_precio(Descripcion)
GO

CREATE INDEX idx_v_productos_todos
ON v_productos_lista_precio(Descripcion)
INCLUDE(Precio, Stock)
GO

--Note que se ha incluido en este último ejercicio el campo Descripción.

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

--Creando el índice para la vista
CREATE UNIQUE CLUSTERED INDEX idx_v_clientes_lista_codigo
ON v_clientes_lista(codigo)
GO

--Índices para los otros campos de la vista
CREATE INDEX v_clientes_lista_nombre 
ON v_clientes_lista(cliente)
GO

--Se puede incluir la cláusula include para optimizar las consultas en la vista
CREATE INDEX v_clientes_lista_nombre_direc_contact
ON v_clientes_lista(cliente)
INCLUDE(direccion, contacto)
GO