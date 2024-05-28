// Importación de las librerías necesarias
// ignore_for_file: use_key_in_widget_constructors

import 'package:smart_led/menu/menu_opciones_page.dart';
import 'package:flutter/material.dart';

// Función principal (main) para iniciar la aplicación
void main() {
  // Inicia la aplicación
  runApp(const MyApp());
}

// Clase MyApp que hereda de StatelessWidget
class MyApp extends StatelessWidget {
  // Constructor constante de MyApp
  const MyApp({Key? key});

  // Método build que construye el widget
  @override
  Widget build(BuildContext context) {
    // Retorna una MaterialApp con la configuración de la aplicación
    return MaterialApp(
      title: 'Flutter Demo',
      // Desactiva el banner de depuración en la esquina superior derecha
      debugShowCheckedModeBanner: false,
      // Define el tema de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Ruta inicial al iniciar la aplicación
      initialRoute: 'home',
      // Define las rutas de navegación de la aplicación
      routes: <String, WidgetBuilder>{
        'home': (BuildContext context) => const MenuOpciones(),
      },
    );
  }
}
