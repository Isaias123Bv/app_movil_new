import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<Eventos?> getEvento(var userId) async {
  final response = await http.get(Uri.parse(
      'https://technologystaruth5.com.mx/api_xd/evento.php?id_usuario=$userId'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> eventosJson = jsonDecode(response.body);
    return Eventos.fromJson(eventosJson);
  } else {
    print('Error ${response.statusCode}: ${response.reasonPhrase}');
    return null;
  }
}

class Eventos {
  final List<Evento> eventos;

  Eventos({required this.eventos});

  factory Eventos.fromJson(Map<String, dynamic> json) {
    final eventosFromJson = json['eventos'] as List<dynamic>;
    final eventos = eventosFromJson
        .map((evento) => Evento.fromJson(evento as Map<String, dynamic>))
        .toList();
    return Eventos(eventos: eventos);
  }
}

class Evento {
  final String nombre;
  final String horaEntrada;
  final String horaSalida;
  final String fecha;

  Evento({
    required this.nombre,
    required this.horaEntrada,
    required this.horaSalida,
    required this.fecha,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      nombre: json['nombre'] ?? '',
      horaEntrada: json['hora_entrada'] ?? '',
      horaSalida: json['hora_salida'] ?? '',
      fecha: json['fecha'] ?? '',
    );
  }
}

class TablaDatos extends StatefulWidget {
  var loggedInUserId;

  TablaDatos({Key? key, required this.loggedInUserId}) : super(key: key);

  @override
  _TablaDatosState createState() => _TablaDatosState();
}

class _TablaDatosState extends State<TablaDatos> {
  late Future<Eventos?> _futureEventos;

  @override
  void initState() {
    super.initState();
    _futureEventos = getEvento(widget.loggedInUserId ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Eventos?>(
      future: _futureEventos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Text('Error al cargar los datos');
          } else {
            final eventos = snapshot.data!.eventos;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DataTable(
                dataRowHeight: 35.0,
                columnSpacing: 10.0,
                columns: const [
                  DataColumn(label: Text('Nombre'), numeric: false),
                  DataColumn(label: Text('Fecha'), numeric: false),
                  DataColumn(label: Text('Hora de entrada'), numeric: false),
                  DataColumn(label: Text('Hora de salida'), numeric: false),
                ],
                rows: eventos.map((evento) {
                  return DataRow(
                    cells: [
                      DataCell(Text(evento.nombre)),
                      DataCell(Text(evento.fecha)),
                      DataCell(Text(evento.horaEntrada)),
                      DataCell(Text(evento.horaSalida)),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
