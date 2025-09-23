public class EmpleadoDTO
{
    public int Id { get; set; }
    public string Nombre { get; set; }
    public string ValorDocumentoIdentidad { get; set; }
    public string Puesto { get; set; }
    public DateTime FechaContratacion { get; set; }
    public decimal SaldoVacaciones { get; set; }
    public bool EsActivo { get; set; }
}
