/*-- CURSORES CON VARIABLE TIPO TABLA EN SQL SERVER --

Los cursores guardan en memoria el resultado de una instrucción Select para luego poder recorrer los 
registros y poder con cada uno de ellos realizar algún tipo de trabajo.

Importante

Los cursores ocupan mucha memoria, evitar en lo posible el uso de estos y si deciden usarlos la cantidad de 
registros y los campos del select debería ser lo más selectiva posible.
Es recomendable guardar los datos del procesamiento del cursor en variables tipo tabla (Ver Variables 
tipo tabla) o tablas temporales (Ver tablas temporales) e incluir estos dentro de un procedimiento 
almacenado para ser consumido desde las aplicaciones.

En este artículo se presentan ejercicios de cursores con el uso de variables tipo tabla.
*/
USE Northwind
GO

/*EJERCICIO 01. Crear un cursor que muestre el código del empleado y el número de órdenes de pedido emitidas*/
DECLARE @empleados_ordenes TABLE(
	codigo CHAR(5), 
	empleado CHAR(100), 
	cant_ordenes INT
)

DECLARE @codigo CHAR(5)
DECLARE @empleado VARCHAR(100)
DECLARE @cant_ordenes INT

DECLARE c_empleados_ordenes CURSOR
FOR SELECT RIGHT('0000' + LTRIM(STR(e.EmployeeID)), 5) AS codigo, 
		   empleado = e.LastName + SPACE(1) + e.FirstName, 
		   COUNT(o.OrderID) AS cantidad
	FROM Employees AS e 
		INNER JOIN Orders AS o ON(e.EmployeeID = o.EmployeeID)
	GROUP BY e.EmployeeID, e.LastName + SPACE(1) + e.FirstName

OPEN c_empleados_ordenes

FETCH NEXT FROM c_empleados_ordenes INTO @codigo, @empleado, @cant_ordenes

WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @empleados_ordenes
		VALUES(@codigo, @empleado, @cant_ordenes)
		
		FETCH NEXT FROM c_empleados_ordenes INTO @codigo, @empleado, @cant_ordenes
	END
CLOSE c_empleados_ordenes
DEALLOCATE c_empleados_ordenes

SELECT * 
FROM @empleados_ordenes 
ORDER BY cant_ordenes DESC
GO

/*EJERCICIO 02. Crear un cursor que muestre un producto y la cantidad de unidades vendidas
y el monto total generado*/
DECLARE @productos_totales TABLE(
	codigo CHAR(5),
	descripcion VARCHAR(50),
	total_unidades NUMERIC(9,2),
	monto_total NUMERIC(9,2)
)

DECLARE @codigo CHAR(5)
DECLARE @descripcion VARCHAR(50)
DECLARE @total_unidades NUMERIC(9,2)
DECLARE @monto_total NUMERIC(9,2)

DECLARE c_productos_totales CURSOR
FOR SELECT  RIGHT('0000' + LTRIM(STR(p.ProductID)), 5) AS codigo,
			p.ProductName AS descripcion,
			SUM(od.Quantity) AS cantidad,
			SUM(od.Quantity * od.UnitPrice) AS 'monto total'
	FROM Products AS p
		INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
	GROUP BY p.ProductID, p.ProductName

OPEN c_productos_totales

FETCH NEXT FROM c_productos_totales INTO @codigo, @descripcion, @total_unidades, @monto_total

WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @productos_totales
		VALUES(@codigo, @descripcion, @total_unidades, @monto_total)

		FETCH NEXT FROM c_productos_totales INTO @codigo, @descripcion, @total_unidades, @monto_total
	END
CLOSE c_productos_totales
DEALLOCATE c_productos_totales

SELECT * 
FROM @productos_totales
ORDER BY descripcion
GO