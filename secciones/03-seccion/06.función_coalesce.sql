/*-- USANDO LA FUNCIÓN COALESCE --
En una base de datos es una buena práctica que no existan valores Null, esto se puede 
evitar usando la restricción de tipo Default y desde la aplicación el programador puede enviar un 
dato predeterminado en los campos que el usuario no ingrese valor. 

Por otro lado, debería realizarse tareas para revisar que la base de datos
no tenga valores Null, pero si los hubiera, es necesario en muchos casos
evitarlos o tenerlos en cuenta en las consultas.

Como usar Coalesce en SQL Server

La función Coalesce evalua un grupo de valores y retorna el primer valor de la lista de argumentos 
que no tiene valor Null.
Sintaxis
Coalesce(Expresión1 [, Expresión2, Expresión3, …])
Donde:
Expresión1 [, Expresión2, Expresión3, …] son las expresiones que pueden contener valores Null.
*/

/*EJERCICIO 01. Reporte del primer valor no null*/
SELECT COALESCE(NULL, NULL, 'Valor válido', 'Otro dato', NULL) AS 'dato'
GO

/*EJERCICIO 02. Crear una tabla con dos campos que pueden tener valores null. 
En este ejercicio se va a crear una tabla con algunos campos que permiten valores null. Luego
se va a comparar los listados sin usar y usando la función COALESCE*/
USE Northwind
GO

CREATE TABLE prueba_coalesce(
	codigo CHAR(4),
	descripcion CHAR(100),
	dato1 VARCHAR(50),
	dato2 VARCHAR(50),
	dato3 VARCHAR(50),
	CONSTRAINT pk_prueba_coalesce PRIMARY KEY(codigo)
)	
GO

INSERT INTO prueba_coalesce(codigo, descripcion, dato1, dato2, dato3)
VALUES('8521','Trainer SQL Server',Null, 'Valor insertado','Dato Válido'),
('1598','Guía profesional SQL','Primer valor', Null,'Servicios'),
('3654','Datos para SQL',Null, Null,'SQL Server'),
('2596','Valor de Coalesce',Null, Null,'Programando SQL'),
('7533','Conviertete en DBA',Null, 'Recuerdo','Dato Válido'),
('4569','DBA por accidente, es válido','Casino SQL', 'Valor insertado','Dato Válido'),
('8547','Funciones de SQL Server',Null, Null,'Fin de Prueba')
GO

--Listado de todos los campos
SELECT * 
FROM prueba_coalesce
GO

--Usando coalesce, para obtener el primer reutlado válido de una de las columnas con nombre pruebaDato
SELECT codigo, descripcion, dato1, dato2, dato3, COALESCE(dato1, dato2, dato3) AS 'resultado'
FROM prueba_coalesce
GO

--Note que la última columna muestra el primer valor válido diferente de null
--El listado anterior podría usarse de la siguiente forma
SELECT codigo, descripcion, COALESCE(dato1, dato2, dato3) AS 'resultado'
FROM prueba_coalesce
GO

/*EJERCICIO 03. En el departamento de personal se ha diseñado una tabla que permite tres formas de pago
diferentes. Una teniendo en cuenta la cantidad de horas trabajadas. Otra con un salario asignado y
una tercera teniendo en cuenta una comisión por ventas. */
CREATE TABLE pagos(
	codigo CHAR(4),
	empleado VARCHAR(100),
	pago_hora NUMERIC(9,2),
	salario NUMERIC(9,2),
	comision NUMERIC(9,2),
	numero_ventas NUMERIC(9,2),
	CONSTRAINT pk_pagos PRIMARY KEY(codigo)
)
GO

INSERT INTO pagos(codigo, empleado, pago_hora, salario, comision, numero_ventas)
VALUES('F698', 'FERNANDO LUQUE', 120.00, NULL, NULL, NULL),
('T673', 'INGRID CHAVEZ', 80.00, NULL, NULL, NULL),
('M345', 'ROXANA VALLEJO', 90.00, NULL, NULL, NULL),
('E150', 'JOSE ALCANTARA', 60.00, NULL, NULL, NULL),
('V970', 'VALENTINO CARRASCO',NULL, 8000.00, NULL, NULL),
('R456', 'CARLOS MENDIOLA',NULL, 4000.00, NULL, NULL),
('C689', 'RENATO CAMPOS',NULL, 3000.00, NULL, NULL),
('S324', 'PEDRO CUBA',NULL, 7500.00, NULL, NULL),
('H893', 'ESMERALDA TERRANOVA',NULL, NULL, 1500, 5),
('W437', 'ARACELY WONG',NULL, NULL, 3200, 4),
('N045', 'VICTOR SANCHEZ',NULL, NULL, 720, 12),
('D996', 'MARIO LIZARZABURO',NULL, NULL, 1400, 3)
GO

