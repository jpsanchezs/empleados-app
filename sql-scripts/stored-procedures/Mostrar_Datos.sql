-- Catálogos
SELECT * FROM dbo.TipoEvento ORDER BY Id;
SELECT * FROM dbo.TipoMovimiento ORDER BY Id;
SELECT * FROM dbo.Error ORDER BY Id;
SELECT * FROM dbo.Usuario ORDER BY Id;
SELECT * FROM dbo.Puesto ORDER BY Id;

-- Operativas
SELECT * FROM dbo.Empleado ORDER BY Id;
SELECT * FROM dbo.Movimiento ORDER BY Id;

-- Bitácora de errores
SELECT * FROM dbo.DBError ORDER BY PostTime DESC;
