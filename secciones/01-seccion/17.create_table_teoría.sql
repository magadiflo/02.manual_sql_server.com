/*-- CREATE TABLE TEOR�A --*/
/*
La informaci�n guardada en la base de datos se almacena en tablas, 
estas deben partir de un dise�o de base de datos previo. 
Las tablas son el resultado de un proceso de dise�o detallado 
que incluye reglas de normalizaci�n y criterios propios del dise�ador 
y requisitos del sistema.

Las tablas en una base de datos deber�an de alguna forma estar 
todas relacionadas, es recomendable usar tipos de datos similares 
y antes del dise�o de las tablas, es muy �til crear tipos de datos
definidos por el usuario para estandarizar el dise�o.

RECOMENDACIONES:
Los nombres de campos de la tabla deber�an tener el nombre de la 
tabla al inicio, esto har� posible identificar a que tabla pertenece 
un campo, por ejemplo, el campo Codigo para la tabla Productos se puede 
llamar ProductosCodigo.

Especifique las restricciones con un nombre adecuado, por ejemplo, 
para la restricci�n tipo Primary key de la tabla Productos 
el nombre puede ser ProductosPK.

Se recomienda el uso de campos nchar y char para los datos cuya 
longitud no var�a como c�digos. Tenga en cuenta usar nchar por su 
soporte de datos Unicode.

Se recomienda el uso de campos nvarchar y varchar para los datos cuya 
longitud var�a como nombres, direcciones, apellidos, descripciones, etc. 
Tenga en cuenta usar nchar por su soporte de datos Unicode.

Se recomienda el uso de campos Numeric para todos los num�ricos.

Evite eliminar los registros de manera f�sica (Usando Delete), puede usar 
un campo de tipo nchar con un flag que indique que el registro est� eliminado.

Para las im�genes use campos de tipo Image. (Ver Insertar im�genes)

Defina de manera adecuada el esquema donde se va a ubicar la tabla.

INSTRUCCI�N CREATE TABLE
Para crear una tabla se puede simplificar la instrucci�n como sigue:

CREATE TABLE [BaseDatos.][Esquema.]NombreTabla (
Campo1 TipoDeDato,
Campo2 TipoDeDato, �) ON GrupoDeArchivos
GO

PARA CREAR UNA TABLA PARTICIONADA
Crear primero la Funci�n de partici�n, el esquema de partici�n y al 
crear la tabla se utiliza la siguiente sintaxis:

CREATE TABLE [BaseDatos.][Esquema.]NombreTabla (
Campo1 TipoDeDato,
Campo2 TipoDeDato, �) ON EsquemaPartici�n (CampoPartici�n)
GO

NOTAS IMPORTANTES:

Los nombres de las tablas pueden tener hasta 128 caracteres. 
Las tablas temporales un m�ximo de 116.

Se sugiere que los nombres de campos tengan al inicio en nombre de la tabla.

Agrupar la tablas en Esquemas.

Evitar en lo posible usar la propiedad  Identity

Por optimizaci�n se pueden crear campos calculados.

No usar guiones bajos no espacios en los nombres de las tablas 
ni en los nombres de campo.

RECOMENDACIONES AL DEFINIR TIPOS DE DATOS PARA CADA CAMPO
Datos alfanum�ricos que no cambian la longitud como c�digos, 
n�meros de documentos y campos para estados deber�an ser nchar.

Datos alfanum�ricos que cambian la longitud como apellidos, nombres, 
direcciones, descripciones, etc deber�an ser nvarchar.

Datos num�ricos deber�an ser Numeric y definir un rango amplio para que 
alcancen todos los valores posibles. (Ver tipos de datos en SQL Server)

Datos donde se guardan fecha deber�an ser Date y si interesa guardar la 
hora junto con la fecha DateTime.

Datos donde se guarden im�genes deber�an ser Image.

Evitar en lo posible usar la propiedad Identity.

RECOMENDACIONES PARA RESTRICCIONES DE LOS CAMPOS
Especificar correctamente los campos obligatorios con Not Null.

Para los campos que no son obligatorios de preferencia usar restricciones de tipo Default.

Los campos que sirven como clave for�nea deber�an tener el mismo nombre 
que tiene en la tabla donde es clave principal.

Si en un campo no se debe repetir el valor ingresado y no es la clave primaria, 
usar restricciones de tipo UNIQUE.

Es recomendable usar las restricciones de tipo Check para comprobar una o 
mas condiciones que deben de cumplir los datos para insertarlos en la tabla.
*/
