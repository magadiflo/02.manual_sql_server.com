/*-- DENEGAR PERMISOS - DENY --

Sobre los objetos de base de datos se pueden administrar los permisos de forma expl�cita para que 
los usuarios accedan a ellos. (Ver Logins) (Ver Usuarios de base de datos)

Cada asegurable tiene permisos que se pueden otorgar a una entidad de seguridad mediante la instrucci�n
de permiso Grant (Ver Asignar permisos con Grant) y para quitar los permisos se debe utilizar Deny.

Los siguientes p�rrafos corresponden a la explicaci�n del art�culo donde se asignan los permisos con 
Grant. (Ver Permisos Grant)

Principio de los privilegios m�nimos
Existe el enfoque basado en cuenta de usuario de privilegios m�nimos (LUA) para el desarrollar de 
aplicaciones lo que constituye una parte importante de una estrategia de defensa contra las amenazas 
a la seguridad.

El enfoque LUA garantiza que los usuarios de base de datos siguen el principio de los privilegios 
m�nimos e inician sesi�n con cuentas de usuario limitadas ya sea en base a roles o de manera 
individual (por usuario).

Se pueden utilizar roles fijos del servidor o roles flexibles de servidor (desde SQL Server 2012). 
(Ver Roles de Servidor)

Considere el uso del rol fijo del servidor sysadmin muy restringido.

Cuando conceda permisos a usuarios de base de datos, siga siempre el principio de los privilegios 
m�nimos.

Otorgue a usuarios y roles los m�nimos permisos necesarios para que puedan realizar una tarea concreta.

Permisos basados en roles
Administrar los permisos usando roles en lugar de a usuarios hace mas sencilla la administraci�n de 
la seguridad en SQL Server.

Los permisos asignados a roles se heredan por todos los miembros del rol.

Es m�s sencillo agregar o quitar usuarios de base de datis de un rol que volver a crear conjuntos 
de permisos distintos para cada usuario.

Se pueden anidar los roles, tenga cuidado con crear mucho niveles de anidamiento puede reducir el 
rendimiento.

Se pueden usar los roles fijos tanto de servidor como de base de datos para simplificar los permisos 
de asignaci�n.

Es una buena pr�ctica asignar los permisos a nivel de esquema. Los usuarios heredan autom�ticamente 
los permisos en todos los objetos nuevos creados en el esquema; no es necesario otorgar permisos 
cuando se crean objetos nuevos.


Permisos a mediante c�digo basado en procedimiento
El encapsulamiento del acceso a los datos a trav�s de m�dulos tales como procedimientos almacenados 
y funciones definidas por el usuario brinda un nivel de protecci�n adicional a la aplicaci�n.

Se puede evitar que los usuarios interact�en directamente con objetos de la base de datos otorgando 
permisos solo a procedimientos almacenados o funciones, y denegando permisos a objetos subyacentes 
tales como tablas.

SQL Server lo consigue mediante encadenamiento de propiedad. Por ejemplo, se puede restringir los 
permisos de lectura de todos los objetos de la base de datos y dar permisos de ejecuci�n de los 
procedimientos almacenados. Si el usuario logra conectarse a SQL Server no ver� ning�n objeto
pero si podr� ejecutar los procedimientos almacenados a los que se le ha asignado permiso de ejecuci�n.

Denegar permisos
Instrucci�n Deny

Deniega permisos de un asegurable a un principal. Evita que la entidad de seguridad herede permisos por su pertenencia a grupos o roles.
Sintaxis:

Deny { ALL [ PRIVILEGES ] }
| Permisos [ ON [ clase :: ] asegurable ] TO principal [ ,�n ]

Donde
All Opci�n que se mantienen por compatibilidad con versiones anteriores.
Se incluye Privileges para compatibilidad con ISO.
Si el asegurable es base de datos, ALL asigna BACKUP DATABASE, BACKUP LOG, CREATE DATABASE, CREATE DEFAULT, CREATE FUNCTION, CREATE PROCEDURE, CREATE RULE, CREATE TABLE y CREATE VIEW.
Si el asegurable es funci�n escalar, ALL asigna EXECUTE y REFERENCES.
Si el asegurable es funci�n que retorna una tabla, ALL asigna DELETE, INSERT, REFERENCES, SELECT y UPDATE.
Si el asegurable es procedimiento almacenado, ALL asigna EXECUTE.
Si el asegurable es tabla, ALL asigna DELETE, INSERT, REFERENCES, SELECT y UPDATE.
Si el asegurable es Vista, ALL asigna DELETE, INSERT, REFERENCES, SELECT y UPDATE.

Permisos: la lista de permisos a denegar sobre el asegurable.
Clase: especifica el tipo de objeto.
asegurable: es el nombre del objeto asegurable.
To principal: el principal que se le denegar�n los permisos.

Para hacer los ejercicios se incluir� sintaxis separadas

1. Deny con Base de datos
Deny Permisos to Principal

2. Deny con Procedimientos Almacenados
Deny Execute on Object::NombreProcedimiento to Principal

3. Deny con Vista, Tabla, Sin�nimo o funci�n definida por el usuario
Deny Permisos on Object::[NombreEsquema.]NombreObjeto to Principal

4. Deny en un esquema
Deny Permisos on Schema::NombreEsquema to Principal

5. Deny con Tipos definidos por el usuario
Deny Permisos on Type::[NombreEsquema.]NombreTipo to Principal
Nota: Los permisos pueden ser References o View Definition
*/

