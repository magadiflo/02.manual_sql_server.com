/*-- FUNCIONES DE TEXTO O CADENA --
Las funciones de texto en SQL Server realizan operaciones sobre cadenas de caracteres o 
contenido de los campos de tipo carácter y devuelven un valor de cadena o un valor entero.

Las funciones de SQL que permiten el manejo de cadenas de caracteres son:

Función		Explicación
-----------------------------------------------------------
ASCII		Retorno el valor ASCII del primer caracter
LTRIM		Elimina espacios en blanco iniciales
SPACE		Devuelve una cadena de espacios
STR			Convierte un dato a tipo cadena de caracteres
CONCAT		Concatena cadenas de caracteres
STUFF		Inserta una cadena en otra
REPLACE		Reemplaza una cadena por otra
SUBSTRING	Extrae una cantidad de caracteres de una cadena
REPLICATE	Repite una cadena de caracteres
LEFT		Obtiene caracteres de la izquierda
REVERSE		Invierte la escritura de una cadena
UPPER		Convierte a mayúsculas
LEN			Obtiene la longitud de la cadena
RIGHT		Devuelve caracteres de la derecha
LOWER		Convierte a minúsculas
RTRIM		Elimina los espacios en blanco del final de una cadena de caracteres
*/

--Quitar reemplazar los espacios en blanco por una cadena sin caracteres
SELECT REPLACE('SQL Server Manual Profesional', SPACE(1), '')
GO

--Cuarta letra del apellido en mayúscula
SELECT UPPER(SUBSTRING(REPLACE('Del Castillo', SPACE(1), ''), 4,1))
GO

--REVERSE: Invierte la cadena de caracteres
SELECT REVERSE('Un gestor de base de datos')
GO

--Reemplazo de caracteres
SELECT STUFF('Funciones de texto y cadena', 14, 5, 'fechas, horas')
GO

--Repetir una cadena, aparece la palabra Gol con puntos suspensivos 20 veces
PRINT REPLICATE('Gol...', 20)
GO

--Obtener el valor ASCII del primer carácter
PRINT ASCII('Auténtico') --Resultado: 65, la letra A mayúscula
GO

--Elimina los espacios en blanco iniciales. LEN obtiene la longitud
PRINT LEN(LTRIM(' Hola'))
GO

--Elimina los espacios de la derecha
PRINT LEN(RTRIM('   Hola   '))
GO

-- En mayúsculas
PRINT UPPER('Alberto debe') + SPACE(1) + LTRIM(STR(800)) + SPACE(1) + LOWER('dolares')
GO

--Concatenar
PRINT CONCAT(UPPER('Alberto debe'), LTRIM(STR(800)), SPACE(1), LOWER('dólares'))
GO

PRINT CONCAT_WS(' ', 'Martín', 'Díaz', 'Flores')
GO

--Función LEFT para extraer caracteres de la izquierda
PRINT LEFT('SQL Server', 5)
GO

--Función RIGHT para extrraer caracteres de la derecha
SELECT UPPER(RIGHT(RTRIM('Base de datos'), 5))
GO

--Extraer caracteres, desde la posición 3 extrae 5 caracteres
SELECT SUBSTRING('Gestor de Negocios', 4,8)
GO

--Desde la posición 4 extrae un carácter
SELECT SUBSTRING('Comercial', 4,1)
GO

--Replace, reemplaza la letra a por el número 4
SELECT REPLACE('Este mensaje es el original', 'e', '3')
GO