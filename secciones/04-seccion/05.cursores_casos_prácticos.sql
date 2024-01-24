/*-- CURSORES CASOS PRÁCTICOS --

Cursores
Elemento que almacena en memoria el resultado de un Select. Para mayor información ver 
Cursores en SQL Server

Pasos
1. Declarar el cursor, utilizando DECLARE
2. Abrir el cursor, utilizando OPEN
3. Leer los datos del cursor, utilizando FETCH … INTO
4. Cerrar el cursor, utilizando CLOSE
5. Liberar el cursor, utilizando DEALLOCATE

Las sintaxis de las instrucciones es como sigue:

DECLARE <NOMBRE_CURSOR> CURSOR 
FOR <SENTENCIA_SQL>

OPEN <NOMBRE_CURSOR>

FETCH <NOMBRE_CURSOR> INTO <LISTA_VARIABLES>

WHILE (@@FETCH_STATUS = 0)
	BEGIN
		.....
		.....
		FETCH <NOMBRE_CURSOR> INTO <LISTA_VARIABLES>
	END — FIN DEL BUCLE WHILE

CLOSE <NOMBRE_CURSOR>

DEALLOCATE <NOMBRE_CURSOR>
*/
USE Northwind
GO

/*EJERCICIO 01. Cursor que liste las categorías, el resultado se muestra como sigue*/
DECLARE c_categorias CURSOR
FOR SELECT CategoryID, CategoryName
	FROM Categories

OPEN c_categorias

DECLARE @cod_categoria INT, @categoria VARCHAR(15)

FETCH c_categorias INTO @cod_categoria, @categoria

WHILE @@FETCH_STATUS = 0 -- 0 cuando existen registros por leer, -1 cuando ya no existen registros
	BEGIN
		PRINT 'código: ' + TRIM(STR(@cod_categoria)) + ', categoría: ' + @categoria
		FETCH c_categorias INTO @cod_categoria, @categoria
		PRINT @@FETCH_STATUS
	END
CLOSE c_categorias
DEALLOCATE c_categorias
GO

/*EJERCICIO 02. Actualizar el precio de los productos: si su stock es mayor o igual a 100, 
se descuenta el precio al 50%, sino se descuenta el precio al 20%*/
DECLARE c_actualiza_precios_productos CURSOR
FOR SELECT ProductID, ProductName, UnitPrice, UnitsInStock
	FROM Products
OPEN c_actualiza_precios_productos 
DECLARE @id INT, @nombre VARCHAR(255), @precio DECIMAL, @stock_actual INT
FETCH c_actualiza_precios_productos INTO @id, @nombre, @precio, @stock_actual
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @stock_actual >= 100
			BEGIN
				SET @precio = @precio*0.5
			END
		ELSE 
			BEGIN
				SET @precio = @precio*0.8
			END
		UPDATE Products
		SET UnitPrice = @precio 
		WHERE CURRENT OF c_actualiza_precios_productos
		PRINT 'El precio del procuto ' + @nombre + ' es ' + TRIM(STR(@precio))
		FETCH c_actualiza_precios_productos INTO @id, @nombre, @precio, @stock_actual
	END
CLOSE c_actualiza_precios_productos
DEALLOCATE c_actualiza_precios_productos
GO

/*CURSORES ANIDADOS
Cursor que muestre las categorías de cada categoría los productos*/
DECLARE c_categorias CURSOR
FOR SELECT CategoryID, CategoryName
	FROM Categories

OPEN c_categorias
DECLARE @codigo_categoria INT, @categoria VARCHAR(15)
FETCH c_categorias INTO @codigo_categoria, @categoria
WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'cod. cate: ' + TRIM(STR(@codigo_categoria)) + ', categoría: ' + @categoria
		PRINT '---------------------------------------------------------------------------'
		DECLARE c_productos CURSOR
		FOR SELECT p.ProductID, p.ProductName, p.UnitPrice
			FROM Products AS p
			WHERE p.CategoryID = @codigo_categoria

		OPEN c_productos
		DECLARE @cod_producto INT, @producto VARCHAR(40), @precio DECIMAL
		FETCH c_productos INTO @cod_producto, @producto, @precio
		WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT 'cod. producto: ' + TRIM(STR(@cod_producto)) + 
				', producto: ' + @producto + ', precio:  S/ ' + TRIM(STR(@precio))
				FETCH c_productos INTO @cod_producto, @producto, @precio
			END
			CLOSE c_productos
			DEALLOCATE c_productos
		FETCH c_categorias INTO @codigo_categoria, @categoria
	END
CLOSE c_categorias
DEALLOCATE c_categorias
GO

/*CURSOR SCROLL
Para leer los datos del cursor definido como scroll, en en la instrucción FETCH se p uede
usar las siguientes palabras para desplazarse
— First – Primer registro
— Last – Último registro
— Next – Siguiente Registro
— Prior – Registro Anterior
— Relative n – Positivo Avanza n
— Negativo Retrocede n
— Absolute n – Registro n

— NO OLVIDAR USAR LA CLAUSULA…. FROM
*/

--Crear un cursor Scroll con las categorías
DECLARE c_categorias_scroll SCROLL CURSOR
FOR SELECT *
	FROM Categories
OPEN c_categorias_scroll
GO

--Recién abierto, la siguiente instrucción lee el primer registro
FETCH c_categorias_scroll
GO

--Primero
FETCH FIRST FROM c_categorias_scroll
GO

--Último
FETCH LAST FROM c_categorias_scroll
GO

--Retroceder 3
FETCH RELATIVE -3 FROM c_categorias_scroll
GO

--Al número 6
FETCH ABSOLUTE 6 FROM c_categorias_scroll
GO

--Siguiente
FETCH NEXT FROM c_categorias_scroll
GO

--Anterior
FETCH PRIOR FROM c_categorias_scroll
GO

--Cerrar y liberar
CLOSE c_categorias_scroll
DEALLOCATE c_categorias_scroll
GO