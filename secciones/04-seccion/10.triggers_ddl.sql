/*-- TRIGGERS DDL EN SQL SERVER --

Los Triggers DDL son aquellos que se disparan cuando se realizan eventos DDL, que son las siglas 
de Data Definition Languages, estos comando son Create, Alter, Drop, GRANT, DENY, REVOKE o 
UPDATE STATISTICS.

Creando Triggers DDL

CREATE [ OR ALTER ] TRIGGER NombreTrigger
ON { ALL SERVER | BaseDatos }
{ FOR | AFTER } { TipoEvento | GrupoEventos } [ ,…n ]
AS
Begin
Instrucciones T-SQL
End

Eventos de un Trigger DDL

Los eventos que hacen que se dispare un Trigger DDL clasificados por el alcance 
de los mismos son de dos tipos:
1. Eventos que tienen alcance de base de datos
2. Eventos que tienen alcance de servidor

Eventos que tienen alcance de base de datos

CREATE_APPLICATION_ROLE				ALTER_APPLICATION_ROLE				DROP_APPLICATION_ROLE
CREATE_ASSEMBLY						ALTER_ASSEMBLY						DROP_ASSEMBLY
CREATE_ASYMMETRIC_KEY				ALTER_ASYMMETRIC_KEY				DROP_ASYMMETRIC_KEY
ALTER_AUTHORIZATION					ALTER_AUTHORIZATION_DATABASE	
CREATE_BROKER_PRIORITY				CREATE_BROKER_PRIORITY				CREATE_BROKER_PRIORITY
CREATE_CERTIFICATE					ALTER_CERTIFICATE					DROP_CERTIFICATE
CREATE_CONTRACT						DROP_CONTRACT	
CREATE_CREDENTIAL					ALTER_CREDENTIAL					DROP_CREDENTIAL
GRANT_DATABASE						DENY_DATABASE						REVOKE_DATABASE
CREATE_DATABASE_AUDIT_SPEFICIATION	ALTER_DATABASE_AUDIT_SPEFICIATION	DENY_DATABASE_AUDIT_SPEFICIATION
CREATE_DATABASE_ENCRYPTION_KEY		ALTER_DATABASE_ENCRYPTION_KEY		DROP_DATABASE_ENCRYPTION_KEY
CREATE_DEFAULT						DROP_DEFAULT	
BIND_DEFAULT						UNBIND_DEFAULT	
CREATE_EVENT_NOTIFICATION			DROP_EVENT_NOTIFICATION	
CREATE_EXTENDED_PROPERTY			ALTER_EXTENDED_PROPERTY				DROP_EXTENDED_PROPERTY
CREATE_FULLTEXT_CATALOG				ALTER_FULLTEXT_CATALOG				DROP_FULLTEXT_CATALOG
CREATE_FULLTEXT_INDEX				ALTER_FULLTEXT_INDEX				DROP_FULLTEXT_INDEX
CREATE_FULLTEXT_STOPLIST			ALTER_FULLTEXT_STOPLIST				DROP_FULLTEXT_STOPLIST
CREATE_FUNCTION						ALTER_FUNCTION						DROP_FUNCTION
CREATE_INDEX						ALTER_INDEX	DROP_INDEX
CREATE_MASTER_KEY					ALTER_MASTER_KEY					DROP_MASTER_KEY
CREATE_MESSAGE_TYPE					ALTER_MESSAGE_TYPE					DROP_MESSAGE_TYPE
CREATE_PARTITION_FUNCTION			ALTER_PARTITION_FUNCTION			DROP_PARTITION_FUNCTION
CREATE_PARTITION_SCHEME				ALTER_PARTITION_SCHEME				DROP_PARTITION_SCHEME
CREATE_PLAN_GUIDE					ALTER_PLAN_GUIDE					DROP_PLAN_GUIDE
CREATE_PROCEDURE					ALTER_PROCEDURE						DROP_PROCEDURE
CREATE_QUEUE						ALTER_QUEUE	DROP_QUEUE
CREATE_REMOTE_SERVICE_BINDING		ALTER_REMOTE_SERVICE_BINDING		DROP_REMOTE_SERVICE_BINDING
CREATE_SPATIAL_INDEX		
RENAME		
CREATE_ROLE							ALTER_ROLE							DROP_ROLE
ADD_ROLE_MEMBER						DROP_ROLE_MEMBER	
CREATE_ROUTE						ALTER_ROUTE							DROP_ROUTE
CREATE_RULE							DROP_RULE	
BIND_RULE							UNBIND_RULE	
CREATE_SCHEMA						ALTER_SCHEMA						DROP_SCHEMA
CREATE_SEARCH_PROPERTY_LIST			ALTER_SEARCH_PROPERTY_LIST			DROP_SEARCH_PROPERTY_LIST
CREATE_SEQUENCE_EVENTS				CREATE_SEQUENCE_EVENTS				CREATE_SEQUENCE_EVENTS
CREATE_SERVER_ROLE					ALTER_SERVER_ROLE					DROP_SERVER_ROLE
CREATE_SERVICE						ALTER_SERVICE						DROP_SERVICE
ALTER_SERVICE_MASTER_KEY			BACKUP_SERVICE_MASTER_KEY			RESTORE_SERVICE_MASTER_KEY
ADD_SIGNATURE						DROP_SIGNATURE	
ADD_SIGNATURE_SCHEMA_OBJECT			DROP_SIGNATURE_SCHEMA_OBJECT	
CREATE_SPATIAL_INDEX				ALTER_INDEX							DROP_INDEX
CREATE_STATISTICS					DROP_STATISTICS						UPDATE_STATISTICS
CREATE_SYMMETRIC_KEY				ALTER_SYMMETRIC_KEY					DROP_SYMMETRIC_KEY
CREATE_SYNONYM						DROP_SYNONYM	
CREATE_TABLE						ALTER_TABLE							DROP_TABLE
CREATE_TRIGGER						ALTER_TRIGGER						DROP_TRIGGER
CREATE_TYPE							DROP_TYPE	
CREATE_USER							ALTER_USER							DROP_USER
CREATE_VIEW							ALTER_VIEW							DROP_VIEW
CREATE_XML_INDEX					ALTER_INDEX							DROP_INDEX
CREATE_XML_SCHEMA_COLLECTION		ALTER_XML_SCHEMA_COLLECTION			DROP_XML_SCHEMA_COLLECTION

Eventos DDL a nivel de base de datos.
Fuente: Documentación Microsoft

Eventos DDL que tienen alcance en el servidor

Se pueden crear en respuesta de cualquiera de los siguientes eventos, los que ocurren en la 
instancia de SQL Server.

ALTER_AUTHORIZATION_SERVER			ALTER_SERVER_CONFIGURATION			ALTER_INSTANCE
CREATE_AVAILABILITY_GROUP			ALTER_AVAILABILITY_GROUP			DROP_AVAILABILITY_GROUP
CREATE_CREDENTIAL					ALTER_CREDENTIAL					DROP_CREDENTIAL
CREATE_CRYPTOGRAPHIC_PROVIDER		ALTER_CRYPTOGRAPHIC_PROVIDER		DROP_CRYPTOGRAPHIC_PROVIDER
CREATE_DATABASE						ALTER_DATABASE						DROP_DATABASE
CREATE_ENDPOINT						ALTER_ENDPOINT						DROP_ENDPOINT
CREATE_EVENT_SESSION				ALTER_EVENT_SESSION					DROP_EVENT_SESSION
CREATE_EXTENDED_PROCEDURE			DROP_EXTENDED_PROCEDURE	
CREATE_LINKED_SERVER				ALTER_LINKED_SERVER					DROP_LINKED_SERVER
CREATE_LINKED_SERVER_LOGIN			DROP_LINKED_SERVER_LOGIN	
CREATE_LOGIN						ALTER_LOGIN							DROP_LOGIN
CREATE_MESSAGE						ALTER_MESSAGE						DROP_MESSAGE
CREATE_REMOTE_SERVER				ALTER_REMOTE_SERVER					DROP_REMOTE_SERVER
CREATE_RESOURCE_POOL				ALTER_RESOURCE_POOL					DROP_RESOURCE_POOL
GRANT_SERVER						DENY_SERVER							REVOKE_SERVER
ADD_SERVER_ROLE_MEMBER				DROP_SERVER_ROLE_MEMBER	
CREATE_SERVER_AUDIT					ALTER_SERVER_AUDIT					DROP_SERVER_AUDIT
CREATE_SERVER_AUDIT_SPECIFICATION	ALTER_SERVER_AUDIT_SPECIFICATION	DROP_SERVER_AUDIT_SPECIFICATION
CREATE_WORKLOAD_GROUP				ALTER_WORKLOAD_GROUP				DROP_WORKLOAD_GROUP

Eventos DDL a nivel de servidor.
Fuente: Documentación Microsoft
*/
USE Northwind
GO

