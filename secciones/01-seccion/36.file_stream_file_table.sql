/*-- USANDO FILESTREAM Y FILETABLE EN SQL SERVER --*/

/*TABLAS DE ARCHIVOS EN SQL SERVER

La caracter�stica FileTable brinda compatibilidad con el espacio de nombres de 
archivos de Windows y la compatibilidad con las aplicaciones de Windows con los 
datos de archivos almacenados en SQL Server.

FileTable permite que una aplicaci�n integre sus componentes de almacenamiento y 
administraci�n de datos, y proporciona servicios integrados de SQL Server, que 
incluyen b�squeda de texto completo y b�squeda sem�ntica, sobre datos no estructurados 
y metadatos. En otras palabras, puede almacenar archivos y documentos en tablas 
especiales en SQL Server llamadas FileTables, pero acceda a ellos desde las 
aplicaciones de Windows como si estuvieran almacenados en el sistema de archivos, 
sin realizar ning�n cambio en las aplicaciones de sus clientes. La caracter�stica 
FileTable se basa en la tecnolog�a FILESTREAM de SQL Server.

FILESTREAM EN SQL SERVER

Caracter�sticas de FileStream de SQL Server
- FILESTREAM permite que las aplicaciones basadas en SQL Server almacenen datos no 
  estructurados, como documentos e im�genes, en el sistema de archivos.
- Las aplicaciones pueden aprovechar las valiosas API de transmisi�n y el rendimiento 
  del sistema de archivos y, al mismo tiempo, mantener la coherencia transaccional 
  entre los datos no estructurados y los datos estructurados correspondientes.
- FILESTREAM integra el Motor de base de datos del servidor SQL con un sistema de 
  archivos NTFS o ReFS al almacenar datos de objetos binarios grandes (BLOB) 
  varbinary (max) como archivos en el sistema de archivos.
- Las instrucciones de Transact-SQL pueden insertar, actualizar, consultar, buscar y 
  hacer una copia de seguridad de los datos de FILESTREAM.
- Las interfaces del sistema de archivos Win32 proporcionan acceso continuo a los datos
- FILESTREAM utiliza la memoria cach� del sistema NT para almacenar datos de archivos 
  en cach�, esto ayuda a reducir cualquier efecto que los datos de FILESTREAM puedan 
  tener en el rendimiento del motor de base de datos. El grupo de b�feres de SQL Server 
  no se usa; por lo tanto, esta memoria est� disponible para el procesamiento de 
  consultas.
- FILESTREAM no se habilita autom�ticamente cuando instala o actualiza SQL Server. 
  Debe habilitar FILESTREAM utilizando el Administrador de configuraci�n de SQL Server y 
  SQL Server Management Studio. Para usar FILESTREAM, debe crear o modificar una base de 
  datos para contener un tipo especial de grupos de archivos. A continuaci�n, cree o 
  modifique una tabla para que contenga una columna varbinary (max) con el atributo FILESTREAM. 
  Despu�s de completar estas tareas, puede usar Transact-SQL y Win32 para administrar los 
  datos de FILESTREAM.

PASOS PARA CONFIGURAR Y UTILIZAR FILESTREAM

1. Habilitar los servicios de filestream
En este paso debemos abrir el administrador de configuraciones de SQLServer. En el 
servicio de motor de base de datos, pulsar doble click, se abre la ventana de propiedades. 
--------------------------------------------------
NOTA: Si nos sale una ventana de error al entrar al SQL Server 2017 Configuration Manager
"Cannot connect to WMI provider. You do not have permission or the server unreachable. Note
that you can only manage SQL Server 2005 and later servers with SQL Server configuration
manager. Clase no v�lida [0x80041010]"

Soluci�n: 
- Ir a la ruta de instalaci�n de SQL Server, la que se ubica en (x86)
  Ser�a: 
	C:\Program Files (x86)\Microsoft SQL Server\140\Shared
- Verificar que en ese directorio hay un archivo llamado
	sqlmgmproviderxpsp2up.mof
- Abrir un CMD en modo ADMINISTRADOR en esa ruta y ejecutar el siguiente comando:
	> mofcomp sqlmgmproviderxpsp2up.mof
- La ruta y comando en el CMD modo ADMINISTRADOR ser�a as�: 
  C:\Program Files (x86)\Microsoft SQL Server\140\Shared>mofcomp sqlmgmproviderxpsp2up.mof
- Finalmente saldr�a un mensaje de confirmaci�n:
	Microsoft (R) MOF Compiler Version 10.0.18362.1550
	Copyright (c) Microsoft Corp. 1997-2006. Todos los derechos reservados.
	Analizando el archivo MOF: sqlmgmproviderxpsp2up.mof
	El archivo MOF se analiz� correctamente
	Almacenando informaci�n en el repositorio...
	Hecho
--------------------------------------------------

En la ventana de propiedades seleccionar la pesta�a FILESTREAM

Activar las casillas de verificaci�n
Habilitar FILESTREAM para el acceso de Transact-SQL
Habilitar FILESTREAM para el acceso de E/S de archivo
Escribir el nombre del recurso compartido de Windos, que por defecto es el nombre de la instancia.
Permitir que los clientes remotos tengan acceso a los datos de FILESTREAM.

2. Configurar el servidor para FileStream
En la ventana del explorador de objetos de Microsoft SQL Server Management Studio, 
pulsar bot�n derecho en la instancia a configurar e ir a propiedades, en la opci�n Avanzados, 
configurar el FILESTREAM para el acceso total.

Tambi�n se puede ejecutar el siguiente procedimiento
EXEC sys.sp_configure N'filestream access level', N'2'
GO
RECONFIGURE WITH OVERRIDE
GO

3. Configurar la base de datos para FileStream
Abrir la ventana de propiedades de la base de datos, luego en la p�gina Opciones configurar 
el nivel de acceso a Full, es decir: 
	FILESTREAM Non-Transacted Access = FULL
Las otras opciones son: Off y ReadOnly. Adem�s agregarle en 
FILESTREAM Directory Name = ArchivosStream

Tambi�n se puede configurar utilizando el siguiente c�digo.
USE [master]
GO
ALTER DATABASE [Northwind]
SET FILESTREAM( NON_TRANSACTED_ACCESS = FULL )
WITH NO_WAIT
GO

4. Agregar un grupo de archivos para FileStream
En la base de datos se necesita un grupo de archivos que tenga la opci�n de FileStream habilitada, 
usando la base de datos Northwind, insertar un grupo y luego un archivo al grupo.
*/

