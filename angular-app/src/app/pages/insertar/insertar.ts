import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Router } from '@angular/router';
import { EmpleadoService } from '../../services/empleado';

@Component({
  selector: 'app-insertar',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './insertar.html'
})
export class Insertar {
  nombre = '';
  salario = 0;
  mensaje = '';
  exito = false;

  constructor(private empleadoService: EmpleadoService, private router: Router) {}

  insertar(): void {
    this.empleadoService.insertar({ nombre: this.nombre, salario: this.salario }).subscribe(res => {
      switch (res.codigo) {
        case 1:
          this.mensaje = 'Empleado insertado correctamente';
          this.exito = true;
          setTimeout(() => this.router.navigate(['/']), 1500);
          break;
        case -2:
          this.mensaje = 'Error: El nombre ya está registrado';
          this.exito = false;
          break;
        case -1:
          this.mensaje = 'Error: El salario debe ser mayor a cero';
          this.exito = false;
          break;
        default:
          this.mensaje = 'Error desconocido';
          this.exito = false;
      }

      this.nombre = '';
      this.salario = 0;
    });
  }
}
