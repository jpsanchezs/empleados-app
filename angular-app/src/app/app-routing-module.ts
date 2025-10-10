import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EmpleadosComponent } from './pages/empleados/empleados';
import { InsertarComponent } from './pages/insertar/insertar';
import { LoginComponent } from './pages/login/login';

const routes: Routes = [
  { path: '', component: LoginComponent },
  { path: 'empleados', component: EmpleadosComponent },
  { path: 'insertar', component: InsertarComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
