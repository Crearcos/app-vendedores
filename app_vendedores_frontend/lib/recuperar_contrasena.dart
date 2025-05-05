import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _message = '';
  bool _hasSentEmail = false; // Indica si el correo ya fue enviado una vez

  // Determinar la URL del backend según la plataforma
  String getApiUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/reset_password/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/reset_password/'; // Para escritorio o navegador
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    final String apiUrl = getApiUrl(); // Obtiene la URL correcta

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": _emailController.text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _message = data["message"];
        _hasSentEmail = true;
      });
    } else {
      setState(() {
        _message = "Error al enviar el correo";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: Text(_hasSentEmail ? 'Reenviar correo' : 'Enviar correo'),
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