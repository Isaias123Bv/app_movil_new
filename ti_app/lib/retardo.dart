import 'package:flutter/material.dart';
import 'package:ti_app/tabla.dart';
import 'package:ti_app/calendario.dart';

class DelayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: TablaDatos(loggedInUserId: '')),
          Expanded(child: Calendario()),
        ],
      ),
    );
  }
}
