import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class Persona {
  String nombre;
  int contadorLimpiezas;

  Persona({required this.nombre, this.contadorLimpiezas = 0});

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'contadorLimpiezas': contadorLimpiezas,
  };

  factory Persona.fromMap(Map<String, dynamic> map) => Persona(
    nombre: map['nombre'],
    // Este pequeño cambio evita que el error de 'int' vuelva a aparecer
    contadorLimpiezas: map['contadorLimpiezas'] is int ? map['contadorLimpiezas'] : 0,
  );
}

class SemanaProyecto {
  DateTime fechaInicio;
  DateTime fechaFin;
  List<Persona> equipo;

  SemanaProyecto({required this.fechaInicio, required this.fechaFin, required this.equipo});
}

class AgendaService {
  static String? nombreUsuario;
  static List<Persona> personas = [];
  static List<SemanaProyecto> trimestreProyectado = [];

  static Future<void> guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    if (nombreUsuario != null) await prefs.setString('user_name', nombreUsuario!);
    String personasJson = jsonEncode(personas.map((p) => p.toMap()).toList());
    await prefs.setString('lista_personal', personasJson);
  }

  static Future<void> cargarDatos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      nombreUsuario = prefs.getString('user_name');
      String? personasJson = prefs.getString('lista_personal');
      
      if (personasJson != null) {
        Iterable l = jsonDecode(personasJson);
        personas = List<Persona>.from(l.map((model) => Persona.fromMap(model)));
      }
    } catch (e) {
      // Si la memoria guardó basura y causa error, limpiamos el caché silenciosamente
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('lista_personal');
      personas = [];
    }
  }

  static void generarPlanTrimestral(int tamanoGrupo, DateTime fechaInicio) {
    trimestreProyectado.clear();
    if (personas.isEmpty) return;

    List<Persona> pool = List.from(personas);
    pool.shuffle(Random()); // Mezcla al azar

    DateTime corriente = fechaInicio;

    for (int i = 0; i < 12; i++) {
      List<Persona> equipo = [];
      for (int j = 0; j < tamanoGrupo; j++) {
        equipo.add(pool[(i * tamanoGrupo + j) % pool.length]);
      }

      trimestreProyectado.add(SemanaProyecto(
        fechaInicio: corriente,
        fechaFin: corriente.add(const Duration(days: 5)),
        equipo: equipo,
      ));
      
      corriente = corriente.add(const Duration(days: 7));
    }
  }

  static void confirmarLimpieza(List<Persona> equipo) {
    for (var p in equipo) {
      p.contadorLimpiezas++;
    }
    guardarDatos();
  }
}