--Listado de los empleados se muestra como sigue
SELECT * 
FROM pagos
GO

/*Se desea mostrar el listado de los empleados y suspagos. El que tiene asignado un pago por hora se 
calcula en base a 22 días y a 8 horas diarias. Los que tienen asignado unacomisión se calcula el pago
multiplicando la comisión por el número de ventas
*/
SELECT codigo, empleado, 
	   CAST(COALESCE(pago_hora * 22 * 8, salario, comision * numero_ventas) AS NUMERIC(9,2)) AS 'pago mensual'
FROM pagos
ORDER BY [pago mensual] DESC
GO

/*USANDO CASE EN LUGAR DE COALESCE
La estructura Case se puede usar en lugar de la función Coalesce.
En el ejemplo anterior, el resultado del listado usando Case es como sigue
*/
SELECT codigo, empleado, 
	   CAST((CASE 
			WHEN pago_hora IS NOT NULL THEN pago_hora * 22 * 8
			WHEN salario IS NOT NULL THEN salario
			WHEN comision IS NOT NULL THEN comision * numero_ventas
		END) AS NUMERIC(9,2)) AS 'pago mensual'
FROM pagos
ORDER BY [pago mensual] DESC
GO

--Analizando el plan estimado de ejecución 
--Para la instrucción usando la función COALESCE
SELECT codigo, empleado, 
	   CAST(COALESCE(pago_hora * 22 * 8, salario, comision * numero_ventas) AS NUMERIC(9,2)) AS 'pago mensual'
FROM pagos
ORDER BY [pago mensual] DESC
GO
--Costo: 0.0147248

--Para la instrucción usando case
SELECT codigo, empleado, 
	   CAST((CASE 
			WHEN pago_hora IS NOT NULL THEN pago_hora * 22 * 8
			WHEN salario IS NOT NULL THEN salario
			WHEN comision IS NOT NULL THEN comision * numero_ventas
		END) AS NUMERIC(9,2)) AS 'pago mensual'
FROM pagos
ORDER BY [pago mensual] DESC
GO
--Costo: 0.0147248
/*
Note que son exactamente iguales, posiblemente la elección sea de acuerdo a la escritura 
de la instrucción, Coalesce parece ser mas sencilla.
*/

/*EJERCICIO 04. Listado de correos de un participante, puede ser que un participante no tenga correos,
en ese caso se mostrará el mensaje "Sin correo", lo mismo para celulares*/
DROP TABLE IF EXISTS participantes
GO

CREATE TABLE participantes(
	codigo CHAR(5),
	paterno VARCHAR(50) NOT NULL,
	materno VARCHAR(50) NOT NULL,
	nombres VARCHAR(50) NOT NULL,
	correo_hotmail VARCHAR(50),
	correo_gmail VARCHAR(50),
	correo_corporativo VARCHAR(50),
	celular_personal VARCHAR(50),
	celular_corporativo VARCHAR(50),
	CONSTRAINT pk_participantes PRIMARY KEY(codigo)
)
GO

INSERT INTO participantes
VALUES( 'P4562','Luque','Sanchez','Fernando',NULL,Null,Null,Null, '987654321'),
( 'P5852','Carranza','Mendoza','Manuel',NULL,'mcarranza@gmail.com','mcarranza775@miempresa.com','963258741', '951235746'),
( 'P0235','Chavez','Alvarado','Ingrid','ichavez@hotmail.com','arachavez@gmail.com',Null,Null, Null),
( 'P8521','Sandoval','Palacios','Yeni','yenipal@hotmail.com',Null,Null,'951357485', '987654321'),
( 'P6521','Terranova','Holguin','Marco','marcoth@hotmail.com',Null,Null,'951357485','987654321'),
( 'P1596','Villanueva','Llanos','Sergio',Null,Null,'villaser@miempresa.com','987625426', Null)
GO

