import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPaqueteScreen extends StatefulWidget {
  const RegisterPaqueteScreen({super.key});

  @override
  _RegisterPaqueteScreenState createState() => _RegisterPaqueteScreenState();
}

class _RegisterPaqueteScreenState extends State<RegisterPaqueteScreen> {
  final TextEditingController _duracionController = TextEditingController();
  final TextEditingController _idealParaController = TextEditingController();
  final TextEditingController _soporteController = TextEditingController();
  final TextEditingController _entregablesController = TextEditingController();
  final TextEditingController _kpisController = TextEditingController();
  final TextEditingController _precioMinimoController = TextEditingController();
  final TextEditingController _precioMaximoController = TextEditingController();

  List<Map<String, String>> _acciones = []; // Lista de acciones dinámica
  bool _isLoadingButton = false;
  String _message = '';

  List<String> _planes = [];
  String _selectedPlan = "";
  bool _isLoadingPlanes = true;

  @override
  void initState() {
    super.initState();
    _fetchPlanes();
  }

  Future<void> _fetchPlanes() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/tarifarios/listar_planes/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedResponse);
        setState(() {
          _planes = data.map((plan) => plan['nombre'] as String).toList();
          _isLoadingPlanes = false;

          // Seleccionar el primer plan por defecto si la lista no está vacía
          if (_planes.isNotEmpty && _selectedPlan.isEmpty) {
            _selectedPlan = _planes.first;
          }
        });
      } else {
        setState(() {
          _message = "Error al obtener planes";
          _isLoadingPlanes = false;
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error de conexión";
        _isLoadingPlanes = false;
      });
    }
  }

  Future<void> _registerPaquete() async {
    setState(() {
      _isLoadingButton = true;
    });

    final String apiUrl = 'http://127.0.0.1:8000/api/tarifarios/crear_paquete/';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "plan_nombre": _selectedPlan,
        "duracion": _duracionController.text,
        "ideal_para": _idealParaController.text,
        "soporte": _soporteController.text,
        "entregables": _entregablesController.text,
        "kpis_sugeridos": _kpisController.text,
        "precio_minimo": _precioMinimoController.text,
        "precio_maximo": _precioMaximoController.text,
        "acciones": _acciones,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      setState(() {
        _message = "Error al registrar paquete";
      });
    }

    setState(() {
      _isLoadingButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Paquete')),
      body: _isLoadingPlanes
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
                decoration: const InputDecoration(labelText: 'Duración'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _idealParaController,
                decoration: const InputDecoration(labelText: 'Ideal para'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _soporteController,
                decoration: const InputDecoration(labelText: 'Soporte'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _entregablesController,
                decoration: const InputDecoration(labelText: 'Entregables'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _kpisController,
                decoration: const InputDecoration(labelText: 'KPIs sugeridos'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _precioMinimoController,
                decoration: const InputDecoration(labelText: 'Precio mínimo'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _precioMaximoController,
                decoration: const InputDecoration(labelText: 'Precio máximo'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Lista dinámica para ingresar acciones
              const Text("Acciones", style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: _acciones.asMap().entries.map((entry) {
                  int index = entry.key;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(labelText: 'Nombre de la acción'),
                            onChanged: (value) {
                              _acciones[index]["nombre"] = value;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Descripción de la acción'),
                            onChanged: (value) {
                              _acciones[index]["descripcion"] = value;
                            },
                          ),
                          const SizedBox(height: 8),
                          // Botón para eliminar acción
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _acciones.removeAt(index);
                              });
                            },
                            child: const Text("Eliminar acción", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Botón para añadir acción
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _acciones.add({"nombre": "", "descripcion": ""});
                  });
                },
                child: const Text("Agregar acción"),
              ),
              const SizedBox(height: 16),

              // Botón para registrar el paquete
              ElevatedButton(
                onPressed: _isLoadingButton ? null : _registerPaquete,
                child: _isLoadingButton
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text('Registrar Paquete'),
              ),

              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(_message, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}