/*-- USO DE WITH TIES EN SELECT SQL SERVER --

- La opción WITH TIES en una instrucción SELECT se utiliza cuando se usa la cláusula
  TOP N [PERCENT]
- El uso de WITH TIES en el listado permite mostrar los registros que tienen los mismos
  valores que el último mostrado de auerdo a la cantidad mostrada por TOP n o TOP n PERCENT
- El uso de TOP debe ir acompañado con la cláusula ORDER BY

EJEMPLO. 
Para entender el uso de WITH TIES vamos a crear una base de datos, luego crear una tabla de
ALUMNOS e insertar registros los cuales van a tener un campo de promedios
*/
CREATE DATABASE bd_prueba_ties
GO

USE bd_prueba_ties
GO

CREATE TABLE alumnos(
	codigo CHAR(6),
	nombre VARCHAR(50),
	promedio NUMERIC(9,2),
	CONSTRAINT pk_alumnos PRIMARY KEY(codigo)
)
GO

--Los registros
INSERT INTO alumnos
VALUES('050426','Carlos Balarezo',12),
('798455','Aracely Terravova',17),
('230974','Mónica Mendoza',16),
('094569','Sergio Campos',14),
('092395','Rossana Llanos',9),
('077845','Pedro Alcántara',14),
('509875','Patricia López',7)
GO

--Listado de alumos ordenados por promedio en orden descendente
SELECT * 
FROM alumnos
ORDER BY promedio DESC
GO

/*Note que en el conjunto de resultados hay dos registros que tienen
igual promedio, que son el tercero y cuarto
*/

--Mostrar los 3 primeros sin el uso de WITH TIES
SELECT TOP 3 * 
FROM alumnos
ORDER BY promedio DESC
GO

/*Puede visualizarse solamente los tres primeros, en la figura donde
se muestran todos los alumnos puede notarse que el cuarto alumno tienen
el mismo promedio que el terero*/

--USANDO WITH TIES

--Mostrar los 3 primeros, usando WITH TIES
SELECT TOP 3 WITH TIES *
FROM alumnos 
ORDER BY promedio DESC
GO

/*Note que en la instrucción se está especificando que se muestren 3 registros al usar
la cláusula TOP 3, pero al incluir la opción WITH TIES también se muestra el cuarto 
registro por que tiene el mismo promedio que el tercero.

Si no hubieran registros con el mismo valor del promedio iguales al último, 
solamente se mostrarían los tres primeros
*/

