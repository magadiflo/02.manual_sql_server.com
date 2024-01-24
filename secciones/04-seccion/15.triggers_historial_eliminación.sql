/*-- TRIGGERS HISTORIAL DE REGISTROS ELIMINADOS --
Los Triggers son una herramienta muy poderosa para asegurar integridad de datos, posibilidad de recuperar 
los datos si se usa una eliminación usando Delete, guardar historial de acciones para efectos de auditoria 
(Ver Historial con Triggers), acciones que pueden reemplazar a la inserción (Ver Triggers Instead of), etc.

Eliminación de registros

La eliminación de registros de una tabla se puede hacer usando la instrucción Delete 
(Ver Eliminación de registros), lo que en ocasiones no pueda ejecutarse debido a restricciones de
tipo Foreign Key (Ver Claves Foráneas).

Un registro eliminado con Delete es imposible de recuperar, se recomienda el borrado lógico, es decir, 
usando un campo que puede ser de tipo caracter donde se pueda guardar datos como A de Activo 
y E de Eliminado.

Creando un historial de registros eliminados

En este artículo se creará una tabla de Historial de registros eliminado para la tabla Productos (Products),
al eliminar un registro con Delete, se utilizará un Trigger para guardar en la tabla historial el registro 
eliminado.

Pasos para crear el historial

1. Primero crear una tabla con la estructura de los datos que se desean registrar de los registros 
   eliminados, para el ejercicio será la tabla Products a la que se agregará la fecha de eliminación.

   La tabla a crear es recomendable que no tenga restricciones y que se cree en un esquema adecuado, 
   es posible que se elimine mas de una vez un registro y debería guardarse en la tabla, de preferencia 
   con la fecha de eliminación.
*/
USE Northwind
GO

CREATE TABLE dbo.productos_historial_eliminados(
	ProductID INT NOT NULL,
	ProductName VARCHAR(40) NOT NULL,
	SupplierID INT NULL,
	CategoryID INT NULL,
	QuantityPerUnit VARCHAR(20) NULL,
	UnitPrice MONEY,
	UnitInStock SMALLINT,
	UnitsOnOrder SMALLINT,
	ReorderLevel SMALLINT,
	Discontinued BIT,
	fecha_eliminacion DATETIME
)
GO

/*
2. Crear el Trigger que va a guardar los datos del registro eliminado usando Delete en la tabla 
   Historial de Productos será como sigue
*/
CREATE TRIGGER tr_productos_guarda_historial_eliminado
ON Products
FOR DELETE
AS 
	BEGIN	
		INSERT INTO productos_historial_eliminados
		SELECT *, GETDATE()
		FROM DELETED
	END
GO

--Insertaremos algunos registros en Products para luego poder eliminarlos.
INSERT INTO Products(ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice,
					 UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES('Ron Solera', 6, 1, 'Bot. 750 ml', 70, 40, 0, 20, 0),
('Pavita', 3, 6, 'Uni. 7kg', 170, 30, 0, 10, 0),
('Queso parmesano', 8, 4, 'Env. x 200gr', 50, 20, 5, 10, 0)
GO

--Los registros insertados tienen los códigos 79, 80, 81
SELECT * 
FROM Products
ORDER BY ProductID DESC
GO

--Eliminar registros
--Primero intentaremos eliminar productos que tienen registros en detalle de venta.
DELETE Products WHERE ProductID = 10
go

/*
El mensaje es claro, no se puede eliminar porque hay un conflicto con la restricción de 
Clave foránea de la tabla Order Details.
Msg 547, Level 16, State 0, Line 80
The DELETE statement conflicted with the REFERENCE constraint "FK_Order_Details_Products".
The conflict occurred in database "Northwind", table "dbo.Order Details", column 'ProductID'.
The statement has been terminated.
*/

SELECT * 
FROM productos_historial_eliminados
GO

/*
Eliminar uno de los productos insertados, los que no figuran con clave foránea. Según los 
registros insertados líneas arriba son los que tiene código 79, 80, 81
*/
DELETE Products WHERE ProductID = 79
GO

--Listando la tabla historial
SELECT * 
FROM productos_historial_eliminados
GO

/*
NOTA: 
- Al tener el historial se puede conservar los datos del registro eliminado.

Notas importantes
– Se sugiere evitar los campos con la propiedad Identity (Ver Identity)
– Se recomienda para almacenar los datos numéricos el uso de Numeric. (Ver Crear tablas)
*/