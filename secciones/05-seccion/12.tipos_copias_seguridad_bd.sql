/*-- TIPOS DE COPIAS DE SEGURIDAD DE BASE DE DATOS --

Backups en SQL Server
SQL Server admite varios tipos de copia de seguridad, que puedes combinar para implementar la 
copia de seguridad correcta y estrategia de recuperaci�n para una base de datos en particular 
basado en los requisitos del negocio y la recuperaci�n.

Copia de seguridad Completa
Una copia de seguridad completa de una base de datos incluye los archivos de datos y la 
parte activa del registro de transacciones. El primer paso en la copia de seguridad es 
realizar una operaci�n CHECKPOINT.

La parte activa del registro de transacciones incluye todos los detalles del reenv�o de 
transacci�n activo m�s antiguo.

Una copia de seguridad completa representa la base de datos en el momento en que se complet� 
la fase de lectura de datos de la copia de seguridad y sirve como l�nea de base en caso de 
falla del sistema. Las copias de seguridad completas no truncan el registro de transacciones.

Copia de seguridad diferencial
Una copia de seguridad diferencial guarda los datos que se han cambiado desde la �ltima copia de 
seguridad completa. Copias de seguridad diferenciales se basan en los contenidos del archivo de 
datos en lugar del contenido del archivo de registro y contienen extensiones que han sido modificado
desde la �ltima copia de seguridad completa de la base de datos. Las copias de seguridad diferenciales 
generalmente son m�s r�pidas de restaurar que copias de seguridad de registro de transacciones, 
pero tienen menos opciones disponibles. Por ejemplo, la recuperaci�n de un punto en el tiempo 
no es disponible a menos que las copias de seguridad diferenciales tambi�n se combinen con copias 
de seguridad de archivos de registro

Copia de seguridad de registro de transacciones
Las copias de seguridad del registro de transacciones registran cualquier cambio en la base de datos 
realizando una copia de seguridad de los registros de la transacci�n Iniciar sesi�n. La recuperaci�n 
de un punto en el tiempo es posible con copias de seguridad de registros de transacciones que son 
generalmente mucho m�s peque�as que copias de seguridad completas de la base de datos, esto significa 
que se pueden ejecutar con mucha m�s frecuencia. Despu�s de que el registro de transacciones es copia 
de seguridad, los registros de registro que se han respaldado y no est�n en la parte actualmente 
activa de el registro de transacciones est� truncado. Las copias de seguridad del registro de 
transacciones no est�n disponibles en el modelo de recuperaci�n simple.

Copias de seguridad de archivos o grupos
Si no es pr�ctico realizar una copia de seguridad completa de la base de datos en bases de datos 
muy grandes, puede realizar una base de datos copias de seguridad de archivos o grupos de archivos 
para hacer copias de seguridad de archivos espec�ficos o grupos de archivos

Copia de seguridad parcial
Si la base de datos incluye algunos grupos de archivos de solo lectura, puede simplificar el proceso 
de copia de seguridad utilizando un parcial apoyo. Una copia de seguridad parcial es similar a una 
copia de seguridad completa, pero contiene solo los datos en el grupo de archivos primario, cada 
grupo de archivos de lectura / escritura y cualquier archivo de solo lectura especificado. 
Una copia de seguridad parcial de una base de datos de solo lectura contiene solo el grupo de 
archivos primario.

Copia de seguridad de registro de cola
Una copia de seguridad de registro de transacciones realizada justo antes de una operaci�n de 
restauraci�n se denomina copia de seguridad de registro de cola. Por lo general, taillog las 
copias de seguridad se toman despu�s de una falla en el disco que afecta �nicamente a los archivos 
de datos. Desde SQL Server 2005 en adelante, SQL

El servidor ha requerido que realice una copia de seguridad de registro de cola antes de que 
le permita restaurar una base de datos, proteger contra la p�rdida de datos inadvertida. Adem�s, 
las copias de seguridad de registro de cola a menudo son posibles incluso cuando los archivos de 
datos de la base de datos ya no son accesible.

Copia de seguridad modo copia
SQL Server 2005 y versiones posteriores admiten copias de seguridad que son �tiles para tomar
copias de copias de seguridad fuera del sitio o al realizar operaciones de restauraci�n en l�nea. 
A diferencia de otras copias de seguridad, una copia de seguridad �nica no afecta los procedimientos 
generales de copia de seguridad y restauraci�n de la base de datos. Todos los modelos de recuperaci�n 
admiten Copias de seguridad de datos solo de copia.
*/