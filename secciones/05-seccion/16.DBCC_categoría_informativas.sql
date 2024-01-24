/*-- DBCC CATEGOR�A INFORMATIVAS --

Los comandos DBCC, Database Console Commands de la categor�a Informativas son las siguientes:

DBCC INPUTBUFFER
DBCC SHOWCONTIG
DBCC OPENTRAN
DBCC SQLPERF
DBCC OUTPUTBUFFER
DBCC TRACESTATUS
DBCC PROCCACHE
DBCC USEROPTIONS
DBCC SHOW_STATISTICS

En las l�neas siguientes se explican los comandos DBCC de la categor�a informativas.

DBCC INPUTBUFFER
Muestra la �ltima declaraci�n enviada desde un cliente a una instancia de Microsoft SQL Server.
Sintaxis:
DBCC INPUTBUFFER ( Id_Sesion [ , ID_Requerimiento])
[WITH NO_INFOMSGS ]
Donde:
Id_Sesion
Es la ID de sesi�n asociada con cada conexi�n primaria activa.
ID_Requerimiento
Es la solicitud exacta (lote) para buscar dentro de la sesi�n actual
NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/

/*EJERCICIO 01. Visualizar la declaraci�n enviada en la sesi�n con ID 58*/
DBCC INPUTBUFFER(58)
GO

/*EJERCICIO 02. Podemos crear una nueva sesi�n, crear un login e iniciar sesi�n*/
CREATE LOGIN trainer WITH password = '123'
GO

--Al abrir una nueva consulta, con una nueva ventana de c�digo
DBCC INPUTBUFFER(69)
GO

/*DBCC SHOWCONTIG

Muestra informaci�n de fragmentaci�n para los datos y los �ndices de la tabla o vista especificada.
Puede usar tambi�n: sys.dm_db_index_physical_stats
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
Es la tabla o vista para verificar la informaci�n de fragmentaci�n.
Si no se especifica, se verifican todas las tablas y vistas indexadas en la base de datos actual.
Para obtener la ID de tabla o vista, use la funci�n OBJECT_ID.

NombreIndice
Es el �ndice para verificar la informaci�n de fragmentaci�n.
Si no se especifica, la instrucci�n procesa el �ndice base para la tabla o vista especificada.
Para obtener la identificaci�n del �ndice, use la vista del cat�logo sys.indexes.

With
Especifica opciones para el tipo de informaci�n devuelta por la declaraci�n DBCC.

Fast
Especifica si se realiza un escaneo r�pido del �ndice y se genera informaci�n m�nima. Un escaneo 
r�pido no lee las p�ginas de hoja o de datos del �ndice.

ALL_INDEXES
Muestra resultados para todos los �ndices de las tablas y vistas especificadas, incluso si se 
especifica un �ndice en particular.

TABLERESULTS
Muestra resultados como un conjunto de filas, con informaci�n adicional.

All_Levels
Mantenido solo por compatibilidad con versiones anteriores.
Incluso si se especifica ALL_LEVELS, solo se procesa el nivel de hoja de �ndice o el nivel
de datos de tabla.

NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/
USE Northwind
GO

--Ver la informaci�n de fragmentaci�n de la tabla Customers
DBCC showcontig ("Customers")
GO

/*DBCC OPENTRAN

DBCC OPENTRAN ayuda a identificar transacciones activas que pueden estar previniendo el 
truncamiento del registro. DBCC OPENTRAN muestra informaci�n sobre la transacci�n activa 
m�s antigua y las transacciones replicadas distribuidas y no distribuidas m�s antiguas, si existen, 
dentro del registro de transacciones de la base de datos especificada. Los resultados se 
muestran solo si hay una transacci�n activa que existe en el registro o si la base de datos 
contiene informaci�n de replicaci�n. Se muestra un mensaje informativo si no hay transacciones 
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
Es el nombre o ID de la base de datos para mostrar la informaci�n de transacci�n m�s antigua. 
Si no se especifica, o si se especifica 0, se usa la base de datos actual. Los nombres de las 
bases de datos deben cumplir con las reglas para los identificadores.

TABLERESULTS
Especifica los resultados en un formato tabular que se puede cargar en una tabla. Use esta opci�n 
para crear una tabla de resultados que se pueda insertar en una tabla para realizar comparaciones. 
Cuando esta opci�n no se especifica, los resultados se formatean para su legibilidad.

NO_INFOMSGS
Suprime todos los mensajes informativos.
*/

