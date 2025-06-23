import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterSolucionScreen extends StatefulWidget {
  const RegisterSolucionScreen({super.key});

  @override
  _RegisterSolucionScreenState createState() => _RegisterSolucionScreenState();
}

class _RegisterSolucionScreenState extends State<RegisterSolucionScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  List<Map<String, dynamic>> _paquetesDisponibles = [];
  Set<int> _paquetesSeleccionados = {};
  bool _isLoading = true;
  String _message = "";

  @override
  void initState() {
    super.initState();
    _fetchPaquetes();
  }

  Future<void> _fetchPaquetes() async {
    final url = Uri.parse("http://127.0.0.1:8000/api/tarifarios/listar_paquetes/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decoded);
        setState(() {
          _paquetesDisponibles = data.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        setState(() {
          _message = "Error al cargar paquetes disponibles";
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        _message = "Error de conexión";
        _isLoading = false;
      });
    }
  }

  Future<void> _registrarSolucion() async {
    final url = Uri.parse("http://127.0.0.1:8000/api/tarifarios/crear_solucion/");
    setState(() {
      _message = "";
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre": _nombreController.text,
        "descripcion": _descripcionController.text,
        "paquetes": _paquetesSeleccionados.toList(),
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      setState(() {
        _message = "Error al registrar la solución";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Solución")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: "Nombre de la solución"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: "Descripción"),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              const Text("Selecciona los paquetes que conforman la solución:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._paquetesDisponibles.map((paquete) => CheckboxListTile(
                title: Text("${paquete['plan_nombre']} - ${paquete['duracion']}"),
                subtitle: Text("Ideal para: ${paquete['ideal_para']}"),
                value: _paquetesSeleccionados.contains(paquete['id']),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true) {
                      _paquetesSeleccionados.add(paquete['id']);
                    } else {
                      _paquetesSeleccionados.remove(paquete['id']);
                    }
                  });
                },
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarSolucion,
                child: const Text("Registrar Solución"),
              ),
              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_message, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
