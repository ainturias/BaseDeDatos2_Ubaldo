/* TP3-T1 (Programación de PA en Transact SQL) */
use preventas;
--1. Crear la Base de Datos "preventas" usando el Esquema Fisico de la Base de Datos preventa
--2. Elabora los siguientes Procedimientos Almacenados en la Base de Datos preventas
	GO;
--EJERCICIOS: 
--1. Hacer un PA denominado PA_Setear, donde declare variables de tipo Fecha, Entero, Real y Cadena, inicializarlas y mostrar su valor.

	-- OPCION #1 --
	CREATE PROCEDURE PA_Setear
	AS
	BEGIN
		--declaramos variables
		declare @fecha as date
		declare @entero as integer
		declare @real as float
		declare @cadena as varchar(50)

		--inicializamos variables
		set @fecha = GETDATE()
		set @entero = 20
		set @real = 10.2
		set @cadena = 'HOLA MUNDO como estamos'

		SELECT  'Fecha: '  + CONVERT(VARCHAR(10), @fecha) AS Fecha,
				'Entero: ' + CONVERT(VARCHAR(10), @entero) AS Entero,
				'Real: '   + CONVERT(VARCHAR(20), @real) AS Real,
				'Cadena: ' + @cadena AS Cadena
	END
	GO
	--llamamos:
	execute dbo.PA_Setear
	--eliminamos:
	drop procedure dbo.PA_Setear;
	GO

	-- OPCION #2 -- (manera del ingeniero)
	CREATE PROCEDURE PA_Setear2
	(	@fecha  date output, 
		@entero integer output, 
		@real   float output, 
		@cadena varchar(50) output
	)
	AS
	BEGIN
		select @fecha=GETDATE(), @entero=20, @real=11.5, @cadena='Hello world'
	END
	GO
	--llamamos:
	--primeramente tenemos que declarar para guardar en variables lo que retorna.
	declare @fecha date, @entero int, @real float, @cadena varchar(50)
	--de esta menera ejecutamos el procedimiento almacenado
	execute dbo.PA_Setear2 @fecha output, @entero output, @real output, @cadena output;
	--de esta manera mostramos los resultados.
	print 'Fecha: '  + cast(@fecha as varchar(50)) +
		  'Entero: ' + cast(@entero as varchar(50)) +
		  'Real: '   + cast(@real as varchar(50)) +
		  'Cadena: ' + @cadena
	--eliminamos:
	drop procedure dbo.PA_Setear2;
	--NOTA: lo que estamos haciendo es que no estamos pasando parametros de entrada, solamente estamos capturando todos los 
	-- parámetros de salida(output) del procedimiento y lo estamos almacenando en variables que hemos creado fuera del PA.
	GO

--2. Hacer un PA denominado PA_Igual, en la que se le pasan 2 números y retorne 1 si son iguales, 0 si no lo son.
	CREATE PROCEDURE PA_Igual
		@Numero1 int,
		@Numero2 int,
		@res int output
	AS
	BEGIN
		if(@Numero1 = @Numero2)
			Begin
				set @res = 1;
			End
		else
			Begin
				set @res = 0;
			End
	END
	GO
	--llamamos:
	declare @resultado int
	execute dbo.PA_Igual 5,4,@resultado output;
	print @resultado;
	--eliminamos:
	drop procedure dbo.PA_Igual;
	GO

--3. Hacer un PA denominado PA_Nombre, que reciba como parámetro su <nombre> y muestre un mensaje "Hola <nombre>".
	CREATE PROCEDURE PA_Nombre
		@nombre varchar(20) output
	AS
	BEGIN
		declare @mensaje varchar(100)
		set @mensaje = 'Hola ' + @nombre
		print @mensaje
	END
	GO
	--llamamos:
	execute dbo.PA_Nombre 'alexander';
	--eliminamos:
	drop procedure dbo.PA_Nombre;
	GO