--Para saber si hay transacciones abiertas
DBCC OpenTran
GO

--Abrir una transacci�n
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
Proporciona estad�sticas de uso de espacio de registro de transacciones para todas las bases de datos. 
En SQL Server, tambi�n se puede usar para restablecer las estad�sticas de espera y bloqueo.
Sintaxis:
DBCC SQLPERF
(
[ LOGSPACE ]
| [ �sys.dm_os_latch_stats� , CLEAR ]
| [ �sys.dm_os_wait_stats� , CLEAR ]
)
[WITH NO_INFOMSGS ]
Donde:
LOGSPACE
Devuelve el tama�o actual del registro de transacciones y el porcentaje de espacio de registro 
utilizado para cada base de datos. Use esta informaci�n para controlar la cantidad de espacio 
utilizado en un registro de transacciones.

�sys.dm_os_latch_stats�, Clear
Restablece las estad�sticas de pestillo.
Esta opci�n no est� disponible en la base de datos SQL.

�sys.dm_os_wait_stats�, Clear
Restablece las estad�sticas de espera.
Esta opci�n no est� disponible en la base de datos SQL.

with NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/
DBCC SQLPERF(LOGSPACE);
GO

/*DBCC OUTPUTBUFFER

Devuelve el b�fer de salida actual en formato hexadecimal y ASCII para el session_id especificado.
Sintaxis:
DBCC OUTPUTBUFFER ( Id_Sesion [ , Id_Requerimiento ])
[ WITH NO_INFOMSGS ]
Donde:
Id_Sesion
Es la ID de sesi�n asociada con cada conexi�n primaria activa.
Id_Requerimiento
Es la solicitud exacta (lote) para buscar dentro de la sesi�n actual.
*/
--La siguiente instrucci�n muestra el buffer de salida para la conexi�n activa
DBCC OUTPUTBUFFER(54)
GO

/*DBCC TRACESTATUS
Muestra el estado de las marcas de rastreo.
Sintaxis:
DBCC TRACESTATUS ( [ [ trace# [ ,�n ] ] [ , ] [ -1 ] ] )
[ WITH NO_INFOMSGS ]
Donde:
Trace#
Es el n�mero del indicador de seguimiento para el que se muestra el estado.
Si no se especifican traza # y -1, se muestran todos los indicadores de seguimiento que 
est�n habilitados para la sesi�n.
n
Es un marcador de posici�n que indica que se pueden especificar m�ltiples
marcas de seguimiento.
-1
Muestra el estado de las marcas de rastreo que est�n habilitadas globalmente.
Si se especifica -1 sin rastro #, se muestran todos los indicadores de seguimiento
globales que est�n habilitados.
With NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/

--El siguiente ejemplo muestra el estado de todos los indicadores de rastreo que est�n actualmente 
--habilitados globalmente.
DBCC TRACESTATUS(-1)
GO

--La instrucci�n siguiente muestra todas las marcas de rastreo en la sesi�n actual
DBCC TRACESTATUS()
GO

/*DBCC PROCCACHE

Muestra informaci�n en un formato de tabla sobre el cach� del procedimiento.
Sintaxis:
DBCC PROCCACHE [ WITH NO_INFOMSGS ]
Donde:
With NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/
--Muestra los procedimientos en cach�
DBCC PROCCACHE
GO

/*DBCC USEROPTIONS

Devuelve las opciones SET activadas para la conexi�n actual.
Sintaxis:
DBCC USEROPTIONS
[ WITH NO_INFOMSGS ]
Donde:
With NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
*/

--Mostrar las opciones de la conexi�n activa
DBCC USEROPTIONS
GO

