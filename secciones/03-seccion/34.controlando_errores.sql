/*-- CONTROLANDO ERRORES EN SQLSERVER --

Al usar el lenguage Transact-SQL debemos tener en cuenta, como en cualquier lenguaje de programación, 
que algunas instrucciones nos pueden dar errores debido a los valores de parámetros de entrada 
incorrectos o faltantes, ingresos de datos con tipos incorrectos, falta de datos en un procedimiento 
o función definida por el usuario o de manera general en una transacción no finalizada de manera 
correcta.

Funciones para el manejo de errores

Las funciones para el manejo de errores permiten conocer los parámetros que reporta un error, 
las funciones son las siguientes:

ERROR_NUMBER()		Devuelve el número de error.
ERROR_SEVERITY()	Devuelve la severidad del error.
ERROR_STATE()		Devuelve el estado del error.
ERROR_PROCEDURE()	Devuelve el nombre del procedimiento almacenado que ha provocado el error.
ERROR_LINE()		Devuelve el número de línea en el que se ha producido el error.
ERROR_MESSAGE()		Devuelve el mensaje de error.
*/

/*EJERCICIO 01. El siguiente ejemplo muestra una división entre CERO, lo que arroja error, 
luego se muestran los valores de cada función. Se utiliza la estructura Try Catch cuya explicación 
está al final de este artículo.*/
BEGIN TRY
	DECLARE @valor1 NUMERIC(9,2), @valor2 NUMERIC(9,2), @division NUMERIC(9,2)
	SET @valor1 = 100
	SET @valor2 = 0
	SET @division = @valor1/@valor2
	PRINT 'La división no reporta error'
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS 'N° de error', ERROR_SEVERITY() AS 'severidad',
		   ERROR_STATE() AS 'estado', ERROR_PROCEDURE() AS 'procedimiento',
		   ERROR_LINE() AS 'N° línea', ERROR_MESSAGE() AS 'mensaje'
END CATCH
GO
/*
LA FUNCIÓN @@ERROR
La función @@ERROR almacena el número de error producido por la última sentencia Transact SQL ejecutada,
Si no se ha producido ningún error el valor de la función es CERO.
Se puede usar esta función para controlar los errores usando una estructura If
*/

/*EJERCICIO 02. El siguiente ejemplo muestra una división entre CERO, lo que arroja error, 
luego se da consistencia al error con una estructura If*/
DECLARE @valor1 NUMERIC(9,2), @valor2 NUMERIC(9,2), @division NUMERIC(9,2)
SET @valor1 = 100
SET @valor2 = 0
SET @division = @valor1/@valor2
IF @@ERROR = 0 
	BEGIN
		PRINT 'El resultado es: ' + STR(@division)
		PRINT 'No hubo error'
	END
ELSE
	BEGIN
		PRINT 'Error al divir entre cero'
	END
GO
--Probamos el mismo código con el valor2 igual a 2
DECLARE @valor1 NUMERIC(9,2), @valor2 NUMERIC(9,2), @division NUMERIC(9,2)
SET @valor1 = 100
SET @valor2 = 2
SET @division = @valor1/@valor2
IF @@ERROR = 0 
	BEGIN
		PRINT 'El resultado es: ' + STR(@division)
		PRINT 'No hubo error'
	END
ELSE
	BEGIN
		PRINT 'Error al divir entre cero'
	END
GO

