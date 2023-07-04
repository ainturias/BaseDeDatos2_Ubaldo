/*  TP2-T1 (Programación de Funciones en Transact SQL)   */

	use Demo;
	GO

-- I) Revisar el Diagrama e Instancia de la Base de Datos "Demo"
-- II) Crear y poblar la Base de Datos "Demo" usando el Script SQL denominado EsqBD_Demo.sql
-- III) Elaborar los siguientes programas en la Base de Datos "Demo" usando TRANSACT-SQL
	GO
--1. Hacer una funcion denominada "Suma", que reciba dos numeros y retorne la suma de ambos numeros.
	CREATE FUNCTION FN_Suma(@num1 int, @num2 int)
	RETURNS Integer
	AS
	BEGIN
		Declare @res int
		set @res = @num1 + @num2
		RETURN @res
	END;
	GO
	-- se lo llama así:
	select dbo.FN_Suma(10, 20);
	-- se elimina una funcion así:
	DROP FUNCTION FN_Suma;
	GO
	
--2. Hacer una funcion denominada "GetCiudad", que reciba como parámetro el código del proveedor y retorne la ciudad donde vive el proveedor.
	CREATE FUNCTION FN_GetCiudad(@cprv int)
	RETURNS varchar(10)		--tenemos que especifiar el tamaño de salida, por defecto es 1.
	AS
	BEGIN
		declare @ciudad varchar(10)
		select @ciudad = prov.ciud from prov where prov.cprv = @cprv
		return @ciudad
	END;
	GO
	--llamamos:
	select dbo.FN_GetCiudad(2);
	--eliminamos:
	drop function FN_GetCiudad
	GO

--3. Hacer una funcion denominada "GetNombre", que reciba el codigo del proveedor y retorne su nombre.
	CREATE FUNCTION FN_GetNombre (@cprv int)
	RETURNS varchar(255)
	AS
	BEGIN
		declare @nombre varchar(20)
		select @nombre = prov.nomb from prov where prov.cprv = @cprv
		return @nombre
	END;
	GO
	-- llamamos:
	select dbo.FN_GetNombre(1);
	-- eliminamos:
	drop function dbo.FN_GetNombre;
	GO

--4. Hacer una funcion denominada "CalcularPuntos", que reciba el codigo del proveedor y calcule los puntos de bonificacion en base a los 
--	 siguientes criterios:
	-- Si el proveedor suministro entre 1 y 20 bs se le asigna 10 puntos.
	-- Si el proveedor suministro entre 21 y 50 bs se le asigna 15 puntos.      
	-- Si el proveedor suministro mas de 51 bs se le asigna 20 puntos.
	CREATE FUNCTION FN_CalcularPuntos (@cprv int)
	RETURNS Integer
	AS
	BEGIN
		declare @c_cprv integer
		declare @importe decimal(12,2)
		declare @puntosTotales integer
		set @puntosTotales = 0
		--Declaramos un cursor:
		declare PuntosCursor Cursor 
			for select cprv, impt from sumi
		--Abrimos el cursor:
		open PuntosCursor
		--navegamos en el cursor		--usamos into para cargar los datos del cursor a las variables que creamos
		fetch next from PuntosCursor into @c_cprv, @importe
		while @@FETCH_STATUS = 0
		BEGIN
			if(@c_cprv = @cprv)
			BEGIN
				set @puntosTotales = @puntosTotales +
				(case
					when (@importe>=1 and @importe<=20) then 10
					when (@importe>=21 and @importe<=50) then 15
					when (@importe>=51) then 20
					else 0
				end)
			END;
			fetch next from puntoscursor into @c_cprv, @importe
		END;
		--Cerramos el cursor:
		close PuntosCursor
		--Liberamos el cursor:
		deallocate PuntosCursor
		return @puntosTotales
	END;
	GO
	--llamamos:
	select dbo.FN_CalcularPuntos(1);
	--eliminamos:
	drop function dbo.FN_CalcularPuntos;
	--comprobacion (cprv = 1) //20 + 15 + 20 + 10 + 20 + 20 = 105
	GO;

