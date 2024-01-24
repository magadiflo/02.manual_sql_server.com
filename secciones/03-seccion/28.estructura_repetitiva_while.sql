/*-- ESTRUCTURA REPETITIVA WHILE SQL SERVER --

La estructura While es una estructura repetitiva que permite ejecutar un bloque de 
instrucciones mientras que una expresión lógica sea verdadera.

Sintaxis

While (Expresión Lógica)
Begin
Conjunto de instrucciones del bloque
[BREAK | CONTINUE]
End
Donde
Expresión Lógica: es una expresión que retorna verdadero o falso. 
Los paréntesis serán necesarios si la expresión lógica tiene una instrucción Select.
BREAK
Provoca una salida del bucle WHILE más interno. Se ejecutan todas las declaraciones 
que aparecen después de la palabra clave END, que marcan el final del ciclo.
CONTINUE
Hace que el ciclo WHILE se reinicie, ignorando cualquier declaración después de 
la palabra clave CONTINUE.
*/

USE Northwind
GO

/*EJERCICIO 01. While dentro de un cursor. Cursor que reporte la lista de productos, si las unidades
en orden son mayores al stock, mostrar COMPRAR URGENTE, de lo contrario mostrar STOCK ADECUADO.*/
DECLARE cursorProductoComprasUrgente CURSOR
FOR SELECT p.ProductID, p.ProductName, p.UnitsInStock, p.UnitsOnOrder
	FROM Products AS p

OPEN cursorProductoComprasUrgente

DECLARE @codigo INT, @descripcion VARCHAR(40), @stock NUMERIC(9,2), @porAtender NUMERIC(9,2)

FETCH cursorProductoComprasUrgente 
INTO @codigo, @descripcion, @stock, @porAtender

PRINT '================= LISTADO ===================='
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		DECLARE @mensaje VARCHAR(20)
		IF @porAtender > @stock
			BEGIN
				SET @mensaje = 'COMPRAR URGENTE'
			END
		ELSE
			BEGIN
				SET @mensaje = 'STOCK ADECUADO'
			END
		PRINT 'Código: ' + STR(@codigo)
		PRINT 'Descripción: ' + @descripcion  + ', Stock: ' + LTRIM(STR(@stock)) + ', porAtender: ' + LTRIM(STR(@porAtender))
		PRINT 'Mensaje: ' + @mensaje
		PRINT '=============================================='
		
		FETCH cursorProductoComprasUrgente 
		INTO @codigo, @descripcion, @stock, @porAtender
	END


CLOSE cursorProductoComprasUrgente
DEALLOCATE cursorProductoComprasUrgente
GO

/*EJERCICIO 02. En este ejercicio se va a insertar en una tabla intervalos de cada media hora, 
desde las 00 horas hasta las 24 horas y en un campo se va a especificar las horas, de 1 a 24.*/
DROP TABLE IF EXISTS horas
GO

CREATE TABLE horas(
	intervalo TIME,
	hora CHAR(10)
)
GO

--INSERTAR
SET NOCOUNT ON
DECLARE @vez INT, @hora TIME, @intervalo INT
SET @vez = 1
SET @hora = '0:00 am'
SET @intervalo = 1
WHILE @vez <= 48
	BEGIN
		IF ((@vez % 2) = 0)
			BEGIN
				INSERT INTO horas VALUES(@hora, '')
			END
		ELSE
			BEGIN
				INSERT INTO horas VALUES(@hora, @intervalo)
				SET @intervalo = @intervalo + 1
			END
		SET @vez = @vez + 1
		SET @hora = DATEADD(MI, 30, @hora)
	END
GO
SET DATEFORMAT dmy
GO
SELECT FORMAT(h.intervalo, 'hh\:mm') AS intervalo, hora
FROM horas AS h
GO

/*EJERCICIO 03. Uso de la estructura While para recorrer los caracteres de una cadena de texto. 
Se va a crear una función definida por el usuario que recibe como parámetro la cadena de texto.
Mostrar cuántos consonantes y cuántas vocales tiene la frase ingresada.*/
CREATE OR ALTER FUNCTION fduRetornaVocalesConsonantes(@frase VARCHAR(200))
RETURNS VARCHAR(100)
AS
	BEGIN
		SET @frase = LOWER(REPLACE(@frase, ' ', ''))
		DECLARE @contador INT = 1
		DECLARE @letra VARCHAR(1)
		DECLARE @vocal INT = 0
		DECLARE @consonante INT = 0

		WHILE @contador <= LEN(@frase)
			BEGIN				
				SET @letra = SUBSTRING(@frase, @contador, 1)
				IF @letra IN('a', 'e', 'i', 'o', 'u', 'á', 'é', 'í', 'ó', 'ú')
					BEGIN
						SET @vocal += 1
					END
				ELSE
					BEGIN
						SET @consonante += 1
					END
					
				SET @contador += 1
			END

		RETURN 'La frase "' + UPPER(@frase) + '" tiene ' + TRIM(STR(@vocal)) + ' vocales y ' + TRIM(STR(@consonante)) + ' consonantes'
	END
GO

SELECT dbo.fduRetornaVocalesConsonantes('SQL SERVER GUÍA PROFESIONAL') AS 'Resultado'
GO