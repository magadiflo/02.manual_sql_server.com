/*-- USANDO CURSOR EN SQL SERVER --

Los cursores permiten almacenar los datos de una consulta T-SQL en memoria y poder manipular los 
datos de los elementos resultantes para realizar operaciones con ellos. Se recomienda su uso con 
cierto cuidado porque consume mucha memoria, la instrucción select que llena el cursor debe ser 
lo más selectiva posible.

Proceso para declarar, abrir, usar, cerrar y liberar los datos de un cursor

1. Declarar el cursor, utilizando DECLARE Cursor
2. Abrir el cursor, utilizando OPEN
3. Leer los datos del cursor, utilizando FETCH … INTO dentro de una estructura While
4. Cerrar el cursor, utilizando CLOSE
5. Liberar el cursor, utilizando DEALLOCATE

En este artículo se muestra como usar un cursor, el ejemplo es con una tabla de Alumnos, 
tiene registrado el código, su nombre y cinco calificaciones, se pretende hacer un reporte 
de estas en columnas adicionales a la tabla ordenando las calificaciones de menor a mayor.
*/
USE Northwind
GO

CREATE TABLE alumnos(
	codigo CHAR(4),
	nombre VARCHAR(50),
	nota_1 INT,
	nota_2 INT,
	nota_3 INT,
	nota_4 INT,
	nota_5 INT,
	CONSTRAINT pk_alumnos PRIMARY KEY(codigo)
)
GO

INSERT INTO alumnos
VALUES('0001', 'Fernando Luque', 18, 5, 12, 8, 13),
('0002', 'Fagos', 9, 15, 12, 7, 13),
('0003', 'Vania', 20, 6, 15, 18, 14),
('0004', 'Lucas', 18, 15, 2, 8, 17),
('0005', 'Pedro', 4, 5, 20, 18, 13)
GO

SELECT *
FROM alumnos
GO

--Cursor para obtener el resultado
DECLARE c_alumnos CURSOR
FOR SELECT * 
	FROM alumnos

OPEN c_alumnos

DECLARE @resultados TABLE(codigo CHAR(4), nombre VARCHAR(50), 
						  nota_1 INT, nota_2 INT, nota_3 INT, nota_4 INT, nota_5 INT,
						  primero INT, segundo INT, tercero INT, cuarto INT, quinto INT)
DECLARE @codigo CHAR(4), @nombre VARCHAR(50), @nota_1 INT, @nota_2 INT, @nota_3 INT, @nota_4 INT, @nota_5 INT

FETCH c_alumnos INTO @codigo, @nombre, @nota_1, @nota_2, @nota_3, @nota_4, @nota_5

WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @valor_1 INT,@valor_2 INT,@valor_3 INT,@valor_4 INT,@valor_5 INT
		DECLARE @notas_ordenadas TABLE(orden INT, n INT)

		INSERT INTO @notas_ordenadas(orden, n)
		SELECT 1, nota_1 FROM alumnos WHERE codigo = @codigo
		UNION
		SELECT 2, nota_2 FROM alumnos WHERE codigo = @codigo
		UNION
		SELECT 3, nota_3 FROM alumnos WHERE codigo = @codigo
		UNION
		SELECT 4, nota_4 FROM alumnos WHERE codigo = @codigo
		UNION
		SELECT 5, nota_5 FROM alumnos WHERE codigo = @codigo

		SET @valor_1 = (SELECT TOP 1 n FROM @notas_ordenadas ORDER BY n ASC)
		SET @valor_2 = (SELECT n FROM @notas_ordenadas ORDER BY n ASC OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY)
		SET @valor_3 = (SELECT n FROM @notas_ordenadas ORDER BY n ASC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY)
		SET @valor_4 = (SELECT n FROM @notas_ordenadas ORDER BY n ASC OFFSET 3 ROWS FETCH NEXT 1 ROWS ONLY)
		SET @valor_5 = (SELECT n FROM @notas_ordenadas ORDER BY n ASC OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY)

		DELETE @notas_ordenadas

		INSERT INTO @resultados
		VALUES(@codigo, @nombre, @nota_1, @nota_2, @nota_3, @nota_4, @nota_5, 
			   @valor_1, @valor_2, @valor_3, @valor_4, @valor_5)

		FETCH c_alumnos INTO @codigo, @nombre, @nota_1, @nota_2, @nota_3, @nota_4, @nota_5
	END

CLOSE c_alumnos
DEALLOCATE c_alumnos

SELECT * 
FROM @resultados
GO
