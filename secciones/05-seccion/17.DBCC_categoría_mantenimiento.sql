/*-- COMANDOS DBCC CATEGORÍA MANTENIMIENTO --
Los comandos DBCC de la categoría Mantenimiento permiten realizar tareas de mantenimiento 
en las bases de datos, los índices o los grupos de archivos.

Los comandos DBCC de mantenimiento son los siguientes:

DBCC CLEANTABLE
DBCC INDEXDEFRAG
DBCC DBREINDEX
DBCC SHRINKDATABASE
DBCC DROPCLEANBUFFERS
DBCC SHRINKFILE
DBCC FREEPROCCACHE
DBCC UPDATEUSAGE
 
En las líneas siguientes se explican los comandos DBCC de la categoría mantenimiento

DBCC CLEANTABLE
Recupera el espacio de las columnas de longitud variable eliminadas en tablas o vistas indizadas

Sintaxis
DBCC CLEANTABLE
( { BaseDatos }
, { NombreTabla | NombreVista }
[ , TamañoBatch ]
) [ WITH NO_INFOMSGS ]

Donde:
BaseDatos: es el nombre de la base de datos
NombreTabla: Nombre de la tabla
NombreVista: Nombre de la vista
TamañoBatch: Es el número de filas procesadas por transacción.
Si no se especifica, o si se especifica 0, la declaración procesa toda la tabla en una transacción.
WITH NO_INFOMSGS suprime los mensajes
Importante:
DBCC CLEANTABLE reclama espacio después de que se descarta una columna de longitud variable.
Una columna de longitud variable puede ser uno de los siguientes tipos de datos:
varchar, nvarchar, varchar (max), nvarchar (max), varbinary, varbinary (max), text, ntext,
image, sql_variant y xml.
Use DBCC CleanTable cuando ha realizado eliminación de varias columnas de longitud variable
de una tabla, no debe usar este comando el planes de mantenimiento.
*/
Use Northwind
go
--Recuperar el espacio de las columnas eliminadas de Customers
dbcc cleanTable (Northwind, Customers)
go
--Resultado
--Ejecución de DBCC completada. Si hay mensajes de error, consulte al administrador del sistema.

--Crear una tabla, insertar registros, eliminar un campo y luego recuperar el espacio.
Create table Prueba
(PruebaCodigo nchar(4), PruebaDescripcion nvarchar(100), PruebaElimina nvarchar(200))
go
Insert into Prueba values ('8525','Primer registro', 'Datos del primero a eliminar'),
('8152','Segundo registro', 'Desaparecerá en el DBCC CleanTable'),
('3652','Tercer registro', 'No se puede recuperar'),
('1598','Cuarto registro', 'Otro dato eliminado'),
('7521','Quinto registro', 'No se puede recuperar')
go

--Eliminar la columna PruebaElimina
Alter table Prueba drop column PruebaElimina
go
--Recuperar el espacio de la columna eliminada
dbcc CleanTable (Northwind, Prueba)
go

/*DBCC INDEXDEFRAG

Desfragmenta un indexado en una tabla o vista.
De preferencia use Alter index
Sintaxis
DBCC INDEXDEFRAG
( { BaseDatos }, { NombreTabla | NombreVista }
[ , { indice } [ , { particion | 0 } ] ]
) [ WITH NO_INFOMSGS ]
Donde:
BaseDatos: es el nombre de la base de datos
NombreTabla: Nombre de la tabla
NombreVista: Nombre de la vista
indice: Nombre del índice
particion: Nº de partición del índice
WITH NO_INFOMSGS suprime los mensajes
Importante
DBCC INDEXDEFRAG desfragmenta el nivel de hoja de un índice para que el orden físico de las páginas 
coincida con el orden lógico de izquierda a derecha de los nodos de hoja, lo que mejora el rendimiento 
del escaneo de índice.
*/
use Northwind
go
--Para visualizar los índices de la tabla Customers
sp_help customers
go
--Desfragmentar el índice CompanyName
DBCC IndexDefrag (Northwind, Customers, CompanyName)
go

/*Permisos
Propietario de la tabla o ser miembro de la función fija del servidor sysadmin, 
la función fija de la base de datos db_owner o la función fija de la base de datos db_ddladmin.*/

