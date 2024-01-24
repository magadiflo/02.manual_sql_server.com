/*-- DBCC CATEGORÍA INFORMATIVAS --

Los comandos DBCC, Database Console Commands de la categoría Informativas son las siguientes:

DBCC INPUTBUFFER
DBCC SHOWCONTIG
DBCC OPENTRAN
DBCC SQLPERF
DBCC OUTPUTBUFFER
DBCC TRACESTATUS
DBCC PROCCACHE
DBCC USEROPTIONS
DBCC SHOW_STATISTICS

En las líneas siguientes se explican los comandos DBCC de la categoría informativas.

DBCC INPUTBUFFER
Muestra la última declaración enviada desde un cliente a una instancia de Microsoft SQL Server.
Sintaxis:
DBCC INPUTBUFFER ( Id_Sesion [ , ID_Requerimiento])
[WITH NO_INFOMSGS ]
Donde:
Id_Sesion
Es la ID de sesión asociada con cada conexión primaria activa.
ID_Requerimiento
Es la solicitud exacta (lote) para buscar dentro de la sesión actual
NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/

/*EJERCICIO 01. Visualizar la declaración enviada en la sesión con ID 58*/
DBCC INPUTBUFFER(58)
GO

/*EJERCICIO 02. Podemos crear una nueva sesión, crear un login e iniciar sesión*/
CREATE LOGIN trainer WITH password = '123'
GO

--Al abrir una nueva consulta, con una nueva ventana de código
DBCC INPUTBUFFER(69)
GO

/*DBCC SHOWCONTIG

Muestra información de fragmentación para los datos y los índices de la tabla o vista especificada.
Puede usar también: sys.dm_db_index_physical_stats
Sintaxis:
DBCC SHOWCONTIG
[ (
{ NombreTabla | NombreVista }
[ , NombreIndice ]
) ]
[ WITH
{
[ , [ ALL_INDEXES ] ]
[ , [ TABLERESULTS ] ]
[ , [ FAST ] ]
[ , [ ALL_LEVELS ] ]
[ NO_INFOMSGS ]
}
]
Donde:
NombreTabla | NombreVista
Es la tabla o vista para verificar la información de fragmentación.
Si no se especifica, se verifican todas las tablas y vistas indexadas en la base de datos actual.
Para obtener la ID de tabla o vista, use la función OBJECT_ID.

NombreIndice
Es el índice para verificar la información de fragmentación.
Si no se especifica, la instrucción procesa el índice base para la tabla o vista especificada.
Para obtener la identificación del índice, use la vista del catálogo sys.indexes.

With
Especifica opciones para el tipo de información devuelta por la declaración DBCC.

Fast
Especifica si se realiza un escaneo rápido del índice y se genera información mínima. Un escaneo 
rápido no lee las páginas de hoja o de datos del índice.

ALL_INDEXES
Muestra resultados para todos los índices de las tablas y vistas especificadas, incluso si se 
especifica un índice en particular.

TABLERESULTS
Muestra resultados como un conjunto de filas, con información adicional.

All_Levels
Mantenido solo por compatibilidad con versiones anteriores.
Incluso si se especifica ALL_LEVELS, solo se procesa el nivel de hoja de índice o el nivel
de datos de tabla.

NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/
USE Northwind
GO

--Ver la información de fragmentación de la tabla Customers
DBCC showcontig ("Customers")
GO

/*DBCC OPENTRAN

DBCC OPENTRAN ayuda a identificar transacciones activas que pueden estar previniendo el 
truncamiento del registro. DBCC OPENTRAN muestra información sobre la transacción activa 
más antigua y las transacciones replicadas distribuidas y no distribuidas más antiguas, si existen, 
dentro del registro de transacciones de la base de datos especificada. Los resultados se 
muestran solo si hay una transacción activa que existe en el registro o si la base de datos 
contiene información de replicación. Se muestra un mensaje informativo si no hay transacciones 
activas en el registro.
Sintaxis:
DBCC OPENTRAN
[
( [ BaseDatos | 0 ] ) ]
{ [ WITH TABLERESULTS ]
[ , [ NO_INFOMSGS ] ]
}
]
Donde:
Es el nombre o ID de la base de datos para mostrar la información de transacción más antigua. 
Si no se especifica, o si se especifica 0, se usa la base de datos actual. Los nombres de las 
bases de datos deben cumplir con las reglas para los identificadores.

TABLERESULTS
Especifica los resultados en un formato tabular que se puede cargar en una tabla. Use esta opción 
para crear una tabla de resultados que se pueda insertar en una tabla para realizar comparaciones. 
Cuando esta opción no se especifica, los resultados se formatean para su legibilidad.

NO_INFOMSGS
Suprime todos los mensajes informativos.
*/

