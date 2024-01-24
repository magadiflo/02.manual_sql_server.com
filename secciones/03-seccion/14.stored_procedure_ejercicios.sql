/*-- PROCEDIMIENTOS ALMACENADOS - EJERCICIO --

Ejercicio para el uso de los procedimientos almacenados con los datos de una tabla.

En este ejercicio se crea una tabla para carreras en la Universidad SQL, se crean los procedimientos 
almacenados para insertar un registro, modificar los datos del registro, listar los registros ordenados 
por descripción y borrar un registro. El borrado del registro es lógico. (Ver Eliminación de registros)
*/
CREATE DATABASE bd_universidad_sql
GO

USE bd_universidad_sql
GO

CREATE TABLE carreras(
	codigo CHAR(5),
	descripcion VARCHAR(100), 
	acreditada CHAR(1),
	vacantes NUMERIC(9,2),
	estado CHAR(1),
	CONSTRAINT pk_carreras PRIMARY KEY(codigo)
)
GO

--Insertar registros
INSERT INTO carreras
VALUES('95642','Ing. de SISTEMAS','S',250,'A'),
('28596','ADMINISTRACION','S',290,'A'),
('05252','Ing. INDUSTRIAL','S',450,'A'),
('78596','MEDICINA','N',100,'A')
GO

--Procedimiento para insertar, editar y eliminar
--INSERTAR
CREATE PROCEDURE sp_carreras_insertar(
	@codigo CHAR(5),
	@descripcion VARCHAR(100), 
	@acreditada CHAR(1),
	@vacantes NUMERIC(9,2),
	@estado CHAR(1)
)
AS
	BEGIN
		INSERT INTO carreras(codigo, descripcion, acreditada, vacantes, estado)
		VALUES(@codigo, @descripcion, @acreditada, @vacantes, @estado)
	END
GO

--Prueba del SP para insertar
EXECUTE sp_carreras_insertar @codigo = '96325',
							 @vacantes = 80,
							 @descripcion = 'INGENIERÍA',
							 @acreditada = 'S',
							 @estado = 'A'
GO

--Listado de carreras
SELECT * FROM carreras
GO

--Crear un índice por descripción de carrera
CREATE INDEX idx_carreras_descripcion 
ON carreras(descripcion)
WITH(FILLFACTOR = 80)
GO

--Procedimiento para listado, note que no aparecen los que tienen en el estado la letra E que 
--indica que han sido eliminadas.
CREATE PROCEDURE sp_carreras_listado
AS
	BEGIN
		SELECT codigo, descripcion, acreditada, vacantes, estado
		FROM carreras
		WHERE estado <> 'E'
		ORDER BY descripcion
	END
GO

--Procedimiento al macenado para editar una carrera
CREATE PROCEDURE sp_carreras_editar(
	@codigo CHAR(5),
	@descripcion VARCHAR(100), 
	@acreditada CHAR(1),
	@vacantes NUMERIC(9,2)
)
AS
	BEGIN
		UPDATE carreras 
		SET descripcion = @descripcion,
			acreditada = @acreditada, 
			vacantes = @vacantes
		WHERE codigo = @codigo
	END
GO

--Ejecutar el procedimiento para actualizar la carrera INGENIERÍA con los siguientes datos: 
--INGENIERÍA EN ENERGÍA, está acreditada y número de vacantes es 150
EXECUTE sp_carreras_editar '96325', 'Ing. En Energía', 'S', 150
GO

--Procedimiento almacenado para eliminar una carrera, la eliminación es lógica, cambia el estado
CREATE PROCEDURE sp_carreras_eliminar(@codigo VARCHAR(5))
AS
	BEGIN
		UPDATE carreras 
		SET estado = 'E'
		WHERE codigo = @codigo
	END
GO

--Ejecutar el procedimiento para borrar el registro 96325
sp_carreras_eliminar '96325'
GO

--Listar carreras con el sp de listar
EXECUTE sp_carreras_listado
GO