--5. Hacer una funcion denominada "GetStock", que devuelva el Stock existente de un producto que se encuentra en una ciudad en particular.
	CREATE FUNCTION FN_GetStock (@calm int)
	RETURNS Integer
	AS
	BEGIN
		declare @stock int
		set @stock = (select ISNULL(SUM(sumi.cant),0) from sumi, alma where sumi.calm = alma.calm and alma.calm = @calm)
		return @stock
	END;
	GO
	--llamamos:
	select dbo.FN_GetStock(1);
	--eliminamos:
	drop function dbo.FN_GetStock;
	GO
	   
--6. Hacer una funcion denominada "GetInven", que devuelva el Inventario Valorado de un producto.
<<<<<<< HEAD
	CREATE FUNCTION FN_GetInven (@cprd int)
=======
	CREATE FUNCTION FN_GetInven (@cprd integer)
>>>>>>> ffe57aed4a2b52a58808f152cb7d1892f2a58955
	RETURNS decimal(12,2)
	AS
	BEGIN
		declare @InventarioValorado decimal(12,2)
		set @InventarioValorado = (select ISNULL(SUM(sumi.impt),0) from sumi where sumi.cprd = @cprd)
		return @InventarioValorado
	END;
	GO
	--llamamos:
	select dbo.FN_GetInven(1);
	--eliminamos:
	drop function dbo.FN_GetInven;
	GO
	
--7. Hacer una funcion denominada "GetProdxCiud", que devuelva en una tabla los Productos existentes en una ciudad en particular
	CREATE FUNCTION FN_GetProdxCiud (@ciud as varchar(2) )
	RETURNS table
	AS
	RETURN
		--definimos la tabla que será retornada
		select sumi.cprd, prod.nomp, alma.ciud
		from sumi, prod, alma 
		where sumi.cprd = prod.cprd and sumi.calm = alma.calm and alma.ciud = @ciud
	GO
	--llamamos:
	select * from dbo.FN_GetProdxCiud('BE');
	--eliminamos:
	drop function FN_GetProdxCiud;
	GO;

	select * from prod
	select * from sumi
	select * from alma
	select * from sumi where sumi.cprd = 1;

--8. Hacer una funcion denominada "GetProvxProd", que devuelva en una tabla los Proveedores que suministraron algún Producto
	CREATE FUNCTION FN_GetProvxProd ()
	RETURNS TABLE
	AS
	RETURN
		--definimos la tabla que será retornada
		select * 
		from prov
		where prov.cprv IN (select sumi.cprv from sumi, prod where sumi.cprd = prod.cprd)
	GO
	--llamamos:
	select * from dbo.FN_GetProvxProd();
	--eliminamos:
	drop function dbo.FN_GetProvxProd;
	GO

--9. Hacer una funcion denominada "GetProvNoSumi", que devuelva en una tabla los Proveedores que todavía no suministraron productos.
	
	CREATE FUNCTION FN_GetProvNoSumi ()
	RETURNS TABLE
	AS
	RETURN
		--definimos la tabla que será retornada
		select * 
		from prov
		where prov.cprv NOT IN (select sumi.cprv from sumi, prod where sumi.cprd = prod.cprd)
		--Y si llamamos a una funcion dentro de otra función sería así:
		--where prov.cprv NOT IN (select cprv from dbo.FN_GetProvxProd())
	GO
	--llamamos:
	select * from dbo.FN_GetProvNoSumi();
	--eliminamos:
	drop function dbo.FN_GetProvNoSumi;
	GO

