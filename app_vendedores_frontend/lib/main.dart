import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_vendedores_frontend/administrador/adminMain.dart';
import 'package:app_vendedores_frontend/vendedor/vendedorMain.dart';
import 'package:app_vendedores_frontend/recuperar_contrasena.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Determinar la URL del backend según la plataforma
  String getApiUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/login/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/login/'; // Para escritorio o navegador
    }
  }

  Future<void> _login() async {
    final String apiUrl = getApiUrl(); // Obtiene la URL correcta
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      int status = data["status"];

      if (status == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminScreen()));
      } else if (status == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerScreen()));
      }
    } else if (response.statusCode == 400) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      setState(() {
        _errorMessage = data["message"]; // Mostrar el mensaje de error de Django
      });
    } else {
      setState(() {
        _errorMessage = "Error de conexión con el servidor";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
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
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: const Text('¿Ha olvidado la contraseña?', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}