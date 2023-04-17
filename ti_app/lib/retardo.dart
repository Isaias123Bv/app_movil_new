import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class DelayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TablaDatosRetardo(loggedInUserId: LoginPageState.user.id),
          ),
        ],
      ),
    );
  }
}

Future<Retardos?> getRetardos(var userId) async {
  final response = await http.get(Uri.parse(
      'https://technologystaruth5.com.mx/api_xd/retardo.php?id_usuario=$userId'));
  print(response.body);
  print(userId);
  if (response.statusCode == 200) {
    final Map<String, dynamic> retardosJson = jsonDecode(response.body);
    return Retardos.fromJson(retardosJson);
  } else {
    print('Error ${response.statusCode}: ${response.reasonPhrase}');
    return null;
  }
}

class Retardos {
  final List<Retardo> retardos;

  Retardos({required this.retardos});

  factory Retardos.fromJson(Map<String, dynamic> json) {
    final retardosFromJson = json['retardos'] as List<dynamic>;
    final retardos = retardosFromJson
        .map((retardo) => Retardo.fromJson(retardo as Map<String, dynamic>))
        .toList();
    return Retardos(retardos: retardos);
  }
}

class Retardo {
  final String horaEntrada;
  final String fecha;
  final String horaEstimada;

  Retardo(
      {required this.horaEntrada,
      required this.fecha,
      required this.horaEstimada});

  factory Retardo.fromJson(Map<String, dynamic> json) {
    return Retardo(
      horaEntrada: json['hora_entrada'].toString(),
      fecha: json['fecha'].toString(),
      horaEstimada: json['hora_planificada'].toString(),
    );
  }
}

class TablaDatosRetardo extends StatefulWidget {
  var loggedInUserId;

  TablaDatosRetardo({Key? key, required this.loggedInUserId}) : super(key: key);

  @override
  _TablaDatosRetardoState createState() => _TablaDatosRetardoState();
}

class _TablaDatosRetardoState extends State<TablaDatosRetardo> {
  late Future<Retardos?> _futureRetardos;

  @override
  void initState() {
    super.initState();
    _futureRetardos = getRetardos(widget.loggedInUserId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Retardos?>(
      future: _futureRetardos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Text('Error al cargar los datos');
          } else {
            final retardos = snapshot.data!.retardos;
            return Padding(
              padding: EdgeInsets.only(
                  left:
                      16.0), // Ajusta el valor del relleno izquierdo según tus necesidades
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Expanded(
                      child: DataTable(
                        dataRowHeight: 35.0,
                        columnSpacing: 10.0,
                        columns: const [
                          DataColumn(label: Text('Fecha'), numeric: false),
                          DataColumn(
                              label: Text('Hora de entrada'), numeric: false),
                          DataColumn(
                              label: Text('Hora Estimada'), numeric: false),
                        ],
                        rows: retardos.map((retardo) {
                          return DataRow(
                            cells: [
                              DataCell(Text(retardo.fecha)),
                              DataCell(Text(retardo.horaEntrada)),
                              DataCell(Text(retardo.horaEstimada)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
