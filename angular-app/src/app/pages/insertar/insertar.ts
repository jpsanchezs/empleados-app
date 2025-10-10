import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { EmpleadoService } from '../../services/empleado';

@Component({
  selector: 'app-insertar',
  templateUrl: './insertar.html',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule
  ]
})
export class InsertarComponent {
  empleado = {
    valorDocumentoIdentidad: '',
    nombre: '',
    nombrePuesto: '',
    fechaContratacion: '',
    userName: 'juan.dev',
    ip: '127.0.0.1'
  };

  movimiento = {
    valorDocumentoIdentidad: '',
    nombreTipoMovimiento: '',
    monto: 0,
    userName: 'juan.dev',
    ip: '127.0.0.1'
  };

  constructor(private service: EmpleadoService) {}

  insertarEmpleado() {
    this.service.insertarEmpleado(this.empleado).subscribe(res => {
      alert('Empleado insertado. Código: ' + res.codigoResultado);
    });
  }

  insertarMovimiento() {
    this.service.insertarMovimiento(this.movimiento).subscribe(res => {
      alert('Movimiento insertado. Código: ' + res.codigoResultado);
    });
  }
}
