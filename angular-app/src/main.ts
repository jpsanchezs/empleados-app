import { bootstrapApplication } from '@angular/platform-browser';
import { App } from './app';
import { importProvidersFrom } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { AppRoutingModule } from './app-routing.module';
import { HttpClientModule } from '@angular/common/http';

bootstrapApplication(App, {
  providers: [
    importProvidersFrom(
      BrowserModule,
      FormsModule,
      HttpClientModule,
      AppRoutingModule
    )
  ]
}).catch(err => console.error(err));
