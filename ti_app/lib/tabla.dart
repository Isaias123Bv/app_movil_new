import 'package:flutter/material.dart';

class TablaDatos extends StatelessWidget {
  const TablaDatos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Dia')),
          DataColumn(label: Text('Entrada')),
          DataColumn(label: Text('Salida')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('15-Feb')),
            DataCell(Text('7:19 a.m')),
            DataCell(Text('2:30 p.m')),
          ]),
          DataRow(cells: [
            DataCell(Text('16-Feb')),
            DataCell(Text('8:00 a.m')),
            DataCell(Text('3:00 p.m')),
          ]),
          DataRow(cells: [
            DataCell(Text('17 Feb')),
            DataCell(Text('9:00 a.m')),
            DataCell(Text('5:00 p.m')),
          ]),
          DataRow(cells: [
            DataCell(Text('18 Feb')),
            DataCell(Text('9:00 a.m')),
            DataCell(Text('5:00 p.m')),
          ]),
          DataRow(cells: [
            DataCell(Text('19 Feb')),
            DataCell(Text('9:00 a.m')),
            DataCell(Text('5:00 p.m')),
          ]),
        ],
      ),
    );
  }
}
