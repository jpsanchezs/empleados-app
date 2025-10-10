import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class EmpleadoService {
  private apiUrl = 'https://localhost:5298';

  constructor(private http: HttpClient) {}

  login(data: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/login`, data);
  }

  getEmpleados(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/empleados`);
  }

  getEmpleadoPorCedula(cedula: string): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/empleados/cedula/${cedula}`);
  }

  getEmpleadosPorNombre(nombre: string): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/empleados/nombre/${nombre}`);
  }

  insertarEmpleado(data: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/empleados/insertar`, data);
  }

  getMovimientos(cedula: string): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/movimientos/${cedula}`);
  }

  insertarMovimiento(data: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/movimientos/insertar`, data);
  }
}