/*EJERCICIO 01. Crear un trigger para evitar que se creen, modifiquen o eliminen tablas*/
CREATE OR ALTER TRIGGER tr_no_crear_modificar_borrar_tablas
ON DATABASE
FOR CREATE_TABLE, DROP_TABLE, ALTER_TABLE
AS
	BEGIN
		RAISERROR('Transacción anulada, no se permite crear, editar o eliminar tablas', 6, 1)
		ROLLBACK TRANSACTION
	END
GO

--Intentar crear una tabla
CREATE TABLE prueba(
	codigo CHAR(4),
	descripcion VARCHAR(100)
)
GO
/*
Transacción anulada, no se permite crear, editar o eliminar tablas
Msg 50000, Level 6, State 1
Msg 3609, Level 16, State 2, Line 127
The transaction ended in the trigger. The batch has been aborted.
*/

--NOTA: Para poder crear tablas, se debe eliminar el Trigger o solamente desactivar 
DISABLE TRIGGER tr_no_crear_modificar_borrar_tablas
ON DATABASE
GO

--Intentar crear nuevamente una tabla
CREATE TABLE pruebas(
	codigo CHAR(4),
	descripcion VARCHAR(100)
)
GO

--RESULTADO: Comandos completados correctamente


--Activar nuevamente el trigger
ENABLE TRIGGER tr_no_crear_modificar_borrar_tablas
ON DATABASE
GO

