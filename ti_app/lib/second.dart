import 'package:flutter/material.dart';
import 'package:ti_app/semana.dart';
import 'package:ti_app/mes.dart';
import 'package:ti_app/retardo.dart';
import 'package:ti_app/main.dart';
import 'package:ti_app/recuperacion.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SecondRoute extends StatefulWidget {
  final String? loggedInUserId;
  SecondRoute({Key? key, required this.loggedInUserId}) : super(key: key);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    WeekScreen(),
    MonthScreen(),
    DelayScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle_sharp,
                        color: Colors.white,
                        size: 50,
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.loggedInUserId ?? 'No User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Semana Actual'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Mes'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Retardo'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Recovery()),
                  (route) => false,
                );
                // Aquí puedes agregar la lógica para cerrar sesión
              },
            ),
          ],
        ),
      ),
    );
  }
}
