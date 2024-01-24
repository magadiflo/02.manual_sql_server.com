/*-- COMANDOS DBCC CATEGORÍA VALIDACIÓN --

Los comandos DBCC de la categoría de validación realizan operaciones de validación en una 
base de datos, en tablas, índices, en catálogos, grupo de archivos o asignación de páginas 
de base de datos.

Los comandos de validación son los siguientes:

DBCC CHECKALLOC
DBCC CHECKFILEGROUP
DBCC CHECKCATALOG
DBCC CHECKIDENT
DBCC CHECKCONSTRAINTS
DBCC CHECKTABLE
DBCC CHECKDB
 
En las líneas siguientes se explican los comandos DBCC de la categoría Validación

DBCC CHECKALLOC

Este comando permite comprobar la coherencia de las estructuras de asignación de espacio en disco 
de una base de datos determinada.
Sintaxis:
DBCC CHECKALLOC
[
( NombreBaseDatos | Id_BaseDatos | 0
[ , NOINDEX
| , { REPAIR_ALLOW_DATA_LOSS | REPAIR_FAST | REPAIR_REBUILD } ]
)
[ WITH
{
[ ALL_ERRORMSGS ]
[ , NO_INFOMSGS ]
[ , TABLOCK ]
[ , ESTIMATEONLY ]
}
]
]
Donde:
NombreBaseDatos | Id_BaseDatos | 0
Es el nombre o el Id. de la base de datos cuya asignación y uso de espacio se va a comprobar.
Si no se especifica o se especifica 0, se utiliza la base de datos actual.
NOINDEX
Especifica que no se deben comprobar los índices no clúster de las tablas de usuario.
REPAIR_ALLOW_DATA_LOSS | REPAIR_FAST | REPAIR_REBUILD
Especifica que DBCC CHECKALLOC repare los errores que encuentre. database_name debe estar en modo de 
usuario único.
REPAIR_ALLOW_DATA_LOSS
Intenta reparar los errores encontrados. Estas reparaciones pueden ocasionar alguna pérdida de datos. 
REPAIR_ALLOW_DATA_LOSS es la única opción que permite la reparación de los errores de asignación.
REPAIR_FAST
La sintaxis solo se mantiene por razones de compatibilidad con versiones anteriores. No se realizan 
acciones de reparación.
REPAIR_REBUILD
No aplicable
ALL_ERRORMSGS
Muestra todos los mensajes de error. De forma predeterminada, se muestran todos los mensajes de error. 
Especificar u omitir esta opción no tiene ningún efecto.
NO_INFOMSGS
Suprime todos los mensajes informativos y el informe del espacio utilizado.
TABLOCK
Hace que el comando DBCC obtenga un bloqueo de base de datos exclusivo.
ESTIMATE ONLY
Muestra la cantidad calculada de espacio de tempdb que se necesita para ejecutar DBCC CHECKALLOC 
cuando todas las otras opciones están especificadas.
*/
USE Northwind
GO

DBCC CheckAlloc(Northwind)
GO

/*DBCC CHECKFILEGROUP

Este comando permite comprobar la asignación y la integridad estructural de todas las tablas y vistas 
indizadas del grupo de archivos especificado de la base de datos actual
Sintaxis:
DBCC CHECKFILEGROUP
[
[ ( { NombreGrupoArchivos | IDGrupoArchivos | 0 }
[ , NOINDEX ]
) ]
[ WITH
{
[ ALL_ERRORMSGS | NO_INFOMSGS ]
[ , TABLOCK ]
[ , ESTIMATEONLY ]
[ , PHYSICAL_ONLY ]
}
]
]
Donde:
NombreGrupoArchivos
Es el nombre del grupo de archivos de la base de datos actual para el que se debe comprobar
la asignación de tablas y la integridad estructural.
Si no se especifica o se especifica 0, el valor predeterminado es el grupo de archivos principal. 
Los nombres de los grupos de archivos deben cumplir las mismas reglas que los identificadores.
IDGrupoArchivos
Es el número de identificación (identificador) del grupo de archivos de la base de datos actual para 
el que se debe comprobar la asignación de tablas y la integridad estructural.
NOINDEX
Especifica que no se deben realizar comprobaciones intensivas de índices no clúster para las tablas 
de usuario. Esto reduce el tiempo total de ejecución. La opción NOINDEX no afecta a las tablas del 
sistema, ya que DBCC CHECKFILEGROUP siempre comprueba todos los índices de las tablas del sistema.
ALL_ERRORMSGS
Muestra un número ilimitado de errores por objeto. De forma predeterminada, se muestran todos los 
mensajes de error. Especificar u omitir esta opción no tiene ningún efecto.
NO_INFOMSGS
Suprime todos los mensajes informativos.
TABLOCK
Hace que DBCC CHECKFILEGROUP obtenga bloqueos en lugar de utilizar una instantánea de base de datos 
interna.
ESTIMATE ONLY
Muestra la cantidad estimada de espacio necesario en la base de datos tempdb para ejecutar 
DBCC CHECKFILEGROUP con todas las demás opciones especificadas.
PHYSICAL_ONLY
Limita la comprobación de la integridad a la estructura física de la página, los encabezados
de registro y la estructura física de árboles b. Se ha diseñado para proporcionar una pequeña 
comprobación de la sobrecarga de la coherencia física del grupo de archivos; esta comprobación 
también puede detectar páginas rasgadas y errores de hardware comunes que pueden comprometer los datos. Una ejecución completa de DBCC CHECKFILEGROUP puede tardar mucho más tiempo que en versiones anteriores.
*/
use Northwind
go
--Para comprobar la asignación de los elementos del grupo Primary
DBCC CheckFilegroup ([Primary])
go

