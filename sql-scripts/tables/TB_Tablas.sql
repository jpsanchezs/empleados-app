SET NOCOUNT ON;
GO

-- Tabla Puesto
CREATE TABLE dbo.Puesto
(
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    ,Nombre NVARCHAR(200) NOT NULL
    ,SalarioxHora DECIMAL(18,4) NOT NULL
);
GO

-- Tabla Usuario
CREATE TABLE dbo.Usuario
(
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    ,Username NVARCHAR(150) NOT NULL UNIQUE
    ,Password NVARCHAR(256) NOT NULL
);
GO

-- Tabla Empleado
CREATE TABLE dbo.Empleado
(
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    ,IdPuesto INT NOT NULL
    ,ValorDocumentoIdentidad NVARCHAR(100) NOT NULL
    ,Nombre NVARCHAR(250) NOT NULL
    ,FechaContratacion DATE NOT NULL
    ,SaldoVacaciones DECIMAL(10,2) NOT NULL DEFAULT (0)
    ,EsActivo BIT NOT NULL DEFAULT (1)
    ,CONSTRAINT FK_Empleado_Puesto FOREIGN KEY (IdPuesto) REFERENCES dbo.Puesto(Id)
);
GO

-- Tabla TipoMovimiento
CREATE TABLE dbo.TipoMovimiento
(
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    ,Nombre NVARCHAR(150) NOT NULL
    ,TipoAccion NVARCHAR(50) NOT NULL
);
GO

-- Tabla Movimiento
CREATE TABLE dbo.Movimiento
(
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    ,IdEmpleado INT NOT NULL
    ,IdTipoMovimiento INT NOT NULL
    ,Fecha DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
    ,Monto DECIMAL(18,4) NOT NULL
    ,NuevoSaldo DECIMAL(18,4) NOT NULL
    ,IdPostByUser INT NULL
    ,PostIP NVARCHAR(45) NULL
    ,PostTime DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
    ,CONSTRAINT FK_Movimiento_Empleado FOREIGN KEY (IdEmpleado) REFERENCES dbo.Empleado(Id)
    ,CONSTRAINT FK_Movimiento_TipoMovimiento FOREIGN KEY (IdTipoMovimiento) REFERENCES dbo.TipoMovimiento(Id)
    ,CONSTRAINT FK_Movimiento_PostUser FOREIGN KEY (IdPostByUser) REFERENCES dbo.Usuario(Id)
);
GO

-- Tabla TipoEvento
CREATE TABLE dbo.TipoEvento
(
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    ,Nombre NVARCHAR(150) NOT NULL
);
GO

-- Tabla BitacoraEvento
CREATE TABLE dbo.BitacoraEvento
(
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    ,IdTipoEvento INT NOT NULL
    ,Descripcion NVARCHAR(1000) NOT NULL
    ,IdPostByUser INT NULL
    ,PostIP NVARCHAR(45) NULL
    ,PostTime DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
    ,CONSTRAINT FK_BitacoraEvento_TipoEvento FOREIGN KEY (IdTipoEvento) REFERENCES dbo.TipoEvento(Id)
    ,CONSTRAINT FK_BitacoraEvento_PostUser FOREIGN KEY (IdPostByUser) REFERENCES dbo.Usuario(Id)
);
GO

-- Tabla DBError (registro de errores de BD) 
CREATE TABLE dbo.DBError
(
    ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    ,UserName NVARCHAR(150) NULL
    ,Number INT NULL
    ,State TINYINT NULL
    ,Severity TINYINT NULL
    ,Line INT NULL
    ,ProcedureName NVARCHAR(200) NULL
    ,Message NVARCHAR(MAX) NOT NULL
    ,PostTime DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Tabla Error (catálogo de errores)
CREATE TABLE dbo.Error
(
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    ,Codigo NVARCHAR(100) NOT NULL UNIQUE
    ,Descripcion NVARCHAR(1000) NOT NULL
);
GO

-- Índices
CREATE INDEX IX_Empleado_ValorDocumentoIdentidad ON dbo.Empleado(ValorDocumentoIdentidad);
CREATE INDEX IX_Movimiento_IdEmpleado ON dbo.Movimiento(IdEmpleado);
CREATE INDEX IX_Movimiento_PostTime ON dbo.Movimiento(PostTime);
CREATE INDEX IX_BitacoraEvento_PostTime ON dbo.BitacoraEvento(PostTime);
GO

-- Asegurar que TipoMovimiento.TipoAccion tenga valores esperados (Credito/Debito)
ALTER TABLE dbo.TipoMovimiento
ADD CONSTRAINT CHK_TipoMovimiento_TipoAccion CHECK (TipoAccion IN (N'Credito', N'Debito'));
GO

-- Evitar inserciones duplicadas de Empleado por Nombre o ValorDocumentoIdentidad
CREATE UNIQUE INDEX UX_Empleado_ValorDocumentoIdentidad ON dbo.Empleado(ValorDocumentoIdentidad);
CREATE UNIQUE INDEX UX_Empleado_Nombre ON dbo.Empleado(Nombre);
GO