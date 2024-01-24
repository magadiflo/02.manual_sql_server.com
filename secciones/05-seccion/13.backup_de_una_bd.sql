/*-- BACKUP DE UNA BASE DE DATOS --

Copia de seguridad de una base de datos en SQL Server
Las bases de datos en SQL Server y en general en cualquier servidor de base de datos se deben respaldar cada cierto tiempo, 
es recomendable obtener una copia de seguridad de la base de datos completa una vez a la semana y 
obtener copias de seguridad diferenciales durante la semana.

Los horarios para obtener las copias de seguridad de seguridad deber�an coincidir cuando hay la
menor cantidad de usuarios conectados al servidor de base de datos.

Se sugiere Planes de mantenimiento para automatizar el trabajo de obtener copias de seguridad. 
(Ver Planes de Mantenimiento)

En el dispositivo usado para las copias de seguridad deber�a haber espacio suficiente para realizar 
la copia, es conveniente ir eliminando las copias de seguridad anteriores, se recomienda, de acuerdo 
al tama�o de la base de datos guardar las �ltimas tres copias de seguridad.

Considere de acuerdo a la importancia y la seguridad de la informaci�n, encriptar la base de datos 
(Ver copias de seguridad encriptadas) y adem�s guardar la copia de seguridad en un contenedor de 
una cuenta de almacenamiento de Microsoft Azure.

Copia de seguridad usando el asistente
1. En la ventana del explorador de objetos, pulsar bot�n derecho del mouse en la base de datos 
de la que se obtendr� la copia de seguridad, luego seleccionar Tareas �Task� y luego �Copia de 
seguridad� �Back up�. Para nuestro ejemplo se obtendr� una copia de seguridad de AdventureWorks.

2. En la ventana de para especificar las propiedades de la copia de seguridad seleccionar el tipo 
de copia de seguridad, para este ejercicio es Completa (Full), se puede obtener tambi�n una copia 
de seguridad Diferencial (primero debe obtenerse una copia completa).

3. En la opci�n Destino (Destination), aparecen tres botones (Add, Remove, Contents), 
pulsar Remover (Remove) si hubiera alguna especificaci�n de copia de seguridad, luego pulsar 
Agregar �Add� para especificar el destino y el nombre de la copia de seguridad.

4. Pulsar el bot�n con los tres puntos, luego seleccionar la carpeta de destino y escribir el 
nombre de la copia de seguridad. Para el ejercicio se ha creado en la unidad C: la carpeta BackupBD y 
el nombre de la copia de seguridad es: AventuraCopiaSeguridad.bak

Al pulsar Ok aparece la ventana con el destino especificado: 
C:\BackupBD\AventuraCopiaSeguridad.bak. Pulsar Ok

5. Note la copia de seguridad en el cuadro Destino (Destination). Para obtener la copia de seguridad, 
pulsar Ok

6. Al finalizar deber�a aparecer el mensaje de correcto. 
Podemos ver en la carpeta C:\BackupBD la copia de seguridad.



Script para copia de seguridad

La misma tarea realizada desde un script es como sigue:

BACKUP DATABASE [AdventureWorks]
TO DISK = 'C:\BackupBD\AventuraCopiaSeguridad.bak'
WITH NOFORMAT, NOINIT, NAME = 'AdventureWorks-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO
*/