/*
NIVELES DE SEVERIDAD DEL ERROR
Al cometer algún error en SQL Server se presentan mensajes dentro de los cuales aparece el nivel de 
severidad del mismo, en esta tabla se presentan los 25 diferentes niveles de gravedad del error.

0-9		Mensajes informativos que devuelven información de estado o informan sobre errores que no 
		son graves. El Motor de base de datos no muestra errores del sistema con gravedades de 0 a 9.

10		Mensajes informativos que devuelven información de estado o informan sobre errores que no 
		son graves. Por razones de compatibilidad, el Motor de base de datos convierte la gravedad 
		10 en gravedad 0 antes de devolver la información de errores a la aplicación que hace la llamada.

11-16	Indica errores que pueden ser corregidos por el usuario.

11		Indica que un objeto o una entidad determinados no existen.

12		Una gravedad especial para consultas que no utilizan bloqueo debido a sugerencias de consulta 
		especiales. En algunos casos, las operaciones de lectura realizadas por estas instrucciones 
		podrían producir datos incoherentes, ya que no se adoptan bloqueos para garantizar la 
		coherencia.

13		Indica errores de interbloqueo de transacciones.

14		Indica errores relacionados con la seguridad, como es el caso de permisos denegados.

15		Indica errores de sintaxis en el comando Transact-SQL .

16		Indica errores generales que pueden ser corregidos por el usuario.

17-19	Indica errores de software que no pueden ser corregidos por el usuario. Informe al administrador 
		del sistema sobre el problema.

17		Indica que la instrucción ha hecho que SQL Server se quede sin recursos (como, por ejemplo, 
		memoria, bloqueos o espacio en disco para la base de datos) o ha superado alguno de los 
		límites establecidos por el administrador del sistema.

18		Indica un problema en el software de Motor de base de datos pero la instrucción completa su 
		ejecución y la conexión con la instancia del Motor de base de datos se mantiene. 
		El administrador del sistema debe ser informado cada vez que se produce un mensaje con un 
		nivel de gravedad 18.

19		Indica que se ha superado un límite de Motor de base de datos no configurable y el proceso por 
		lotes actual ha finalizado. Los mensajes de error con nivel de gravedad 19 o superior detienen 
		la ejecución del lote actual. Los errores de nivel de gravedad 19 son poco frecuentes y deben 
		ser corregidos por el administrador del sistema o por el proveedor principal de asistencia 
		técnica. Póngase en contacto con el administrador del sistema cuando se produzca un mensaje 
		con nivel de gravedad 19. Los mensajes de error con nivel de gravedad entre 19 y 25 se escriben 
		en el registro de errores.

20-24	Indica problemas del sistema y son errores irrecuperables, lo que significa que ya no está en 
		ejecución la tarea de Motor de base de datos que esté ejecutando una instrucción o lote. 
		La tarea registra información sobre lo acontecido y, a continuación, finaliza. En la mayoría 
		de los casos, puede que también finalice la conexión de la aplicación a la instancia del Motor 
		de base de datos . Si esto ocurre, dependiendo del problema, la aplicación podría no conseguir 
		volver a conectarse.

		Los mensajes de error incluidos en este intervalo pueden afectar a todos los procesos que tienen 
		acceso a los datos de la misma base de datos y pueden indicar que una base de datos u objeto 
		está dañado. Los mensajes de error con nivel de gravedad entre 19 y 24 se escriben en el 
		registro de errores.

20		Indica que una instrucción ha encontrado un problema. Puesto que el problema ha afectado solo a 
		la tarea actual, no es probable que la propia base de datos haya sido dañada.

21		Indica que una instrucción ha encontrado un problema. Puesto que el problema ha afectado solo
		a la tarea actual, no es probable que la propia base de datos haya sido dañada.

22		Indica que la tabla o índice especificado en el mensaje ha sido dañado por un problema de software 
		o hardware.

		Los errores de nivel de gravedad 22 se producen en raras ocasiones. Si se produce uno de ellos, 
		ejecute DBCC CHECKDB para determinar si hay otros objetos de la base de datos dañados. 
		Es posible que el problema se encuentre solo en la caché del búfer y no en el propio disco. 
		Si es así, al reiniciar la instancia del Motor de base de datos se corregirá el problema. 
		Para seguir trabajando, deberá volver a conectarse a la instancia del Motor de base de datos; 
		en caso contrario, utilice DBCC para solucionar el problema. En algunas ocasiones, puede que 
		tenga que restaurar la base de datos.

		Los errores de nivel de gravedad 22 se producen en raras ocasiones. Si se produce uno de ellos, 
		ejecute DBCC CHECKDB para determinar si hay otros objetos de la base de datos dañados. 
		Es posible que el problema se encuentre solo en la caché del búfer y no en el propio disco. 
		Si es así, al reiniciar la instancia del Motor de base de datos se corregirá el problema. 
		Para seguir trabajando, deberá volver a conectarse a la instancia del Motor de base de datos; 
		en caso contrario, utilice DBCC para solucionar el problema. En algunas ocasiones, puede que 
		tenga que restaurar la base de datos.

		Si al reiniciar la instancia del Motor de base de datos no se corrige el problema, el problema 
		estará en el disco. Algunas veces se puede resolver si se destruye el objeto especificado en 
		el mensaje de error. Por ejemplo, si el mensaje le indica que la instancia del Motor de base 
		de datos ha encontrado una fila con longitud 0 en un índice no clúster, elimine el índice y 
		vuelva a generarlo.

23		Indica que se sospecha de la integridad de toda la base de datos debido al daño causado por 
		un problema de hardware o software.

		Los errores de nivel de gravedad 23 se producen en raras ocasiones. Si se produce alguno, 
		ejecute DBCC CHECKDB para determinar la magnitud de los daños. Es posible que el problema 
		se encuentre solo en la caché y no en el propio disco. Si es así, al reiniciar la instancia 
		del Motor de base de datos se corregirá el problema. Para seguir trabajando, deberá volver 
		a conectarse a la instancia del Motor de base de datos; en caso contrario, utilice DBCC para 
		solucionar el problema. En algunas ocasiones, puede que tenga que restaurar la base de datos.

24		Indica un error en los medios. Puede que el administrador del sistema tenga que restaurar 
		a base de datos. Puede que también tenga que llamar al distribuidor de hardware.


MENSAJES DE ERROR
SQL Server tienen una vista de catálogo con los mensajes definidos por defecto, la vista es sys.messages,
a la cual se le pueden añadir mensajes de error con sus parámetros respectivos usando el procedimiento 
almacenado sp_addmessage.

El procedimiento almacenado sp_addmessage permite agregar a la vista de catálogo sys.messages mensajes 
de error definidos por el usuario con niveles de gravedad de 1 a 25. Use Raiserror para utilizar los 
mensajes de error definidos por el usuario.

RAISERROR puede hacer referencia a un mensaje de error definidos por el usuario almacenados en la 
vista de catálogo sys.messages o puede generar un mensaje dinámicamente. Si se usa el mensaje de error 
definido por el usuario de sys.messages mientras se genera un error, la gravedad especificada por 
RAISERROR reemplazará a la gravedad especificada en sys.messages.

Para visualizar los mensajes de la vista de catálogo Sys.messages puede ejecutar la siguiente instrucción.
*/
SELECT * 
FROM SYS.MESSAGES
GO

