import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Router } from '@angular/router';

import { EmpleadoService } from '../../services/empleado';

@Component({
  selector: 'app-login',
  templateUrl: './login.html',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    RouterModule
  ]
})
export class LoginComponent {
  username = '';
  password = '';
  ip = '127.0.0.1';
  resultado = '';

  constructor(private service: EmpleadoService, private router: Router) {}

  login() {
    if (!this.username || !this.password) {
      this.resultado = 'Debe ingresar usuario y contraseña.';
      return;
    }

    const data = {
      username: this.username,
      password: this.password,
      ip: this.ip
    };

    this.service.login(data).subscribe(res => {
      const codigo = res.codigoResultado;
      switch (codigo) {
        case 0:
          this.resultado = 'Login exitoso';
          this.router.navigate(['/empleados']);
          break;
        case 50001:
          this.resultado = 'Usuario inválido';
          break;
        case 50002:
          this.resultado = 'Contraseña incorrecta';
          break;
        case 50003:
          this.resultado = 'Demasiados intentos fallidos';
          break;
        default:
          this.resultado = 'Error desconocido';
      }
    });
  }
}
