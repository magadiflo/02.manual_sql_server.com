/*-- FUNCIONES DE CONVERSI�N DE DATOS --

Los datos en muchas ocasiones deben ser convertidos y transformados en un est�ndar para poder tratarlos, 
para esto se deben usar las funciones de Conversi�n de datos.

Las siguientes funciones admiten la conversi�n de tipos de datos.

* CAST y CONVERT � Convierte una expresi�n de un tipo de datos en otro.
* PARSE � Devuelve el resultado de una expresi�n, traducido al tipo de datos solicitado en SQL Server.
* TRY_CONVERT � Devuelve una conversi�n de valor al tipo de datos especificado si la conversi�n se realiza 
  correctamente; de lo contrario, devuelve NULL.
* TRY_PARSE � Devuelve el resultado de una expresi�n, traducido al tipo de datos solicitado, o NULL si se 
  produce un error en la conversi�n en SQL Server. Use TRY_PARSE solo para convertir de tipos de cadena a 
  tipos de fecha y hora y de n�mero.

Sintaxis y Ejemplos
Sintaxis CAST
CAST ( expression AS data_type [ ( length ) ] )

Sintaxis CONVERT
CONVERT ( data_type [ ( length ) ] , expression [ , style ] )

Donde:

expresi�n: Se trata de cualquier expresi�n.
data_type: Es el tipo de datos de destino. Esto incluye xml, bigint, y sql_variant. No se pueden utilizar 
tipos de datos de alias.

longitud: Es un n�mero entero opcional que especifica la longitud del tipo de datos de destino. 
El valor predeterminado es 30.

estilo: Expresi�n entera que especifica c�mo la funci�n CONVERT convertir expresi�n. Si style es NULL, 
se devuelve NULL. Determina el intervalo por data_type.

Para la conversi�n de datos se debe tener en cuenta si el tipo de dato original es posible de 
convertir al valor resultante.
*/

USE Northwind
GO

--Uso de CAST
--Listar los productos cuyo precio inicia con el d�gito 3
SELECT *
FROM Products AS p
WHERE CAST(p.UnitPrice AS VARCHAR) LIKE '3%'
GO

--Uso de CONVERT
SELECT *
FROM Products AS p
WHERE CONVERT(VARCHAR, p.UnitPrice) LIKE '3%'
GO

--Listado con el precio del producto concatenado
SELECT p.ProductName + ' tiene precio de lista en: ' + CAST(p.UnitPrice AS VARCHAR) AS lista
FROM Products AS p
GO

--Convirtiendo fechas
SELECT GETDATE() AS 'original', 
		CAST(GETDATE() AS VARCHAR(30)) AS 'convertida con cast',
		CONVERT(VARCHAR(30), GETDATE(), 126) AS 'convertida con convert ISO8601'
GO

--Parse
--PARSE ( ValorString AS TipoDato [ USING culture ] )

--Interpretar el DATETIME2
SELECT PARSE('Jul 24 2021 12:43PM' AS DATETIME2 USING 'en-US') AS resultado
GO
SELECT PARSE('Saturday, 24 February 1996' AS DATETIME2 USING 'en-US') AS resultado
GO

--Interpretar datos num�ricos
SELECT PARSE('�345.98' AS MONEY USING 'de-DE') AS 'moneda alemana'
GO

/*TRY_CONVERT
TRY_CONVERT ( data_type [ ( length ) ], expression [, style ]
*/
--Intentar convertir a un valor flotante a texto
SELECT CASE
		WHEN TRY_CONVERT(FLOAT, 'test') IS NULL THEN 'CAST HA FALLADO'
	   ELSE 
		'CAST EXITOSO'
	   END AS resultado
GO

/*Try_Parse
TRY_PARSE ( string_value AS data_type [ USING culture ] )
*/

--Convertir a fecha
SELECT TRY_PARSE('PRIMER D�A DE TRABAJO' AS DATETIME2 USING 'en-US') AS resultado
GO