/*
EL PROCEDIMIENTO SP_ADDMESSAGE
Permite agregar un mensaje de error definido por el usuario a la vista de catálogo sys.messages

Sintaxis:
sp_addmessage [ @msgnum= ] msg_id , [ @severity= ] severidad , [ @msgtext= ] ‘mensaje’
[ , [ @lang= ] ‘languaje’ ]

Donde:
[ @msgnum= ] msg_id Especifica el Id del mensaje, se pueden iniciar en 50001, el valor máximo 
es 2,147,483,647.
[ @severity= ] severidad Indica el nivel de gravedad del error, puede ser un valor entre 1 y 25.
[ @msgtext= ] ‘mensaje‘ Especifica el mensaje definido por el usuario.
[ @lang= ] ‘languaje’ Especifica el lenguaje.
*/

/*EJERCICIO 03. Agregar el mensaje para indicar que un porcentaje de descuento puede ser entre 0 y 25%.
Note que es necesario insertar el mensaje para el idioma inglés y así poder agregar el mensaje para español.*/
USE MASTER
GO

EXECUTE SP_ADDMESSAGE 50001, 16, 'The discount percentage should be between 0 and 25%', 'us_english', false, replace
GO

EXECUTE SP_ADDMESSAGE 50001, 16, 'El porcentaje de descuento debe ser entre 0 y 25%', 'Spanish', false, replace
GO

/*EJERCICIO 04. Agregar el mensaje para indicar que un precio debe ser CERO o mayor.
Note que es necesario insertar el mensaje para el idioma inglés y así poder agregar el 
mensaje para español*/
USE MASTER
GO

EXECUTE SP_ADDMESSAGE 50002, 16, 'The price should be 0 or greater', 'us_english', false, replace
GO

EXECUTE SP_ADDMESSAGE 50002, 16, 'El precio debe ser 0 o mayor’', 'Spanish', false, replace
GO

/*
Procedimientos almacenados para los mensajes de error definidos por el usuario

Procedimiento almacenado sp_altermessage

Modifica el estado de los mensajes definidos por el usuario o del sistema en una instancia del motor de base de datos de SQL Server.
Sintaxis:

sp_altermessage [ @message_id = ] message_number ,[ @parameter = ]’write_to_log’
,[ @parameter_value = ]’value’

Donde:
[ @message_id = ] message_number Especifica el Id del mensaje
[ @parameter = ]’write_to_log‘ Especifica si se va a escribir en el log de Windows
[ @parameter_value = ]’value’ Se utiliza con @parameter para indicar que el error debe escribirse en el 
registro de aplicación de Microsoft Windows
*/

/*EJERCICIO 05. El siguiente ejemplo permite especificar que el mensaje de error creado se escriba
en el log de windows*/
SP_ALTERMESSAGE 50001, 'with_log', 'true'
GO

/*
Procedimiento almacenado sp_dropmessage

Elimina un mensaje de error definido por el usuario
Sintaxis:

sp_dropmessage [ @msgnum = ] message_number [ , [ @lang = ] ‘language’ ]

Donde:
[ @msgnum = ] message_number Especifica el Id del mensaje
[ @lang = ] ‘language’ Especifica el lenguaje.
*/

/*EJERCICIO 06. El siguiente código elimina el mensaje creado con id 50001*/
SP_DROPMESSAGE 50001, 'Spanish'
GO

/*
CONTROLANDO LOS ERRORES

USANDO TRY CATCH
- Permite implementar el manejo de errores para Transact-SQL, esta estructura es similar a la de los 
  lenguajes de programación.
- La sentencias Transact-SQL que pueden dar error se incluyen en el bloque TRY. Si se produce un error 
  en el bloque TRY,  el control se pasa a otro grupo de sentencias incluidas en un bloque CATCH.

Sintaxis:

BEGIN TRY
	Instrucciones Transact – SQL que pueden dar error
END TRY
BEGIN CATCH
	Instrucciones Transact – SQL para manejar el error
END CATCH
*/
/*EJERCICIO 07. Usando la base de datos Northwind, listar los registros de la tabla Ventas, tenga en 
cuenta que la tabla no existe.
El select se incluirá en un procedimiento almacenado.*/
USE Northwind
GO

--El procedimiento almacenado
CREATE PROCEDURE sp_lista_ventas
AS
	SELECT * FROM ventas
GO

--Ahora ejecutamos el procedimiento almacenado
BEGIN TRY
	EXECUTE sp_lista_ventas
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS [N° error], ERROR_MESSAGE() AS [Mensaje]
END CATCH