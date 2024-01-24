/*-- COLUMNSTORE INDEX EN SQL SERVER --

La importancia de los índices en las consultas radica en que estos van a permitir optimizar 
la obtención del conjunto de resultados.

Los índices son estructuras que ordenan los registros de una tabla o vista por uno o más 
campos de manera ascendente o descendente.

Los índices en una tabla o vista guardan todas las columnas del registro, si es necesario 
buscar un campo de un registro específico lo que hace la consulta es leer toda la fila y 
luego extraer el dato que se requiere. 

Los Column Store Index almacenan los datos en columnas, esto mejora la compresión de datos, 
reduce considerablemente los datos de E/S ya que se leerán solamente las columnas necesarias 
y mejora el desempeño. 

En este artículo se va a explicar el uso de los Column Store index.

BENEFICIOS DE LOS COLUMNSTORE INDEX
- Proporciona un nivel de compresión más alto, aproximadamente 10 veces.
- Mejora el rendimiento de los índices B-Tree.
- Se pueden hacer filtros en índices desde SQL Server 2016.
- Óptimo formato de almacenamiento para Datawarehouse y Analytics.
- Usan menos memoria debido a la alta tasa de compresión.
- Reduce el IO total al leer solamente las columnas necesarias en la consulta.
- A partir de SQL Server 2014 se incorpora un Clusteres columnstore index que es actualizable.
- Es posible usarlos en ambientes AlwaysOn.
- Mejora el rendimiento en agrupamientos.
- A partir de SQL Server 2016 se puede modificar los datos de la tabla que tiene el índice 
  ColumnStore sin tener que eliminar el índice y luego de los cambios volver a crearlo.

CONSIDERACIONES
- No se permiten tipos de datos ntex, text, image, varchar(max), nvarchar(max), jerárquicos 
  ni espaciales.
- En SQL Server 2014 sólo estaba disponible para la versión Enterprise.
- No se permiten tablas con fileStream
- Necesita un espacio adicional para almacenar las columnas elegidas.

EJERCICIOS
*/
USE Northwind
GO

/*EJERCICIO 01. Crear una tabla pruebas e insertar registros. 
En este ejercicio se explica cómo crear un índice ColumnStore no agrupado*/
IF EXISTS(SELECT * FROM SYS.TABLES WHERE name = 'pruebas')
	BEGIN
		DROP TABLE pruebas
	END
GO
CREATE TABLE pruebas(
	codigo INT, 
	fecha DATE,
	dato1 VARCHAR(30),
	dato2 VARCHAR(30),
	dato3 VARCHAR(30),
	dato4 VARCHAR(30),
	valor1 INT,
	valor2 INT,
	valor3 INT,
	valor4 INT,
	valor5 INT,
)
GO

/*Insertar 3 millones de registros. 
Pruede probar con menos registros, esta inserción puede llevar algo más de 
20 minutos, dependiendo de la velocidad y memoria de su equipo*/
SET DATEFORMAT dmy
SET NOCOUNT ON
DECLARE @valor INT = 1
WHILE @valor <= 3000000
	BEGIN
		INSERT INTO pruebas
		VALUES(@valor, DATEADD(D, @valor, '01/01/1920'), 
		'Dato texto' + CAST(ROUND(RAND()*100,0) AS VARCHAR),  
		'Dato texto' + CAST(ROUND(RAND()*100,0) AS VARCHAR),
		'Dato texto' + CAST(ROUND(RAND()*100,0) AS VARCHAR),
		'Dato texto' + CAST(ROUND(RAND()*100,0) AS VARCHAR),
		ROUND(RAND()*200000, 0),
		ROUND(RAND()*200000, 0),
		ROUND(RAND()*200000, 0),
		ROUND(RAND()*200000, 0),
		ROUND(RAND()*200000, 0))

		SET @valor += 1
	END
GO

--Listar los registros de la tabla pruebas
SELECT * FROM pruebas
GO

/************************* A PARTIR DE AQUÍ PARA ADELANTE FALTA ************************/
--Creando índices no agrupados
--El índice B-TREE no agrupado
CREATE NONCLUSTERED INDEX idx_pruebas_dato1_valor1
ON pruebas(dato1, valor1)
GO

--El índice ColumnStore no agrupado
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_pruebas_dato1_valor1_columnstore
ON pruebas(dato1, valor1)
GO

/*GOBERNADOR DE RECURSOS RESOURCE GOVERNOR
El regulador de recursos de SQL Server es una función que puede utilizar para administrar la 
carga de trabajo de SQL Server y el consumo de recursos del sistema. Resource Governor le 
permite especificar límites en la cantidad de CPU, E / S físicas y memoria que pueden usar 
las solicitudes de aplicaciones entrantes.

El Gobernador de recursos en SQL Server (Resource Governor) es una funcionalidad que permite 
administrar el uso de recursos que tiene la instancia para diferentes aplicaciones y usuarios. 
El Resource Governor se activa en tiempo real al establecer los límites de memoria y CPU, esta 
opción ayudar a prevenir que una transacción o proceso consuma todos los recursos del sistema.

Modifica la cantidad de memoria máxima a 75% al grupo de cargas de trabajo por defecto. 
*/
ALTER WORKLOAD GROUP[default] 
WITH(request_max_memory_grant_percent = 75)
GO

