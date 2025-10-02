CREATE PROCEDURE dbo.FiltrarEmpleadosPorNombre
    @inNombre NVARCHAR(150),
    @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT 
            E.Id
            ,E.ValorDocumentoIdentidad
            ,E.Nombre
            ,P.Nombre AS NombrePuesto
            ,E.SaldoVacaciones
        FROM dbo.Empleado E
        INNER JOIN dbo.Puesto P ON P.Id = E.IdPuesto
        WHERE E.EsActivo = 1
            AND E.Nombre LIKE '%' + @inNombre + '%'
        ORDER BY E.Nombre ASC;

        SET @outResultCode = 0;
    END TRY
    BEGIN CATCH
        SET @outResultCode = 50008;
    END CATCH

    SET NOCOUNT OFF;
END
