import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class RegisterPlanScreen extends StatefulWidget {
  const RegisterPlanScreen({super.key});

  @override
  RegisterPlanScreenState createState() => RegisterPlanScreenState();
}

class RegisterPlanScreenState extends State<RegisterPlanScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _registerPlan() async {
    setState(() {
      _isLoading = true; // Bloquear el botón antes de la petición
    });

    try {
      final String apiUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000/api/tarifarios/crear_plan/'
          : 'http://127.0.0.1:8000/api/tarifarios/crear_plan/';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": _nameController.text,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _message = "Plan registrado exitosamente";
        });
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        setState(() {
          _message = "Error al registrar el plan";
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
      appBar: AppBar(title: const Text('Registrar Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del plan',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _isLoading ? null : _registerPlan, // Si está cargando, el botón estará bloqueado
              child: _isLoading
                  ? const SizedBox( // Indicador de carga dentro del botón
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text('Registrar Plan'),
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