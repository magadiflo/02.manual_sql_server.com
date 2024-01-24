/*-- CURSORES CON VARIABLE TIPO TABLA Y CONTADORES --
En este artículo se utiliza un cursor para mostrar un reporte de acuerdo a registros que tienen valores 
enteros, de los cuales se hace un análisis para insertar registros en el reporte como entradas y salidas.
*/
USE Northwind
GO

DROP TABLE IF EXISTS eventos
GO

CREATE TABLE eventos(
	id INT IDENTITY,
	fecha_registro DATETIME,
	evento VARCHAR(20),
	entrada INT,
	salida INT,
	CONSTRAINT pk_eventos PRIMARY KEY(id)
)
GO

INSERT INTO eventos(fecha_registro, evento, entrada, salida)
VALUES('2021-03-21 14:54:45', 'CONTADOR', 1, 0),
('2021-03-21 14:54:41', 'CONTADOR', 3, 1),
('2021-03-21 14:54:38', 'CONTADOR', 2, 1),
('2021-03-21 14:54:34', 'CONTADOR', 0, 2),
('2021-03-21 14:54:26', 'CONTADOR', 1, 4),
('2021-03-21 14:54:14', 'CONTADOR', 1, 0)
GO

SELECT * 
FROM eventos
GO

/*
En consulta anterior podemos notar que el primer registro tiene una entrada y no tienen salidas, 
el cursor mostrará entonces para ese registro una entrada, para el segundo registro, tiene 3 entradas 
y una salida, se debe mostrar entonces 04 registros, 03 de entrada y 01 de salida.
*/
DECLARE c_eventos CURSOR
FOR SELECT *
	FROM eventos
OPEN c_eventos

DECLARE @reporte_eventos TABLE(id INT, fecha_registro DATETIME, evento VARCHAR(20), 
							   [entrada/salida] VARCHAR(20))
DECLARE @id INT, @fecha_registro DATETIME, @evento VARCHAR(50), @entrada INT, @salida INT

FETCH c_eventos INTO @id, @fecha_registro, @evento, @entrada, @salida

WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @contrador_entradas INT = 0
		WHILE(@contrador_entradas < @entrada)
			BEGIN
				INSERT INTO @reporte_eventos
				VALUES(@id, @fecha_registro, @evento, 'ENTRADA')
				SET @contrador_entradas += 1
			END

		DECLARE @contador_salidas INT = 0
		WHILE(@contador_salidas < @salida)
			BEGIN
				INSERT INTO @reporte_eventos
				VALUES(@id, @fecha_registro, @evento, 'SALIDA')
				SET @contador_salidas += 1
			END
		FETCH c_eventos INTO @id, @fecha_registro, @evento, @entrada, @salida
	END
CLOSE c_eventos
DEALLOCATE c_eventos

SELECT * 
FROM @reporte_eventos
GO

/*
La ejecución del query anterior muestra el resultado esperado.
*/