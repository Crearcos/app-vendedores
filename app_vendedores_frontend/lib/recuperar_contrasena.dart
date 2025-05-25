import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

// Cambiar el nombre de la clase a pública
class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _message = '';
  bool _hasSentEmail = false; // Indica si el correo ya fue enviado una vez
  bool _isLoading = false; // Estado para bloquear el botón mientras se espera la respuesta

  // Hacer el método público
  String getApiUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/reset_password/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/reset_password/'; // Para escritorio o navegador
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _isLoading = true; // Bloquear el botón antes de la petición
    });
    final String apiUrl = getApiUrl(); // Obtiene la URL correcta

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": _emailController.text}),
      );
      final decodedResponse = utf8.decode(response.bodyBytes); // Decodificar para caracteres especiales
      final data = jsonDecode(decodedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _message = data["message"];
          _hasSentEmail = true; // Cambiar el texto del botón
        });
      } else {
        setState(() {
          _message = data["message"] ?? "Error al enviar el correo";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error de conexión con el servidor";
      });
    }

    setState(() {
      _isLoading = false; // Habilitar el botón nuevamente después de la respuesta
    });
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

            // Botón de envio de correo deshabilitado mientras espera la respuesta
            ElevatedButton(
              onPressed: _isLoading ? null : _sendPasswordResetEmail, // Si está cargando, el botón estará bloqueado
              child: _isLoading
                  ? const SizedBox(  // Mostrar un indicador de carga dentro del botón
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : Text(_hasSentEmail ? 'Reenviar correo' : 'Enviar correo'),
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