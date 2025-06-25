import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterTarifarioScreen extends StatefulWidget {
  const RegisterTarifarioScreen({super.key});

  @override
  @override
  State<RegisterTarifarioScreen> createState() => _RegisterTarifarioScreenState();
}

class _RegisterTarifarioScreenState extends State<RegisterTarifarioScreen> {
  final TextEditingController _costoTotalMinController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  final TextEditingController _costoTotalMaxController = TextEditingController();
  final TextEditingController _costoMensualMinController = TextEditingController();
  final TextEditingController _costoMensualMaxController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();

  bool _isLoadingButton = false;
  String _errorMessage = '';
  List<String> _planes = [];
  String _selectedPlan = "";
  bool _isLoadingPlanes = true;

  @override
  void initState() {
    super.initState();
    _fetchPlanes();
    _isLoadingPlanes = false;
  }

  Future<void> _fetchPlanes() async {
    try {
      final String apiUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000/api/tarifarios/listar_planes/'
          : 'http://127.0.0.1:8000/api/tarifarios/listar_planes/';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedResponse);
        setState(() {
          _planes = data.map((plan) => plan['nombre'] as String).toList();
          if (_planes.isNotEmpty && _selectedPlan.isEmpty) {
            _selectedPlan = _planes.first;
          }
        });
      } else {
        setState(() {
          _errorMessage = "Error al obtener planes";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión";
      });
    }
  }

  Future<void> _registerTarifario() async {
    setState(() {
      _isLoadingButton = true; // Bloquear el botón mientras espera la respuesta
    });

    try {
      final String apiUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000/api/tarifarios/crear_tarifario/'
          : 'http://127.0.0.1:8000/api/tarifarios/crear_tarifario/';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "plan_nombre": _selectedPlan,
          "duracion": _duracionController.text,
          "costo_total_minimo": _costoTotalMinController.text,
          "costo_total_maximo": _costoTotalMaxController.text,
          "costo_mensual_minimo": _costoMensualMinController.text,
          "costo_mensual_maximo": _costoMensualMaxController.text,
          "notas": _notasController.text,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _errorMessage = "Tarifario registrado exitosamente";
        });
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        setState(() {
          _errorMessage = "Error al registrar tarifario";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión con el servidor";
      });
    }

    setState(() {
      _isLoadingButton = false; // Habilitar el botón nuevamente
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Tarifario')),
      body: _isLoadingPlanes
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedPlan,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPlan = newValue!;
                });
              },
              items: _planes.map((plan) {
                return DropdownMenuItem(value: plan, child: Text(plan));
              }).toList(),
              decoration: const InputDecoration(
                labelText: "Selecciona un plan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _duracionController,
              decoration: const InputDecoration(labelText: "Duración (Ejemplo: 6 meses, 1 año)"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costoTotalMinController,
              decoration: const InputDecoration(labelText: 'Costo total mínimo'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costoTotalMaxController,
              decoration: const InputDecoration(labelText: 'Costo total máximo'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costoMensualMinController,
              decoration: const InputDecoration(labelText: 'Costo mensual mínimo'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costoMensualMaxController,
              decoration: const InputDecoration(labelText: 'Costo mensual máximo'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notasController,
              decoration: const InputDecoration(labelText: 'Notas'),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _isLoadingButton ? null : _registerTarifario,
              child: _isLoadingButton
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text('Registrar Tarifario'),
            ),
            const SizedBox(height: 16),

            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
