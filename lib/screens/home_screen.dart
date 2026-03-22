import 'package:flutter/material.dart';
import '../services/agenda_service.dart';
import 'gestion_screen.dart';
import 'calendario_trimestral_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _fechaSeleccionada;
  int _tamanoGrupo = 3;

  void _seleccionarFecha() async {
    DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  void _generarYNavegar() {
    if (_fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una fecha de inicio.')),
      );
      return;
    }
    if (AgendaService.personas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se necesita agregar personas para esto !¡.')),
      );
      return;
    }

    // Aquí nos aseguramos de que el int y el DateTime vayan en el orden exacto
    AgendaService.generarPlanTrimestral(_tamanoGrupo, _fechaSeleccionada!);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarioTrimestralScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Qué bueno verte, ${AgendaService.nombreUsuario}!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Gestionar Personal'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GestionScreen()),
                ).then((_) => setState(() {})); 
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _fechaSeleccionada == null
                              ? 'Sin fecha de inicio'
                              : 'Inicio: ${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: _seleccionarFecha,
                          child: const Text('Elegir Fecha'),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Personas por grupo:', style: TextStyle(fontSize: 16)),
                        DropdownButton<int>(
                          value: _tamanoGrupo,
                          items: [1, 2, 3, 4, 5].map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              if (newValue != null) _tamanoGrupo = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _generarYNavegar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Generar Rotación',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}