--4. Hacer un PA denominado PA_GetProv, que reciba como parámetro el código del proveedor y retorne la ciudad donde vive 
--	 el proveedor.
	CREATE PROCEDURE PA_GetProv
		@codProv int,
		@ciudad char(2) output
	AS
	BEGIN
		select @ciudad = ciud
		from prov 
		where prov.cprv = @codProv
	END
	GO
	--llamamos:
	declare @ciudad char(2), @codProv int
	set @codProv = 3
	execute dbo.PA_GetProv @codProv, @ciudad output
	print @ciudad
	--eliminamos:
	drop procedure dbo.PA_GetProv;
	GO
	
--5. Hacer un PA denominado PA_ExisteProducto, que reciba como parámetro el código del producto y retorne 1 si existe el 
--   producto de lo contrario retorne 0.
	CREATE PROCEDURE PA_ExisteProducto
		@codProd int,
		@res int output
	AS
	BEGIN
		If EXISTS (select cprd from prod where cprd = @codProd)
			set @res = 1
		else
			set @res = 0
	END
	GO
	--llamamos:
	declare @cprd int, @res int
	set @cprd = 8
	execute dbo.PA_ExisteProducto @cprd, @res output
	print @res
	--eliminamo:
	drop proc dbo.PA_ExisteProducto;
	GO

--6. Hacer un PA denominado PA_LeerProducto, que reciba como parámetro el código del producto y retorne  nombre y el color 
--   del producto si el código del producto introducido es valido, de lo contrario debe retornar nulo para ambos casos.
	CREATE PROCEDURE PA_LeerProducto
		@codProd int, 
		@nomProd varchar(20) output,
		@colorProd varchar(20) output
	AS
	BEGIN
		if EXISTS (select * from prod where cprd=@codProd)
			Begin
				select @nomProd=nomp, @colorProd=colo 
				from prod 
				where cprd = @codProd
			End
		else
			Begin
				set @nomProd = null
				set @colorProd = null
			End
	END
	GO
	--llamamos:
	declare @cprd int, @nomp varchar(20), @color varchar(20)
	set @cprd = 4
	execute dbo.PA_LeerProducto @cprd, @nomp output, @color output;
	print 'NombreProducto: ' + @nomp + 'ColorProducto: ' + @color
	--eliminamos:
	drop proc dbo.PA_LeerProducto;
	GO

--7. Hacer un PA denominado PA_TotalStock que reciba como parámetro el código del producto y retorne el TotalStock existente 
--   del producto. (El stock es la sumatoria de cantidades suministrada del producto).
	CREATE PROCEDURE PA_TotalStock
		@codProd int, 
		@TotalStock int output
	AS
	BEGIN 
		select @TotalStock = ISNULL(SUM(cant),0) from sumi where cprd = @codProd
	END
	GO
	--llamamos:
	declare @codProd int, @TotalStock int
	set @codProd = 4
	execute dbo.PA_TotalStock @codProd, @TotalStock output;
	print 'Total Stock: ' + cast(@TotalStock as varchar(5))
	--eliminamos:
	drop procedure dbo.PA_TotalStock;
	GO

--8. Hacer un PA denominado PA_HayStock que reciba como parámetro el código del producto y que retorne 1 si hay Stock 
--	 disponible, de lo contrario que retorne 0. 
	CREATE PROCEDURE PA_HayStock
		@codProd int, 
		@hayStock int output
	AS
	BEGIN 
		if EXISTS(select * from sumi where cprd = @codProd)
			set @hayStock = 1
		else
			set @hayStock = 0
	END
	GO
	--llamamos:
	declare @cprd int, @hayStock int
	set @cprd = 4
	execute dbo.PA_HayStock @cprd, @hayStock output;
	print @hayStock
	--eliminamos:
	drop proc dbo.PA_HayStock;
	GO

