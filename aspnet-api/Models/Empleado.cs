
namespace aspnet_api.Models;

public class Empleado
{
    public int Id { get; set; }
    public required string Nombre { get; set; }
    public decimal Salario { get; set; }
}