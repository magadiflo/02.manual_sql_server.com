/*-- TABLAS TEMPORALES --*/
/*
Las tablas temporales en SQL Server son utilizadas para almacenar c�lculos intermedios
en transacciones que requieren de grandes cantidades de datos para ser manejados m�s 
eficientemente que con variables. 
Las tablas temporales se almacenan en la base de datos Tempdb.

Las tablas temporales son de dos tipos:

- Temporales locales: 
  Las tablas temporales locales incluyen en el nombre el s�mbolo # como primer car�cter. 
  Se crean por cada usuario conectado y la tabla se elimina autom�ticamente cuando el 
  usuario termina la sesi�n.

- Temporales globales: 
  Las tablas temporales globales inician con dos s�mbolos ## en el nombre y son visibles 
  por todos los usuarios conectados al servidor. Al desconectarse todos los usuarios, 
  la tabla temporal global se elimina autom�ticamente.

Consideraciones para el trabajo con tablas temporales:

- No se pueden usar Foreign key
- Las tablas temporales se almacenan en la base de datos del sistema Tempdb
- Una tabla temporal creada en un SP s�lo est� presente cuando se completa las 
  transacciones del procedimiento almacenado
- Las tablas temporales locales se pueden crear con el mismo nombre para diferentes 
  inicios de sesi�n (Ver Logins), SQL Server le incluye un sufijo para diferenciarlas.
- Los dos tipos de tablas se pueden quitar usando DROP TABLE.
*/

/*EJERCICIO 01. Para ver las tablas temporales por cada usuario, vamos a
crear los inicios de sesi�n Gerente y Vendedor*/
USE master
GO

--gerente
CREATE LOGIN gerente WITH PASSWORD = 'gerente'
GO

--Agregarlo al sysadmin (No hacer esto en ambiente de producci�n)
ALTER SERVER ROLE SYSADMIN
ADD MEMBER gerente
GO

--vendedor
CREATE LOGIN vendedor WITH PASSWORD = 'vendedor'
GO

--Agregarlo al sysadmin
ALTER SERVER ROLE SYSADMIN
ADD MEMBER vendedor
GO

/*EJERCICIO 02. Iniciar sesi�n con gerente y crear una tabla temporal #pruebas*/
/*
- Asegurarse que este script tambi�n est� conectado como gerente
- El siguiente c�digo se escribir� estando conectado como Gerente. 
  Debe abrir una nueva consulta, se recomienda para hacer las pruebas volver a 
  cargar SQL Server Management Studio.
*/
-- Usando Northwind
USE Northwind
GO

CREATE TABLE #pruebas(
	codigo CHAR(4),
	descripcion VARCHAR(20),
	CONSTRAINT pk_pruebas_ger PRIMARY KEY(codigo)
)
GO

-- Insertar registros
INSERT INTO #pruebas(codigo, descripcion)
VALUES('9867', 'Tablas Gerente'),
('7499', 'Datos Gerente'),
('7684', 'Medios Gerente')
GO

-- Visualizar los datos
SELECT * FROM #pruebas
GO

/*EJERCICIO 03. Iniciar sesi�n con vendedor y crear una tabla temporal #pruebas*/
/*
- Asegurarse que este script tambi�n est� conectado como vendedor
- El siguiente c�digo se escribir� estando conectado como Vendedor
*/
USE Northwind
GO

CREATE TABLE #pruebas(
	codigo CHAR(4),
	descripcion VARCHAR(20),
	CONSTRAINT pk_pruebas_ven PRIMARY KEY(codigo)
)
GO

-- Insertar registros
INSERT INTO #pruebas(codigo, descripcion)
VALUES('4578', 'Vendedor Dato1'),
('5892', 'Vendedor Ingreso'),
('7900', '�ltimo de Vendedor')
GO

-- Visualizar los datos
SELECT * FROM #pruebas
GO

/*
- Se puede comprobar que existen dos tablas #pruebas. 
- En el exploradr de objetos de Microsoft SQL Server Managament Studio
  despliegue las bases del sistema y luego el nodo tablas temporales 
  de la base de datos Tempdb. 
- SQL Server les incluye un sufijo para cada usuario

NOTA: Es importante que no se cierre la sessi�n de ambos usuarios para ver
las dos tablas temporales. De cerrar sesi�n se eliminar� autom�ticamente la
tabla asociada al usuario que se desconect�. Por eso se recomienda abrir 
una consultas separadas para cada usuario.
*/

/*EJERCICIO 04. Crear una tabla temporal GLOBAL, esta la puede crear en cualquier
inicio que tenga permisos*/
CREATE TABLE ##empresa_datos(
	codigo CHAR(3),
	nombre VARCHAR(100),
	direccion VARCHAR(100)
)
GO

-- Insertar registro
INSERT INTO ##empresa_datos
VALUES('298', 'Trainer SQL Team', 'Av. Trainer 4996')
GO

--Comprueba que todos los usuarios conectados tienen acceso a los registros de esta tabla
--Es decir, ir a la conexi�n abierta de gerente y vendedor o si hay m�s conexiones abiertas
--Realizar esta consulta
SELECT * FROM ##empresa_datos
GO

/*EJERCICIO 05. Crear una tabla temporal usando la cl�usula INTO de la instrucci�n SELECT*/
USE Northwind
GO

SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock
INTO #lista_precios
FROM Products AS p 
WHERE p.Discontinued = 0
ORDER BY p.ProductName
GO

SELECT * 
FROM #lista_precios
GO

/*Eliminando tabla temporal local*/
DROP TABLE #pruebas
GO

/*Eliminando tabla temporal global*/
DROP TABLE ##empresa_datos
GO