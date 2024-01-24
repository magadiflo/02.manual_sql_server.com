/*-- TRANSACCIONES EN SQL SERVER --

Caracter�sticas de las transacciones

- Atomicidad: significa que las instrucciones de la transacci�n tienen �xito o fallan juntas. 
  A menos que todos las instrucciones se ejecuten correctamente la transacci�n ser� completada.
- Consistencia: significa que las instrucciones en una transacci�n tiene un estado consistente. 
  La transaccion lleva la base de datos subyacente de un estado estable a otro, sin reglas violadas 
  antes de la comenzando o despu�s del final de la transacci�n.
- Aislamiento: cada transacci�n es una entidad independiente. Una transacci�n no afectar� a 
  ninguna otra transacci�n que se ejecuta al mismo tiempo.
- Durabilidad: cada transacci�n se mantiene en un medio confiable que no se puede deshacer mediante 
  fallas del sistema. Adem�s, si una falla del sistema ocurre en medio de una transacci�n,los pasos 
  completados deben deshacerse o los pasos incompletos deben ejecutarse para terminar la transacci�n. 
  Esto suele ocurrir mediante el uso de un registro que se puede reproducir para volver el sistema a 
  un estado consistente.

Alcance de las transacciones

Dependiendo de la forma de como trabajan las transacciones pueden ser de dos tipos:
Transacciones Locales: las que trabajan en una sola base de datos.
Transacciones distribuidas: las que trabajan en m�ltiples bases de datos.

Transacciones Locales en SQL Server
Las transacciones que trabajan en una sola base de datos se llaman transacciones locales, 
estas transacciones tienen cuatro modos diferentes:

AutoCommit
Explicit
Implicit
Batch-scope

Transacciones en modo AutoCommit
El modo AutoCommit, llamado transacci�n de confirmaci�n autom�tica es el modo de transacci�n 
predeterminado.En este modo, SQL Server garantiza la seguridad de los datos durante toda la 
vida �til de la ejecuci�n de la consulta, independientemente de si ha solicitado o no una 
transacci�n Por ejemplo, si ejecuta una instrucci�n de lenguaje de manipulaci�n de datos (DML) 
(ACTUALIZAR,INSERTAR, o ELIMINAR), los cambios se confirmar�n autom�ticamente 
(si no se producen errores) o se revertir�n (deshecho) en caso contrario.

Transacciones en modo Explicit
El modo de transacci�n AutoCommit permite ejecutar instrucciones individuales de manera transaccional,
pero con frecuencia, se requiere que un lote de instrucciones funcione dentro de una sola transacci�n.
En ese escenario, se debe utilizar transacciones expl�citas. En el modo de transacci�n expl�cita, 
se solicita expl�citamente los l�mites de una transacci�n. En otras palabras, se especifica con 
precisi�n cu�ndo comienza la transacci�n y cu�ndo termina.

Al terminar el modo Explicit, SQL Server contin�a trabajando en el modo de transacci�n AutoCommit 
hasta que solicite una excepci�n a la regla, por lo que si desea ejecutar una serie de sentencias 
Transact-SQL (T-SQL) como un solo lote, usa el modo de transacci�n expl�cito en su lugar. 
Para iniciar la transacci�n en modo Explicit se utiliza la instrucci�n BEGIN TRANSACTION.

Sintaxis para crear transacciones
BEGIN TRANSACTION [NombreTransaccion] [WITH MARK [�descripci�n�]]

Al terminar una transacci�n en modo Explicit se puede usar:

Para terminar de manera exitosa la transacci�n
COMMIT TRANSACTION [NombreTransaccion]

Para anular todas las instrucciones de la transacci�n
ROLLBACK TRANSACTION [NombreTransaccion]

Las instrucciones para terminar o anular la transacci�n se incluyen dentro de estructuras 
condicionales para comprobar si hubo o no alg�n error al ejecutar el conjunto de instrucciones 
de la transacci�n.

Transacciones explicit anidadas
El uso de una transacci�n dentro de otra refiere el uso de transacciones anidadas.

Ejemplo
BEGIN TRANSACTION Primera
	Insert into MiTabla1 VALUES (�C09?,�Mi Dato�)
BEGIN TRANSACTION Segunda
	Insert into MiTabla1 VALUES (�C15?,�Otro Dato�)
COMMIT TRANSACTION Segunda
ROLLBACK Transaction Primera

A pesar de haber terminado de manera exitosa la transacci�n Segunda, la inserci�n del 
registro �C09� con el valor �Mi Dato� no se realiza porque la transacci�n Segunda en una 
transacci�n anidada en la transacci�n Primera que es anulada con la instrucci�n Rollback.

Transacciones en SQL Server en modo Implicit
SQL Server Management Studio (SSMS) o SQL Server Data Tools (SSDT) por defecto tienen conexi�n
en modo de transacci�n autom�tica lo que significa que al ejecutar una instrucci�n DML, los cambios 
se guardan autom�ticamente. El modo Implicit en las transacciones en SQL Server requiere que los 
cambios sean confirmados usando Commit o anulados usando Rollback.

Para configurar la conexi�n de la base de datos al modo de transacci�n impl�cita se utliza 
la sentencia: 
SET IMPLICIT_TRANSACTIONS {ON | OFF}

Una transacci�n se inicia autom�ticamente cuando se ejecuta cualquiera de los siguientes instrucciones:
ALTER TABLE, CREATE, DELETE, DROP, FETCH, GRANT, INSERT, OPEN, REVOKE, SELECT, TRUNCATE TABLE, o UPDATE.


El t�rmino impl�cito se refiere al hecho de que una transacci�n se inicia impl�citamente sin una 
Declaraci�n expl�cita BEGIN TRANSACTION. Por lo tanto, siempre es necesario que expl�citamente 
confirme la transacci�n posteriormente para guardar los cambios (o revertirla para descartarlos).

Con el modo de transacci�n impl�cita, la transacci�n que comienza impl�citamente no se termina o 
revierte a menos que se solicite expl�citamente. Esto significa que si emite una sentencia UPDATE, 
SQL Server mantendr� un bloqueo en los datos afectados hasta que emita un COMMIT o ROLLBACK. 
Si no emite una instrucci�n COMMIT o ROLLBACK, la transacci�n se anula cuando el usuario desconecta

Transacciones en SQL en modo Batch-Scope
Desde SQL Server 2005, se admiten m�ltiples conjuntos de resultados activos (MARS) en la misma conexi�n, 
esto no significa que haya ejecuci�n paralela de comandos. El comando ejecuci�n todav�a est� intercalado
con reglas estrictas que rigen qu� declaraciones pueden sobrepasar otras declaraciones.

Las conexiones que utilizan MARS tienen un entorno de ejecuci�n por lotes asociado. En la ejecuci�n por 
lotes el entorno contiene varios componentes, como las opciones SET, el contexto de seguridad, 
el contexto de la base de datos, y las variables de estado de ejecuci�n, que definen el entorno en 
el que se ejecutan los comandos.

Cuando MARS est� habilitado, puede tener m�ltiples lotes intercalados ejecut�ndose al mismo tiempo, 
por lo que todos los cambios realizados en el entorno de ejecuci�n se aplican al lote espec�fico hasta 
la ejecuci�n de ese lote esta completo Una vez finalizada la ejecuci�n del lote, se copian los ajustes 
de ejecuci�n al entorno por defecto. Por lo tanto, se dice que una conexi�n utiliza el modo de 
transacci�n de �mbito por lotes si est� ejecutando una transacci�n, tiene habilitado MARS en �l y 
tiene varios lotes intercalados ejecut�ndose al mismo tiempo.
*/
USE Northwind
GO

/*EJERCICIO 01. Insertar un registro en la tabla regi�n usando transacci�n*/
BEGIN TRANSACTION inserta_region
INSERT INTO Region(RegionID, RegionDescription)
VALUES(30, 'Lima')

IF @@ERROR <> 0 
	BEGIN
		ROLLBACK TRANSACTION inserta_region
		PRINT 'Anulada... no se insert�'
	END
ELSE
	BEGIN
		COMMIT TRANSACTION inserta_region
		PRINT 'Se insert� la regi�n'
	END
GO
/*
En el ejercicio anterior se han inclu�do mensajes con Print s�lo para efectos de comprobar que la 
transacci�n se ejecuta o no, o como termina, en producci�n no use los mensajes con Print.
*/

/*EJERCICIO 02. Crear un store procedure para insertar una regi�n*/
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

/*EJERCICIO 03. Crear un trigger en la tabla regi�n que no permita insertar un registro
con la descripci�n duplicada*/
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
				PRINT 'Ya existe una regi�n con el nombre insertado'
		   END
		ELSE
			BEGIN
				PRINT 'Se inserto�el registro, mensaje desde el trigger'
			END
	END
GO

/*EJERCICIO 04. Este c�digo muestra transacciones anidadas. Tiene en cuenta el registro
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