--10. Hacer una funcion denominada "GetProvSumi", que devuelva en una tabla los nombres de los proveedores que suministraron 
--	  algún producto color rojo.
	CREATE FUNCTION FN_GetProvSumi ()
	RETURNS TABLE
	AS
	RETURN
		--Definimos la tabla que será retornada
		select prov.cprv as CodigoProveedor, prov.nomb as NombreProveedor
		from prov
		where prov.cprv IN (select sumi.cprv from sumi, prod where sumi.cprd = prod.cprd and prod.colo = 'ROJO')
	GO
	--llamamos:
	select * from dbo.FN_GetProvSumi();
	--eliminamos:
	drop function dbo.FN_GetProvSumi;
	GO

--11. Hacer una funcion denominada "GetProdxProv", que devuelva en una tabla productos existente en un almacen y que fueron 
--	  suministrado por un proveedor en particular.
	CREATE FUNCTION FN_GetProdxProv (@calm int, @cprv int)
	RETURNS TABLE
	AS
	RETURN
		--Definimos la tabla que será retornada
		select prod.cprd as CodigoProducto, prod.nomp as NombreProducto
		from sumi, prod, alma, prov 
		where sumi.cprd=prod.cprd and sumi.calm=alma.calm and sumi.cprv=prov.cprv
			and prov.cprv =@cprv and alma.calm = @calm
	GO
	--llamamos:
	select * from dbo.FN_GetProdxProv(2,1);
	--eliminamos:
	drop function dbo.FN_GetProdxProv;
	GO;

--12. Hacer una funcion denominada "GetProdxColor", que devuelva en una tabla productos de color rojo suministrados por un proveedor.
	CREATE FUNCTION FN_GetProdxColor (@cprv int)
	RETURNS table
	AS
	RETURN
		--Definimos la tabla que será retornada
		select prod.cprd as CodigoProducto, prod.colo as ColorProducto, sumi.cprv as CodigoProveedor
		from sumi, prod
		where sumi.cprd=prod.cprd and prod.colo='ROJO' and sumi.cprv=1
	GO
	--llamamos:
	select * from dbo.FN_GetProdxColor(1);
	--eliminamos:
	drop function FN_GetProdxColor;
	GO;

--13. Hacer una funcion denominada "GetProvTodo", que devuelva en una tabla los nombres de los proveedores que suministraron todos los productos.
	CREATE FUNCTION FN_GetProvTodo ()
	RETURNS table
	AS
	RETURN
		--aqui va el codigo que se ejecutará
		select prov.cprv as CodigoProveedor, prov.nomb as NombreProveedor, COUNT(DISTINCT sumi.cprd) as CantidadProdSuministrado
		from prov, sumi
		where prov.cprv=sumi.cprv
		group by prov.cprv, prov.nomb
		having COUNT(DISTINCT sumi.cprd) = (select COUNT(prod.cprd) from prod)
	GO
	--llamamos:
	select * from dbo.FN_GetProvTodo();
	--eliminamos:
	drop function dbo.FN_GetProvTodo;
	GO;

	
--14. Hacer una funcion denominada "GetProvTres", que devuelva en una tabla los nombres de los proveedores que suministraron por lo 
--	  menos dos productos diferentes
	CREATE FUNCTION FN_GetProvTres ()
	RETURNS table
	AS
	RETURN
		--definimos la tabla que será retornada
		select prov.cprv as CodigoProveedor, prov.nomb as NombreProveedor, COUNT(DISTINCT sumi.cprd) as CantidadProdSumiDiferentes
		from prov, sumi
		where prov.cprv=sumi.cprv
		group by prov.cprv, prov.nomb
		having COUNT(DISTINCT sumi.cprd) >= 2
	GO
	--llamamos:
	select * from dbo.FN_GetProvTres();
	--eliminamos:
	drop function dbo.FN_GetProvTres;
	GO;

--15. Hacer una funcion denominada "GetProvOutCiud", que devuelva en una tabla los nombres de los proveedores que suministraron algún 
--	  producto fuera de su ciudad.
	CREATE FUNCTION FN_GetProvOutCiud()
	RETURNS table
	AS
	RETURN
		--definimos la tabla que se retornará
		select prov.cprv as CodigoProveedor, prov.nomb as NombreProveedor
		from sumi, prov, alma
		where sumi.cprv=prov.cprv and sumi.calm=alma.calm
			and prov.ciud != alma.ciud
		group by prov.cprv, prov.nomb
	GO
	--llamada:
	select * from dbo.FN_GetProvOutCiud();
	--eliminamos:
	drop function dbo.FN_GetProvOutCiud;
	GO

