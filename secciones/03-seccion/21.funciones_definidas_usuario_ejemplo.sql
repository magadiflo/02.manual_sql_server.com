/*-- FUNCIONES DEFINIDAS POR EL USUARIO - EJEMPLO --*/
/*
Obtener la cantidad de vocales y consonantes de un texto

En una consulta a través de internet nos pidieron hacer una función que al darle una cadena de caracteres, 
reporte la cantidad de vocales y la cantidad de consonantes. Aquí la solución.
*/

USE Northwind
GO

CREATE FUNCTION fdu_retorna_vocales_consonantes(@palabra VARCHAR(200))
RETURNS VARCHAR(100)
AS
	BEGIN
		DECLARE @dato VARCHAR(200), @letra VARCHAR(1)
		SET @dato = UPPER(REPLACE(LTRIM(RTRIM(@palabra)), ' ', ''))

		DECLARE @inicio INT, @total_vocales INT, @total_consonantes INT
		SET @inicio = 1
		SET @total_vocales = 0
		SET @total_consonantes = 0
		
		WHILE @inicio <= LEN(@dato)
			BEGIN
				SET @letra = SUBSTRING(@dato, @inicio, 1)
				IF @letra IN('A', 'E', 'I', 'O', 'U')
					BEGIN
						SET @total_vocales += 1
					END
				ELSE
					BEGIN
						SET @total_consonantes += 1
					END
				SET @inicio += 1
			END
		DECLARE @resultado VARCHAR(100)
		SET @resultado = 'La palabra ' + UPPER(@palabra) + ' tiene ' + LTRIM(STR(@total_vocales)) + 
						' vocales y ' + LTRIM(STR(@total_consonantes)) + ' consonantes'
		RETURN @resultado
	END
GO

--Usando la función definida por el usuario
SELECT dbo.fdu_retorna_vocales_consonantes('Martin')
GO