/*DBCC DBREINDEX

Reconstruye uno o más índices para una tabla en la base de datos especificada.
Sintaxis
DBCC DBREINDEX
(
NombreTabla [ , NombreIndice [ , factorRelleno ] ]
) [ WITH NO_INFOMSGS ]
Donde:
NombreTabla: Nombre de la tabla
NombreIndice: Nombre del índice a reconstruir
FactorRelleno: especifica el factor de relleno del índice (Ver Índices)
WITH NO_INFOMSGS suprime los mensajes

Importante
DBCC DBREINDEX reconstruye un índice para una tabla o todos los índices definidos para una tabla.
Al permitir que un índice se reconstruya dinámicamente, los índices que aplican las restricciones
PRIMARY KEY o UNIQUE se pueden reconstruir sin tener que eliminar y volver a crear esas restricciones.
Esto significa que un índice se puede reconstruir sin conocer la estructura de una tabla o
sus restricciones. Esto puede ocurrir después de una copia masiva de datos en la tabla.
DBCC DBReindex no se permiten en:
Tablas de sistemas
Indexados Spatial
Indexados ColumnStore con memoria optimizada

Ejemplo
Reconstruir el índice CompanyName en Customers, asignar un factor de relleno de 80
*/
use Northwind
go
DBCC DBReindex (Customers, CompanyName, 80)
go

/*DBCC SHRINKDATABASE

Reduce el tamaño de los archivos de datos y registro de transacciones en la base de datos especificada
Sintaxis
DBCC SHRINKDATABASE
( NombreBaseDatos [ , Porcentaje ]
[ , { NOTRUNCATE | TRUNCATEONLY } ]
) [ WITH NO_INFOMSGS ]
Donde:
NombreBaseDatos: es el nombre de la base de datos a reducir.
Porcentaje: Es el porcentaje de espacio libre que desea dejar en el archivo de base de datos después
de que la base de datos se haya reducido.
NoTruncate: Solo es aplicable a archivos de datos. El archivo de registro no se ve afectado.
TruncateOnly: Libera todo el espacio libre al final del archivo al sistema operativo, pero no realiza
ningún movimiento de página dentro del archivo.
El archivo de datos se reduce solo hasta la última extensión asignada. target_percent
se ignora si se especifica con TRUNCATEONLY.
Esta opción no es compatible con el Almacén de datos SQL de Azure.
TRUNCATEONLY afecta el archivo de registro. Para truncar solo el archivo de datos, use DBCC SHRINKFILE.
WITH NO_INFOMSGS suprime los mensajes
*/
--Reducir Northwind liberando 30% del espacio
dbcc ShrinkDataBase (Northwind, 30)
go

/*DBCC DROPCLEANBUFFERS

Elimina todos los búferes limpios del Pool de búferes y los objetos de ColumnStore del pool 
de ColumnStores.
Sintaxis
DBCC DROPCLEANBUFFERS [ WITH NO_INFOMSGS ]
Donde:
WITH NO_INFOMSGS suprime los mensajes
*/
DBCC DropCleanBuffers
go

/*DBCC SHRINKFILE

Reduce el tamaño del archivo de datos o archivo de registro (Ver archivos de base de datos) 
para la base de datos actual, o vacía un archivo moviendo los datos del archivo especificado a 
otros archivos en el mismo grupo de archivos (Ver Grupos de archivos), lo que permite eliminar 
el archivo de la base de datos.
Puede reducir un archivo a un tamaño que sea menor que el tamaño especificado cuando se creó.
Esto restablece el tamaño de archivo mínimo al nuevo valor.
Sintaxis
DBCC SHRINKFILE
(
{ NombreArchivo } { [ , EmptyFile ]
| [ [ , TamañoFinal ] [ , { NOTRUNCATE | TRUNCATEONLY } ] ]
} ) [ WITH NO_INFOMSGS ]
Donde
NombreArchivo: es el nombre lógico del archivo a reducir
TamañoFinal: Tamaño al que se reducirá el archivo.
EmptyFile: Migra todos los datos del archivo especificado a otros archivos en el mismo grupo de 
archivos. En otras palabras, EmptyFile migrará los datos del archivo especificado a otros archivos 
en el mismo grupo de archivos.
Emptyfile le asegura que no se agregarán nuevos datos al archivo, a pesar de que este archivo no se 
marque como solo de lectura.
El archivo se puede eliminar mediante la instrucción ALTER DATABASE.
Si el tamaño del archivo se modifica mediante la instrucción ALTER DATABASE, el indicador de solo 
lectura se restablece y se pueden agregar datos.
NOTRUNCATE:
Mueve las páginas asignadas desde el final de un archivo de datos a las páginas no asignadas al 
frente del archivo con o sin especificar target_percent. El espacio libre al final del archivo no 
se devuelve al sistema operativo, y el tamaño físico del archivo no cambia. Por lo tanto, cuando se 
especifica NOTRUNCATE, el archivo parece no encogerse.
NOTRUNCATE solo es aplicable a archivos de datos. Los archivos de registro no se ven afectados.
Esta opción no es compatible con los contenedores del grupo de archivos FILESTREAM.
TRUNCATEONLY:
Libera todo el espacio libre al final del archivo al sistema operativo, pero no realiza ningún 
movimiento de página dentro del archivo. El archivo de datos se reduce solo hasta la última 
extensión asignada. target_size se ignora si se especifica con TRUNCATEONLY.
La opción TRUNCATEONLY no mueve información en el registro, pero elimina VLFs inactivos del final 
del archivo de registro.
Esta opción no es compatible con los contenedores del grupo de archivos FILESTREAM.
WITH NO_INFOMSGS suprime los mensajes
*/
--Crear una base de datos, luego reducir el tamaño de un archivo.
xp_Create_subdir 'E:\Datos'
go
Create database Nueva
on Primary (name ='Nueva1', filename='E:\Datos\Nueva1.mdf', Size = 80MB)
log on (name ='NuevaLog1', filename='E:\Datos\NuevaLog1.ldf', Size = 40MB)
go
use Nueva
go
--Reducir el archivo a 30MB
DBCC ShrinkFile(Nueva1,30)
go
--Reducir el archivo de transacciones a 20
DBCC ShrinkFile(NuevaLog1,20)
go

