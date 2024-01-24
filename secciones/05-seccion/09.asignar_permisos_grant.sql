/*-- ASIGNAR PERMISOS EN SQL SERVER - GRANT --

El trabajo de la asignación de permisos sobre los asegurables a las entidades de seguridad debe 
ser hecho de manera muy responsable, se debe planear con mucho cuidado que entidades de seguridad 
pertenecerán a los diferentes roles de servidor y roles de base de datos.

Conceptos importantes
Sobre los objetos de base de datos se pueden administrar los permisos de forma explícita para 
que los usuarios accedan a ellos. Para conectarse a SQL Server se usan los inicios de sesión 
(Ver Logins) y para la asignación de permisos sobre los asegurables de la base de datos se usan 
los usuarios de base de datos. (Ver Usuarios de base de datos)

Cada asegurable tiene permisos que se pueden otorgar a una entidad de seguridad mediante la 
instrucción de permiso Grant.

Principio de los privilegios mínimos
Existe el enfoque basado en cuenta de usuario de privilegios mínimos (LUA) para el desarrollar de 
aplicaciones lo que constituye una parte importante de una estrategia de defensa contra las amenazas 
a la seguridad.

El enfoque LUA garantiza que los usuarios de base de datos siguen el principio de los privilegios 
mínimos e inician sesión con cuentas de usuario limitadas ya sea en base a roles o de manera individual
(por usuario).

Se pueden utilizar roles fijos del servidor o roles flexibles de servidor (desde SQL Server 2012).

Considere el uso del rol fijo del servidor sysadmin muy restringido.

Cuando conceda permisos a usuarios de base de datos, siga siempre el principio de los privilegios 
mínimos.

Otorgue a usuarios y roles los mínimos permisos necesarios para que puedan realizar una tarea concreta.


Permisos basados en roles
Administrar los permisos usando roles en lugar de a usuarios hace mas sencilla la administración de 
la seguridad en SQL Server.

Los permisos asignados a roles se heredan por todos los miembros del rol.

Es más sencillo agregar o quitar usuarios de base de datos de un rol que volver a crear conjuntos 
de permisos distintos para cada usuario.

Se pueden anidar los roles, tenga cuidado con crear mucho niveles de anidamiento puede reducir el 
rendimiento.

Se pueden usar los roles fijos tanto de servidor como de base de datos para simplificar los permisos
de asignación.

Es una buena práctica asignar los permisos a nivel de esquema. Los usuarios heredan automáticamente 
los permisos en todos los objetos nuevos creados en el esquema; no es necesario otorgar permisos 
cuando se crean objetos nuevos.

Permisos mediante código basado en procedimiento
El encapsulamiento del acceso a los datos a través de módulos tales como procedimientos 
almacenados y y funciones definidas por el usuario brinda un nivel de protección adicional a 
la aplicación.

Se puede evitar que los usuarios interactúen directamente con objetos de la base de datos otorgando 
permisos solo a procedimientos almacenados o funciones, y denegando permisos a objetos subyacentes 
tales como tablas.

SQL Server lo consigue mediante encadenamiento de propiedad. Por ejemplo, se puede restringir los 
permisos de lectura de todos los objetos de la base de datos y dar permisos de ejecución de los 
procedimientos almacenados. Si el usuario logra conectarse a SQL Server no verá ningún objeto pero 
si podrá ejecutar los procedimientos almacenados a los que se le ha asignado permiso de ejecución.

Asignar permisos
Instrucción Grant
Asignar permisos de un asegurable a un principal.

Sintaxis:

GRANT { ALL [ PRIVILEGES ] }
| Permisos [ ON [ clase :: ] asegurable ] TO principal [ ,…n ]
[ WITH GRANT OPTION ]

Donde
All Opción que se mantienen por compatibilidad con versiones anteriores. Se incluye Privileges 
para compatibilidad con ISO.

Importante

Si el asegurable es base de datos, ALL asigna BACKUP DATABASE, BACKUP LOG, CREATE DATABASE, 
CREATE DEFAULT, CREATE FUNCTION, CREATE PROCEDURE, CREATE RULE, CREATE TABLE y CREATE VIEW.

Si el asegurable es función escalar, ALL asigna EXECUTE y REFERENCES.
Si el asegurable es función que retorna una tabla, ALL asigna DELETE, INSERT, REFERENCES, SELECT y 
UPDATE.
Si el asegurable es procedimiento almacenado, ALL asigna EXECUTE.
Si el asegurable es tabla, ALL asigna DELETE, INSERT, REFERENCES, SELECT y UPDATE.
Si el asegurable es Vista, ALL asigna DELETE, INSERT, REFERENCES, SELECT y UPDATE.
Permisos: la lista de permisos para el asegurable.
Clase: especifica el tipo de objeto.
asegurable: es el nombre del objeto asegurable.
To principal: el principal que se le asignarán los permisos.
with grant Option significa que al principal al que se le asignan los permisos puede también asignar 
los permisos a otros.

Grant para algunos asegurables
Para hacer los ejercicios se incluirá sintaxis separadas, la lista de permisos para cada 
asegurable es amplia y las opciones de Grant son muchas mas de las que se muestran en este artículo, 
para información completa se sugiere ir a la información oficial de Microsoft.

1. Grant con Base de datos
Grant Permisos to Principal [ WITH GRANT OPTION ]

2. Grant con Procedimientos Almacenados
Grant Execute on Object::NombreProcedimiento to Principal [ WITH GRANT OPTION ]

3. Grant con Vista, Tabla, Sinónimo o función definida por el usuario
Grant Permisos on Object::[NombreEsquema.]NombreObjeto to Principal [ WITH GRANT OPTION ]

4. Grant en un esquema
Grant Permisos on Schema::NombreEsquema to Principal [ WITH GRANT OPTION ]

5. Grant con Tipos definidos por el usuario
Grant Permisos on Type::[NombreEsquema.]NombreTipo to Principal [ WITH GRANT OPTION ]
Nota: Los permisos pueden ser References o View Definition
*/

