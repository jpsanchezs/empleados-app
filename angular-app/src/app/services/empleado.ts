import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({ providedIn: 'root' })
export class EmpleadoService {
  private apiUrl = 'http://localhost:5298/api/empleado';

  constructor(private http: HttpClient) {}

  consultar() {
    return this.http.get<any[]>(`${this.apiUrl}/consultar`);
  }

  insertar(dto: { nombre: string; salario: number }) {
    return this.http.post<{ codigo: number }>(`${this.apiUrl}/insertar`, dto);
  }
}
