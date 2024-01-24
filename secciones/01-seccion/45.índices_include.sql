/*-- USO DE INCLUDE EN ÍNDICES SQL SERVER --

El uso de include en los índices permite ampliar la funcionalidad de los índices no agrupados. 

BENEFICIOS DEL USO DE INCLUDE
- Se pueden usar tipos de datos no permitidos en índices
- No son considerados como una columna mas en la cantidad de columnas del índice o en el tamaño 
  del índice. La cantidad de columnas máxima en un índice es 32.
- Recuerde que el tamaño máximo del índice es de 1700bytes
- Aumenta la efectividad de las consultas

LIMITACIONES
- Se usan en sólo índices no agrupados (NONCLUSTERED)
- Se pueden usar todos los tipos de datos excepto text, ntext, and image
- No se pueden eliminar las columnas incluidas con include salvo que se elimine primero el índice

ÍNDICES CON CAMPOS INCLUIDOS (INFORMACIÓN ADICIONAL)
Obtenido de: http://dbadixit.com/indices-con-campos-incluidos-include/

Supongamos que tenemos una tabla DATOS con los campos: ID, nombre, apellidos, sexo y turno
Además se crea para esta tabla un índice por nombre. Este índice está en un árbol (que es
una estructura adicional a los datos) que está asociado a la tabla DATOS. De esta manera si 
se ejecuta la siguiente consulta: 
	SELECT nombre, apellido
	FROM datos
	WHERE nombre = 'Juan';
El motor de base de datos utiliza el índice por nombre ejecutando lo siguiente:
- Busca dentro del índice (el árbol [binario]) un nodo que corresponda con el nombre buscado
  en este caso es 'Juan'
- Una vez encontrado el nodo (donde solo está el nombre y un "apuntador" al registro que 
  contiene los datos de juan, es decir un "apuntador" dirigido  hacia el registro 
  de 'Juan' ubicado en la tabla Datos) utiliza la información en el nodo para ubicar el registro
  de la tabla y hace una seguna lectura del registro correspondiente.
- Con el nombre que obtuvo del índice, más el apellido que obtudo de los datos puede 
  responder al query y regresar los 2 campos requeridos (nombre y apellido)
En este caso, la búsqueda es más eficiente que hcerla sin el índice (por que tendría que hacer un
barrido secuencial de toda la tabla para encontrar los registros que tengan 'Juan' en el nombre,
pero tiene que hacer un salto del punto 2 (llamado lookup en el plan de ejecución) para poder
responder al query que requería de 2 campos.

¿Qué pasa si la consulta solo necesita del nombre y apelido?
Si un usuario quiera ejecutar una consulta que solo requiera dos campos específicos,
en este caso nombre ay apellido , tenría que escribir el siguiente query
	SELECT nombre, apellido
	FROM datos
	WHERE nombre = 'Juan';
En este caso SQL Server se tiene que hacer el mismo procedimiento, ya que necesita hacer el 'salto'
a los datos una vez que encuentre el registro en el índice.

¿Y si existiera una forma de ahorrarse ese salto?
Existe, y en este caso se trata de los índices con campos INCLUIDOS.

Un índice con campos incluidos lo que hace es que añade a cada nodo del árbol del índice los campos
que nosotros queramos, pero sin formar parte de la llave, solo son datos adicionales. En ese sentido
es un índice inermedio entre los índices cluster y los noncluster, ya que el índice contien datos
adicionales a la llave. El índice se podría ver de la siguiente manera.
	//Se muestra un ábrol binario con nodos, en cada nodo está el nombre (como índice) y en el 
	//mismo nodo, debajo, está el apellido
De esta manera, cuando se ejecuta el código
	SELECT nombre, apellido
	FROM datos
	WHERE nombre = 'Juan';

Ya no es necesario el salto a la tabla de datos, ya que toda la información que se necesita
para responder a la petición ya se tiene dentro del índice (tanto  nombre (llave) como apellido). 
Es por eso que el uso de SELECT * es tan penalizado en el performance, ya que siempre obliga a hacer
el lookup a la tabla de datos, y siempre se deberá preferir un SELECT con la enumeración
de los campos requeridos por si existiese un índice que puediera evitar esa lectura adicional

VENTAJAS
- Existe un ahorro de tiempo de procesamiento, ya que no hay que leer el índice y después
  hacer el salto a la tabla de datos

DESVENTAJAS
- El índice ocupa ahora más espacio (el campo o los campos incluidos se duplicarán, ya que
  están en la tabla de datos y en el índice)

Un índice de este tipo es recomendable cuando existen muchas consultas que solo requieren 
algunos datos - pocos- adicionales a los que tiene la llave y vale la pena la duplicidad de
datos por la ganancia en el tiempo de procesamiento
EJERCICIOS
*/
USE Northwind
GO

/*EJERCICIO 01. Crear un índice para la tabla productos por su ProductName, incluir
los campos Unidad y Precio*/
CREATE INDEX idx_productos_unidad_precio
ON products(ProductName)
INCLUDE([QuantityPerUnit], [UnitPrice])
GO

--Ejecutando una consulta por el índice
SELECT ProductName, QuantityPerUnit, UnitPrice
FROM products
WHERE ProductName LIKE 'Sir%'
GO

/*EJERCICIO 02. Crear un índice para Empleados por LastName y FirstName,
incluir Title y Address*/
CREATE INDEX idx_empleados_title_address
ON Employees(LastName ASC, FirstName ASC)
INCLUDE([Title], [Address])
GO

--Ver los índices creados
SELECT * 
FROM SYS.INDEXES 
WHERE name LIKE 'idx%' OR name LIKE '%productos%'
GO

/*EJERCICIO 03. Crear un índice para clientes(Customers) para el campo ContactName,
incluir Country, Region y City. 
Asignar un factor de relleno de 70 y dar consistencia si existe*/
IF NOT EXISTS(SELECT * FROM SYS.INDEXES WHERE name = 'idx_clientes_contacto')
	BEGIN
		CREATE INDEX idx_clientes_contacto
		ON Customers(ContactName)
		INCLUDE(Country, Region, City)
		WITH FILLFACTOR = 70
	END
ELSE
	BEGIN
		CREATE INDEX idx_clientes_contacto
		ON Customers(ContactName)
		INCLUDE(Country, Region, City)
		WITH (FILLFACTOR = 70, DROP_EXISTING = ON)
	END
GO

/*Cambiar el nombre al índice
Para cambiar el nombre de un objeto en la base de datos se utiliza el procedimiento
almacenado SP_RENAME, específicamente para cambiar el nombre a un índice la
sintaxis es como sigue: 
	EXECUTE SP_RENAME 'Tabla.NombreIndiceOriginal', 'NuevoNombre', 'INDEX'
	GO

EJERCICIO 04. Cambiar el nombre del índice idx_productos_unidad_precio por
idx_productos_nombre_unidad_precio
*/
EXECUTE SP_RENAME 'products.idx_productos_unidad_precio', 'idx_productos_nombre_unidad_precio', 'INDEX'
GO

/*
Resultado:
Precaución: al cambiar cualquier parte del nombre de un objeto pueden dejar de ser scripts válidos y
procedimientos almacenados.
*/