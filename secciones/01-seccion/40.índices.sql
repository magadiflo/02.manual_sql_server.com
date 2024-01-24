/*-- ÍNDICES EN SQL SERVER | TEORÍA Y EJERCICIOS --

Un índice se puede definir como un objeto que ordena los registros de una tabla o vista por uno
o más campos de manera ascendente o descendente.

IMPORTANTE
- Es recomendable crear índices para optimizar las consultas.
- Se pueden crear un índice agrupado (CLUSTERED), que se crea de manera automática en la tabla con 
  clave primaria (primary key) y 999 índices no agrupados (NONCLUSTERED) en la misma tabla o vista.
- En la lista de campos por el cual va a ordenar los registros de la tabla o vista pueden 
  haber hasta 32 campos.
- El orden puede ser ascendente (Asc) o descendente (Desc). El valor por defecto es Asc.
- Las columnas con tipos de datos ntext, text, varchar(max), nvarchar(max), varbinary(max), 
  xml, o image no se pueden crear índices.
- Se puede crear índices para las tablas particionadas, estos índices se les llama 
  índices particionados.
- El Factor de relleno (FILLFACTOR) permite optimizar los índices de nuestra base de datos. 
  Sino utilizamos este factor, las páginas de datos de los índices se llenan completamente, 
  pero cuando hay muchas actualizaciones en dicho índice y necesitan de más espacio, dichas páginas 
  tienen que romperse por la mitad y una parte de ella se traslada a una página de índice libre. 
  Si esto ocurre muy a menudo, el rendimiento del índice decrece rápidamente.
  Una solución para evitar esto es no completar las hojas de los índices y dejar un espacio vacío, 
  precisamente para cuando hayan actualizaciones que “no quepan” en una fila normal, se pueda utilizar 
  dicho espacio sin tener que “trocear” la página (split page es como se llama este proceso) y así 
  no producir fragmentación interna. Este espacio es el denominado Fill Factor. 
  Por ejemplo un fill factor de 80 indica que dejamos un 80% de espacio para el índice 
  y un 20% de espacio libre. En esta página de Microsoft tenéis más información de cómo activarlo.

SINTAXIS
Para la creación de índices vamos a dividir la sintaxis de acuerdo al tipo de índice.

- Crear un índice no agrupado

	CREATE NONCLUSTERED INDEX nombreDelIndice 
	ON tabla/vista(camp1 orden[, campo2 orden])
	GO

- Crear un índice agrupado
	CREATE CLUSTERED INDEX nombreDelIndice 
	ON tabla/vista(camp1 orden[, campo2 orden])
	GO

- Crear un índice único
	CREATE UNIQUE INDEX nombreDelIndice
	ON tabla/vista(camp1 orden, [, campo2 orden])
	GO

- Crear un índice filtrado
	CREATE INDEX nombreDelIndice 
	ON tabla/vista(camp1 orden[, campo2 orden])
	WHERE expresiónLógica
	GO

- Crear un índice con factor de relleno
	CREATE INDEX nombreDelIndice 
	ON tabla/vista(camp1 orden [, campo2 orden])
	WITH FILLFACTOR = Valor
	GO

- Crear un índice y sobre escribir el existente
	CREATE INDEX nombreDelIndice 
	ON tabla/vista(campo 1 orden [, campo2 orden])
	WITH DROP_EXISTING = ON
	GO

EJERCICIOS
- Usando la base de datos de Northwind
*/
USE Northwind
GO

/*EJERCICIO 01. Crear un índice para la tabla categorias, campo categoryName*/
SP_HELP categories
GO

CREATE INDEX idx_categorias_nombre
ON Categories(CategoryName ASC)
GO

/*EJERCICIO 02. Ver los índices de la tabla categorías. Suponer que los nombres
de los índices comienzan con la palabra idx*/
SELECT * 
FROM SYS.INDEXES
WHERE name LIKE 'idx%'
GO

/*EJERCICIO 03. Ver la estructura de la tabla. También se presetan la lista de indexados
creados en la tabla.*/
SP_HELP Categories
GO

/*EJERCICIO 04. Crear un índice para los productos que tengan un precio mayor a 30*/
CREATE INDEX idx_productos_precio
ON products(UnitPrice)
WHERE UnitPrice > 30
GO

SP_HELP products
GO

/*EJERCICIO 05. Crear un índice único para los productos por el campo ProductName*/
CREATE UNIQUE INDEX idx_productos_nombre
ON products(ProductName ASC)
GO

/*EJERCICIO 06. Crear un índice único para los empleados por los campos LastName y FirstName*/
CREATE INDEX idx_empleados_full_name
ON employees(LastName ASC, FirstName ASC)
GO

/*EJERCICIO 07. Crear un índice para el campo UnitsInStock en la tabla Products 
con factor de relleno de 70*/
CREATE INDEX idx_productos_UnitsInStock
ON products(UnitsInStock)
WITH FILLFACTOR = 70
GO

/*EJERCICIO 08. Crear un índice para el nombre del cliente (campo CompanyName) en 
Customers. Asignar un factor de relleno de 70 y sobre escribir el existente. 
Usar la estructura IF para comprobar que el indice existe*/

IF NOT EXISTS(SELECT * FROM SYS.INDEXES WHERE name = 'idx_cliente_CompanyName')
	BEGIN
		CREATE INDEX idx_cliente_CompanyName
		ON customers(CompanyName)
		WITH FILLFACTOR = 70
	END
ELSE
	BEGIN
		CREATE INDEX idx_cliente_CompanyName
		ON customers(CompanyName)
		WITH(FILLFACTOR = 70, DROP_EXISTING = ON)
	END
GO


SP_HELP customers
GO