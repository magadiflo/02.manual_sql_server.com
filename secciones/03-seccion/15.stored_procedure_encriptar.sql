/*-- ENCRIPTAR PROCEDIMIENTOS ALMACENADOS SQL SERVER --

En este artículo se muestran los procedimientos almacenados de una tabla de Categorías de platos 
en un restaurante. Es importante que la definición de los Store procedures no se puedan visualizar 
ya que al tener el nombre de una de las tablas de la base de datos se puede llegar a cualquiera de 
las tablas de la misma con el peligro de llegar a la tabla con los usuarios y lograr acceder a los 
sistemas.

Asegurable que se pueden encriptar

Elementos de la base de datos que se pueden encriptar, para esto se utiliza la cláusula with encryption
Vistas
Funciones definidas por el usuario
Procedimientos almacenados
Triggers

Importante:
Cree procedimientos almacenados y asignar el permiso para ejecutarlo al usuario de base de datos 
relacionado con el inicio de sesión asignado al usuario que utilizará el sistema.
*/
CREATE DATABASE bd_cocina
GO

USE bd_cocina
GO

--Tabla categorias
CREATE TABLE categorias(
	codigo CHAR(5),
	descripcion VARCHAR(50) NOT NULL,
	fecha_registro DATE,
	estado CHAR(1),
	CONSTRAINT pk_categorias PRIMARY KEY(codigo),
	CONSTRAINT uq_des_cat UNIQUE(descripcion)
)
GO

--Insertamos las categorías de los platos
INSERT INTO categorias(codigo, descripcion, fecha_registro, estado)
VALUES('00001','Entradas','2019-02-10','A'),
('00002','Arroces','2018-11-21','A'),
('00003','Ensaladas','2017-11-16','A'),
('00004','Carnes','2020-07-23','A'),
('00005','Parrillas','2016-10-01','A'),
('00006','Bebidas','2010-08-06','A'),
('00007','Pescados y Mariscos','2013-07-14','A')
GO
/*
El campo estado servirá para eliminar un registro únicamente cambiando el estado,
el valor por defecto es "A" de Activo, al eliminar  cambia a estado "E" de eliminado
*/
SELECT * FROM categorias
GO

--Procedimiento almacenado para listar las categorías no eliminadas. 
--Este Primer SP no se va a encriptar
CREATE PROCEDURE sp_lista_categorias_no_eliminadas
AS 
	BEGIN
		SELECT c.codigo, c.descripcion, c.fecha_registro, c.estado
		FROM categorias AS c
		WHERE c.estado = 'A'
	END
GO

--Se puede visualizar la definición del procedimiento usando el SP del sistema SP_HELPTEXT
SP_HELPTEXT sp_lista_categorias_no_eliminadas
GO

/*Modificar el SP y encriptarlo. Para ello se utiliza la opción WITH ENCRYPTION*/
CREATE OR ALTER PROCEDURE sp_lista_categorias_no_eliminadas
WITH ENCRYPTION
AS 
	BEGIN
		SELECT c.codigo, c.descripcion, c.fecha_registro, c.estado
		FROM categorias AS c
		WHERE c.estado = 'A'
	END
GO

--Intentar visualizar la definición del SP
SP_HELPTEXT sp_lista_categorias_no_eliminadas
GO

--Resultado: The text for object 'sp_lista_categorias_no_eliminadas' is encrypted.

/*Procedimiento para listar categorías eliminadas*/
CREATE OR ALTER PROCEDURE sp_lista_categorias_eliminadas
WITH ENCRYPTION
AS
	BEGIN
		SELECT c.codigo, c.descripcion, c.fecha_registro, c.estado
		FROM categorias AS c
		WHERE c.estado = 'E'
	END
GO

/*Procedimiento para insertar una categoría*/
CREATE OR ALTER PROCEDURE sp_categoria_insertar(
	@codigo CHAR(5),
	@descripcion VARCHAR(50),
	@fecha_registro DATE,
	@estado CHAR(1)
)
WITH ENCRYPTION
AS	
	BEGIN
		INSERT INTO categorias(codigo, descripcion, fecha_registro, estado)
		VALUES(@codigo, @descripcion, @fecha_registro, @estado)
	END
GO

/*Procedimiento para actualizar una categoría*/
CREATE OR ALTER PROCEDURE sp_categoria_actualizar(
	@codigo CHAR(5),
	@descripcion VARCHAR(50),
	@fecha_registro DATE,
	@estado CHAR(1)
)
WITH ENCRYPTION
AS	
	BEGIN
		UPDATE categorias
		SET descripcion = @descripcion, 
			fecha_registro = @fecha_registro,
			estado = @estado
		WHERE codigo = @codigo
	END
GO

/*Procedimiento para eliminar una categoría*/
CREATE OR ALTER PROCEDURE sp_categoria_eliminar(@codigo CHAR(5))
WITH ENCRYPTION
AS	
	BEGIN
		UPDATE categorias
		SET estado = 'E'
		WHERE codigo = @codigo
	END
GO

/*Procedimiento para recuperar una categoría eliminada*/
CREATE OR ALTER PROCEDURE sp_categoria_recuperar(@codigo CHAR(5))
WITH ENCRYPTION
AS
	BEGIN
		UPDATE categorias
		SET estado = 'A'
		WHERE codigo = @codigo
	END
GO

--Intentar visualizar los procedimientos almacenados
SP_HELPTEXT sp_categoria_recuperar
GO