--16. Hacer una funcion denominada "GetMaxCantxCiud", que devuelva la cantidad más alta suministrada de un producto en una ciudad en particular.
	CREATE FUNCTION FN_GetMaxCantxCiud (@cprd int, @ciudad varchar(2))
	RETURNS int
	AS
	BEGIN
		declare @CantidadAlta int
		select @cantidadAlta = MAX(sumi.cant)
		from sumi, prod, alma
		where sumi.cprd=prod.cprd and sumi.calm=alma.calm
			and prod.cprd=@cprd and alma.ciud=@ciudad
		return @CantidadAlta
	END
	GO
	--llamamos:
	select dbo.FN_GetMaxCantxCiud (1,'SC');   --(1-CB)(2-SC)(3-LP)(4-BE)
	--eliminamos:
	drop function dbo.FN_GetMaxCantxCiud;
	GO
	
--17. Hacer una funcion denominada "GetUltFecxProv", que devuelva la ultima fecha que se suministró un producto por un proveedor en particular.
	CREATE FUNCTION FN_GetUltFecxProv (@cprv int)
	RETURNS date  --tambien podemos retornar un varchar()
	AS
	BEGIN
		declare @UltimaFecha date
		select @UltimaFecha=MAX(sumi.ftra)
		from sumi, prov
		where sumi.cprv=prov.cprv
			and sumi.cprv=@cprv
		return @UltimaFecha
	END
	GO
	--llamamos:
	select dbo.FN_GetUltFecxProv(1);
	--eliminamos:
	drop function dbo.FN_GetUltFecxProv;
	GO

--18. Hacer una funcion denominada "GetPrimFecxColor", que devuelva la en qué fecha que por primera vez suministró algún producto de color Rojo.
	CREATE FUNCTION FN_GetPrimFecxColor ()
	RETURNS date
	AS
	BEGIN
		declare @PrimFecha date
		select @PrimFecha = MIN(sumi.ftra)
		from sumi, prod
		where sumi.cprd=prod.cprd
			and prod.colo = 'ROJO'
		return @PrimFecha
	END
	GO
	--llamamos:
	select dbo.FN_GetPrimFecxColor();
	--eliminamos:
	drop function dbo.FN_GetPrimFecxColor;
	GO

--19. Hacer una funcion denominada "GetPromxProv", que devuelva el importe promedio de productos suministrados por un proveedor.
	CREATE FUNCTION FN_GetPromxProv (@cprv int)
	RETURNS decimal(5,2)
	AS
	BEGIN
		declare @promedio decimal(5,2)
			select @promedio = AVG(sumi.impt) --el castear o convertir (redondear) no es necesario por que en la salida lo hace.
			from sumi
			where sumi.cprv=@cprv
		return @promedio
	END
	GO
	--llamamos:
	select dbo.FN_GetPromxProv(1);
	--eliminamos:
	drop function dbo.FN_GetPromxProv;
	GO

--20. Hacer una funcion denominada "HayStock", que devuelva 1 si un producto tiene stock disponibles en un determinado almacen,
--    de lo contrario que devuelva 0
	CREATE FUNCTION FN_HayStock (@cprd int, @calm int)
	RETURNS int
	AS
	BEGIN
		declare @res int
		if((select ISNULL(SUM(sumi.cant),0) from sumi where sumi.calm=@calm and sumi.cprd=@cprd) > 0)
			Begin
				set @res = 1;
			End
		else
			Begin
				set @res = 0;
			End
		return @res
	END
	GO
	--llamamos:
	select dbo.FN_HayStock(4,2);
	--eliminamos:
	drop function dbo.FN_HayStock;
