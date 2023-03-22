import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ti_app/second.dart';
import 'package:ti_app/recuperacion.dart';
import 'package:http/http.dart' as http;

Future<Usuario> getUsuario(String usuario, String contrasena) async {
  final response = await http.get(Uri.parse(
      'https://uthliberador.com/iot/ws/loginn.php?us=$usuario&ps=$contrasena'));
  if (response.statusCode == 200) {
    return Usuario.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error al validar usuario');
  }
}

class Usuario {
  final String id_usuario;
  final String user;
  final String nombre;
  final String ap;
  final String am;
  final String perfil;
  final String correo;

  const Usuario({
    required this.id_usuario,
    required this.user,
    required this.nombre,
    required this.ap,
    required this.am,
    required this.perfil,
    required this.correo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
        id_usuario: json['id_usuario'],
        user: json['user'],
        nombre: json['nombre'],
        ap: json['ap'],
        am: json['am'],
        perfil: json['perfil'],
        correo: json['correo']);
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondRoute()),
      );
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
