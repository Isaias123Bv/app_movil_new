import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Evento?> getEvento(var userId) async {
  final response = await http.get(Uri.parse(
      'https://technologystaruth5.com.mx/api_xd/evento.php?idregistro=$userId'));
  print(response.statusCode);
  print(response.body);
  print(userId);
  if (response.statusCode == 200) {
    print("ya valide :3");
    final Map<String, dynamic> eventoJson = jsonDecode(response.body);
    return Evento.fromJson(eventoJson);
  } else {
    print('Error ${response.statusCode}: ${response.reasonPhrase}');
    return null;
  }
}

class Evento {
  final String nombre;
  final String horaEntrada;
  final String horaSalida;

  Evento({
    required this.nombre,
    required this.horaEntrada,
    required this.horaSalida,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      nombre: json['nombre'] ?? '',
      horaEntrada: json['hora_entrada'] ?? '',
      horaSalida: json['hora_salida'] ?? '',
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
  late Future<Evento?> _futureEvento;

  @override
  void initState() {
    super.initState();
    _futureEvento = getEvento(widget.loggedInUserId ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Evento?>(
      future: _futureEvento,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Text('Error al cargar los datos');
          } else {
            final evento = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Hora de entrada')),
                  DataColumn(label: Text('Hora de salida')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text(evento.nombre)),
                      DataCell(Text(evento.horaEntrada)),
                      DataCell(Text(evento.horaSalida)),
                    ],
                  ),
                ],
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