/*EJERCICIO 01. Crear en AdventureWorks un usuario AsistenteRH en base a un login del mismo 
nombre que tenga permisos de lectura y escritura en el esquema Person*/
use master
go
create login AsistenteRH with password = '123'
go
use AdventureWorks
go
create user AsistenteRH from login AsistenteRH
go
--Permisos
Grant Select, Update on Schema::Person to AsistenteRH
Deny Insert, Delete on Schema::Person to AsistenteRH
go

/*EJERCICIO 02. Crear un inicio para Northwind llamado Capataz en base al mismo login Asignar 
permisos de Lectura, Inserción y Actualización en toda la BD*/
use master
go
Create login Capataz with password = '123'
go
use Northwind
go
Create user Capataz from login Capataz
go
grant select, Insert, Update to Capataz
Deny delete to Capataz
go

/*EJERCICIO 03. Crear un usuario Auditor, asignar permiso de lectura en la BD y hacerlo 
miembro de db_backupoperator. Al login hacerlo miembro de [processadmin]*/
use master
go
create login Auditor with password = '123'
go
Alter server role processadmin add member Auditor
go
use Northwind
go
create user Auditor from login Auditor
go
Grant Select to Auditor
Deny Insert, Delete, Update to Auditor
go
Alter role db_backupoperator add member Auditor
go

/*EJERCICIO 04. Crear un usuario AsistenteVentas usando un login con el mismo nombre en AdventureWorks 
que tengo permisos de lectura, modificación, inserción en el esquema Sales (Ventas) Denegar Eliminación.*/
use master
go
create login AsistenteVentas with password = '123'
go
use AdventureWorks
go
Create user AsistenteVentas from login AsistenteVentas
go
Grant Select, Update, Insert on Schema::Sales to AsistenteVentas
Deny Delete on Schema::Sales to AsistenteVentas
go

--Incluir para AsistenteVentas la lectura de la tabla [HumanResources].[Employee]
use AdventureWorks
go
Grant Select on Object::HumanResources.Employee to AsistenteVentas
Deny Insert, Update, Delete on Object::HumanResources.Employee to AsistenteVentas
go

/*EJERCICIO 05. Crear un SP que liste sólo Id, Descripción, Precio y Stock de Productos, 
luego crear un usuario Reportes que tenga permiso únicamente al SP creado
Permiso en un SP es: EXECUTE*/
use Northwind
go

Create procedure spProductosListado
As
	SELECT ProductID, ProductName, UnitPrice,
	UnitsInStock from Products
go

use master
go
Create login Reportes with password = ‘123’
go
use Northwind
create user Reportes from login Reportes
go
Deny Select, insert, Update, Delete to Reportes
Grant Execute on object::dbo.spProductosListado to Reportes
go