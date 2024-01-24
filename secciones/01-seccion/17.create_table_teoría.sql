/*-- CREATE TABLE TEORÍA --*/
/*
La información guardada en la base de datos se almacena en tablas, 
estas deben partir de un diseño de base de datos previo. 
Las tablas son el resultado de un proceso de diseño detallado 
que incluye reglas de normalización y criterios propios del diseñador 
y requisitos del sistema.

Las tablas en una base de datos deberían de alguna forma estar 
todas relacionadas, es recomendable usar tipos de datos similares 
y antes del diseño de las tablas, es muy útil crear tipos de datos
definidos por el usuario para estandarizar el diseño.

RECOMENDACIONES:
Los nombres de campos de la tabla deberían tener el nombre de la 
tabla al inicio, esto hará posible identificar a que tabla pertenece 
un campo, por ejemplo, el campo Codigo para la tabla Productos se puede 
llamar ProductosCodigo.

Especifique las restricciones con un nombre adecuado, por ejemplo, 
para la restricción tipo Primary key de la tabla Productos 
el nombre puede ser ProductosPK.

Se recomienda el uso de campos nchar y char para los datos cuya 
longitud no varía como códigos. Tenga en cuenta usar nchar por su 
soporte de datos Unicode.

Se recomienda el uso de campos nvarchar y varchar para los datos cuya 
longitud varía como nombres, direcciones, apellidos, descripciones, etc. 
Tenga en cuenta usar nchar por su soporte de datos Unicode.

Se recomienda el uso de campos Numeric para todos los numéricos.

Evite eliminar los registros de manera física (Usando Delete), puede usar 
un campo de tipo nchar con un flag que indique que el registro está eliminado.

Para las imágenes use campos de tipo Image. (Ver Insertar imágenes)

Defina de manera adecuada el esquema donde se va a ubicar la tabla.

INSTRUCCIÓN CREATE TABLE
Para crear una tabla se puede simplificar la instrucción como sigue:

CREATE TABLE [BaseDatos.][Esquema.]NombreTabla (
Campo1 TipoDeDato,
Campo2 TipoDeDato, …) ON GrupoDeArchivos
GO

PARA CREAR UNA TABLA PARTICIONADA
Crear primero la Función de partición, el esquema de partición y al 
crear la tabla se utiliza la siguiente sintaxis:

CREATE TABLE [BaseDatos.][Esquema.]NombreTabla (
Campo1 TipoDeDato,
Campo2 TipoDeDato, …) ON EsquemaPartición (CampoPartición)
GO

NOTAS IMPORTANTES:

Los nombres de las tablas pueden tener hasta 128 caracteres. 
Las tablas temporales un máximo de 116.

Se sugiere que los nombres de campos tengan al inicio en nombre de la tabla.

Agrupar la tablas en Esquemas.

Evitar en lo posible usar la propiedad  Identity

Por optimización se pueden crear campos calculados.

No usar guiones bajos no espacios en los nombres de las tablas 
ni en los nombres de campo.

RECOMENDACIONES AL DEFINIR TIPOS DE DATOS PARA CADA CAMPO
Datos alfanuméricos que no cambian la longitud como códigos, 
números de documentos y campos para estados deberían ser nchar.

Datos alfanuméricos que cambian la longitud como apellidos, nombres, 
direcciones, descripciones, etc deberían ser nvarchar.

Datos numéricos deberían ser Numeric y definir un rango amplio para que 
alcancen todos los valores posibles. (Ver tipos de datos en SQL Server)

Datos donde se guardan fecha deberían ser Date y si interesa guardar la 
hora junto con la fecha DateTime.

Datos donde se guarden imágenes deberían ser Image.

Evitar en lo posible usar la propiedad Identity.

RECOMENDACIONES PARA RESTRICCIONES DE LOS CAMPOS
Especificar correctamente los campos obligatorios con Not Null.

Para los campos que no son obligatorios de preferencia usar restricciones de tipo Default.

Los campos que sirven como clave foránea deberían tener el mismo nombre 
que tiene en la tabla donde es clave principal.

Si en un campo no se debe repetir el valor ingresado y no es la clave primaria, 
usar restricciones de tipo UNIQUE.

Es recomendable usar las restricciones de tipo Check para comprobar una o 
mas condiciones que deben de cumplir los datos para insertarlos en la tabla.
*/
