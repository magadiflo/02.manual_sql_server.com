/*-- USANDO MERGE CON SELECT --

Usando Merge con una consulta como origen

La instrucción Merge realiza instrucciones de inserción de registros, actualización o 
eliminación de registros en una tabla de destino en la misma base de datos o en otra 
base de datos según los resultados de combinar los registros con una tabla de origen, 
esta tabla origen puede ser una consulta Select.

Merge puede ser usado de varias formas, en este ejercicio se va a usar dentro de un 
procedimiento almacenado para la inserción o actualización de un empleado. 
El origen desde donde se actualizará la tabla es una consulta.

Sintaxis
La forma de usar Merge es la siguiente:

MERGE
[ TOP ( n ) [ PERCENT ] ]
[ INTO ] [ [ AS ] AliasTablaDestino ]
USING [ [ As ] AliasTablaOrigen]
ON
[ WHEN MATCHED [ AND ]
THEN ] [ …n ]
[ WHEN NOT MATCHED [ BY TARGET ] [ AND ]
THEN ]
[ WHEN NOT MATCHED BY SOURCE [ AND ]
THEN ] [ …n ]

Donde
[ TOP ( n ) [ PERCENT ] ]
Permite especificar la cantidad en registros o porcentaje del total
que se tendrán en cuenta para las instrucciones dentro de Merge.
[ INTO ] [ [ AS ] AliasTablaDestino ]
Permite especificar la tabla donde se realizará la acción.
USING [ [ As ] AliasTablaOrigen]
Permite especificar la tabla o conjunto de resultados que servirán para realizar las instrucciones del Merge.
ON
Condición o condiciones que deben de cumplir los registros al compararlos entre las tablas origen y destino.
[ WHEN MATCHED [ AND ]
THEN ] [ …n ]
Instrucciones cuando se encuentra coincidencia en el destino.
[ WHEN NOT MATCHED [ BY TARGET ] [ AND ]
THEN ]
Instrucciones cuando no se encuentra coincidencia en el origen.
[ WHEN NOT MATCHED BY SOURCE [ AND ]
THEN ] [ …n ]
Instrucciones cuando no se encuentra coincidencia en el origen.
*/
USE Northwind
GO

/*EJERCICIO 01. Procedimiento almacenado que evalúa la existencia de un Cliente, si el cliente existe 
se van a actualizar sus datos y si no existe se va a insertar un nuevo cliente.*/
CREATE OR ALTER PROCEDURE sp_clientes_actualiza_inserta_merge(
	@codigo CHAR(5), @nombre VARCHAR(40), @contacto VARCHAR(30), 
	@cargo VARCHAR(30), @direccion VARCHAR(60), @ciudad VARCHAR(15), 
	@region VARCHAR(15), @codigo_postal VARCHAR(10), @pais VARCHAR(15),
	@fono VARCHAR(24), @fax VARCHAR(24)
)
AS
	BEGIN
		MERGE dbo.Customers AS clientes_destino
		USING(SELECT @codigo, @nombre, @contacto, @cargo, @direccion,
		@ciudad, @region, @codigo_postal, @pais, @fono, @fax) AS clientes_origen ([CustomerId], 
		[CompanyName], [ContactName], [ContactTitle], [Address], [City], [Region], [PostalCode],
		[Country], [Phone], [Fax])
		ON clientes_destino.CustomerId = clientes_origen.CustomerId
		WHEN MATCHED THEN --Cliente encontrado
		UPDATE SET [CustomerId] = clientes_origen.[CustomerId], 
				[CompanyName]	= clientes_origen.[CompanyName],
				[ContactName]	= clientes_origen.[ContactName],
				[ContactTitle]	= clientes_origen.[ContactTitle],
				[Address]		= clientes_origen.[Address],
				[City]			= clientes_origen.[City],
				[Region]		= clientes_origen.[Region],
				[PostalCode]	= clientes_origen.[PostalCode],
				[Country]		= clientes_origen.[Country],
				[Phone]			= clientes_origen.[Phone],
				[Fax]			= clientes_origen.[Fax]
		WHEN  NOT MATCHED THEN --Cliente no encontrado
		INSERT VALUES(@codigo, @nombre, @contacto, @cargo, @direccion,
			@ciudad, @region, @codigo_postal, @pais, @fono, @fax);
	END
GO

--Listado de los clientes, se puede ver que el cliente con el que se va a ejecutar el SP no existe.
SELECT * 
FROM Customers
GO

--Ejecutar el SP con un nuevo cliente
EXECUTE sp_clientes_actualiza_inserta_merge 
	@codigo = 'FLSND',
	@nombre = 'TRAINER SQL SERVER',
	@contacto = 'FERNANDO LUQUE SANCHEZ',
	@cargo = 'GERENTE GENERAL',
	@direccion = 'Av. San Blas 4995',
	@ciudad = 'Lima',
	@region = 'CE',
	@codigo_postal = '11258',
	@pais = 'Perú',
	@fono = '949483333',
	@fax = '052-525258'
GO

--Listado de los clientes
SELECT * 
FROM Customers
WHERE CustomerID = 'FLSND'
GO

--Ejecutamos el sp con el mismo código del cliente pero con algunos datos cambiados
EXECUTE sp_clientes_actualiza_inserta_merge 
	@codigo = 'FLSND',
	@nombre = 'Master SQL SERVER',
	@contacto = 'FERNANDO LUQUE SANCHEZ',
	@cargo = 'GERENTE GENERAL',
	@direccion = 'Av. Los Álamos 159',
	@ciudad = 'Trujillo',
	@region = 'CE',
	@codigo_postal = '25852',
	@pais = 'Perú',
	@fono = '95858582',
	@fax = '052-525258'
GO