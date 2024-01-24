/*-- FUNCIONES DE CURSOR --
Las funciones de cursor devuelven información de los cursores

Las funciones de cursor son las siguientes:
@CURSOR_ROWS
CURSOR_STATUS
@@FETCH_STATUS

Función @Cursor_rows
Devuelve el número de filas del cursor abierto.

Valor	Descripción
------------------------------------------------------
-m		El cursor se llena asincrónicamente. El valor –m es el número de filas actualmente en el 
		conjunto de claves.
-1		El cursor es dinámico. Como los cursores dinámicos reflejan todos los cambios, el número de 
		filas correspondientes al cursor cambia constantemente. Nunca se puede afirmar que se han 
		recuperado todas las filas que correspondan.
0		No se han abierto cursores, no hay filas calificadas para el último cursor abierto, o éste 
		se ha cerrado o su asignación se ha cancelado.
n		El cursor está completamente relleno. El valor devuelto (n) es el número total de filas del cursor.
*/
USE Northwind
GO

/*EJERCICIO 01. Crear un cursor con los productos de categoría 5*/
--Antes de declarar y abrir el cursor
SELECT @@CURSOR_ROWS
GO
--Resultado: 0

DECLARE c_productos_categoria_5 CURSOR
FOR SELECT * FROM Products WHERE CategoryID = 5
GO

OPEN c_productos_categoria_5
GO

--Después de abrir el cursor
SELECT @@CURSOR_ROWS
GO
--Resultado: -1

--Leer los datos del cursor
FETCH c_productos_categoria_5
GO

--Cerrar y liberar el cursor
CLOSE c_productos_categoria_5
DEALLOCATE c_productos_categoria_5
GO

/*FUNCIÓN @@FETCH_STATUS

Devuelve el estado de la última instrucción que lee los datos del cursor (FETCH).
El tipo de dato devuelto es entero

Valor	Descripción
-------------------------------------
0		La instrucción FETCH se ejecutó correctamente y muestra registro.
-1		La instrucción FETCH no se ejecutó correctamente y no muestra registro.
-2		Falta la fila capturada.
-9		El cursor no está realizando una operación de búsqueda.

Generalmente @@Fetch_Status es usada con la estructura While para leer los registros del cursor.
*/

/*EJERCICIO 02. Crea un cursor para mostrar los empleados*/
DECLARE c_empleados CURSOR 
FOR SELECT e.EmployeeID AS 'codigo', empleado = e.LastName + SPACE(1) + e.FirstName
	FROM Employees AS e
	ORDER BY empleado

OPEN c_empleados

FETCH FROM c_empleados

PRINT '======== Empleados ============'
WHILE @@FETCH_STATUS = 0
	BEGIN	
		FETCH FROM c_empleados
	END
CLOSE c_empleados
DEALLOCATE c_empleados
GO

/*FUNCIÓN CURSOR_STATUS
Permite determinar si el resultado de un procedimiento almacenado ha devuelto un cursor y un conjunto de 
resultados al recibir un parámetro.

Valor	Descripción
-1		El cursor está cerrado.
1		El cursor tiene al menos una fila.
0		El conjunto de resultados del cursor está vacío.
-3		No existe un cursor con el nombre indicado.
*/

/*EJERCICIO 03. Crear un cursor con las categorías*/

--Antes de crear el cursor
SELECT CURSOR_STATUS('global', 'c_categorias') AS 'antes de crear'
GO

DECLARE c_categorias CURSOR 
FOR SELECT c.CategoryID, c.CategoryName
	FROM Categories AS c
GO

--Antes de abrir el cursor
SELECT CURSOR_STATUS('global', 'c_categorias') AS 'Antes de abrir el cursor'
GO

--Después de abrir el cursor
OPEN c_categorias
GO

SELECT CURSOR_STATUS('global', 'c_categorias') AS 'Después de abrir el cursor'
GO
--Después de cerrar el cursor
CLOSE c_categorias
GO

SELECT CURSOR_STATUS('global', 'c_categorias') AS 'Después de cerrar el cursor'
GO

--Eliminando cursor
DEALLOCATE c_categorias
GO