--9. Hacer un PA denominado PA_StockxCiudad que reciba el código del producto y la ciudad del almacen, y que retorne el 
--	 Stock existente del producto en la ciudad. (El stock es la sumatoria de cantidades suministrada del producto en una 
--	 determinada ciudad).
	
	CREATE PROCEDURE PA_StockxCiudad
		@codProd int, 
		@ciudad char(2), 
		@Stock int output
	AS
	BEGIN
		select @Stock = ISNULL(SUM(cant),0) from sumi, alma where cprd = @codProd and alma.ciud = @ciudad
	END 
	GO
	--llamamos:
	declare @codProd int, @ciudad char(2), @Stock int
	set @codProd = 2
	set @ciudad = 'SC'
	execute dbo.PA_StockxCiudad @codProd, @ciudad, @Stock output;
	print @Stock
	--eliminamos:
	drop procedure dbo.PA_StockxCiudad;
	GO

--10. HAcer un PA denominado PA_HayStockxAlmacen que reciba como parámetro el código del producto y el código del almacén, 
--    y que retorne 1 si hay Stock disponible del producto en esa ciudad, de lo contrario que retorne 0. (usar PA_StockxAlmacen).

	-- PROCEDIMIENTO #1 --
	CREATE PROCEDURE PA_HayStockxAlmacen
		@codProd int,
		@codAlma int,
		@res int output
	AS
	BEGIN
		execute dbo.PA_StockxAlmacen @codProd, @codAlma, @res output
		if (@res != 0)
			set @res = 1;
		else
			set @res = 0;
	END
	GO

	-- PROCEDIMIENTO #2 --
	CREATE PROCEDURE PA_StockxAlmacen
		@codProd int, 
		@codAlma int,
		@Stock int output
	AS
	BEGIN
		--retorna el la cantidad total de un producto en un almacén
		select @Stock = ISNULL(SUM(cant),0) from sumi where cprd = @codProd AND calm = @codAlma
	END
	GO

	--llamamos:
	declare @codProducto int, @codAlmacen int, @resultado int
	set @codProducto = 1
	set @codAlmacen = 1
	execute dbo.PA_HayStockxAlmacen @codProducto, @codAlmacen, @resultado output;
	print @resultado
	--eliminamos:
	drop procedure dbo.PA_HayStockxAlmacen;

--11. Hacer un denominado PA_ValidarPreVenta, que reciba el Numero de Venta y que retorne 1 si todos los productos de la 
--    Pre Venta cuenta con Stock suficiente, de lo contrario retorna 0. (PA_StockxAlmacen).  Se debe insertar datos a la 
--    tabla pventas y dventas para probar.


--12. Hacer un PA denominado PA_TotalPreVenta, que reciba el Numero de Venta y que retorne  el Importe Total de la Pre Venta. 

--13. Hacer un PA denominado PA_DescPreVenta, que reciba como parámetro Numero de Venta y retorne el importe de descuento 
--    de la Pre Ventas, el descuento es dado bajo los siguientes criterios:
	--    Si el importe total de la pre venta esta entre 10 y 20 bs se aplica un descuento de 10%
	--    Si el importe total de la pre venta esta entre 11 y 50 bs se aplica un descuento de 15% 
	--    Si el importe total de la pre venta es mayor a 50 bs se aplica un descuento de 20% 
--14. Hacer un PA denominado PA_PromPreVenta, que reciba como parámetro Numero de Venta y retorne el importe promedio de las 
--    cantidades los producto de la Pre Ventas.

--15. Hacer un PA denominado PA_DelDetPreVentas, que reciba como parámetro Numero de Ventas y elimina las tuplas de las 
--    tablas dventas.

--16. hacer un PA denominado PA_ProvSumistra, que reciba  el código del proveedor y retorne 1 si el proveedor ha suministrado 
--    algún Producto, de lo contrario retorna 0.

--17. Hacer un PA denominado PA_ListaProvSumistra, que muestre la lista de los Proveedores que Suministraron algún 
--    Producto (usar PA_ProvSumistra).