/*DBCC CHECKCATALOG

Este comando permite comprobar la coherencia del catálogo en la base de datos especificada. 
La base de datos debe en línea.
Sintaxis:
DBCC CHECKCATALOG
[
(
NombreBaseDatos | Id_BaseDatos | 0
)
]
[ WITH NO_INFOMSGS ]
Donde:
NombreBaseDatos | Id_BaseDatos | 0
Es el nombre o Id. de la base de datos en la que se va a comprobar la coherencia
del catálogo. Si no se especifica o se especifica 0, se utiliza la base de datos actual.
WITH NO_INFOMSGS
Suprime todos los mensajes de información.
*/
--Para comprobar el catalogo de la base de datos Northwind
DBCC CheckCatalog (Northwind)
go

/*DBCC CHECKIDENT

Este comando permite comprobar el valor de identidad actual de la tabla especificada en SQL Server y, si fuera necesario, lo cambia.
También puede utilizar DBCC CHECKIDENT para establecer manualmente un nuevo valor de identidad actual para la columna de identidad. (Ver Uso de Identity)
Sintaxis:
DBCC CHECKIDENT
(
NombreTabla
[, { NORESEED | { RESEED [, new_reseed_value ] } } ]
)
[ WITH NO_INFOMSGS ]
Donde:
NombreTabla
Es el nombre de la tabla para la que se va a comprobar el valor de identidad actual. La tabla especificada debe contener una columna de identidad. Los nombres de tabla deben cumplir las reglas de los identificadores.
NORESEED
Especifica que el valor de identidad actual no se debe cambiar.
RESEED
Especifica que el valor de identidad actual se debería cambiar.
new_reseed_value
Es el nuevo valor que se va a usar como valor de identidad actual de la columna de identidad.
WITH NO_INFOMSGS
Suprime todos los mensajes de información.
*/
--Para comprobar el valor de Identity en la tabla Categories
DBCC CheckIdent (Categories)
go

--Si se desea cambiar el valor de Indetity a 4 en la tabla Personas
dbcc checkident (Personas, Reseed, 4)
go

--Si se borran todos los registros
delete Personas
dbcc checkident (Personas, Reseed, 0)
go

/*DBCC CHECKCONSTRAINTS

Este comando permite comprobar la integridad de una restricción especificada o de todas las 
restricciones de una tabla determinada en la base de datos actual.
Sintaxis:
DBCC CHECKCONSTRAINTS
[
(
NombreTabla | IdTabla | NombreContraint | IdContraint
)
]
[ WITH
[ { ALL_CONSTRAINTS | ALL_ERRORMSGS } ]
[ , ] [ NO_INFOMSGS ]
]
Donde:
ombreTabla | IdTabla | NombreContraint | IdContraint
Es la tabla o la restricción que se va a comprobar.
Si no se especifica table_name o table_id, se comprueban todas las restricciones habilitadas en la 
tabla. Si se especifica constraint_name o constraint_id, solo se comprueba esa restricción. 
Si no se especifica un identificador de tabla ni un identificador de restricción, se comprueban 
todas las restricciones habilitadas en todas las tablas de la base de datos actual.
WITH
Habilita opciones que se van a especificar
ALL_CONSTRAINTS
Comprueba todas las restricciones habilitadas y deshabilitadas de la tabla, si se especifica el 
nombre de tabla o si se comprueban todas las tablas; de lo contrario, comprueba solo la restricción 
habilitada. ALL_CONSTRAINTS no tiene ningún efecto cuando se especifica un nombre de restricción.
ALL_ERRORMSGS
Devuelve todas las filas que infringen las restricciones de la tabla comprobada. 
El valor predeterminado es las 200 primeras filas.
NO_INFOMSGS
Suprime todos los mensajes de información.
*/
--Para comprobar las restricciones de la tabla Employees
DBCC CheckConstraints (Employees)
go

