
using Microsoft.AspNetCore.Mvc;
using aspnet_api.Repositories;

[ApiController]
[Route("api/[controller]")]

public class EmpleadoController : ControllerBase
{
    private readonly EmpleadoRepository _repo;

    public EmpleadoController(EmpleadoRepository repo)
    {
        _repo = repo;
    }

    [HttpPost("insertar")]
    public async Task<IActionResult> Insertar([FromBody] EmpleadoDto dto)
    {
        var resultado = await _repo.InsertarEmpleadoAsync(dto.Nombre, dto.Salario);
        return Ok(new { Codigo = resultado });
    }

    [HttpGet("consultar")]
    public async Task<IActionResult> Consultar()
    {
        var empleados = await _repo.ConsultarEmpleadosAsync();
        return Ok(empleados);
    }
}