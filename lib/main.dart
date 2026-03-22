import 'package:flutter/material.dart';
import 'services/agenda_service.dart';
import 'screens/home_screen.dart';      // el Home
import 'screens/bienvenida_screen.dart'; // la Bienvenida

void main() async {
  // Aseguramos que Flutter esté listo para usar plugins
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargamos los datos de la memoria (SharedPreferences)
  await AgendaService.cargarDatos();
  
  // Decidimos qué pantalla mostrar
  Widget pantallaInicial;
  if (AgendaService.nombreUsuario != null && AgendaService.nombreUsuario!.isNotEmpty) {
    pantallaInicial = const HomeScreen();
  } else {
    pantallaInicial = const BienvenidaScreen();
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'AgendaOP',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true, // Esto le da un aspecto más moderno en tu Redmi
    ),
    home: pantallaInicial,
  ));
}