USE [master]
GO

ALTER DATABASE [Northwind]
ADD FILEGROUP [GrupoTablasArchivos] CONTAINS FILESTREAM
GO

/*Agregar un archivo al grupo de archivos GrupoTablasArchvios, el archivo se crear�
en la carpeta ArchivosStream en la unidad C:
*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\ArchivosStream'
GO

ALTER DATABASE Northwind
ADD FILE(NAME='ArchivosStreamData', FILENAME='C:\BD_SQL_SERVER\ArchivosStream\ArchivosStreamData.ndf')
TO FILEGROUP [GrupoTablasArchivos]
GO

/*En la carpeta donde se cre� el archvio aparece un archivo con el nombre FileStream.hdr
que contiene los metadatos que relacionan los registros insertados
*/

/*
5. Especificar el directorio de FileStream
Este directorio permitir� compartir los archivos.
*/
ALTER DATABASE [Northwind] 
SET FILESTREAM (DIRECTORY_NAME=N'ArchivosStream') 
WITH NO_WAIT
GO

/*
6. Comprobar si la base de datos Northwind permite y tiene activada la opci�n FileStream
Para visualizar las bases de datos que soportan FileStream y el directorio.
*/
SELECT DB_NAME(database_id) AS 'Base de datos', DIRECTORY_NAME AS 'Carpeta FileStream'
FROM SYS.DATABASE_FILESTREAM_OPTIONS
GO

/*-- CREANDO UNA TABLA CON FILESTREAM --*/
/*
Para poder utilizar una tabla y utilizar las opciones que provee FileStream de debe crear 
una con un identificador UniqueIdentifier y el campo con la propiedad FileStream debe ser de 
tipo varbinary(max)
*/
USE Northwind
GO

CREATE TABLE dbo.tablaFileStream(
	codigo UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
	descripcion NVARCHAR(100),
	foto VARBINARY(MAX) FILESTREAM NULL
) ON [PRIMARY]
GO

/*INSERTAR REGISTROS EN UNA TABLA FILESTREAM
Al insertar registros se especifican las im�genes o documentos usando OpenRowSet 
*/
USE Northwind
GO

INSERT INTO tablaFileStream(codigo, descripcion, foto)
SELECT NEWID(), 'Foto de Goku ultrainstinto', *
FROM OPENROWSET(BULK 'C:\BD_SQL_SERVER\goku.jpg', SINGLE_BLOB) AS foto
GO

--Ver los registros
SELECT * FROM tablaFileStream
GO


/*RESTRICCIONES EN EL USO DE FILESTREAM
- No se puede usar Database Mirroring en las bases de datos configuradas para soporte FILESTREAM
- Las tablas temporales (en memoria) no pueden tener columnas con FILESTREAM habilitado.
- FILESTREAM s�lo permite almacenar datos en vol�menes de disco locales.
- Las columnas computadas que hacen referencia a columnas FILESTREAM no se pueden indexar.
- Las columnas FILESTREAM no soportan Transparent Data Encription (TDE)
- FILESTREAM no se puede habilitar en SQL Server de 32 bits que se ejecutan sobre sistemas 
  operativos Windows de 64 bits.
- No se permite la creaci�n de estad�sticas en columnas con FILESTREAM habilitado.
- El �nico nivel de aislaci�n (Isolation Level) soportado es el modo READ COMMITED cuando los 
  datos de FILESTREAM son accedidos a trav�s de la API Win32

CREAR TABLA TIPO FILETABLE
Las tablas tipo FileTable permiten el manejo de archivos compartidos. Estos archivos 
se guardan en el recurso compartido de la instancia donde se especific� el uso de FileStream.
*/

USE Northwind
GO

CREATE TABLE Northwind.dbo.misDocumentos AS FileTable
WITH(FILETABLE_DIRECTORY = 'ArchivosStream', FILETABLE_COLLATE_FILENAME = DATABASE_DEFAULT)
GO

/*
Se puede agregar archivos desde el Explorador de Windows en el recurso compartido de la 
instancia de SQL Server
*/

--Agregar carpetas al FileTable
INSERT INTO MisDocumentos(name, is_directory)
VALUES('Fotografias', 1)
GO

--Ver los datos del filetable
SELECT * FROM dbo.misDocumentos
GO