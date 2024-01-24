/*-- �NDICES EN SQL SERVER | EJERCICIOS --*/

/*
Tomado de:
https://www.youtube.com/watch?v=PodbAFmHYq8
Demostraci�n de la aplicaci�n y uso de �ndices en laboratorio grabado.

Un �ndice es una estructura de disco asociada con una tabla o una vista que acelera la recuperaci�n
de filas de la tabla o de la vista. Un �ndice contiene claves generadas a partir de una o varias 
columnas de la tabla o la vista. Dichas claves est�n almacenadas en una estructura (�rbol b) que 
permite que SQL Server busque de forma r�pida y eficiente la fila o filas asociadas a los 
valores de cada clave. 

Los �ndices servir�n para que nuestra consulta sea r�pida. 
�OJO! es un costo, por que nuestra consulta se va a volver R�PIDA, �S�!
pero, atenci�n, la INSERCI�N si va a demorar. Es decir, cuando los datos de una tabla
est�n desordenados y se INSERTA un registro, sencillamente se inserta y ya, no hay demora, 
pero en el caso de que los datos ya est�n ORDENADOS y se inserta, all� se evidenciar� la demora
en la INSERCICI�N ya que SQL Server tendr� que buscar la ubicaci�n correcta para insertar el registro. 
En conclusi�n, los �NDICES hacen m�s eficientes las CONSULTAS SELECT, pero demoran m�s
en la INSERCI�N de datos
*/
USE Northwind
GO

/*Crearemos la tabla ciudadanos sin llave primaria que contendr� 1 mill�n de registros.
No hay �ndices que es lo que queremos evaluar.
*/
CREATE TABLE ciudadanos(
	nom1 VARCHAR(20),
	nom2 VARCHAR(20),
	ape1 VARCHAR(20),
	ape2 VARCHAR(20)
)
GO

/*Insertams 1 mill�n de registros*/
DECLARE @contador INT = 1
WHILE @contador <= 1000000
	BEGIN
		INSERT INTO ciudadanos(nom1, nom2, ape1, ape2)
		VALUES('nombre' + CONVERT(VARCHAR, @contador), 'segundo'+ CONVERT(VARCHAR, @contador), 'paterno'+ CONVERT(VARCHAR, @contador), 'materno'+ CONVERT(VARCHAR, @contador))
		SET @contador = @contador + 1
	END
GO


--Borrar todos los planes de memoria cach�
DBCC FREEPROCCACHE WITH NO_INFOMSGS
--Vaciar la cach� de datos
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS
GO

/*
NOTA: Las dos instrucciones de arriba permiten eliminar de cach� los planes
realizados de las consultas ejecutadas. Es decir, si por primera vez se ejecuta una
consulta, SQL Server establece un plan para esa consulta, es decir,  una gu�a 
que permitir� obtener los resultados m�s r�pidos cuando se vuelvan a ejecutar la consulta,
de tal manera que cuando, ejecutemos en reiteradas oportunidades la misma consulta
SQL Server ya tiene en cach� dicho plan y ejecuta m�s r�pido las consultas.
Por esta raz�n es que utilizamos esas dos instrucciones de arriba para poder eliminarlas
y ver el verdadero tiempo que le toma a la consulta ejecutarse y c�mo m�s adelante
utilizaremos �ndices las consultas mejorar�n considerablemente.
*/

--Ejecutaremos una consulta y veremos que su tiempo de demora es largo.
--ya que no hay �ndices y tendr� que buscar registro por registro
SELECT  nom1, nom2, ape1, ape2
FROM ciudadanos
WHERE ape1 = 'paterno1000000' AND ape2 = 'materno1000000'
GO

/*
-El �ndice CLUSTEREADO se ordena F�SICAMENTE en el disco
-Es decir, �l va a reodenar los datos para que est�n ordenados por el ape1 y ape2
-Solo puede haber un �ndice CLUSTEREADO (SOLO UNO)
-Si lo queremos comparar con algo ser�a similar a las P�GINAS AMARILLAS, 
 estos, est�n ordenamos alfab�ticamente. Por ejemplo, si buscamos a la empresa
 WONG, se tendr�a que empezar a buscar por la W
 */
CREATE CLUSTERED INDEX idx_ciudadanos_ape1_ape2
ON ciudadanos(ape1 ASC, ape2 DESC)
GO

/*Una vez creada el �ndice, volvemos a ejecutar la consulta select ejecutada
anteriormente. Debemos observar que esta vez el timepo de respuesta debe ser
mucho menor ya que se cre� el �ndice. Si eliminamos el plan de la
cach�, veremos que la consulta ser� muy r�pida, tanto o mejor como si no borr�ramos
la cach�.
*/
SELECT  nom1, nom2, ape1, ape2
FROM ciudadanos
WHERE ape1 = 'paterno1000000' AND ape2 = 'materno1000000'
GO

--A partir de ahora solo se pueden crear �ndices NO CLUSTEREADOS
--El �ndice NO CLUSTEREADO, crea una estructura de �ndice, si lo comparamos con un 
--libro, crea la p�gina �NDICE del libro
CREATE NONCLUSTERED INDEX idx_ciudadanos_nom1_ape1
ON ciudadanos(nom1, ape1)
GO


/*Una vez ejecutado el �ndice no clustereado, realizamos la consulta
*/
SELECT  nom1, nom2, ape1, ape2
FROM ciudadanos
WHERE nom1 = 'nombre1009999' AND ape1 = 'paterno1009999'
GO

