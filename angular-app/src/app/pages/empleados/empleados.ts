import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { CurrencyPipe, DatePipe } from '@angular/common';

import { EmpleadoService } from '../../services/empleado';

@Component({
  selector: 'app-empleados',
  templateUrl: './empleados.html',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
    CurrencyPipe,
    DatePipe
  ]
})
export class EmpleadosComponent implements OnInit {
  empleados: any[] = [];
  filtroCedula = '';
  filtroNombre = '';

  constructor(private service: EmpleadoService) {}

  ngOnInit(): void {
    this.service.getEmpleados().subscribe(data => {
      this.empleados = data;
    });
  }

  buscarPorCedula(): void {
    if (!this.filtroCedula) return;
    this.service.getEmpleadoPorCedula(this.filtroCedula).subscribe(emp => {
      this.empleados = emp ? [emp] : [];
    });
  }

  buscarPorNombre(): void {
    if (!this.filtroNombre) return;
    this.service.getEmpleadosPorNombre(this.filtroNombre).subscribe(data => {
      this.empleados = data;
    });
  }
}
