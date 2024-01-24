/*-- CURSORES EN SQL SERVER --
Los cursores permiten almacenar los datos de una consulta T-SQL en memoria y poder manipular los datos 
de los elementos resultantes para realizar operaciones con ellos. Se recomienda su uso con cierto 
cuidado porque consume mucha memoria, la instrucción select que llena el cursor debe ser lo más 
selectiva posible.

Proceso para declarar, abrir, usar, cerrar y liberar los datos de un cursor

1. Declarar el cursor utilizando DECLARE CURSOR
2. Abrir el cursor utilizando OPEN
3. Leer los datos del cursor utilizando FETCH ...INTO
4. Cerrar el cursor utilizando CLOSE
5. Liberar el cursor utilizando DEALLOCATE

Las instrucciones reducidas para los pasos anterios son: 

1. Para declarar el cursor
	DECLARE nombreCursor CURSOR FOR instrucción select

2. Abrir el cursor
	OPEN nombreCursor

3. Lectura de los datos del cursor, va a depender del tipo de cursor. Hay de avance 
   hacia adelante solamente y Scroll.
	FETCH nombreCursor

   Si se va a recorrer el cursor, se debe almacenar los datos de cada registro en variables 
   previamente definidas con la variante siguiente:
	FETCH nombreCursor INTO listaVariables

   Para lectura de manera automática de los registros del cursor se usa la estructura While, 
   el bucle de esta estructura se ejecutará siempre que la función @@FETCH_STATUS sea igual a CERO. 
   La función @@FETCH_STATUS reporta CERO (0) cuando la instrucción Fetch lee un registro. 
   Al finalizar @@FETCH_STATUS toma el valor de -1.
	FETCH nombreCursor INTO listaVariables
	WHILE @@FETCH_STATUS = 0
		BEGIN
			....Instrucciones del bloque
			FETCH nombreCursor INTO listaVariables
		END
		
4. Cerrar el cursor
	CLOSE nombreCursor

5. Liberar el espacio de memoria ocupada por el cursor
	DEALLOCATE nombreCursor
*/

USE Northwind
GO
/*EJERCICIO 01. Cursor que reporta a los empleados*/
DECLARE c_empleados CURSOR 
FOR SELECT e.EmployeeID, e.LastName, e.FirstName
    FROM Employees AS e
GO

--Abrir el cursor 
OPEN c_empleados
GO

--Los datos disponibles se visualizan con FETCH, ejecutar varias veces para ver los resultados
FETCH c_empleados
GO

--La función @@FETCH_STATUS reporta CERO si hay registro
--Reporta -1 si ya no existen registros para mostrar

SELECT @@FETCH_STATUS
GO

--Cerrar el cursor, liberar memoria
CLOSE c_empleados
DEALLOCATE c_empleados
GO

/*EJERCICIO 02. Cursor que reporte la lista de productos. Si las unidades en orden son mayores
al stock, mostrar COMPRAR URGENTE, de lo contrario mostrar STOCK ADECUADO. 
NOTA: El ejercicio muestra mensajes, los que en la práctica no son realmente útiles.*/
DECLARE c_productos CURSOR
FOR SELECT p.ProductID AS codigo, p.ProductName AS descripcion, 
		   p.UnitsInStock AS stock, p.UnitsOnOrder AS por_atender
	FROM Products AS p

OPEN c_productos

DECLARE @codigo INT
DECLARE @descripcion VARCHAR(40)
DECLARE @stock SMALLINT
DECLARE @por_atender SMALLINT

FETCH c_productos INTO @codigo, @descripcion, @stock, @por_atender

PRINT '=========================== LISTADO ============================='
WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Código: ' +  STR(@codigo)
		PRINT 'Descripción: ' + @descripcion
		PRINT 'Stock: ' + STR(@stock)
		PRINT 'Por atender: ' + STR(@por_atender)

		IF @por_atender > @stock
			BEGIN				
				PRINT 'Mensaje: COMPRAR URGENTE'
			END
		ELSE
			BEGIN
				PRINT 'Mensaje: STOCK ADECUADO'
			END
		PRINT '--------------------------------------------------------------'
		FETCH c_productos INTO @codigo, @descripcion, @stock, @por_atender
	END

CLOSE c_productos

DEALLOCATE c_productos

/*CURSOR DE TIPO SCROLL
Para un cursor de tipo Scroll se pueden usar:  Firts, Next, Prior, Last, Relative n,
Absolute n para mostrar los diferentes registros.
*/

--Cursor Scroll para Categorias
DECLARE c_categorias SCROLL CURSOR
FOR SELECT * 
	FROM Categories AS c

OPEN c_categorias
GO

--Note que en la definición del cursor se ha utilizado la palabra SCROLL
--Mostrar los datos
FETCH c_categorias
GO

--Registro 6
FETCH ABSOLUTE 6 FROM c_categorias
GO

--Siguiente
FETCH NEXT FROM c_categorias
GO

--Anterior
FETCH PRIOR FROM c_categorias
GO

--Último
FETCH LAST FROM c_categorias
GO

--Tres anteriores
FETCH RELATIVE -3 FROM c_categorias
GO

--Dos hacia adelante
FETCH RELATIVE 2 FROM c_categorias
GO

--Primero
FETCH FIRST FROM c_categorias
GO

--Cerrar y liberar
CLOSE c_categorias
DEALLOCATE c_categorias
GO

/*CURSORES ANIDADOS*/
/*Listado de las categorias y sus productos. Incluir cantidad de productos por categoría
, valor del stock por categoría */
DECLARE c_categorias CURSOR
FOR SELECT c.CategoryID, c.CategoryName 
	FROM Categories AS c

OPEN c_categorias

DECLARE @cod_categoria INT, @categoria VARCHAR(15)

FETCH c_categorias INTO @cod_categoria, @categoria

PRINT '============================================================'
PRINT '============ LISTADO DE PRODUCTOS POR CATEGORÍA ============'
PRINT '============================================================'


WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Cód. Categoría: ' + TRIM(STR(@cod_categoria))
		PRINT 'Categoría: ' + @categoria
		PRINT '---------------------------------------------------------------'
		
		DECLARE c_productos CURSOR
		FOR SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock
			FROM Products AS p
			WHERE p.CategoryID = @cod_categoria

		OPEN c_productos

		DECLARE @cod_producto INT, @producto VARCHAR(40), @precio NUMERIC(9,2), @stock SMALLINT
		DECLARE @cant_productos_por_categoria NUMERIC(9,2) = 0
		DECLARE @valor_stock_por_categoria NUMERIC(9,2) = 0

		FETCH c_productos INTO @cod_producto, @producto, @precio, @stock

		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @cant_productos_por_categoria = @cant_productos_por_categoria + @stock
				SET @valor_stock_por_categoria = @valor_stock_por_categoria + @precio * @stock
				PRINT 'Cód. producto: ' + STR(@cod_producto) + ', producto: ' + @producto + ', precio: S/ ' + FORMAT(@precio, '##,###.00')			
				FETCH c_productos INTO @cod_producto, @producto, @precio, @stock
			END
		
		PRINT 'Cantidad de productos: ' + TRIM(STR(@cant_productos_por_categoria))
		PRINT 'Valor del stock: ' + TRIM(STR(@valor_stock_por_categoria))
		PRINT '---------------------------------------------------------------'
		CLOSE c_productos
		DEALLOCATE c_productos	
		
		FETCH c_categorias INTO @cod_categoria, @categoria
	END

CLOSE c_categorias
DEALLOCATE c_categorias