/*DBCC CHECKTABLE

Este comando permite comprobar la integridad de todas las páginas y estructuras que constituyen la 
tabla o la vista indizada.
Sintaxis:
DBCC CHECKTABLE
(
NombreTabla | NombreVista
[ , { NOINDEX | index_id }
|, { REPAIR_ALLOW_DATA_LOSS | REPAIR_FAST | REPAIR_REBUILD }
]
)
[ WITH
{ ALL_ERRORMSGS ]
[ , EXTENDED_LOGICAL_CHECKS ]
[ , NO_INFOMSGS ]
[ , TABLOCK ]
[ , ESTIMATEONLY ]
[ , { PHYSICAL_ONLY | DATA_PURITY } ]
}
]
Donde:
NombreTabla | NombreVista
Es la tabla o la vista indizada para la que se ejecutan las comprobaciones de integridad. 
Los nombres de tablas y vistas se deben ajustar a las reglas de los identificadores.
NOINDEX
Especifica que no deben realizarse comprobaciones intensivas de índices no clúster en tablas de usuario.
Esto reduce la duración global de la ejecución. NOINDEX no afecta a las tablas del sistema porque 
las comprobaciones de integridad siempre se ejecutan en todos los índices de las tablas del sistema.
index_id
Es el número de identificación (Id.) del índice para el que se van a ejecutar las comprobaciones 
de integridad. Si se especifica index_id, DBCC CHECKTABLE ejecuta las comprobaciones de integridad 
solo en ese índice, junto con el índice clúster o el montón.
REPAIR_ALLOW_DATA_LOSS | REPAIR_FAST | REPAIR_REBUILD
Especifica que DBCC CHECKTABLE repare los errores que encuentre. Para utilizar una opción de reparación,
la base de datos debe estar en modo de usuario único.
REPAIR_ALLOW_DATA_LOSS
Intenta reparar todos los errores indicados. Estas reparaciones pueden ocasionar alguna pérdida 
de datos.
REPAIR_FAST
La sintaxis solo se mantiene por razones de compatibilidad con versiones anteriores. No se realizan 
acciones de reparación.
REPAIR_REBUILD
Realiza reparaciones que no tienen ninguna posibilidad de pérdida de datos. Pueden ser reparaciones 
rápidas, como la reparación de las filas que faltan en índices no clúster, y reparaciones que consumen 
más tiempo, como regenerar un índice.
REPAIR_REBUILD no repara errores que implican datos de FILESTREAM.
ALL_ERRORMSGS
Muestra un número ilimitado de errores. De forma predeterminada, se muestran todos los mensajes de 
error. Especificar u omitir esta opción no tiene ningún efecto.
EXTENDED_LOGICAL_CHECKS
Si el nivel de compatibilidad es 100 (SQL Server 2008) o superior, realiza comprobaciones de 
coherencia lógica en una vista indizada, en índices XML y en índices espaciales, en caso de que 
los haya.
NO_INFOMSGS
Suprime todos los mensajes informativos.
TABLOCK
Hace que DBCC CHECKTABLE reciba un bloqueo de tabla compartido en vez de utilizar
una instantánea de base de datos interna. TABLOCK hará que DBCC CHECKTABLE
se ejecute más rápido en una tabla con mucha carga, pero disminuirá la simultaneidad
disponible sobre la tabla mientras DBCC CHECKTABLE está ejecutándose.
ESTIMATEONLY
Muestra la cantidad de espacio calculado de la base de datos tempdb necesario
para ejecutar DBCC CHECKTABLE con todas las otras opciones especificadas.
PHYSICAL_ONLY
Limita la comprobación de la integridad a la estructura física de la página, los encabezados de 
registro y la estructura física de árboles b. Se ha diseñado para proporcionar una pequeña 
comprobación de sobrecarga de la coherencia física de la tabla; esta comprobación también puede 
detectar páginas rasgadas y errores de hardware comunes que pueden comprometer los datos. 
Una ejecución completa de DBCC CHECKTABLE puede tardar mucho más tiempo que en versiones anteriores.
*/

--Para comprobar la tabla Customers
DBCC CheckTable (Customers)
go

