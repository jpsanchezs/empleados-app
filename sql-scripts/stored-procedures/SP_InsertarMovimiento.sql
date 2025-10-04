CREATE PROCEDURE dbo.InsertarMovimiento
    @inValorDocumentoIdentidad NVARCHAR(100)
    , @inNombreTipoMovimiento NVARCHAR(150)
    , @inMonto DECIMAL(18,4)
    , @inUserName NVARCHAR(150)
    , @inIP NVARCHAR(45)
    , @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdEmpleado INT;
    DECLARE @IdTipoMovimiento INT;
    DECLARE @IdUsuario INT;
    DECLARE @SaldoActual DECIMAL(18,4);
    DECLARE @NuevoSaldo DECIMAL(18,4);
    DECLARE @Descripcion NVARCHAR(1000) = '';
    DECLARE @EsValido BIT = 1;

    SET @outResultCode = 0;

    BEGIN TRY
        -- Validar usuario
        SELECT @IdUsuario = U.Id
        FROM dbo.Usuario U
        WHERE U.Username = @inUserName;

        IF @IdUsuario IS NULL
        BEGIN
            SET @outResultCode = 50001;
            SET @EsValido = 0;
        END;

        -- Validar empleado
        IF @EsValido = 1
        BEGIN
            SELECT @IdEmpleado = E.Id, @SaldoActual = E.SaldoVacaciones
            FROM dbo.Empleado E
            WHERE E.ValorDocumentoIdentidad = @inValorDocumentoIdentidad;

            IF @IdEmpleado IS NULL
            BEGIN
                SET @outResultCode = 50004;
                SET @EsValido = 0;
            END;
        END;

        -- Validar tipo de movimiento
        IF @EsValido = 1
        BEGIN
            SELECT @IdTipoMovimiento = TM.Id
            FROM dbo.TipoMovimiento TM
            WHERE TM.Nombre = @inNombreTipoMovimiento;

            IF @IdTipoMovimiento IS NULL
            BEGIN
                SET @outResultCode = 50008;
                SET @EsValido = 0;
            END;
        END;

        -- Validar que el nuevo saldo no sea negativo
        IF @EsValido = 1
        BEGIN
            SET @NuevoSaldo = @SaldoActual + @inMonto;

            IF @NuevoSaldo < 0
            BEGIN
                SET @outResultCode = 50011;
                SET @EsValido = 0;
            END;
        END;

        -- Iniciar transacción solo si hay modificación
        BEGIN TRANSACTION tInsertMovimiento;

        IF @EsValido = 1
        BEGIN
            -- Insertar movimiento
            INSERT INTO dbo.Movimiento (
                IdEmpleado
                , IdTipoMovimiento
                , Monto
                , NuevoSaldo
                , IdPostByUser
                , PostIP
                , PostTime)
            VALUES (
                @IdEmpleado
                , @IdTipoMovimiento
                , @inMonto
                , @NuevoSaldo
                , @IdUsuario
                , @inIP
                , SYSUTCDATETIME());

            -- Actualizar saldo del empleado
            UPDATE dbo.Empleado
            SET SaldoVacaciones = @NuevoSaldo
            WHERE Id = @IdEmpleado;

            -- Registro en Bitácora (evento exitoso)
            SET @Descripcion = 'Movimiento registrado: Documento=' + @inValorDocumentoIdentidad
                            + ', Tipo=' + @inNombreTipoMovimiento
                            + ', Monto=' + CAST(@inMonto AS NVARCHAR)
                            + ', NuevoSaldo=' + CAST(@NuevoSaldo AS NVARCHAR);

            INSERT INTO dbo.BitacoraEvento (
                IdTipoEvento
                , Descripcion
                , IdPostByUser
                , PostIP
                , PostTime)
            VALUES (
                14
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
                + ', Tipo=' + @inNombreTipoMovimiento
                + ', Monto=' + CAST(@inMonto AS NVARCHAR);

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

        COMMIT TRANSACTION tInsertMovimiento;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION tInsertMovimiento;

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
