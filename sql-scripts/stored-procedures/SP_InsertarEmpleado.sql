CREATE PROCEDURE dbo.InsertarEmpleado
    @inValorDocumentoIdentidad NVARCHAR(100)   -- Documento del empleado
    , @inNombre NVARCHAR(150)                     -- Nombre del empleado
    , @inNombrePuesto NVARCHAR(100)              -- Nombre del puesto
    , @inFechaContratacion DATE                  -- Fecha de contratación
    , @inUserName NVARCHAR(150)                  -- Usuario que registra
    , @inIP NVARCHAR(45)                         -- IP desde donde se registra
    , @outResultCode INT OUTPUT                   -- Código de resultado
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdPuesto INT;
    DECLARE @IdUsuario INT;
    DECLARE @Descripcion NVARCHAR(1000) = '';
    DECLARE @EsValido BIT = 1;

    SET @outResultCode = 0;

    BEGIN TRY
        -- Validar usuario
        SELECT @IdUsuario = U.Id
        FROM dbo.Usuario U
        WHERE U.Username = @inUserName;

        IF (@IdUsuario IS NULL)
        BEGIN
            SET @outResultCode = 50001;
            SET @EsValido = 0;
        END;

        -- Validar puesto
        IF @EsValido = 1
        BEGIN
            SELECT @IdPuesto = P.Id
            FROM dbo.Puesto P
            WHERE P.Nombre = @inNombrePuesto;

            IF (@IdPuesto IS NULL)
            BEGIN
                SET @outResultCode = 50008;
                SET @EsValido = 0;
            END;
        END;

        -- Validar documento duplicado
        IF @EsValido = 1 AND EXISTS (
            SELECT 1 FROM dbo.Empleado E
            WHERE E.ValorDocumentoIdentidad = @inValorDocumentoIdentidad)
        BEGIN
            SET @outResultCode = 50004;
            SET @EsValido = 0;
        END;

        -- Validar nombre duplicado
        IF @EsValido = 1 AND EXISTS (
            SELECT 1 FROM dbo.Empleado E
            WHERE E.Nombre = @inNombre)
        BEGIN
            SET @outResultCode = 50005;
            SET @EsValido = 0;
        END;

        -- Validar que documento sea numérico
        IF @EsValido = 1 AND ISNUMERIC(@inValorDocumentoIdentidad) = 0
        BEGIN
            SET @outResultCode = 50010;
            SET @EsValido = 0;
        END;

        -- Validar que nombre sea alfabético con espacios
        IF @EsValido = 1 AND @inNombre LIKE '%[^a-zA-Z ñÑáéíóúÁÉÍÓÚ]%'
        BEGIN
            SET @outResultCode = 50009;
            SET @EsValido = 0;
        END;

        -- Iniciar transacción solo si hay modificación
        BEGIN TRANSACTION tInsertEmpleado;

        IF @EsValido = 1
        BEGIN
            -- Inserción en Empleado
            INSERT INTO dbo.Empleado (
                IdPuesto
                , ValorDocumentoIdentidad
                , Nombre
                , FechaContratacion
                , SaldoVacaciones
                , EsActivo)
            VALUES (
                @IdPuesto
                , @inValorDocumentoIdentidad
                , @inNombre
                , @inFechaContratacion
                , 0
                , 1);

            -- Registro en Bitácora (evento exitoso)
            SET @Descripcion = 'Insertado: Documento=' + @inValorDocumentoIdentidad
                            + ', Nombre=' + @inNombre
                            + ', Puesto=' + @inNombrePuesto;

            INSERT INTO dbo.BitacoraEvento (
                IdTipoEvento
                , Descripcion
                , IdPostByUser
                , PostIP
                , PostTime)
            VALUES (
                6
                , @Descripcion
                , @IdUsuario
                , @inIP
                , SYSUTCDATETIME());

            SET @outResultCode = 0;
        END
        ELSE
        BEGIN
            -- Obtener descripción del error
            SELECT @Descripcion = Descripcion
            FROM dbo.Error
            WHERE Codigo = CAST(@outResultCode AS NVARCHAR);

            IF @Descripcion IS NULL
                SET @Descripcion = 'Error no registrado | Código=' + CAST(@outResultCode AS NVARCHAR);

            SET @Descripcion = @Descripcion
                + ' | Documento=' + @inValorDocumentoIdentidad
                + ', Nombre=' + @inNombre
                + ', Puesto=' + @inNombrePuesto;

            -- Registro en Bitácora (evento no exitoso)
            INSERT INTO dbo.BitacoraEvento (
                IdTipoEvento
                , Descripcion
                , IdPostByUser
                , PostIP
                , PostTime)
            VALUES (
                5
                , @Descripcion
                , @IdUsuario
                , @inIP
                , SYSUTCDATETIME());
        END;

        COMMIT TRANSACTION tInsertEmpleado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION tInsertEmpleado;

        INSERT INTO dbo.DBError (
            UserName
            , Number
            , State
            , Severity
            , Line
            , ProcedureName
            , Message
            , PostTime)
        VALUES (
            SUSER_SNAME()
            , ERROR_NUMBER()
            , ERROR_STATE()
            , ERROR_SEVERITY()
            , ERROR_LINE()
            , ERROR_PROCEDURE()
            , ERROR_MESSAGE()
            , SYSUTCDATETIME());

        SET @outResultCode = 50008;
    END CATCH

    SET NOCOUNT OFF;
END