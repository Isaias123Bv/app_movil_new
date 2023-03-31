import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'tabla.dart';
import 'package:ti_app/second.dart';
import 'package:ti_app/recuperacion.dart';
import 'package:http/http.dart' as http;

Future<Usuario> getUsuario(String usuario, String contrasena) async {
  final response = await http.get(Uri.parse(
      'https://technologystaruth5.com.mx/api_xd/login.php?us=$usuario&ps=$contrasena'));
  if (response.statusCode == 200) {
    return Usuario.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Ingresa los datos. ');
  }
}

class Usuario {
  final String id;
  final String username;
  final String nombre;
  final String ap;
  final String am;
  final String rol;
  final String correo;

  const Usuario({
    required this.id,
    required this.username,
    required this.nombre,
    required this.ap,
    required this.am,
    required this.rol,
    required this.correo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
        id: json['id'],
        username: json['username'],
        nombre: json['nombre'],
        ap: json['ap'],
        am: json['am'],
        rol: json['rol'],
        correo: json['correo']);
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = '';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? loggedInUserId;

  void setLoggedInUserId(String userId) {
    setState(() {
      loggedInUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp._title,
      home: LoginPage(setLoggedInUserId: setLoggedInUserId),
      routes: {
        '/second': (context) => SecondRoute(loggedInUserId: loggedInUserId),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  final Function(String) setLoggedInUserId;
  LoginPage({Key? key, required this.setLoggedInUserId}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      Usuario usuario =
          await getUsuario(_userController.text, _passwordController.text);
      widget.setLoggedInUserId(usuario.id.toString());
      // Aquí se guarda el ID del usuario
      Navigator.pushNamed(context, '/second');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Error al validar usuario'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FINGERPRINT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                '',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              ),
            ),
            Image.asset(
              'assets/imagenes/logo.png',
              height: 200,
              width: 200,
            ), // Agregar aquí

            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Correo Electrónico',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
                obscureText: true,
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
              key: const Key('loginButton'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Recovery()),
                );
              },
              child: const Text('olvide mi contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