--El listado sin el uso de coalesce
SELECT p.codigo AS 'codigo', CONCAT_WS(' ', paterno, materno, nombres) AS 'participante',
	   p.correo_hotmail AS 'hormail', p.correo_gmail AS 'gmail', p.correo_corporativo AS 'mail corporativo',
	   p.celular_personal AS 'cel. personal', p.celular_corporativo AS 'cel. corporativo' 
FROM participantes AS p
GO

--Usando coalesce
SELECT p.codigo AS 'codigo', CONCAT_WS(' ', paterno, materno, nombres) AS 'participante',
	   COALESCE(p.correo_hotmail, p.correo_gmail, p.correo_corporativo, 'NO ESPECIFICADO') AS 'correo',
	   COALESCE(p.celular_personal, p.celular_corporativo, 'NO ESPECIFICADO') AS 'celular'
FROM participantes AS p
GO

/*EJERCICIO 05. En este ejercicio se va a utilizar COALESCE para concatenar las provincias de cada
departamento del Perú*/
DROP TABLE IF EXISTS departamentos
GO

CREATE TABLE departamentos(
	codigo INT,
	nombre VARCHAR(50),
	capital VARCHAR(50),
	CONSTRAINT pk_departamentos PRIMARY KEY(codigo)
)
GO

--Los departamentos
INSERT INTO departamentos(codigo, nombre, capital)
VALUES(1, 'Amazonas', 'Chachapoyas'),
(2,'Áncash','Huaraz'),
(3,'Apurímac','Abancay'),
(4,'Arequipa','Arequipa'),
(5,'Ayacucho','Ayacucho'),
(6,'Cajamarca','Cajamarca'),
(7,'Callao?','Callao'),
(8,'Cusco','Cusco'),
(9,'Huancavelica','Huancavelica'),
(10,'Huánuco','Huánuco'),
(11,'Ica','Ica'),
(12,'Junín','Huancayo'),
(13,'La Libertad','Trujillo'),
(14,'Lambayeque','Chiclayo'),
(15,'Lima','Lima'),
(16,'Loreto','Iquitos'),
(17,'Madre de Dios','Puerto Maldonado'),
(18,'Moquegua','Moquegua'),
(19,'Pasco','Cerro de Pasco'),
(20,'Piura','Piura'),
(21,'Puno','Puno'),
(22,'San Martín','Moyobamba'),
(23,'Tacna','Tacna'),
(24,'Tumbes','Tumbes'),
(25,'Ucayali','Pucallpa')
GO

/*Provincias, se van a insertar en una columna separadas por coma, luego se usará la función STRING_SPLIT
para presentarlas cada una en una fila*/
DROP TABLE IF EXISTS provincias
GO

CREATE TABLE provincias(
	departamento_codigo INT, 
	cantidad INT,
	nombres VARCHAR(1000),
	CONSTRAINT pk_provincias PRIMARY KEY(departamento_codigo),
	CONSTRAINT fk_departamento_codigo FOREIGN KEY(departamento_codigo) REFERENCES departamentos(codigo)
)
GO