--Para saber si hay transacciones abiertas
DBCC OpenTran
GO

--Abrir una transacción
CREATE TABLE prueba(
	dato1 CHAR(3),
	dato2 VARCHAR(50)
)
GO

BEGIN TRANSACTION prueba_datos
INSERT INTO prueba VALUES('T02', 'Traier SQL')
GO

DBCC OpenTran
COMMIT TRANSACTION prueba_datos
GO

--Borrar la tabla
DROP TABLE prueba
GO

/*DBCC SQLPERF
Proporciona estadísticas de uso de espacio de registro de transacciones para todas las bases de datos. 
En SQL Server, también se puede usar para restablecer las estadísticas de espera y bloqueo.
Sintaxis:
DBCC SQLPERF
(
[ LOGSPACE ]
| [ «sys.dm_os_latch_stats» , CLEAR ]
| [ «sys.dm_os_wait_stats» , CLEAR ]
)
[WITH NO_INFOMSGS ]
Donde:
LOGSPACE
Devuelve el tamaño actual del registro de transacciones y el porcentaje de espacio de registro 
utilizado para cada base de datos. Use esta información para controlar la cantidad de espacio 
utilizado en un registro de transacciones.

«sys.dm_os_latch_stats», Clear
Restablece las estadísticas de pestillo.
Esta opción no está disponible en la base de datos SQL.

«sys.dm_os_wait_stats», Clear
Restablece las estadísticas de espera.
Esta opción no está disponible en la base de datos SQL.

with NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/
DBCC SQLPERF(LOGSPACE);
GO

/*DBCC OUTPUTBUFFER

Devuelve el búfer de salida actual en formato hexadecimal y ASCII para el session_id especificado.
Sintaxis:
DBCC OUTPUTBUFFER ( Id_Sesion [ , Id_Requerimiento ])
[ WITH NO_INFOMSGS ]
Donde:
Id_Sesion
Es la ID de sesión asociada con cada conexión primaria activa.
Id_Requerimiento
Es la solicitud exacta (lote) para buscar dentro de la sesión actual.
*/
--La siguiente instrucción muestra el buffer de salida para la conexión activa
DBCC OUTPUTBUFFER(54)
GO

