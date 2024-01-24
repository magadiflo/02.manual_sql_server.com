/*-- COMANDOS DBCC CATEGORÍA VARIOS --

FUENTE: https://manualsqlserver.com/

Los comando DBCC de esta categoría permiten realizar tareas varias como habilitar 
marcas de seguimiento o quitar una DLL de la memoria.

Los comandos DBCC de esta categoría son:

DBCC dllname (FREE)
DBCC HELP
DBCC FREESESSIONCACHE
DBCC TRACEOFF
DBCC FREESYSTEMCACHE
DBCC TRACEON
 
En las líneas siguientes se describe cada uno de ellos

DBCC dllname (FREE)

Descarga la DLL del procedimiento almacenado extendido especificado de la memoria.
Los procedimientos almacenados extendidos en SQL Server proporcionan una interfaz desde una instancia de SQL Server a programas externos para diversas actividades de mantenimiento.
Sintaxis
DBCC ( FREE ) [ WITH NO_INFOMSGS ]
Donde
NombreDDL: es el nombre de la librería a descargar.
WITH NO_INFOMSGS: Suprime los mensajes
Importante
Cuando se ejecuta un procedimiento almacenado extendido, el DLL permanece cargado por la instancia de SQL Server hasta que se apaga el servidor. Esta declaración permite que una DLL se descargue de la memoria sin apagar SQL Server.
Para mostrar los archivos DLL cargados actualmente por SQL Server,
ejecute sp_helpextendedproc
Permisos:
Miembro de sysadmin o de la función fija de base de datos db_owner.
*/

--Suponiendo que se tiene un procedimiento almacenado extendido llamado xp_resumenTotal para 
--liberar la DDL de la memoria.
DBCC xp_resumenTotal (Free)
go

/*DBCC HELP
Devuelve información de sintaxis para el comando DBCC especificado.
Sintaxis
DBCC HELP (‘InstruccionDBCC’)
[ WITH NO_INFOMSGS ]
*/
--Para saber la sintaxis de DBCC ShrinkFile
dbcc help ('ShrinkFile')
go

dbcc ShrinkFile
(
{ 'file_name' | file_id }
{
[ , EMPTYFILE]
| [ [, target_size ] [ , { NOTRUNCATE | TRUNCATEONLY } ] ]
}
)
[ WITH NO_INFOMSGS ]

--Ejecución de DBCC completada. Si hay mensajes de error, consulte al administrador del sistema.

/*DBCC FREESESSIONCACHE

Vacía la memoria caché de conexión de consulta distribuida utilizada por consultas distribuidas en una instancia de Microsoft SQL Server.
Sintaxis
DBCC FREESESSIONCACHE [ WITH NO_INFOMSGS ]
Donde
WITH NO_INFOMSGS: Suprime los mensajes
*/
--Liberar la memoria Caché
DBCC FREESESSIONCACHE
go

/*DBCC TRACEOFF

Desactiva los indicadores de seguimiento especificados.
Los indicadores de seguimiento se utilizan para personalizar ciertas características que controlan cómo funciona la instancia de SQL Server.
Sintaxis
DBCC TRACEOFF ( NºTrace [ ,…n ] [ , -1 ] ) [ WITH NO_INFOMSGS ]
Donde
NºTrace: Es el número del indicador de traza a deshabilitar.
-1 Desactiva las marcas de seguimiento especificadas globalmente.
WITH NO_INFOMSGS: Suprime los mensajes
Permisos
Debe ser miembro de sysadmin
*/
--Desactivar el trace 3205 global
DBCC TRACEOFF (3205)
GO

--Desactivar el trace 3205 global
DBCC TRACEOFF (3205, -1)
GO

--Desactivar los trace 3205 y 260 global
DBCC TRACEOFF (3205, 260, -1)
GO
--Importante: Use DBCC TraceOn para activar los seguimientos.
/*DBCC FREESYSTEMCACHE

Libera todas las entradas de caché no utilizadas de todos los cachés. 
El motor de base de datos de SQL Server limpia proactivamente las entradas de caché no utilizadas 
en segundo plano para que la memoria esté disponible para las entradas actuales. 
Sin embargo, puede usar este comando para eliminar manualmente las entradas no utilizadas de 
todos los cachés o de un caché de grupo de gobernadores de recursos específico.
Sintaxis
DBCC FREESYSTEMCACHE
( ‘ALL’ [, pool_name ] )
[WITH
{ [ MARK_IN_USE_FOR_REMOVAL ] , [ NO_INFOMSGS ] }
]
Donde
(‘ALL’ [, pool_name ])
ALL especifica todos los cachés soportados.
nombre_grupo especifica un caché de grupo del regulador de recursos.
Sólo se liberarán las entradas asociadas a este grupo.

MARK_IN_USE_FOR_REMOVAL
Libera de forma asíncrona las entradas utilizadas actualmente de sus cachés respectivos después de 
que no se utilicen. Las nuevas entradas creadas en el caché después de 
que DBCC FREESYSTEMCACHE WITH MARK_IN_USE_FOR_REMOVAL no se vean afectadas.

NO_INFOMSGS
Suprime todos los mensajes informativos.
Permisos:
Requiere el permiso: Alter server State
*/
DBCC FREESYSTEMCACHE ('ALL', default)
go

/*DBCC TRACEON

Activa los indicadores de seguimiento especificados.
Los indicadores de seguimiento se utilizan para personalizar ciertas características que controlan cómo funciona la instancia de SQL Server.
Sintaxis
DBCC TRACEOn ( NºTrace [ ,…n ] [ , -1 ] ) [ WITH NO_INFOMSGS ]
Donde
NºTrace: Es el número del indicador de traza a habilitar.
-1 activa las marcas de seguimiento especificadas globalmente.
WITH NO_INFOMSGS: Suprime los mensajes
Permisos
Debe ser miembro de sysadmin
*/
--Activar el trace 3205 global
DBCC TRACEOn (3205)
GO

--Activar el trace 3205 global
DBCC TRACEOn (3205, -1)
GO

--Activar los trace 3205 y 260 global
DBCC TRACEOn (3205, 260, -1)
GO