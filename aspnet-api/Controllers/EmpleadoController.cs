using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

[ApiController]
[Route("api/[controller]")]
public class SistemaController : ControllerBase
{
    private readonly string _connectionString;

    public SistemaController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    // R1: Login
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        int resultCode = -1;

        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("LoginUsuario", conn)
        {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue("@inUsername", request.Username);
        cmd.Parameters.AddWithValue("@inPassword", request.Password);
        cmd.Parameters.AddWithValue("@inIP", request.IP);
        var outParam = new SqlParameter("@outResultCode", SqlDbType.Int)
        {
            Direction = ParameterDirection.Output
        };
        cmd.Parameters.Add(outParam);

        await conn.OpenAsync();
        await cmd.ExecuteNonQueryAsync();

        resultCode = (int)outParam.Value;
        return Ok(new { CodigoResultado = resultCode });
    }

    // R2: Listar empleados (todos)
    [HttpGet("empleados")]
    public async Task<IActionResult> GetAllEmpleados()
    {
        var empleados = new List<object>();

        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("GetAllEmpleados", conn)
        {
            CommandType = CommandType.StoredProcedure
        };

        await conn.OpenAsync();
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            empleados.Add(new
            {
                Id = reader.GetInt32(0),
                Nombre = reader.GetString(1),
                ValorDocumentoIdentidad = reader.GetString(2),
                Puesto = reader.GetString(3),
                FechaContratacion = reader.GetDateTime(4),
                SaldoVacaciones = reader.GetDecimal(5),
                EsActivo = reader.GetBoolean(6)
            });
        }

        return Ok(empleados);
    }

    // R2: Listar empleados por cédula
    [HttpGet("empleados/cedula/{cedula}")]
    public async Task<IActionResult> GetEmpleadoPorCedula(string cedula)
    {
        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("GetEmpleadoPorCedula", conn)
        {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue("@ValorDocumento", cedula);

        await conn.OpenAsync();
        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            var empleado = new
            {
                Id = reader.GetInt32(0),
                Nombre = reader.GetString(1),
                ValorDocumentoIdentidad = reader.GetString(2),
                Puesto = reader.GetString(3),
                FechaContratacion = reader.GetDateTime(4),
                SaldoVacaciones = reader.GetDecimal(5),
                EsActivo = reader.GetBoolean(6)
            };
            return Ok(empleado);
        }

        return NotFound();
    }

    // R2: Listar empleados por nombre
    [HttpGet("empleados/nombre/{nombre}")]
    public async Task<IActionResult> GetEmpleadosPorNombre(string nombre)
    {
        var empleados = new List<object>();

        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("GetEmpleadosPorNombre", conn)
        {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue("@Nombre", nombre);

        await conn.OpenAsync();
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            empleados.Add(new
            {
                Id = reader.GetInt32(0),
                Nombre = reader.GetString(1),
                ValorDocumentoIdentidad = reader.GetString(2),
                Puesto = reader.GetString(3),
                FechaContratacion = reader.GetDateTime(4),
                SaldoVacaciones = reader.GetDecimal(5),
                EsActivo = reader.GetBoolean(6)
            });
        }

        return Ok(empleados);
    }

    // R3: Insertar empleado
    [HttpPost("empleados/insertar")]
    public async Task<IActionResult> InsertarEmpleado([FromBody] EmpleadoInsertRequest request)
    {
        int resultCode = -1;

        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("InsertarEmpleado", conn)
        {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue("@inValorDocumentoIdentidad", request.ValorDocumentoIdentidad);
        cmd.Parameters.AddWithValue("@inNombre", request.Nombre);
        cmd.Parameters.AddWithValue("@inNombrePuesto", request.NombrePuesto);
        cmd.Parameters.AddWithValue("@inFechaContratacion", request.FechaContratacion);
        cmd.Parameters.AddWithValue("@inUserName", request.UserName);
        cmd.Parameters.AddWithValue("@inIP", request.IP);
        var outParam = new SqlParameter("@outResultCode", SqlDbType.Int)
        {
            Direction = ParameterDirection.Output
        };
        cmd.Parameters.Add(outParam);

        await conn.OpenAsync();
        await cmd.ExecuteNonQueryAsync();

        resultCode = (int)outParam.Value;
        return Ok(new { CodigoResultado = resultCode });
    }

    // R5: Listar movimientos por cédula
    [HttpGet("movimientos/{cedula}")]
    public async Task<IActionResult> GetMovimientosPorCedula(string cedula)
    {
        var movimientos = new List<object>();

        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("GetMovimientosPorCedula", conn)
        {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue("@ValorDocumento", cedula);

        await conn.OpenAsync();
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            movimientos.Add(new
            {
                Fecha = reader.GetDateTime(0),
                TipoMovimiento = reader.GetString(1),
                Monto = reader.GetDecimal(2),
                NuevoSaldo = reader.GetDecimal(3),
                Usuario = reader.GetString(4),
                IP = reader.GetString(5),
                PostTime = reader.GetDateTime(6)
            });
        }

        return Ok(movimientos);
    }

    // R6: Insertar movimiento
    [HttpPost("movimientos/insertar")]
    public async Task<IActionResult> InsertarMovimiento([FromBody] MovimientoInsertRequest request)
    {
        int resultCode = -1;

        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("InsertarMovimiento", conn)
        {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue("@inValorDocumentoIdentidad", request.ValorDocumentoIdentidad);
        cmd.Parameters.AddWithValue("@inNombreTipoMovimiento", request.NombreTipoMovimiento);
        cmd.Parameters.AddWithValue("@inMonto", request.Monto);
        cmd.Parameters.AddWithValue("@inUserName", request.UserName);
        cmd.Parameters.AddWithValue("@inIP", request.IP);
        var outParam = new SqlParameter("@outResultCode", SqlDbType.Int)
        {
            Direction = ParameterDirection.Output
        };
        cmd.Parameters.Add(outParam);

        await conn.OpenAsync();
        await cmd.ExecuteNonQueryAsync();

        resultCode = (int)outParam.Value;
        return Ok(new { CodigoResultado = resultCode });
    }
}
