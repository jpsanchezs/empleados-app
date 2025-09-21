import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { EmpleadoService } from '../../services/empleado';

@Component({
  selector: 'app-empleados',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './empleados.html'
})
export class Empleados {
  empleados: any[] = [];

  constructor(private empleadoService: EmpleadoService) {}

  ngOnInit(): void {
    this.empleadoService.consultar().subscribe(data => {
      this.empleados = data;
    });
  }
}
