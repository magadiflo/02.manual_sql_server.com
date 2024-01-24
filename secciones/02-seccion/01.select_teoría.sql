/*-- SELECT - TEORÍA --

Visualización de la información de la base de datos

Instrucción: Select
Permite la recuperación de los datos de una o mas tablas de la base de datos.

Sintaxis
La forma de usar la instrucción select es compleja, un resumen de las opciones que tiene se pueden resumir
en las líneas a continuación, es necesario anotar que se pueden combinar las opciones.

* Para listar los campos de una tabla
SELECT ListaDeCampos
FROM Tabla/Vista
WHERE ExpresiónLógica
GROUP BY CamposAgrupados
HAVING ExpresiónLógica
ORDER BY ExpresiónOrden ASC | DESC

* Para generar una tabla en base al resultado del select
SELECT ListaDeCampos
INTO nuevaTablaAGenerar
FROM Tabla/Vista
WHERE ExpresiónLógica
GROUP BY CamposAgrupados
HAVING ExpresiónLógica
ORDER BY ExpresiónOrden ASC | DESC

* Select usando varias tablas
SELECT ListaDeCampos
FROM Tabla1
	JOIN Tabla2 ON Tabla1.CampoJoin = Tabla2.CampoJoin
	[JOIN Tabla2 ON Tabla1.CampoJoin = Tabla2.CampoJoin]
WHERE ExpresiónLógica
GROUP BY CamposAgrupados
HAVING ExpresiónLógica
ORDER BY ExpresiónOrden ASC | DESC

*Select para los superiores o inferiores en cantidad o porcentaje
SELECT TOP n[Percent][WITH Ties] ListaDeCampos
FROM Tabla/Vista
WHERE ExpresiónLógica
GROUP BY CamposAgrupados
HAVING ExpresiónLógica
ORDER BY ExpresiónOrden ASC | DESC

*Select para registros sin repetir
SELECT DISTINCT ListaDeCampos
FROM Tabla1
WHERE ExpresiónLógica
GROUP BY CamposAgrupados
HAVING ExpresiónLógica
ORDER BY ExpresiónOrden ASC | DESC

ORDEN DE PROCESAMIENTO LÓGICO DE LA INSTRUCCIÓN SELECT
Los parámetros de SELECT se ejecutan en el siguiente orden:
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

Explicación de cada parámetro:
FROM			: Indica la tabla principal de dónde se obtendrá la información
ON				: Permite especificar el campo en común por el que se relacionan dos tablas en un JOIN
JOIN			: Permite relacionar dos tablas en la instrucción SELECT
WHERE			: Permite especificar una o más condiciones que deben de cumplir los registros para mostrarse
GROUP BY		: Permite especificar los campos por los que se agrupará el conjunto de resultados de la 
				  instrucción SELECT. Este parámetro se usa cuando se ha incluido funciones de agregado
WITH CUBE o
WITH CUBE ROLLUP: Permite incluir subtotales por cada cambio en un select con funciones de agregado y
				  agrupamientoS
HAVING			: Permite especificar una o más condiciones que deben de cumplir los registros para mostrarse,
				  estas condiciones deben evaluarse en los campos con funciones de agregado
DISTINCT		: Permite listar los registros sin repetirlos
ORDER BY		: Permite especificar el campo o campos por loq ue se ordenará el conjunto de resultados
TOP				: Permite especificar la cantidad de registros a mostrar, en filas o porcentajes de total
*/