/*DBCC CHECKDB

Este comando permite comprobar la integridad física y lógica de todos los objetos de la base de 
datos especificada mediante la realización de las siguientes operaciones
Ejecuta DBCC CHECKALLOC en la base de datos.
Ejecuta DBCC CHECKTABLE en todas las tablas y vistas de la base de datos.
Ejecuta DBCC CHECKCATALOG en la base de datos.
Valida el contenido de cada vista indizada de la base de datos.
Valida la coherencia de nivel de vínculo entre los metadatos de la tabla y los directorios y archivos 
del sistema de archivos cuando almacena datos varbinary(max) en el sistema de archivos 
mediante FILESTREAM.
Valida los datos de Service Broker en la base de datos.
Sintaxis:
DBCC CHECKDB
[
[ ( NombreBaseDatos | IdBaseDatos | 0
[ , NOINDEX
| , { REPAIR_ALLOW_DATA_LOSS | REPAIR_FAST | REPAIR_REBUILD } ]
) ]
[ WITH
{
[ ALL_ERRORMSGS ]
[ , EXTENDED_LOGICAL_CHECKS ]
[ , NO_INFOMSGS ]
[ , TABLOCK ]
[ , ESTIMATEONLY ]
[ , { PHYSICAL_ONLY | DATA_PURITY } ]
}
]
]
Donde:
NombreBaseDatos | IdBaseDatos | 0
Es el nombre o Id. de la base de datos para la que se van a ejecutar comprobaciones de integridad. 
Si no se especifica o se especifica 0, se utiliza la base de datos actual.
NOINDEX
Especifica que no se deben realizar comprobaciones intensivas de índices no clúster para las tablas 
de usuario. Esto reduce el tiempo total de ejecución. NOINDEX no afecta a las tablas del sistema, 

REPAIR_ALLOW_DATA_LOSS | REPAIR_FAST | REPAIR_REBUILD
Especifica que DBCC CHECKDB repare los errores que encuentre.
La base de datos especificada debe estar en modo de usuario único para utilizar una de las siguientes 
opciones de reparación.
REPAIR_ALLOW_DATA_LOSS
Intenta reparar todos los errores indicados. Estas reparaciones pueden ocasionar alguna pérdida de 
datos.
REPAIR_FAST
La sintaxis se mantiene únicamente por compatibilidad con versiones anteriores. No se realizan 
acciones de reparación.
REPAIR_REBUILD
Realiza reparaciones que no tienen ninguna posibilidad de pérdida de datos. Pueden ser reparaciones 
rápidas, como la reparación de las filas que faltan en índices no clúster, y reparaciones que consumen 
más tiempo, como regenerar un índice.
REPAIR_REBUILD no repara errores que implican datos de FILESTREAM.
ALL_ERRORMSGS
Muestra todos los errores notificados por objeto. De forma predeterminada,
se muestran todos los mensajes de error. Especificar u omitir esta opción no tiene ningún efecto.
Los mensajes de error se ordenan por identificador de objeto, salvo en el caso de los mensajes 
generados desde la base de datos tempdb.
En SQL Server Management Studio, el número máximo de mensajes de error devueltos es 1000.
Cuando se especifica ALL_ERRORMSGS, se recomienda ejecutar el comando DBCC con la utilidad sqlcmd o 
programando un trabajo del Agente SQL Server para ejecutar el comando y dirigir el resultado a un 
archivo. Cualquiera de estos métodos garantizará que el comando se ejecute una vez e informará de 
todos los mensajes de error.
EXTENDED_LOGICAL_CHECKS
Si el nivel de compatibilidad es 100 (SQL Server 2008) o superior, realiza comprobaciones de 
coherencia lógica en una vista indizada, en índices XML y en índices espaciales, en caso de que 
los haya. (Ver Nivel de compatibilidad)
NO_INFOMSGS
Suprime todos los mensajes de información.
TABLOCK
Hace que DBCC CHECKDB obtenga bloqueos en lugar de utilizar una instantánea de base de datos interna.
Se incluye un bloqueo exclusivo (X) a corto plazo en la base de datos.
TABLOCK hace que DBCC CHECKDB se ejecute más rápido en una base de datos con mucha carga, pero 
disminuye la simultaneidad disponible en la base de datos mientras DBCC CHECKDB está en ejecución.
TABLOCK limita las comprobaciones que se llevan a cabo; DBCC CHECKCATALOG no se ejecuta en la
base de datos y los datos de Service Broker no se validan.
ESTIMATEONLY
Muestra la cantidad de espacio para la base de datos tempdb que se estima necesario para
ejecutar DBCC CHECKDB con todas las demás opciones especificadas.
No se realiza la comprobación real de la base de datos.
PHYSICAL_ONLY
Limita la comprobación a la integridad de la estructura física de los encabezados de página y 
registro y la coherencia de la asignación de la base de datos. Esta comprobación se ha diseñado para
proporcionar una pequeña comprobación de sobrecarga de la coherencia física de la base de datos; 
también detecta páginas rasgadas, errores de suma de comprobación y errores de hardware comunes que 
pueden comprometer los datos del usuario.
*/
--Para comprobar la base de datos
DBCC CheckDB (Northwind)
go