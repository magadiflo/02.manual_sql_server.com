/*-- TRANSACCIONES EN SQL SERVER --

Características de las transacciones

- Atomicidad: significa que las instrucciones de la transacción tienen éxito o fallan juntas. 
  A menos que todos las instrucciones se ejecuten correctamente la transacción será completada.
- Consistencia: significa que las instrucciones en una transacción tiene un estado consistente. 
  La transaccion lleva la base de datos subyacente de un estado estable a otro, sin reglas violadas 
  antes de la comenzando o después del final de la transacción.
- Aislamiento: cada transacción es una entidad independiente. Una transacción no afectará a 
  ninguna otra transacción que se ejecuta al mismo tiempo.
- Durabilidad: cada transacción se mantiene en un medio confiable que no se puede deshacer mediante 
  fallas del sistema. Además, si una falla del sistema ocurre en medio de una transacción,los pasos 
  completados deben deshacerse o los pasos incompletos deben ejecutarse para terminar la transacción. 
  Esto suele ocurrir mediante el uso de un registro que se puede reproducir para volver el sistema a 
  un estado consistente.

Alcance de las transacciones

Dependiendo de la forma de como trabajan las transacciones pueden ser de dos tipos:
Transacciones Locales: las que trabajan en una sola base de datos.
Transacciones distribuidas: las que trabajan en múltiples bases de datos.

Transacciones Locales en SQL Server
Las transacciones que trabajan en una sola base de datos se llaman transacciones locales, 
estas transacciones tienen cuatro modos diferentes:

AutoCommit
Explicit
Implicit
Batch-scope

Transacciones en modo AutoCommit
El modo AutoCommit, llamado transacción de confirmación automática es el modo de transacción 
predeterminado.En este modo, SQL Server garantiza la seguridad de los datos durante toda la 
vida útil de la ejecución de la consulta, independientemente de si ha solicitado o no una 
transacción Por ejemplo, si ejecuta una instrucción de lenguaje de manipulación de datos (DML) 
(ACTUALIZAR,INSERTAR, o ELIMINAR), los cambios se confirmarán automáticamente 
(si no se producen errores) o se revertirán (deshecho) en caso contrario.

Transacciones en modo Explicit
El modo de transacción AutoCommit permite ejecutar instrucciones individuales de manera transaccional,
pero con frecuencia, se requiere que un lote de instrucciones funcione dentro de una sola transacción.
En ese escenario, se debe utilizar transacciones explícitas. En el modo de transacción explícita, 
se solicita explícitamente los límites de una transacción. En otras palabras, se especifica con 
precisión cuándo comienza la transacción y cuándo termina.

Al terminar el modo Explicit, SQL Server continúa trabajando en el modo de transacción AutoCommit 
hasta que solicite una excepción a la regla, por lo que si desea ejecutar una serie de sentencias 
Transact-SQL (T-SQL) como un solo lote, usa el modo de transacción explícito en su lugar. 
Para iniciar la transacción en modo Explicit se utiliza la instrucción BEGIN TRANSACTION.

Sintaxis para crear transacciones
BEGIN TRANSACTION [NombreTransaccion] [WITH MARK [‘descripción’]]

Al terminar una transacción en modo Explicit se puede usar:

Para terminar de manera exitosa la transacción
COMMIT TRANSACTION [NombreTransaccion]

Para anular todas las instrucciones de la transacción
ROLLBACK TRANSACTION [NombreTransaccion]

Las instrucciones para terminar o anular la transacción se incluyen dentro de estructuras 
condicionales para comprobar si hubo o no algún error al ejecutar el conjunto de instrucciones 
de la transacción.

Transacciones explicit anidadas
El uso de una transacción dentro de otra refiere el uso de transacciones anidadas.

Ejemplo
BEGIN TRANSACTION Primera
	Insert into MiTabla1 VALUES (‘C09?,’Mi Dato’)
BEGIN TRANSACTION Segunda
	Insert into MiTabla1 VALUES (‘C15?,’Otro Dato’)
COMMIT TRANSACTION Segunda
ROLLBACK Transaction Primera

A pesar de haber terminado de manera exitosa la transacción Segunda, la inserción del 
registro «C09» con el valor «Mi Dato» no se realiza porque la transacción Segunda en una 
transacción anidada en la transacción Primera que es anulada con la instrucción Rollback.

Transacciones en SQL Server en modo Implicit
SQL Server Management Studio (SSMS) o SQL Server Data Tools (SSDT) por defecto tienen conexión
en modo de transacción automática lo que significa que al ejecutar una instrucción DML, los cambios 
se guardan automáticamente. El modo Implicit en las transacciones en SQL Server requiere que los 
cambios sean confirmados usando Commit o anulados usando Rollback.

Para configurar la conexión de la base de datos al modo de transacción implícita se utliza 
la sentencia: 
SET IMPLICIT_TRANSACTIONS {ON | OFF}

Una transacción se inicia automáticamente cuando se ejecuta cualquiera de los siguientes instrucciones:
ALTER TABLE, CREATE, DELETE, DROP, FETCH, GRANT, INSERT, OPEN, REVOKE, SELECT, TRUNCATE TABLE, o UPDATE.


El término implícito se refiere al hecho de que una transacción se inicia implícitamente sin una 
Declaración explícita BEGIN TRANSACTION. Por lo tanto, siempre es necesario que explícitamente 
confirme la transacción posteriormente para guardar los cambios (o revertirla para descartarlos).

Con el modo de transacción implícita, la transacción que comienza implícitamente no se termina o 
revierte a menos que se solicite explícitamente. Esto significa que si emite una sentencia UPDATE, 
SQL Server mantendrá un bloqueo en los datos afectados hasta que emita un COMMIT o ROLLBACK. 
Si no emite una instrucción COMMIT o ROLLBACK, la transacción se anula cuando el usuario desconecta

Transacciones en SQL en modo Batch-Scope
Desde SQL Server 2005, se admiten múltiples conjuntos de resultados activos (MARS) en la misma conexión, 
esto no significa que haya ejecución paralela de comandos. El comando ejecución todavía está intercalado
con reglas estrictas que rigen qué declaraciones pueden sobrepasar otras declaraciones.

Las conexiones que utilizan MARS tienen un entorno de ejecución por lotes asociado. En la ejecución por 
lotes el entorno contiene varios componentes, como las opciones SET, el contexto de seguridad, 
el contexto de la base de datos, y las variables de estado de ejecución, que definen el entorno en 
el que se ejecutan los comandos.

Cuando MARS está habilitado, puede tener múltiples lotes intercalados ejecutándose al mismo tiempo, 
por lo que todos los cambios realizados en el entorno de ejecución se aplican al lote específico hasta 
la ejecución de ese lote esta completo Una vez finalizada la ejecución del lote, se copian los ajustes 
de ejecución al entorno por defecto. Por lo tanto, se dice que una conexión utiliza el modo de 
transacción de ámbito por lotes si está ejecutando una transacción, tiene habilitado MARS en él y 
tiene varios lotes intercalados ejecutándose al mismo tiempo.
*/
USE Northwind
GO

