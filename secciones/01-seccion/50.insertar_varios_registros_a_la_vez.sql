/*-- INSERTAR VARIOS REGISTROS A LA VEZ --

En algunas aplicaciones es necesario insertar varios registros en una misma instrucción, 
puede ser por ejemplo el detalle de una pedido, el detalle de un documento de venta, los 
integrantes de un grupo de trabajo, etc.

En este artículo se explica como insertar varios registros a la vez usando un procedimiento 
almacenado y un tipo de dato definido por el usuario con formato tipo tabla.

EJERCICIO

Para el ejemplo a realizar se va a crear una base de datos, luego una tabla y usando un 
procedimiento almacenado se va a agregar en una sola instrucción varios registros a la vez.
*/

CREATE DATABASE bd_procesos_satt
GO

USE bd_procesos_satt
GO
--Crear la tabla contribuyentes para insertar datos
CREATE TABLE contribuyentes(
	codigo CHAR(8),
	paterno VARCHAR(80) NOT NULL,
	materno VARCHAR(80) NOT NULL,
	nombres VARCHAR(100) NOT NULL
	CONSTRAINT pk_contribuyentes PRIMARY KEY(codigo)
)
GO

--Crear el tipo de dato con formato de tabla con los mismos campos que la tabla contribuyentes
CREATE TYPE tipo_dato_contrinuyentes AS TABLE(
	codigo CHAR(8),
	paterno VARCHAR(80) NOT NULL,
	materno VARCHAR(80) NOT NULL,
	nombres VARCHAR(100) NOT NULL
)
GO



--Crear un procedimiento que inserte datos a la tabla basado sobre el tipo de dato creado
CREATE PROCEDURE sp_contribuyentes_insertar_grupos(
	@contribuyentes AS tipo_dato_contrinuyentes READONLY
)
AS
	SET NOCOUNT ON
	INSERT INTO contribuyentes(codigo, paterno, materno, nombres)
	SELECT c.codigo, c.paterno, c.materno, c.nombres
	FROM @contribuyentes AS c
GO

/*Note que el parámetro con el tipo de dato definido por el usuario
con formato tipo tabla debe ser SÓLO LECTURA

Para insertar los datos usando el procedimiento, desde SQL Server Management Studio se 
crea una variable con el tipo de dato definido por el usuario con formato de tabla 
llamado tipo_dato_contrinuyentes, luego a la variable creada se le inserta registros y se 
ejecuta el procedimiento almacenado.
*/

--Hacemos select de la tabla
SELECT * FROM contribuyentes
GO

--Ahora, usamos el sp creado e insertamos el conjunto de datos
DECLARE @datos AS tipo_dato_contrinuyentes
INSERT @datos
VALUES('00070099', 'Díaz', 'Flores', 'Martín Gaspar'),
('00070100', 'Díaz', 'Flores', 'Gabriel Abraham'),
('00070101', 'Díaz', 'Flores', 'Raúl Darío'),
('00070102', 'Díaz', 'Flores', 'Tinkler Adán'),
('00070103', 'Díaz', 'Flores', 'Alicia Flores'),
('00070104', 'Díaz', 'Ardiles', 'Gabrielito Hazael')
EXECUTE sp_contribuyentes_insertar_grupos @contribuyentes = @datos
GO

--Visualizamos nuevamente la tabla
SELECT * FROM contribuyentes
GO