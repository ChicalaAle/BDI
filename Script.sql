--PRIMER EJECUCION DE CONSULTA -----------------------------------------------------------------
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go;


--SEGUNDA EJECUCION DE CONSULTA ----------------------------------------------------------------------------

--SqlServer toma la PK de gasto como indice CLUSTERED, asique para crear el solicitado en periodo debemos primero eliminar el actual
ALTER TABLE gasto
DROP CONSTRAINT PK_gasto;
go;

--Transformamos la PK en un indice NONCLUSTERED
ALTER TABLE gasto
ADD CONSTRAINT PK_gasto PRIMARY KEY NONCLUSTERED (idGasto);
go;

--Creamos un nuevo indice CLUSTERED en periodo
CREATE CLUSTERED INDEX IX_gasto_periodo
ON gasto (periodo);
go;
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go;


--TERCER EJECUCION DE CONSULTA------------------------------------------------------------------
-- Elimina el índice agrupado anterior
DROP INDEX IX_gasto_periodo ON gasto;
go;

-- Crea un nuevo índice agrupado en periodo, fechapago e idtipogasto
CREATE CLUSTERED INDEX IX_Gasto_Periodo_FechaPago_idTipoGasto
ON gasto (periodo, fechapago, idtipogasto);
go;

--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go;

