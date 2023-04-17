import 'package:flutter/material.dart';
import 'package:ti_app/semana.dart';
import 'package:http/http.dart' as http;

class Recovery extends StatefulWidget {
  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isValidEmail(String value) {
    if (value.isEmpty) {
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return false;
    }
    return true;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Realizar petición POST a la API
      var url =
          'https://technologystaruth5.com.mx/api_xd/correo.php?correo=$_emailController'; // Reemplaza con la URL de tu API PHP
      try {
        var response = await http
            .post(Uri.parse(url), body: {'correo': _emailController.text});

        if (response.statusCode == 200) {
          // La petición fue exitosa
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Correo electrónico enviado'),
          ));
        } else {
          // La petición falló
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error al enviar el correo electrónico'),
          ));
        }
      } catch (error) {
        // Capturar errores y mostrar mensaje adecuado
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al enviar el correo electrónico'),
        ));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!_isValidEmail(value!)) {
                    return 'Ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: _submitForm,
                child: Text('Recuperar Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