/*EJERCICIO 01. Crear en AdventureWorks un usuario AsistenteRH en base a un login del mismo
nombre que tenga permisos de lectura y escritura en el esquema Person.
Denegar el los permisos para insertar, modificar y eliminar.*/
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

/*EJERCICIO 02. Crear un inicio para Northwind llamado Capataz en base al mismo login
Asignar permisos de Lectura, Inserci�n y Actualizaci�n en toda la BD
Denegar el permiso de Eliminaci�n.*/
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
miembro de db_backupoperator Al login hacerlo miembro de [processadmin]. 
Denegar el permiso de insertar, eliminar y modificar.*/
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

/*EJERCICIO 04. Crear un usuario AsistenteVentas usando un login con el mismo nombre en 
AdventureWorks que tengo permisos de Lectura, modificaci�n, inserci�n en el esquema Sales (Ventas)
Denegar Eliminaci�n.*/
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

/*EJERCICIO 05. Crear un SP que liste s�lo Id, Descripci�n, Precio y Stock de Productos, 
luego crear un usuario Reportes que tenga permiso �nicamente al SP creado.
Denegar los permisos en la tabla productos de listado, inserci�n, modificaci�n y eliminaci�n.
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
Create login Reportes with password = �123�
go
use Northwind
create user Reportes from login Reportes
go
Deny Select, insert, Update, Delete to Reportes
Grant Execute on object::dbo.spProductosListado to Reportes
go
/*EJERCICIO 06. Usando AdventureWorks.
Crear un usuario llamado Contable que tenga acceso s�lo a los esquemas Person y HumanResorces, 
asegurar que no pueda ver los otros esquemas y que en los esquemas que tiene permisos no pueda
modificar ni eliminar los registros.*/
use master
go
Create login Contable with password = '123'
go
use AdventureWorks
go
Create user Contable from login Contable
go
Grant select, insert on schema::Person to Contable
Grant select, insert on schema::HumanResources to Contable
Deny update, delete on schema::HumanResources to Contable
Deny update, delete on schema::Person to Contable
Deny select, insert, update, delete on schema::Production to Contable
Deny select, insert, update, delete on schema::Purchasing to Contable
Deny select, insert, update, delete on schema::Sales to Contable
Deny select, insert, update, delete on schema::dbo to Contable
go