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
	CREATE FUNCTION FN_GetInven (@cprd integer)
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

	select * from prod
	select * from sumi
	select * from alma
	select * from sumi where sumi.cprd = 1;

--8. Hacer una funcion denominada "GetProvxProd", que devuelva en una tabla los Proveedores que suministraron algún Producto

--9. Hacer una funcion denominada "GetProvNoSumi", que devuelva en una tabla los Proveedores que todavía no suministraron productos.

--10. Hacer una funcion denominada "GetProvSumi", que devuelva en una tabla los nombres de los proveedores que suministraron algún producto color rojo

--11. Hacer una funcion denominada "GetProdxProv", que devuelva en una tabla productos existente en un almacen y que fueron suministrado por un proveedor en particular

--12. Hacer una funcion denominada "GetProdxColor", que devuelva en una tabla productos de color rojo suministrados por un proveedor

--13. Hacer una funcion denominada "GetProvTodo", que devuelva en una tabla los nombres de los proveedores que suministraron todos los productos.

--14. Hacer una funcion denominada "GetProvTres", que devuelva en una tabla los nombres de los proveedores que suministraron por lo menos dos productos diferentes

--15. Hacer una funcion denominada "GetProvOutCiud", que devuelva en una tabla los nombres de los proveedores que suministraron algún producto fuera de su ciudad.

--16. Hacer una funcion denominada "GetMaxCantxCiud", que devuelva la cantidad más alta suministrada de un producto en una ciudad en particular.

--17. Hacer una funcion denominada "GetUltFecxProv", que devuelva la ultima fecha que se suministró un producto por un proveedor en particular.

--18. Hacer una funcion denominada "GetPrimFecxColor", que devuelva la en qué fecha que por primera vez suministró algún producto de color Rojo.

--19. Hacer una funcion denominada "GetPromxProv", que devuelva el importe promedio de productos suministrados por un proveedor.

--20. Hacer una funcion denominada "HayStock", que devuelva 1 si un producto tiene stock disponibles en un determinado almacen,
--    de lo contrario que devuelva 0













