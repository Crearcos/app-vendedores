import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _selectedRole = "admin"; // Valor por defecto
  String _message = '';

  String getApiUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/register/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/register/'; // Para escritorio o navegador
    }
  }

  Future<void> _registerUser() async {
    final String apiUrl = getApiUrl(); // Obtiene la URL correcta
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text,
        "role": _selectedRole,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _message = data["message"];
      });
    } else {
      setState(() {
        _message = "Error al registrar usuario";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de correo
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Lista desplegable para elegir el rol
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(value: "admin", child: Text("Administrador")),
                DropdownMenuItem(value: "seller", child: Text("Vendedor")),
              ],
            ),
            const SizedBox(height: 16),

            // Botón de registro
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('Registrar Usuario'),
            ),
            const SizedBox(height: 16),

            if (_message.isNotEmpty)
              Text(_message, style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}