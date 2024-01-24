/* FUENTE: https://manualsqlserver.com/
master
------
Base de datos que registra toda la informaci�n 
del sistema para una instancia de SQL Server. 
La base de datos master es �nica en la instancia de SQL Server, 
en esta base de datos se puede consultar la existencia 
de todos los objetos de todas las bases de datos 
creadas o adjuntadas en la instancia.

model
-----
Se utiliza como plantilla o  modelo para todas las bases de 
datos creadas en la instancia de SQL Server con la instrucci�n 
Create Table sin especificar los valores y caracter�sticas 
para cada par�metro de Base de datos. Las modificaciones hechas 
a la base de datos model, como el tama�o de la base de datos, 
la intercalaci�n, el modelo de recuperaci�n y otras opciones, 
se aplicar�n a las bases de datos que se creen con posterioridad.

msdb
----
La utiliza el Agente SQL Server para programar alertas y trabajos. 
El agente SQL permite realizar los trabajos que ejecutan tareas, 
generalmente de aplicaciones para Inteligencia de Negocios y 
Toma de Decisiones.

tempdb
------
�rea de trabajo que contiene objetos temporales o conjuntos 
de resultados intermedios.

*/
