/*-- RECONSTRUIR LOS ÍNDICES EN SQL SERVER --

Un índice de SQL Server es una estructura en disco o en memoria asociada con una tabla o vista 
que acelera la recuperación de filas de la tabla o vista. 

Un índice contiene claves generadas a partir de una o varias columnas de la tabla o la vista.

El diseño eficaz de los índices tiene gran importancia para conseguir un buen rendimiento de una 
base de datos y una aplicación, es por ese motivo que no solamente es muy útil crearlos sino cada 
cierto tiempo reconstruirlos, este tiempo va a depender de la cantidad de información que cambia 
en el indice de la tabla o vista.

EJERCICIO
Para este ejercicio se va a usar la base de datos Northwind, se va a crear un cursor que guarde 
los datos de los índices para crear la instrucción de reconstrucción del índice, todo será en un 
procedimiento almacenado para reconstruir los índices.

LOS METADATOS
SQL Server guarda los datos de los objetos de la base de datos en lo que se conoce como metadatos.
Estos metadatos se almacenan en vistas del sistema, para este ejemplo vamos a usar las 
siguientes vistas del sistema:
SYS.TABLES que tiene la información de las tablas
SYS.SCHEMAS que tiene la información de los esquemas
SYS.INDEXES que tiene la información de los índices
SYS.DM_DB_INDEX_PHYSICAL_STATS que tiene la información de las estadísticas de los índices
*/
USE Northwind
GO

/*El procedimiento almacenado recibe de manera opcional dos parámetros, uno que indica que los 
índices se van a reconstruir y el otro con el valor de fragmentación máxima del índice. 
Se crea la variable tipo tabla llamada @listaIndices y se incluyen los datos necesarios
para crear la instrucción para reconstruir el índice.

INSTRUCCIÓN ALTER INDEX
Permite modificar el índice. Para el ejemplo será: 

ALTER INDEX nombreDelIndice
ON [esquema].[tabla] REBUILD 
WITH(ONLINE = OFF)

PROCEDIMIENTO ALMACENADO PARA RECONSTRUIR LOS ÍNDICES

*/
CREATE OR ALTER PROCEDURE dbo.reconstruir_indices(
	@mostrarReconstruir VARCHAR(10) = 'Mostrar',
	@fragmentacionMaxima DECIMAL(20,2) = 20.0
)
AS
	BEGIN
		--Declarar variables
		SET NOCOUNT ON
		DECLARE @esquema				VARCHAR(128),
				@tabla					VARCHAR(128),
				@indice					VARCHAR(128),
				@instruccionAlterIndex	VARCHAR(4000),
				@idBaseDatos			INT,
				@idEsquema				INT,
				@idTabla				INT,
				@indexId				INT
	
		--Variables tipo tabla para los índices
		DECLARE @listaIndices TABLE(
			base_datos VARCHAR(128) NOT NULL,
			id_base_datos INT NOT NULL,
			esquema VARCHAR(128) NOT NULL,
			id_esquema INT NOT NULL,
			nombre_tabla VARCHAR(128) NOT NULL,
			id_tabla INT NOT NULL,
			nombre_indice VARCHAR(128),
			id_indice INT NOT NULL,
			fragmentacion DECIMAL(20,2),
			PRIMARY KEY(id_base_datos, id_esquema, id_tabla, id_indice)
		)
		--Llenar la lista de índices, la información se obtiene de las vistas del sistema
		--Tables, Schemas, Indexes y dm_index_physical_stats

		INSERT INTO @listaIndices(base_datos, id_base_datos, esquema, id_esquema, nombre_tabla, id_tabla, nombre_indice, id_indice, fragmentacion)
		SELECT DB_NAME(), DB_ID(), s.name, s.schema_id, t.name, t.object_id, i.name, i.index_id, MAX(f.avg_fragmentation_in_percent) 
		FROM SYS.TABLES AS t
			JOIN SYS.SCHEMAS AS s ON(t.schema_id = s.schema_id)
			JOIN SYS.INDEXES AS i ON(t.object_id = i.object_id)
			JOIN SYS.DM_DB_INDEX_PHYSICAL_STATS(DB_ID(), NULL, NULL, NULL, NULL) AS f ON(f.object_id = t.object_id AND f.index_id = i.index_id)
		WHERE f.database_id = DB_ID()
		GROUP BY s.name, s.schema_id, t.name, t.object_id, i.name, i.index_id

		--Si recibe el parámetro comprobar si es rebuild para reconstruir
		IF @mostrarReconstruir = 'Rebuild'
			BEGIN
				--Cursor para crear las instrucciones SQL
				DECLARE c_instrucciones_indices CURSOR FAST_FORWARD
				FOR SELECT esquema, nombre_tabla, nombre_indice
					FROM @listaIndices
					WHERE fragmentacion > @fragmentacionMaxima
					ORDER BY fragmentacion DESC, nombre_tabla ASC, nombre_indice ASC
				
				OPEN c_instrucciones_indices
				FETCH NEXT FROM c_instrucciones_indices INTO @esquema, @tabla, @indice

				--Recorrer el cursor
				WHILE(@@FETCH_STATUS = 0)
					BEGIN
						--Crear la instrucción ALTER INDEX
						SET @instruccionAlterIndex = 'ALTER INDEX ' + QUOTENAME(RTRIM(@indice)) + 
						' ON ' + QUOTENAME(RTRIM(@esquema)) + '.' + QUOTENAME(RTRIM(@tabla)) + 
						' REBUILD WITH(ONLINE = OFF)'
						--Para mostrar en el panel de mensajes la istrucción
						PRINT @instruccionAlterIndex
						--Ejecutar la instrucción
						EXECUTE(@instruccionAlterIndex)
						
						FETCH NEXT FROM c_instrucciones_indices INTO @esquema, @tabla, @indice
					END
				
				CLOSE c_instrucciones_indices
				DEALLOCATE c_instrucciones_indices
			END

		--Mostrar resultados
		SELECT l.base_datos AS 'Base de datos', l.esquema AS 'Esquema', 
				l.nombre_tabla AS 'Tabla', l.nombre_indice AS 'Índice',
				l.fragmentacion AS 'Fragmentación Inicial',
				MAX(CAST(f.avg_fragmentation_in_percent AS DECIMAL(20,2))) AS 'Fragmentación Final'
		FROM @listaIndices AS l
			JOIN SYS.DM_DB_INDEX_PHYSICAL_STATS(@idBaseDatos, NULL, NULL, NULL, NULL) AS f ON
			(l.id_base_datos = f.database_id AND l.id_tabla = f.object_id AND l.id_indice = f.index_id)
		GROUP BY l.base_datos, l.esquema, l.nombre_tabla, l.nombre_indice, l.fragmentacion
		ORDER BY l.fragmentacion DESC, l.nombre_tabla ASC, l.nombre_indice ASC
		
		RETURN
	END
GO

--Ejecutar el SP para reconstruir los índices de la base de datos abierta
EXECUTE reconstruir_indices 'Rebuild'
GO

/*IMPORTANTE:
Se recomienda crear un plan de mantenimiento e incluir una tarea para ejecutar el SP
que reconstruya los índices
*/