ALTER RESOURCE GOVERNOR RECONFIGURE
GO

--Visualizar los valores de los grupos de cargas de trabajo
SELECT name, request_max_memory_grant_percent
FROM SYS.DM_RESOURCE_GOVERNOR_WORKLOAD_GROUPS
GO

/*Realizando consultas de la tabla pruebas, una de las cuales es usando el columnstore index
y la otra con el índice agrupado, ambos con las mismas columnas de indexación
*/

--Consulta que usa el ColumnStore Index
SELECT dato1, AVG(CAST((valor1) AS FLOAT)) AS 'promedio'
FROM pruebas
GROUP BY dato1
GO

--Consulta que usa el índice B-Tree
SELECT dato1, AVG(CAST((valor1) AS FLOAT)) AS 'promedio'
FROM pruebas
GROUP BY dato1
OPTION(TABLE HINT(pruebas, INDEX(idx_pruebas_dato1_valor1)))
GO

/*
IMPORTANTE:
- Note la diferencia entre los valores del costo estimado de subárbol:
	Valor del costo estimado de subárbol con el COLUMN STORE INDEX: 2.5667
	Valor de costo estimado de subárbol con el B-TREE INDEX: 15.6488
- Obviamente hay una diferencia muy notoria lo que hacer muy recomendable
  usar listado con los índices de tipo COLUMN STORE INDEX
*/

/*EJERCICIO 02. Usando la tabla Order Details de Northwind*/
--La estructura de la tabla muestra los índices
SP_HELP [Order Details]
GO
--Note que dentro del resultado existe un índice para el campo ProductID

/*Mostrar las unidades vendidas por producto. Se obtendrá el resultado usando un 
índice B-TREE vs. el uso de un COLUMNSTORE INDEX
*/

SELECT d.ProductID AS 'codigo', SUM(d.Quantity) AS 'cantidad'
FROM [Order Details] AS d
GROUP BY d.ProductID
ORDER BY d.ProductID
GO

--Crear el COLUMNSTORE INDEX para el campo ProductID
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_detalle_codigo_producto_columnstore
ON [Order Details](ProductID)
GO

--En la vista indexes se puede visualizar el índice creado
SELECT * FROM SYS.INDEXES
WHERE name LIKE '%detalle%'
GO

--Al visualizar nuevamente la estructura de la tabla
SP_HELP [Order Details]
GO

--Note que ahora existen además de todos los índices un COLUMN STORE INDEX

--Listar neuvamente los productos y las unidades vendidas
SELECT d.ProductID AS 'codigo', SUM(d.quantity) AS 'cantidad'
FROM [Order Details] AS d
GROUP BY d.ProductID
ORDER BY d.ProductID
GO

--El resultado del plan de ejecuación estimado y el costo estimado del subárbols se meustra
--En el Execution plan

/*Note la diferencia:
Sin el columnstore index el costo de subárbol estimado es de: 0.0523268
Con el columnstore index el costo de subárbol estimado es de: 0.0192329*/

--Eliminar el columnstore index
DROP INDEX idx_detalle_codigo_producto_columnstore
ON [Order Details]
GO

/*CONVERTIR UN ÍNDICE B-TREE EN COLUMNSTORE INDEX

EJERCICIO 03. Crear una tabla, luego crear el índice agrupado B-TREE y luego
convertirlo en un COLUMNSTORE INDEX
*/
CREATE TABLE miTabla(
	codigo CHAR(4) NOT NULL,
	fecha DATE,
	cantidad NUMERIC(9,2),
	descripcion VARCHAR(50)
)
GO

--Crear el índice agrupado
CREATE CLUSTERED INDEX pk_idx_miTabla
ON miTabla(codigo)
GO

/*Convertirlo a columnstore index
NOTE: que se especifica el mismo nombre del índice y se adiciona la palabra COLUMNSTORE.
Adicionalmente como el índice ya existe se incluye la opción DROP_EXISTING = ON
*/
CREATE CLUSTERED COLUMNSTORE INDEX pk_idx_miTabla
ON miTabla
WITH (DROP_EXISTING = ON)
GO

/*Creando un NONCLUSTERED COLUMNSTORE INDEX
Primero convertir el clustered columnstore index en B-TREE INDEX*/
CREATE CLUSTERED INDEX pk_idx_miTabla
ON miTabla(codigo)
WITH(DROP_EXISTING = ON)
GO

--Crear el NONCLUSTERED COLUMNSTORE INDEX
IF EXISTS(SELECT name FROM SYS.INDEXES WHERE name = 'idx_miTabla_columnstore')
	BEGIN
		CREATE NONCLUSTERED COLUMNSTORE INDEX idx_miTabla_columnstore
		ON miTabla(fecha, cantidad)
		WITH(DROP_EXISTING=ON)
	END
ELSE
	BEGIN
		CREATE NONCLUSTERED COLUMNSTORE INDEX idx_miTabla_columnstore
		ON miTabla(fecha, cantidad)
	END
GO

--Para mostrar la estructura de la tabla miTabla
SP_HELP miTabla
GO