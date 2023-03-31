class Eventos {
  final String motivo;
  final String hora_entrada;
  final String hora_salida;

  Eventos(
      {required this.motivo,
      required this.hora_entrada,
      required this.hora_salida});

  factory Eventos.fromJson(Map<String, dynamic> pj) {
    return Eventos(
        motivo: pj['motivo'],
        hora_entrada: pj['hora_entrada'],
        hora_salida: pj['hora_salida']);
  }
}
