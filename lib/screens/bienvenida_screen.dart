import 'package:agenda_op/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../services/agenda_service.dart';

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  final TextEditingController _nombreController = TextEditingController();
  String _nombreUsuario = "";

  void _guardarNombre() {
    if (_nombreController.text.isNotEmpty) {
      setState(() {
        _nombreUsuario = _nombreController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un SafeArea para que el contenido no choque con los bordes
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                _nombreUsuario.isEmpty ? _buildFormulario() : _buildBienvenida(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para pedir el nombre
  Widget _buildFormulario() {
    return Column(
      children: [
        const Text('¡Hola! ¿Cómo te llamas?', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        TextField(
          controller: _nombreController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Introduce tu nombre',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _guardarNombre,
          child: const Text('Guardar y Entrar'),
        ),
      ],
    );
  }

  // Widget para saludar
  Widget _buildBienvenida() {
    return Column(
      children: [
        Text('¡Bienvenido de vuelta, $_nombreUsuario!', 
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text('BIT está listo para trabajar.'),
        const SizedBox(height: 30),
       // Busca el botón dentro de _buildBienvenida()
    ElevatedButton(
  onPressed: () async {
    // Usamos el nombre correcto de la variable: _nombreController
    if (_nombreController.text.isNotEmpty) {
      
      // Guardamos en la memoria
      AgendaService.nombreUsuario = _nombreController.text;
      await AgendaService.guardarDatos(); 

      // Vamos al Home y quitamos la pantalla de bienvenida del historial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  },
  child: const Text('Comenzar'),
)
      ],
    );
  }
}