--Las provincias
insert into Provincias values (1,7,' Chachapoyas , Bagua , Bongará , Condorcanqui , Luya , Rodríguez de Mendoza , Utcubamba ')
insert into Provincias values (2,20,' Aija , Antonio Raymondi , Asunción , Bolognesi , Carhuaz , Carlos F. Fitzcarrald , Casma , Corongo , Huaraz , Huari , Huarmey , Huaylas , Mariscal Luzuriaga , Ocros , Pallasca , Pomabamba , Recuay , Santa , Sihuas , Yungay')
insert into Provincias values (3,7,' Abancay , Antabamba , Aymaraes , Cotabambas , Grau , Chincheros , Andahuaylas')
insert into Provincias values (4,8,' Arequipa , Camaná , Caravelí , Castilla , Caylloma , Condesuyos , Islay , La Unión')
insert into Provincias values (5,11,' Cangallo , Huanta , Huamanga , Huanca Sancos , La Mar , Lucanas , Parinacochas , Páucar del Sara Sara , Sucre , Víctor Fajardo , Vilcashuamán')
insert into Provincias values (6,13,' Cajamarca , Cajabamba , Celendín , Chota , Contumazá , Cutervo , Hualgayoc , Jaén , San Ignacio , San Marcos , San Miguel , San Pablo , Santa Cruz')
insert into Provincias values (7,1,' Callao')
insert into Provincias values (8,13,' Cuzco , Acomayo , Anta , Calca , Canas , Canchis , Chumbivilcas , Espinar , La Convención , Paruro , Paucartambo , Quispicanchi , Urubamba')
insert into Provincias values (9,7,' Huancavelica , Acobamba , Angaraes , Castrovirreyna , Churcampa , Huaytará , Tayacaja')
insert into Provincias values (10,11,' Huánuco , Ambo , Dos de Mayo , Huacaybamba , Huamalíes , Leoncio Prado , Marañón , Pachitea , Puerto Inca , Lauricocha , Yarowilca')
insert into Provincias values (11,5,' Ica , Chincha , Nazca , Palpa , Pisco')
insert into Provincias values (12,9,' Chanchamayo , Chupaca , Concepción , Huancayo , Jauja , Junín , Satipo , Tarma , Yauli')
insert into Provincias values (13,12,' Ascope , Bolívar , Chepén , Gran Chimú , Julcán , Otuzco , Pacasmayo , Pataz , Sánchez Carrión , Santiago de Chuco , Trujillo , Virú')
insert into Provincias values (14,3,' Chiclayo , Ferreñafe , Lambayeque')
insert into Provincias values (15,10,' Barranca , Cajatambo , Canta , Cañete , Huaral , Huarochirí , Huaura , Lima , Oyón , Yauyos')
insert into Provincias values (16,8,' Putumayo , Alto Amazonas , Datem del Marañón , Loreto , Mariscal Ramón Castilla , Maynas , Requena , Ucayali')
insert into Provincias values (17,3,' Tambopata , Manu , Tahuamanu')
insert into Provincias values (18,3,' General Sánchez Cerro , Ilo , Mariscal Nieto')
insert into Provincias values (19,3,' Pasco , Daniel A. Carrión , Oxapampa')
insert into Provincias values (20,8,' Ayabaca , Huancabamba , Morropón , Paita , Piura , Sechura , Sullana , Talara')
insert into Provincias values (21,13,' Puno , Azángaro , Carabaya , Chucuito , El Collao , Huancané , Lampa , Melgar , San Antonio de Putina , San Román , Sandia , Yunguyo , Moho')
insert into Provincias values (22,10,' Bellavista , El Dorado , Huallaga , Lamas , Mariscal Cáceres , Moyobamba , Picota , Rioja , San Martín , Tocache')
insert into Provincias values (23,4,' Tacna , Candarave , Jorge Basadre , Tarata')
insert into Provincias values (24,3,' Tumbes , Zarumilla , Contralmirante Villar ')
insert into Provincias values (25,4,' Coronel Portillo , Atalaya , Padre Abad , Purús')
GO

--El listado de los departamentos y sus provincias
SELECT d.codigo, d.nombre AS 'departamento', p.nombres AS 'provincias' 
FROM departamentos AS d
	INNER JOIN provincias AS p ON(d.codigo = p.departamento_codigo)
GO

--Creamos una vista con el resultado
CREATE OR ALTER VIEW v_departamentos_provincias
AS
	SELECT d.codigo, d.nombre AS 'departamento', p.nombres AS 'provincias' 
	FROM departamentos AS d
		INNER JOIN provincias AS p ON(d.codigo = p.departamento_codigo)
GO

--Select de la vista
SELECT * 
FROM v_departamentos_provincias
GO

--Para poder usar el COALESCE se va a crear una consulta separando las provincias en filas, 
--para esto se usará la función STRING_SPLIT
SELECT v.codigo, v.departamento, VALUE AS 'provincia' 
FROM v_departamentos_provincias AS v
	CROSS APPLY STRING_SPLIT(v.provincias, ',')
GO

--Usando COALESCE para filtrar las provincias de un departamento
--Las provincias del departamento de Ancash
DECLARE  @columna VARCHAR(MAX)
SELECT @columna = COALESCE(@columna, '') + '' + d.provincia + '' + ','
FROM (SELECT v.codigo AS 'cód. departamento', v.departamento AS 'departamento', VALUE AS 'provincia'
	  FROM v_departamentos_provincias AS v 
		CROSS APPLY STRING_SPLIT(v.provincias, ',')) AS d
WHERE d.departamento = 'Áncash'
SELECT SUBSTRING(@columna, 1, LEN(@columna) - 1)
GO
