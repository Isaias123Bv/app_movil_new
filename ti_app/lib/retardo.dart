import 'package:flutter/material.dart';
import 'package:ti_app/tabla.dart';
import 'package:ti_app/calendario.dart';

import 'main.dart';

class DelayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: TablaDatos(loggedInUserId: LoginPageState.user.id )),
          Expanded(child: Calendario()),
        ],
      ),
    );
  }
}
