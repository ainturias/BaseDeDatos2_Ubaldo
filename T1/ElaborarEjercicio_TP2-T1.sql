/* Elaborar el ejercicio 8 del TP2-T1 */

--8. Hacer una funcion denominada "GetProvxProd", 
--   que devuelva en una tabla los Proveedores que suministraron algún Producto
	use Demo;
	GO

	-------- OPCION #1 --------
	CREATE FUNCTION FN_GetProvxProd_2 ()
	RETURNS table --vamos a retornar en una tabla
	AS
	RETURN
		--aqui va lo que se va a mostrar en la tabla
		select prov.cprv
		from prov
		where prov.cprv IN (select sumi.cprv from sumi)
	GO
	--llamamos:
	select * from dbo.FN_GetProvxProd_2();
	--eliminamos:
	drop function dbo.FN_GetProvxProd_2;
	GO

	-------- OPCION #2 --------
	CREATE FUNCTION FN_GetProvxProd_3() 
	RETURNS TABLE 
	AS
		 RETURN ( SELECT distinct cprv FROM sumi )
	GO
	--llamamos:
	select * from dbo.FN_GetProvxProd_3();
	--eliminamos:
	drop function dbo.FN_GetProvxProd_3;
	GO