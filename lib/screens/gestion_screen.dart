import 'package:flutter/material.dart';
import '../services/agenda_service.dart';

class GestionScreen extends StatefulWidget {
  const GestionScreen({super.key});

  @override
  State<GestionScreen> createState() => _GestionScreenState();
}

class _GestionScreenState extends State<GestionScreen> {
  final TextEditingController _nombreController = TextEditingController();

  void _agregarPersona() {
    if (_nombreController.text.isNotEmpty) {
      setState(() {
        AgendaService.personas.add(Persona(nombre: _nombreController.text));
        AgendaService.guardarDatos();
        _nombreController.clear();
      });
    }
  }

  void _eliminarPersona(int index) {
    setState(() {
      AgendaService.personas.removeAt(index);
      AgendaService.guardarDatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Personal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del integrante',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _agregarPersona,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AgendaService.personas.isEmpty
                  ? const Center(child: Text('Aún no hay personal registrado.'))
                  : ListView.builder(
                      itemCount: AgendaService.personas.length,
                      itemBuilder: (context, index) {
                        final persona = AgendaService.personas[index];
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(persona.nombre),
                            subtitle: Text(
                              'Limpiezas asignadas: ${persona.contadorLimpiezas}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarPersona(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
