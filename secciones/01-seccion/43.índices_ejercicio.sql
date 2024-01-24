/*-- ÍNDICES EN SQL SERVER | EJERCICIOS --*/

/*
Tomado de:
https://www.youtube.com/watch?v=PodbAFmHYq8
Demostración de la aplicación y uso de Índices en laboratorio grabado.

Un índice es una estructura de disco asociada con una tabla o una vista que acelera la recuperación
de filas de la tabla o de la vista. Un índice contiene claves generadas a partir de una o varias 
columnas de la tabla o la vista. Dichas claves están almacenadas en una estructura (árbol b) que 
permite que SQL Server busque de forma rápida y eficiente la fila o filas asociadas a los 
valores de cada clave. 

Los índices servirán para que nuestra consulta sea rápida. 
¡OJO! es un costo, por que nuestra consulta se va a volver RÁPIDA, ¡Sí!
pero, atención, la INSERCIÓN si va a demorar. Es decir, cuando los datos de una tabla
están desordenados y se INSERTA un registro, sencillamente se inserta y ya, no hay demora, 
pero en el caso de que los datos ya estén ORDENADOS y se inserta, allí se evidenciará la demora
en la INSERCICIÓN ya que SQL Server tendrá que buscar la ubicación correcta para insertar el registro. 
En conclusión, los ÍNDICES hacen más eficientes las CONSULTAS SELECT, pero demoran más
en la INSERCIÓN de datos
*/
USE Northwind
GO

/*Crearemos la tabla ciudadanos sin llave primaria que contendrá 1 millón de registros.
No hay índices que es lo que queremos evaluar.
*/
CREATE TABLE ciudadanos(
	nom1 VARCHAR(20),
	nom2 VARCHAR(20),
	ape1 VARCHAR(20),
	ape2 VARCHAR(20)
)
GO

/*Insertams 1 millón de registros*/
DECLARE @contador INT = 1
WHILE @contador <= 1000000
	BEGIN
		INSERT INTO ciudadanos(nom1, nom2, ape1, ape2)
		VALUES('nombre' + CONVERT(VARCHAR, @contador), 'segundo'+ CONVERT(VARCHAR, @contador), 'paterno'+ CONVERT(VARCHAR, @contador), 'materno'+ CONVERT(VARCHAR, @contador))
		SET @contador = @contador + 1
	END
GO


--Borrar todos los planes de memoria caché
DBCC FREEPROCCACHE WITH NO_INFOMSGS
--Vaciar la caché de datos
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS
GO

/*
NOTA: Las dos instrucciones de arriba permiten eliminar de caché los planes
realizados de las consultas ejecutadas. Es decir, si por primera vez se ejecuta una
consulta, SQL Server establece un plan para esa consulta, es decir,  una guía 
que permitirá obtener los resultados más rápidos cuando se vuelvan a ejecutar la consulta,
de tal manera que cuando, ejecutemos en reiteradas oportunidades la misma consulta
SQL Server ya tiene en caché dicho plan y ejecuta más rápido las consultas.
Por esta razón es que utilizamos esas dos instrucciones de arriba para poder eliminarlas
y ver el verdadero tiempo que le toma a la consulta ejecutarse y cómo más adelante
utilizaremos índices las consultas mejorarán considerablemente.
*/

--Ejecutaremos una consulta y veremos que su tiempo de demora es largo.
--ya que no hay índices y tendrá que buscar registro por registro
SELECT  nom1, nom2, ape1, ape2
FROM ciudadanos
WHERE ape1 = 'paterno1000000' AND ape2 = 'materno1000000'
GO

/*
-El índice CLUSTEREADO se ordena FÍSICAMENTE en el disco
-Es decir, él va a reodenar los datos para que estén ordenados por el ape1 y ape2
-Solo puede haber un índice CLUSTEREADO (SOLO UNO)
-Si lo queremos comparar con algo sería similar a las PÁGINAS AMARILLAS, 
 estos, están ordenamos alfabéticamente. Por ejemplo, si buscamos a la empresa
 WONG, se tendría que empezar a buscar por la W
 */
CREATE CLUSTERED INDEX idx_ciudadanos_ape1_ape2
ON ciudadanos(ape1 ASC, ape2 DESC)
GO

/*Una vez creada el índice, volvemos a ejecutar la consulta select ejecutada
anteriormente. Debemos observar que esta vez el timepo de respuesta debe ser
mucho menor ya que se creó el índice. Si eliminamos el plan de la
caché, veremos que la consulta será muy rápida, tanto o mejor como si no borráramos
la caché.
*/
SELECT  nom1, nom2, ape1, ape2
FROM ciudadanos
WHERE ape1 = 'paterno1000000' AND ape2 = 'materno1000000'
GO

--A partir de ahora solo se pueden crear índices NO CLUSTEREADOS
--El índice NO CLUSTEREADO, crea una estructura de índice, si lo comparamos con un 
--libro, crea la página ÍNDICE del libro
CREATE NONCLUSTERED INDEX idx_ciudadanos_nom1_ape1
ON ciudadanos(nom1, ape1)
GO


/*Una vez ejecutado el índice no clustereado, realizamos la consulta
*/
SELECT  nom1, nom2, ape1, ape2
FROM ciudadanos
WHERE nom1 = 'nombre1009999' AND ape1 = 'paterno1009999'
GO

