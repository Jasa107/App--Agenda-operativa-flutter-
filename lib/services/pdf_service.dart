import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'agenda_service.dart';

class PdfService {
  static Future<void> generarYGuardarPdf() async {
    final pdf = pw.Document();
    final plan = AgendaService.trimestreProyectado;

    if (plan.isEmpty) return;

    String obtenerNombreMes(int mes) {
      const meses = [
        'ENERO',
        'FEBRERO',
        'MARZO',
        'ABRIL',
        'MAYO',
        'JUNIO',
        'JULIO',
        'AGOSTO',
        'SEPTIEMBRE',
        'OCTUBRE',
        'NOVIEMBRE',
        'DICIEMBRE',
      ];
      return meses[mes - 1];
    }

    // ---  Agrupacion de semanas por su mes de inicio ---
    Map<int, List<SemanaProyecto>> semanasPorMes = {};
    for (var semana in plan) {
      int mes = semana.fechaInicio.month;
      if (!semanasPorMes.containsKey(mes)) {
        semanasPorMes[mes] = [];
      }
      semanasPorMes[mes]!.add(semana);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Título centrado
          pw.Center(
            child: pw.Text(
              "CRONOGRAMA TRIMESTRAL DE LIMPIEZA",
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 30),

          // Dibujar tablas mes por mes
          for (var mesKey in semanasPorMes.keys) ...[
            pw.Text(
              obtenerNombreMes(mesKey),
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              // Centrado de la tabla
              child: pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(4),
                },
                children: [
                  // Encabezado de tabla
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Center(
                          child: pw.Text(
                            "FECHA (Lunes a Sábado)",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Center(
                          child: pw.Text(
                            "Personas Asignadas",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Filas de semanas pertenecientes a este mes
                  for (var semana in semanasPorMes[mesKey]!)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          // Quitamos el "Sem X" y dejamos solo el rango de días
                          child: pw.Center(
                            child: pw.Text(
                              "${semana.fechaInicio.day}/${semana.fechaInicio.month} al ${semana.fechaFin.day}/${semana.fechaFin.month}",
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text(
                              semana.equipo.map((p) => p.nombre).join(" - "),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            pw.SizedBox(height: 25), // Espacio entre meses
          ],

          pw.Spacer(),
          pw.Divider(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(top: 10),
              child: pw.Text(
                "JS",
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'agenda_trimestral_2026.pdf',
    );
  }
}
