/*-- USANDO MERGE EN GRAPH TABLES SQL SERVER --

Usando Merge en Graph Tables SQL Server
Una base de datos gráfica es una colección de nodos (o vértices) y bordes (o relaciones). 
Un nodo representa una entidad (por ejemplo, una persona o una organización) y un borde 
representa una relación entre los dos nodos que conecta (por ejemplo, grupos o amigos). 
Tanto los nodos como los bordes pueden tener propiedades asociadas a ellos.

En este artículo se explica como usar la instrucción MERGE para hacer una inserción o 
actualización en una tabla Edge de destino desde una base de datos de gráficos.

*/
USE Northwind
GO

/*EJERCICIO 01. Para explicar el uso de Merge en el uso de Grap Tables se va a crear las tablas
Node Persona y Ciudad y una tabla Edge ViveEn. Se utilizará la instrucción MERGE en la tabla Edge 
ViveEn para inserta un nuevo registro si este no existe, si ya existe en la tabla Edge las 
combinaciones de Persona y Ciudad se actualizará su Dirección.*/
CREATE TABLE personas(
	codigo CHAR(5),
	ap_paterno VARCHAR(30),
	ap_materno VARCHAR(30),
	nombres VARCHAR(30),
	fecha_nacimiento DATE,
	CONSTRAINT pk_personas PRIMARY KEY(codigo)
) AS node
GO

CREATE TABLE ciudades(
	codigo CHAR(3),
	nombre VARCHAR(30),
	estado CHAR(1),
	CONSTRAINT pk_ciudades PRIMARY KEY(codigo)
) AS node
GO

--La tabla edge que tiene las ciudades donde viven las personas
CREATE TABLE vive_en(
	vive_en_direccion VARCHAR(100)
) AS edge
GO

--Insertar registros en las tablas node y la tabla edge
SET DATEFORMAT dmy
INSERT INTO personas
 VALUES('P1325', 'Luque','Sánchez','Fernando','23/07/1966'),
('P1085', 'Luque','Villacorta','Fernando','16/11/1996'),
('P0324', 'Luque','Villacorta','María Fernanda','01/10/2000'),
('P0278', 'Villacorta','Acosta','Carolina','21/11/1966'),
('P1963', 'Wong','Huamán','Alberto','24/02/1996'),
('P0789', 'Salas','Valderrama','Alberto','30/09/1999')
GO

INSERT INTO ciudades
VALUES('001', 'Trujillo', 'A'),
('002', 'Lima', 'A'),
('003', 'Piura', 'A'),
('004', 'Cajamarca', 'A'),
('005', 'Cusco', 'A'),
('006', 'Huaraz', 'A')
GO

--Insertar los registros en el Edge
INSERT vive_en
SELECT p.$node_id, c.$node_id, c
FROM Personas AS p, ciudades AS c, 
(VALUES('P1325','001', 'Ciro Alegría 575'),
('P1085','002', 'Av. Atahualpa 633'),
('P0324','004', 'Av. Brasil 4994'),
('P0278','006', 'Av. Valderrama 499'),
('P1963','003', 'Av. Los Paujiles 6890'),
('P0789','005', 'Av. San Blas 599'))
v(a,b,c)
WHERE p.codigo = a AND c.codigo = b
GO

--Listado de los registros de la tabla ViveEn.
SELECT p.codigo, p.ap_paterno, p.ap_materno, p.nombres,
	   p.fecha_nacimiento, c.nombre, v.vive_en_direccion
FROM personas AS p, ciudades AS c, vive_en AS v
WHERE MATCH(p-(v)->c)

--Usando Merge para insertar o actualizar la dirección
CREATE OR ALTER PROCEDURE sp_persona_direccion_inserta_actualiza(
	@codigo CHAR(5), 
	@ciudad CHAR(3),
	@direccion VARCHAR(100)
)
AS
	BEGIN
		MERGE vive_en
		USING((SELECT @codigo, @ciudad, @direccion) AS destino
			  (PersonaCodigo, CiudadCodigo, ViveEnDireccion)
			 JOIN personas ON destino.PersonaCodigo = personas.codigo
			 JOIN ciudades ON destino.CiudadCodigo = ciudades.codigo
			 )
		ON MATCH(personas-(vive_en)->ciudades)
		WHEN MATCHED THEN
			UPDATE SET vive_en_direccion = @direccion
		WHEN NOT MATCHED THEN
			INSERT ($from_id, $to_id, vive_en_direccion)
			VALUES(personas.$node_id, ciudades.$node_id, @direccion)
	END
GO
