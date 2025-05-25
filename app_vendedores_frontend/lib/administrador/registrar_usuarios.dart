import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false; // Estado para bloquear el botón mientras se espera la respuesta
  String _selectedRole = "administrador"; // Valor por defecto
  String _message = '';

  String getApiUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/register/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/register/'; // Para escritorio o navegador
    }
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true; // Bloquear el botón antes de la petición
    });
    final String apiUrl = getApiUrl(); // Obtiene la URL correcta

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text,
          "email": _emailController.text,
          "role": _selectedRole,
        }),
      );
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);

      setState(() {
        _message = data["message"] ?? "Error al enviar el correo";
      });
    } catch (e) {
      setState(() {
        _message = "Error al registrar usuario";
      });
    }

    setState(() {
      _isLoading = false; // Habilitar el botón nuevamente después de la respuesta
    });
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
            // Campo de Nombre completo
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),

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
                DropdownMenuItem(value: "administrador", child: Text("Administrador")),
                DropdownMenuItem(value: "vendedor", child: Text("Vendedor")),
              ],
            ),
            const SizedBox(height: 16),

            // Botón de registro deshabilitado mientras espera la respuesta
            ElevatedButton(
              onPressed: _isLoading ? null : _registerUser, // Si está cargando, el botón estará bloqueado
              child: _isLoading
                  ? const SizedBox(  // Mostrar un indicador de carga dentro del botón
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : Text('Registrar Usuario'),
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