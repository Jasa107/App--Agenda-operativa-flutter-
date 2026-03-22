import 'package:flutter/material.dart';
import 'package:agenda_op/services/agenda_service.dart';
import 'package:agenda_op/services/pdf_service.dart';

class CalendarioTrimestralScreen extends StatelessWidget {
  const CalendarioTrimestralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = AgendaService.trimestreProyectado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificación Trimestral 2026'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              PdfService.generarYGuardarPdf();
            },
          )
        ],
      ),
      body: plan.isEmpty
          ? const Center(child: Text('No hay una agenda generada aún.'))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: plan.length,
              itemBuilder: (context, index) {
                final semana = plan[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                      'Semana ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Del ${semana.fechaInicio.day}/${semana.fechaInicio.month} al ${semana.fechaFin.day}/${semana.fechaFin.month}',
                    ),
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Equipo de limpieza:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            const SizedBox(height: 5),
                            ...semana.equipo.map((p) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(p.nombre),
                                ],
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
} 