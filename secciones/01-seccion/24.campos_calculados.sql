/*-- CAMPOS CALCULADOS --*/
/*
Los campos calculados en las tablas permiten almacenar los datos que se calculan en 
base a los campos de la misma tabla, es recomendable en casos donde las consultas 
pueden resultar muy pesadas ya que antes de mostrar la consulta con datos calculados 
debe realizar el c�lculo del mismo dato. Por ejemplo, en un documento de venta donde 
existe el precio de un art�culo y la cantidad vendida se podr�a guardar el importe de 
esta venta como campo calculado multiplicando los campos del precio y la cantidad.

Al insertar los registros, los campos calculados no se debe incluir en la instrucci�n, 
estos se calculan de manera autom�tica.

Recordar que algunos ejemplos de este tema lo vimos en el archivo 21.foreign_key_sql_server.sql,
cuando cre�bamos la tabla facturas, all� hab�an dos campos calculados:
	monto_igv AS (monto_igv * porcentaje_igv)
	monto_total AS (monto_sin_igv + monto_sin_igv * porcentaje_igv)

Tamb�n se agreg� un campo calculado en la tabla detalle_factuaras
	importe AS (cantidad_vendida * precio_venta)

Ejemplo: Crear una tabla productos donde se cree un campo calculado para obtener el 
valor del stock por registro

CREATE TABLE productos(
	codigo CHAR(10),
	descripcion VARCHAR(100) NOT NULL,
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	valor_stock AS (precio * stock), <----------------------- Campo calculado
	CONSTRAINT pk_productos PRIMARY KEY(codigo)
)
GO
*/