/*La función EventData()

Esta función devuelve información sobre eventos del servidor o de la base de datos.
Un Trigger Logon o DDL también admite el uso interno de EVENTDATA.

Sintaxis:
EventData()
*/

/*EJERCICIO 02. Crear un trigger que se dispare cuando se crea una vista y captura el evento creado.*/
CREATE OR ALTER TRIGGER tr_capturar_crear_vista
ON DATABASE
FOR CREATE_VIEW
AS
	BEGIN
		SELECT EVENTDATA() AS evento
	END
GO

--Crear una vista para que el trigger creado se dispare
--Puede notar que el resultado se presenta en un esquema XML.
CREATE OR ALTER VIEW v_categorias
AS
	SELECT c.CategoryID AS codigo, c.CategoryName AS nombre 
	FROM Categories AS c
GO

DROP VIEW v_categorias
GO

/*EJERCICIO 03. Crear un trigger que se dispare al crear, modificar o eliminar
un procedimiento almacenado, almacenar la instrucción ejecutada en una tabla
SPHistorial*/

--Primero crear la tabla, si se creo el trigger del ejercicio anterior debemos desactivarlo.
DISABLE TRIGGER tr_no_crear_modificar_borrar_tablas
ON DATABASE
GO

--Ahora sí se podrá crear la tabla
CREATE TABLE historial_cambios_store_procedures(
	tipo_evento VARCHAR(200),
	fecha DATETIME,
	servidor VARCHAR(100),
	inicio_sesion VARCHAR(100),
	equipo VARCHAR(100),
	comando_tsql VARCHAR(400)
)
GO

--Crear el trigger para crear, editar o eliminar un store procedure
CREATE OR ALTER TRIGGER tr_historia_sp 
ON DATABASE
FOR CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE
AS
	BEGIN	
		INSERT INTO historial_cambios_store_procedures(tipo_evento, fecha, servidor, inicio_sesion, equipo, comando_tsql)
		SELECT EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'VARCHAR(200)'),
		EVENTDATA().value('(/EVENT_INSTANCE/PostTime)[1]', 'DATETIME'),
		EVENTDATA().value('(/EVENT_INSTANCE/ServerName)[1]', 'VARCHAR(100)'),
		EVENTDATA().value('(/EVENT_INSTANCE/LoginName)[1]', 'VARCHAR(100)'),
		HOST_NAME(), 
		EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'VARCHAR(400)')
	END
GO

--Para que el Trigger se dispare, crear un procedimiento almacenado para listar los clientes
CREATE PROCEDURE sp_clientes_listado
AS
	BEGIN
		SELECT c.CustomerID AS codigo, c.CompanyName AS cliente
		FROM Customers AS c
		ORDER BY c.CompanyName
	END
GO

--Modificar el procedimiento para incluir un campo adicional
ALTER PROCEDURE sp_clientes_listado
AS
	BEGIN
		SELECT c.CustomerID AS codigo, c.CompanyName AS cliente, c.Address AS direccion
		FROM Customers AS c
		ORDER BY c.CompanyName
	END
GO

--Borrar el SP
DROP PROCEDURE sp_clientes_listado
GO

--Listar la tabla historial_cambios_store_procedures para verificar los registros generados
SELECT * 
FROM historial_cambios_store_procedures
GO
