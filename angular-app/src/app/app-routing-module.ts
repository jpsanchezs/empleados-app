import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { Empleados } from './pages/empleados/empleados';
import { Insertar } from './pages/insertar/insertar';

const routes: Routes = [
  { path: '', component: Empleados },
  { path: 'insertar', component: Insertar }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