/*DBCC SHOW_STATISTICS

DBCC SHOW_STATISTICS muestra las estad�sticas actuales de optimizaci�n de consulta para una tabla 
o vista indizada. El optimizador de consultas usa estad�sticas para estimar la cardinalidad o el 
n�mero de filas en el resultado de la consulta, lo que permite que el optimizador de consultas 
cree un plan de consulta de alta calidad. Por ejemplo, el optimizador de consultas podr�a usar 
estimaciones de cardinalidad para elegir el operador de b�squeda de �ndice en lugar del operador 
de exploraci�n de �ndice en el plan de consulta, lo que mejora el rendimiento de la consulta al evitar 
un an�lisis de �ndice con uso intensivo de recursos.

El optimizador de consultas almacena estad�sticas para una tabla o vista indexada en un objeto de 
estad�sticas. Para una tabla, el objeto de estad�sticas se crea en un �ndice o en una lista de 
columnas de tabla. El objeto de estad�sticas incluye un encabezado con metadatos sobre las estad�sticas,
un histograma con la distribuci�n de valores en la primera columna clave del objeto de estad�sticas y 
un vector de densidad para medir la correlaci�n entre columnas. El motor de base de datos puede 
calcular las estimaciones de cardinalidad con cualquiera de los datos en el objeto de estad�sticas.

DBCC SHOW_STATISTICS muestra el encabezado, el histograma y el vector de densidad en funci�n de 
los datos almacenados en el objeto de estad�sticas. La sintaxis le permite especificar una tabla o 
vista indizada junto con un nombre de �ndice de destino, nombre de estad�stica o nombre de columna. 
Este tema describe c�mo mostrar las estad�sticas y c�mo entender los resultados mostrados.

Sintaxis:
DBCC SHOW_STATISTICS ( Tabla_VistaIndizada , target )
[ WITH [ NO_INFOMSGS ] < option > [ , n ] ]
< option > :: =
STAT_HEADER | DENSITY_VECTOR | HISTOGRAM | STATS_STREAM
Donde:
Tabla_VistaIndizada (Ver Indices en Vistas)
Nombre de la tabla o vista indizada para la que se muestra informaci�n estad�stica.
nombre de la tabla
Nombre de la tabla que contiene las estad�sticas para mostrar.
La tabla no puede ser una tabla externa.
target
Nombre del �ndice, estad�sticas o columna para mostrar informaci�n de estad�sticas. el objetivo se 
incluye entre corchetes, comillas simples, comillas dobles o sin comillas. Si el objetivo es un nombre
de un �ndice o estad�sticas existente en una tabla o vista indizada, se devuelve la informaci�n de 
estad�sticas sobre este objetivo. Si el objetivo es el nombre de una columna existente y existen 
estad�sticas creadas autom�ticamente en esta columna, se devuelve informaci�n sobre esa estad�stica 
creada autom�ticamente. Si no existe una estad�stica creada autom�ticamente para un objetivo de 
columna, se devuelve el mensaje de error 2767.
En SQL Data Warehouse y Parallel Data Warehouse, el destino no puede ser un nombre de columna.
NO_INFOMSGS
Suprime todos los mensajes informativos que tienen niveles de gravedad de 0 a 10.
STAT_HEADER | DENSITY_VECTOR | HISTOGRAMA | STATS_STREAM [, n]
Especificar una o m�s de estas opciones limita los conjuntos de resultados devueltos por la 
declaraci�n a la opci�n u opciones especificadas. Si no se especifican opciones, se devuelve toda 
la informaci�n de estad�sticas.
STATS_STREAM se identifica solo con fines informativos. No soportado. No se garantiza compatibilidad 
futura.
*/
--Mostrar las estad�sticas de la tabla Customers en la base de datos de Northwind
USE Northwind
GO

DBCC SHOW_STATISTICS("dbo.Customers", PK_Customers)
GO

--Crear las estad�sticas para CompanyName en la tabla Customers
Create statistics CustomersEmpresa on Northwind.dbo.Customers(CompanyName)
go
--Ver las estad�sticas
DBCC SHOW_STATISTICS ("dbo.Customers", CompanyName)
GO