
using System.Data;
using Microsoft.Data.SqlClient;
using aspnet_api.Models;

namespace aspnet_api.Repositories
{
    public class EmpleadoRepository
    {
        private readonly IConfiguration _configuration;

        public EmpleadoRepository(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<int> InsertarEmpleadoAsync(string nombre, decimal salario)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            using var command = new SqlCommand("InsertarEmpleado", connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            command.Parameters.AddWithValue("@Nombre", nombre);
            command.Parameters.AddWithValue("@Salario", salario);

            var resultado = new SqlParameter
            {
                ParameterName = "@Resultado",
                SqlDbType = SqlDbType.Int,
                Direction = ParameterDirection.ReturnValue
            };
            command.Parameters.Add(resultado);

            await connection.OpenAsync();
            await command.ExecuteNonQueryAsync();

            return (int)resultado.Value;
        }

        public async Task<List<Empleado>> ConsultarEmpleadosAsync()
        {
            var empleados = new List<Empleado>();

            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            using var command = new SqlCommand("ConsultarEmpleados", connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            await connection.OpenAsync();
            using var reader = await command.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                empleados.Add(new Empleado
                {
                    Id = reader.GetInt32(0),
                    Nombre = reader.GetString(1),
                    Salario = reader.GetDecimal(2)
                });
            }
            return empleados;
        }
    }
}