/*DBCC TRACESTATUS
Muestra el estado de las marcas de rastreo.
Sintaxis:
DBCC TRACESTATUS ( [ [ trace# [ ,…n ] ] [ , ] [ -1 ] ] )
[ WITH NO_INFOMSGS ]
Donde:
Trace#
Es el número del indicador de seguimiento para el que se muestra el estado.
Si no se especifican traza # y -1, se muestran todos los indicadores de seguimiento que 
están habilitados para la sesión.
n
Es un marcador de posición que indica que se pueden especificar múltiples
marcas de seguimiento.
-1
Muestra el estado de las marcas de rastreo que están habilitadas globalmente.
Si se especifica -1 sin rastro #, se muestran todos los indicadores de seguimiento
globales que están habilitados.
With NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/

--El siguiente ejemplo muestra el estado de todos los indicadores de rastreo que están actualmente 
--habilitados globalmente.
DBCC TRACESTATUS(-1)
GO

--La instrucción siguiente muestra todas las marcas de rastreo en la sesión actual
DBCC TRACESTATUS()
GO

/*DBCC PROCCACHE

Muestra información en un formato de tabla sobre el caché del procedimiento.
Sintaxis:
DBCC PROCCACHE [ WITH NO_INFOMSGS ]
Donde:
With NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/
--Muestra los procedimientos en caché
DBCC PROCCACHE
GO

/*DBCC USEROPTIONS

Devuelve las opciones SET activadas para la conexión actual.
Sintaxis:
DBCC USEROPTIONS
[ WITH NO_INFOMSGS ]
Donde:
With NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/

--Mostrar las opciones de la conexión activa
DBCC USEROPTIONS
GO

/*DBCC SHOW_STATISTICS

DBCC SHOW_STATISTICS muestra las estadísticas actuales de optimización de consulta para una tabla 
o vista indizada. El optimizador de consultas usa estadísticas para estimar la cardinalidad o el 
número de filas en el resultado de la consulta, lo que permite que el optimizador de consultas 
cree un plan de consulta de alta calidad. Por ejemplo, el optimizador de consultas podría usar 
estimaciones de cardinalidad para elegir el operador de búsqueda de índice en lugar del operador 
de exploración de índice en el plan de consulta, lo que mejora el rendimiento de la consulta al evitar 
un análisis de índice con uso intensivo de recursos.

El optimizador de consultas almacena estadísticas para una tabla o vista indexada en un objeto de 
estadísticas. Para una tabla, el objeto de estadísticas se crea en un índice o en una lista de 
columnas de tabla. El objeto de estadísticas incluye un encabezado con metadatos sobre las estadísticas,
un histograma con la distribución de valores en la primera columna clave del objeto de estadísticas y 
un vector de densidad para medir la correlación entre columnas. El motor de base de datos puede 
calcular las estimaciones de cardinalidad con cualquiera de los datos en el objeto de estadísticas.

DBCC SHOW_STATISTICS muestra el encabezado, el histograma y el vector de densidad en función de 
los datos almacenados en el objeto de estadísticas. La sintaxis le permite especificar una tabla o 
vista indizada junto con un nombre de índice de destino, nombre de estadística o nombre de columna. 
Este tema describe cómo mostrar las estadísticas y cómo entender los resultados mostrados.

Sintaxis:
DBCC SHOW_STATISTICS ( Tabla_VistaIndizada , target )
[ WITH [ NO_INFOMSGS ] < option > [ , n ] ]
< option > :: =
STAT_HEADER | DENSITY_VECTOR | HISTOGRAM | STATS_STREAM
Donde:
Tabla_VistaIndizada (Ver Indices en Vistas)
Nombre de la tabla o vista indizada para la que se muestra información estadística.
nombre de la tabla
Nombre de la tabla que contiene las estadísticas para mostrar.
La tabla no puede ser una tabla externa.
target
Nombre del índice, estadísticas o columna para mostrar información de estadísticas. el objetivo se 
incluye entre corchetes, comillas simples, comillas dobles o sin comillas. Si el objetivo es un nombre
de un índice o estadísticas existente en una tabla o vista indizada, se devuelve la información de 
estadísticas sobre este objetivo. Si el objetivo es el nombre de una columna existente y existen 
estadísticas creadas automáticamente en esta columna, se devuelve información sobre esa estadística 
creada automáticamente. Si no existe una estadística creada automáticamente para un objetivo de 
columna, se devuelve el mensaje de error 2767.
En SQL Data Warehouse y Parallel Data Warehouse, el destino no puede ser un nombre de columna.
NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
STAT_HEADER | DENSITY_VECTOR | HISTOGRAMA | STATS_STREAM [, n]
Especificar una o más de estas opciones limita los conjuntos de resultados devueltos por la 
declaración a la opción u opciones especificadas. Si no se especifican opciones, se devuelve toda 
la información de estadísticas.
STATS_STREAM se identifica solo con fines informativos. No soportado. No se garantiza compatibilidad 
futura.
*/
--Mostrar las estadísticas de la tabla Customers en la base de datos de Northwind
USE Northwind
GO

DBCC SHOW_STATISTICS("dbo.Customers", PK_Customers)
GO

--Crear las estadísticas para CompanyName en la tabla Customers
Create statistics CustomersEmpresa on Northwind.dbo.Customers(CompanyName)
go
--Ver las estadísticas
DBCC SHOW_STATISTICS ("dbo.Customers", CompanyName)
GO