/*DBCC FREEPROCCACHE

Elimina todos el contenido de la memoria caché del plan, elimina un plan específico de la memoria 
caché del plan especificando un identificador de plan o SQL, o elimina todas las entradas de la 
memoria caché asociadas con un grupo de recursos específico.
Sintaxis
DBCC FREEPROCCACHE [ ( { plan_handle | sql_handle | pool_name } ) ]
[ WITH NO_INFOMSGS ]
Donde:
plan_handle
Plan_handle identifica de forma única un plan de consulta para un lote que se ha ejecutado y cuyo 
plan reside en el caché del plan. plan_handle es varbinary (64) y se puede obtener a partir de los 
siguientes objetos de administración dinámica:
sys.dm_exec_cached_plans
sys.dm_exec_requests
sys.dm_exec_query_memory_grants
sys.dm_exec_query_stats

sql_handle
sql_handle es el manejador de SQL del lote a borrar. sql_handle es varbinary (64) y se puede
obtener a partir de los siguientes objetos de administración dinámica:
sys.dm_exec_query_stats
sys.dm_exec_requests
sys.dm_exec_cursors
sys.dm_exec_xml_handles
sys.dm_exec_query_memory_grants

pool_name
Pool_Name es el nombre de un grupo de recursos del regulador de recursos.
pool_name es sysname y se puede obtener consultando la vista de administración
dinámica sys.dm_resource_governor_resource_pools.

WITH NO_INFOMSGS suprime los mensajes
*/
use Northwind
go

Select * from Orders where Year(OrderDate )= 1997
go

--Ver el plan en el cache
Select plan_handle, T.text
FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS T
WHERE text LIKE N'Select * from Orders where Year(OrderDate )= 1997'
go

--Borrar todo el caché
DBCC FreeProcCache
go

/*DBCC UPDATEUSAGE

Informa y corrige las inexactitudes de recuento de páginas y filas en las vistas de catálogo.
Estas inexactitudes pueden provocar informes de uso de espacio incorrectos devueltos por el 
procedimiento almacenado del sistema sp_space.
Sintaxis
DBCC UPDATEUSAGE
( { NombreBaseDatos } [ , { NombreTabla | NombreVista } [ , { NombreIndice } ] ]
) [ WITH [ NO_INFOMSGS ] [ , ] [ COUNT_ROWS ] ]
Donde
NombreBaseDatos: es el nombre de la base de datos para la cual se reportan y corrigen las 
estadísticas de uso del espacio
NombreTabla: Nombre de la tabla para la cual se reportan y corrigen las estadísticas de uso del 
espacio
NombreVista: Nombre de la vista para la cual se reportan y corrigen las estadísticas de uso del 
espacio
NombreIndice: Nombre del índice para el cual se reportan y corrigen las estadísticas de uso del 
espacio
WITH NO_INFOMSGS suprime los mensajes
Count_Rows: Especifica que la columna de recuento de filas se actualiza con el recuento actual 
del número de filas en la tabla o vista.
*/
--Usando Northwind
Use Northwind
go
--Corregir las estadísticas del uso de espacio de la base de datos
DBCC UpdateUsage (Northwind)
go
--Corregir las estadísticas del uso de espacio de la tabla Customers
DBCC UpdateUsage (Northwind, Customers)
go