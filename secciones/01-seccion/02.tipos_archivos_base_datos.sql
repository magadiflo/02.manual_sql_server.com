/*
PRINCIPAL (.mdf)
Archivos Maestros de Bases de Datos (Master Database Files o MDF)

El archivo de datos principal incluye la información 
de inicio de la base de datos y apunta a los demás 
archivos de la misma. Los datos y objetos del usuario 
se pueden almacenar en este archivo o en archivos de 
datos secundarios. Cada base de datos tiene un archivo 
de datos principal. La extensión recomendada para los 
nombres de archivos de datos principales es mdf


SECUNDARIOS (.ndf)
Los archivos de datos secundarios son opcionales, están 
definidos por el usuario y almacenan los datos del usuario. 
Se pueden utilizar para distribuir datos en varios discos 
colocando cada archivo en una unidad de disco distinta. 
Además, si una base de datos supera el tamaño máximo establecido
para un archivo de Windows, puede utilizar los archivos de 
datos secundarios para permitir el crecimiento de la base de datos. 
La extensión de nombre de archivo recomendada para archivos de 
datos secundarios es ndf


REGISTRO DE TRANSACCIONES (.ldf)
Archivos de Registros de Bases de Datos (Log Database Files o LDF)

Los archivos del registro de transacciones contienen
la información de registro que se utiliza para recuperar
la base de datos. Cada base de datos debe tener al menos 
un archivo de registro. La extensión recomendada para los 
nombres de archivos de registro es ldf. 

El propósito principal del uso de archivo de registro en 
SQL Server es revertir la base de datos en caso de pérdida de datos.

Contiene un registro de las recientes acciones ejecutadas 
por la base de datos, y se utiliza para realizar un seguimiento 
de eventos para que la base de datos puede recuperarse de los 
fallos de hardware u otros cierres inesperados. archivos LDF 
son registros de transacciones que contienen una historia de 
la actividad de ambas transacciones totalmente comprometidos 
y comprometidas parcialmente a la base de datos. Después de 
una parada inesperada, SQL Server puede utilizar el registro 
de transacciones para restaurar la base de datos al estado 
exacto antes del fallo. 
*/