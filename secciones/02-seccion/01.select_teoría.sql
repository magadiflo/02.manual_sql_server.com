/*-- SELECT - TEOR�A --

Visualizaci�n de la informaci�n de la base de datos

Instrucci�n: Select
Permite la recuperaci�n de los datos de una o mas tablas de la base de datos.

Sintaxis
La forma de usar la instrucci�n select es compleja, un resumen de las opciones que tiene se pueden resumir
en las l�neas a continuaci�n, es necesario anotar que se pueden combinar las opciones.

* Para listar los campos de una tabla
SELECT ListaDeCampos
FROM Tabla/Vista
WHERE Expresi�nL�gica
GROUP BY CamposAgrupados
HAVING Expresi�nL�gica
ORDER BY Expresi�nOrden ASC | DESC

* Para generar una tabla en base al resultado del select
SELECT ListaDeCampos
INTO nuevaTablaAGenerar
FROM Tabla/Vista
WHERE Expresi�nL�gica
GROUP BY CamposAgrupados
HAVING Expresi�nL�gica
ORDER BY Expresi�nOrden ASC | DESC

* Select usando varias tablas
SELECT ListaDeCampos
FROM Tabla1
	JOIN Tabla2 ON Tabla1.CampoJoin = Tabla2.CampoJoin
	[JOIN Tabla2 ON Tabla1.CampoJoin = Tabla2.CampoJoin]
WHERE Expresi�nL�gica
GROUP BY CamposAgrupados
HAVING Expresi�nL�gica
ORDER BY Expresi�nOrden ASC | DESC

*Select para los superiores o inferiores en cantidad o porcentaje
SELECT TOP n[Percent][WITH Ties] ListaDeCampos
FROM Tabla/Vista
WHERE Expresi�nL�gica
GROUP BY CamposAgrupados
HAVING Expresi�nL�gica
ORDER BY Expresi�nOrden ASC | DESC

*Select para registros sin repetir
SELECT DISTINCT ListaDeCampos
FROM Tabla1
WHERE Expresi�nL�gica
GROUP BY CamposAgrupados
HAVING Expresi�nL�gica
ORDER BY Expresi�nOrden ASC | DESC

ORDEN DE PROCESAMIENTO L�GICO DE LA INSTRUCCI�N SELECT
Los par�metros de SELECT se ejecutan en el siguiente orden:
FROM 
ON
JOIN
WHERE
GROUP BY
WITH CUBE o WITH ROLLUP
HAVING
SELECT
DISTINCT
ORDER BY
TOP

Explicaci�n de cada par�metro:
FROM			: Indica la tabla principal de d�nde se obtendr� la informaci�n
ON				: Permite especificar el campo en com�n por el que se relacionan dos tablas en un JOIN
JOIN			: Permite relacionar dos tablas en la instrucci�n SELECT
WHERE			: Permite especificar una o m�s condiciones que deben de cumplir los registros para mostrarse
GROUP BY		: Permite especificar los campos por los que se agrupar� el conjunto de resultados de la 
				  instrucci�n SELECT. Este par�metro se usa cuando se ha incluido funciones de agregado
WITH CUBE o
WITH CUBE ROLLUP: Permite incluir subtotales por cada cambio en un select con funciones de agregado y
				  agrupamientoS
HAVING			: Permite especificar una o m�s condiciones que deben de cumplir los registros para mostrarse,
				  estas condiciones deben evaluarse en los campos con funciones de agregado
DISTINCT		: Permite listar los registros sin repetirlos
ORDER BY		: Permite especificar el campo o campos por loq ue se ordenar� el conjunto de resultados
TOP				: Permite especificar la cantidad de registros a mostrar, en filas o porcentajes de total
*/

