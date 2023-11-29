-- Configuración inicial
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;

-- Creación de índice agrupado en la tabla gasto
CREATE CLUSTERED INDEX IX_gasto_periodo ON gasto (periodo);
go;

-- Creación de usuarios y asignación de permisos
CREATE LOGIN UsuarioAdmin WITH PASSWORD = 'pwAdmin';
CREATE LOGIN UsuarioSoloLectura WITH PASSWORD = 'pwSoloLectura';

CREATE USER UsuarioAdmin FOR LOGIN UsuarioAdmin;
ALTER ROLE db_owner ADD MEMBER UsuarioAdmin;

CREATE USER UsuarioSoloLectura FOR LOGIN UsuarioSoloLectura;
ALTER ROLE db_datareader ADD MEMBER UsuarioSoloLectura;

-- Creación de procedimiento almacenado y permisos
GRANT EXECUTE ON dbo.InsertarAdministrador TO UsuarioSoloLectura;

-- Inserciones con usuarios y prueba de permisos
EXECUTE AS LOGIN = 'UsuarioAdmin';
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE());
REVERT;

EXECUTE AS LOGIN = 'UsuarioSoloLectura';
-- La siguiente instrucción debería fallar debido a los permisos revocados
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE());
REVERT;

-- Ejecución de procedimientos almacenados con diferentes usuarios
EXECUTE AS LOGIN = 'UsuarioAdmin'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT;

EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT;

-- Revocación de permisos y prueba posterior
REVOKE EXECUTE ON dbo.InsertarAdministrador FROM UsuarioSoloLectura;

EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
-- La siguiente instrucción debería fallar debido al permiso revocado
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT;

-- Creación de tabla y trigger para auditoría
-- (Suponiendo que auditoria es una tabla válida)
-- (Crea la tabla antes de ejecutar este bloque)
-- (Crea el trigger antes de ejecutar este bloque)
-- ...

-- Ejecución de operaciones con trigger
EXECUTE AS LOGIN = 'UsuarioAdmin'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT;

EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'RONCAGLIA ALFREDO ALEJANDRO', 'S', 3794244222, 'M', '19220828';
REVERT;

-- Creación de usuario para vistas
CREATE LOGIN UsuarioVista WITH PASSWORD = 'pwVista';
CREATE USER UsuarioVista FOR LOGIN UsuarioVista;

-- Asignación de permisos de select en la tabla administrador
GRANT SELECT ON dbo.administrador TO UsuarioVista;

-- Prueba de permisos con vista
EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * FROM dbo.VistaAdministrador; -- La vista debería mostrarse
REVERT;

-- Revocación de permisos y prueba posterior
REVOKE SELECT ON dbo.administrador FROM UsuarioVista;

EXECUTE AS LOGIN = 'UsuarioVista'; 
-- La siguiente instrucción debería fallar debido al permiso revocado
SELECT * FROM dbo.VistaAdministrador;
REVERT;

-- Creación de índices columnares
USE base_consorcio;

-- Creación de índice columnar en la tabla gasto
CREATE CLUSTERED COLUMNSTORE INDEX IX_Columnares_gasto ON gasto;

-- Carga masiva de datos en la tabla gasto
-- (Suponiendo que gasto es una tabla válida)
-- ...

-- Eliminación de índices anteriores y creación de nuevos índices
DROP INDEX IX_gasto_periodo ON gasto;

CREATE CLUSTERED INDEX IX_Gasto_Periodo_FechaPago_idTipoGasto
ON gasto (periodo, fechapago, idtipogasto);

-- Ejecución de consulta con nuevos índices
SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8;
