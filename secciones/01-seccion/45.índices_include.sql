/*-- USO DE INCLUDE EN �NDICES SQL SERVER --

El uso de include en los �ndices permite ampliar la funcionalidad de los �ndices no agrupados. 

BENEFICIOS DEL USO DE INCLUDE
- Se pueden usar tipos de datos no permitidos en �ndices
- No son considerados como una columna mas en la cantidad de columnas del �ndice o en el tama�o 
  del �ndice. La cantidad de columnas m�xima en un �ndice es 32.
- Recuerde que el tama�o m�ximo del �ndice es de 1700bytes
- Aumenta la efectividad de las consultas

LIMITACIONES
- Se usan en s�lo �ndices no agrupados (NONCLUSTERED)
- Se pueden usar todos los tipos de datos excepto text, ntext, and image
- No se pueden eliminar las columnas incluidas con include salvo que se elimine primero el �ndice

�NDICES CON CAMPOS INCLUIDOS (INFORMACI�N ADICIONAL)
Obtenido de: http://dbadixit.com/indices-con-campos-incluidos-include/

Supongamos que tenemos una tabla DATOS con los campos: ID, nombre, apellidos, sexo y turno
Adem�s se crea para esta tabla un �ndice por nombre. Este �ndice est� en un �rbol (que es
una estructura adicional a los datos) que est� asociado a la tabla DATOS. De esta manera si 
se ejecuta la siguiente consulta: 
	SELECT nombre, apellido
	FROM datos
	WHERE nombre = 'Juan';
El motor de base de datos utiliza el �ndice por nombre ejecutando lo siguiente:
- Busca dentro del �ndice (el �rbol [binario]) un nodo que corresponda con el nombre buscado
  en este caso es 'Juan'
- Una vez encontrado el nodo (donde solo est� el nombre y un "apuntador" al registro que 
  contiene los datos de juan, es decir un "apuntador" dirigido  hacia el registro 
  de 'Juan' ubicado en la tabla Datos) utiliza la informaci�n en el nodo para ubicar el registro
  de la tabla y hace una seguna lectura del registro correspondiente.
- Con el nombre que obtuvo del �ndice, m�s el apellido que obtudo de los datos puede 
  responder al query y regresar los 2 campos requeridos (nombre y apellido)
En este caso, la b�squeda es m�s eficiente que hcerla sin el �ndice (por que tendr�a que hacer un
barrido secuencial de toda la tabla para encontrar los registros que tengan 'Juan' en el nombre,
pero tiene que hacer un salto del punto 2 (llamado lookup en el plan de ejecuci�n) para poder
responder al query que requer�a de 2 campos.

�Qu� pasa si la consulta solo necesita del nombre y apelido?
Si un usuario quiera ejecutar una consulta que solo requiera dos campos espec�ficos,
en este caso nombre ay apellido , tenr�a que escribir el siguiente query
	SELECT nombre, apellido
	FROM datos
	WHERE nombre = 'Juan';
En este caso SQL Server se tiene que hacer el mismo procedimiento, ya que necesita hacer el 'salto'
a los datos una vez que encuentre el registro en el �ndice.

�Y si existiera una forma de ahorrarse ese salto?
Existe, y en este caso se trata de los �ndices con campos INCLUIDOS.

Un �ndice con campos incluidos lo que hace es que a�ade a cada nodo del �rbol del �ndice los campos
que nosotros queramos, pero sin formar parte de la llave, solo son datos adicionales. En ese sentido
es un �ndice inermedio entre los �ndices cluster y los noncluster, ya que el �ndice contien datos
adicionales a la llave. El �ndice se podr�a ver de la siguiente manera.
	//Se muestra un �brol binario con nodos, en cada nodo est� el nombre (como �ndice) y en el 
	//mismo nodo, debajo, est� el apellido
De esta manera, cuando se ejecuta el c�digo
	SELECT nombre, apellido
	FROM datos
	WHERE nombre = 'Juan';

Ya no es necesario el salto a la tabla de datos, ya que toda la informaci�n que se necesita
para responder a la petici�n ya se tiene dentro del �ndice (tanto  nombre (llave) como apellido). 
Es por eso que el uso de SELECT * es tan penalizado en el performance, ya que siempre obliga a hacer
el lookup a la tabla de datos, y siempre se deber� preferir un SELECT con la enumeraci�n
de los campos requeridos por si existiese un �ndice que puediera evitar esa lectura adicional

VENTAJAS
- Existe un ahorro de tiempo de procesamiento, ya que no hay que leer el �ndice y despu�s
  hacer el salto a la tabla de datos

DESVENTAJAS
- El �ndice ocupa ahora m�s espacio (el campo o los campos incluidos se duplicar�n, ya que
  est�n en la tabla de datos y en el �ndice)

Un �ndice de este tipo es recomendable cuando existen muchas consultas que solo requieren 
algunos datos - pocos- adicionales a los que tiene la llave y vale la pena la duplicidad de
datos por la ganancia en el tiempo de procesamiento
EJERCICIOS
*/
USE Northwind
GO

/*EJERCICIO 01. Crear un �ndice para la tabla productos por su ProductName, incluir
los campos Unidad y Precio*/
CREATE INDEX idx_productos_unidad_precio
ON products(ProductName)
INCLUDE([QuantityPerUnit], [UnitPrice])
GO

--Ejecutando una consulta por el �ndice
SELECT ProductName, QuantityPerUnit, UnitPrice
FROM products
WHERE ProductName LIKE 'Sir%'
GO

/*EJERCICIO 02. Crear un �ndice para Empleados por LastName y FirstName,
incluir Title y Address*/
CREATE INDEX idx_empleados_title_address
ON Employees(LastName ASC, FirstName ASC)
INCLUDE([Title], [Address])
GO

--Ver los �ndices creados
SELECT * 
FROM SYS.INDEXES 
WHERE name LIKE 'idx%' OR name LIKE '%productos%'
GO

/*EJERCICIO 03. Crear un �ndice para clientes(Customers) para el campo ContactName,
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

/*Cambiar el nombre al �ndice
Para cambiar el nombre de un objeto en la base de datos se utiliza el procedimiento
almacenado SP_RENAME, espec�ficamente para cambiar el nombre a un �ndice la
sintaxis es como sigue: 
	EXECUTE SP_RENAME 'Tabla.NombreIndiceOriginal', 'NuevoNombre', 'INDEX'
	GO

EJERCICIO 04. Cambiar el nombre del �ndice idx_productos_unidad_precio por
idx_productos_nombre_unidad_precio
*/
EXECUTE SP_RENAME 'products.idx_productos_unidad_precio', 'idx_productos_nombre_unidad_precio', 'INDEX'
GO

/*
Resultado:
Precauci�n: al cambiar cualquier parte del nombre de un objeto pueden dejar de ser scripts v�lidos y
procedimientos almacenados.
*/