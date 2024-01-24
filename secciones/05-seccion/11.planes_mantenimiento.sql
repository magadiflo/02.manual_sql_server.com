/*-- PLANES DE MANTENIMIENTO EN SQL SERVER --

Planes de mantenimiento en SQL Server
Los Planes de mantenimiento de SQL Server son flujos de trabajo creados por el administrador 
del SQL Server para asegurar la optimizaci�n de la base de datos, estos flujos de trabajo son 
tareas que pueden crear copias de seguridad, reducir la base de datos, reorganizar 
los �ndices, etc.

Caracter�sticas de los planes de mantenimiento

Al crear un Plan de mantenimiento se crean de flujos de trabajo con diferentes tareas 
de mantenimiento las que se describen l�neas abajo.

En los Planes de mantenimiento se pueden crear scripts Transact-SQL personalizados.

Los planes de mantenimiento que trabajen con diferentes bases de datos se pueden organizar 
en sub planes.

Los Sub planes se pueden programar para ejecutarse a horas diferentes, lo que es recomendable 
para evitar congestionamiento de red.

Los planes de mantenimiento se pueden crear usando cualquier tipo de autenticaci�n, ya sea 
Windows y la autenticaci�n de SQL Server. 

Cada tarea se configura de manera individual y luego se asigna un flujo de trabajo.


Tareas del Plan de mantenimiento
Las tareas del Plan de mantenimiento se describen en la siguiente tabla.

Tarea => Descripci�n  de la tarea
Tarea Copia de seguridad de la base de datos => 
	Al usar la tarea, permite programar distintos tipos de copias de seguridad de bases de datos 
	de SQL Server.
Tarea Comprobar la integridad de la base de datos => 
	Al usar la tarea, permite comprobar la integridad de la base de datos.
Tarea Ejecutar trabajo del Agente SQL Server => Ejecuta trabajos del Agente SQL Server.
Tarea Ejecutar instrucci�n T- SQL => Ejecuta instrucciones de Transact-SQL, esta tarea 
	es interesante cuando se tienen que ejecutar instrucciones que no est�n incluidas en otras tareas.
Tarea Limpieza de historial => Elimina el historial de la base de datos del sistema msdb de SQL Server.
Tarea Limpieza de mantenimiento	=> Borra los archivos de copias de seguridad e informes de los 
	planes de mantenimiento ejecutados con anterioridad
Tarea Notificar al operador => Env�a mensajes de notificaci�n a operadores del Agente SQL Server. 
	Es similar al NetSend de Windows.
Tarea Volver a generar �ndice => Reindexa los �ndices de tablas y vistas de bases de datos de 
	SQL Server. 
Tarea Reorganizar �ndice => Reorganiza los �ndices de tablas y vistas de bases de datos de SQL Server.
Tarea Reducir base de datos	=> Reduce la base de datos de SQL Server.
Tarea Actualizar estad�sticas => Actualiza el conjunto de estad�sticas en la tablas o vistas de 
	la base de datos. 

*/