/*EJERCICIO 01. Insertar un registro en la tabla región usando transacción*/
BEGIN TRANSACTION inserta_region
INSERT INTO Region(RegionID, RegionDescription)
VALUES(30, 'Lima')

IF @@ERROR <> 0 
	BEGIN
		ROLLBACK TRANSACTION inserta_region
		PRINT 'Anulada... no se insertó'
	END
ELSE
	BEGIN
		COMMIT TRANSACTION inserta_region
		PRINT 'Se insertó la región'
	END
GO
/*
En el ejercicio anterior se han incluído mensajes con Print sólo para efectos de comprobar que la 
transacción se ejecuta o no, o como termina, en producción no use los mensajes con Print.
*/

/*EJERCICIO 02. Crear un store procedure para insertar una región*/
CREATE OR ALTER PROCEDURE sp_region_inserta(
	@id INT, 
	@region VARCHAR(50)
)
AS
	BEGIN
		BEGIN TRANSACTION inserta_region

		INSERT INTO Region(RegionID, RegionDescription)
		VALUES(@id, @region)

		IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION inserta_region
			END
		ELSE
			BEGIN
				COMMIT TRANSACTION inserta_region
			END
	END
GO

EXECUTE sp_region_inserta 32, 'Chimbote'
GO

/*EJERCICIO 03. Crear un trigger en la tabla región que no permita insertar un registro
con la descripción duplicada*/
IF EXISTS(SELECT * FROM SYS.TRIGGERS WHERE NAME = 'tr_region_no_duplicados')
	BEGIN
		DROP TRIGGER tr_region_no_duplicados
	END
GO


CREATE TRIGGER tr_region_no_duplicados
ON Region
FOR INSERT, UPDATE
AS
	BEGIN
		SET NOCOUNT ON
		IF(SELECT COUNT(*) 
		   FROM Region, INSERTED 
		   WHERE Region.RegionDescription = INSERTED.RegionDescription) > 1
		   BEGIN
				ROLLBACK TRANSACTION
				PRINT 'Ya existe una región con el nombre insertado'
		   END
		ELSE
			BEGIN
				PRINT 'Se inserto´el registro, mensaje desde el trigger'
			END
	END
GO

/*EJERCICIO 04. Este código muestra transacciones anidadas. Tiene en cuenta el registro
de una factura y el detall de la misma*/
BEGIN TRANSACTION guarda_factura
--
--
--Instrucciones para guardar la factura
BEGIN TRANSACTION guarda_factura_detalle
DECLARE @vDetalle CHAR(1) = 'S'
--
IF @@ERROR = 0 
	BEGIN
		COMMIT TRAN guarda_factura_detalle
	END
ELSE 
	BEGIN
		SET @vDetalle = 'E'
		ROLLBACK TRAN guarda_factura_detalle
	END

IF @vDetalle = 'E'
	BEGIN
		ROLLBACK TRAN guarda_factura
	END
ELSE
	BEGIN
		COMMIT TRAN guarda_factura
	END