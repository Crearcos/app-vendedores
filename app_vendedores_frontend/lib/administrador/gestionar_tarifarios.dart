
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_vendedores_frontend/administrador/registrar_tarifarios.dart';

class ManageTarifariosScreen extends StatefulWidget {
  const ManageTarifariosScreen({super.key});

  @override
  _ManageTarifariosScreenState createState() => _ManageTarifariosScreenState();
}

class _ManageTarifariosScreenState extends State<ManageTarifariosScreen> {
  List<Map<String, dynamic>> _tarifarios = [];
  bool _isLoading = true;
  String _errorMessage = '';
  List<String> _planes = [];
  String _selectedPlan = "";

  @override
  void initState() {
    super.initState();
    _fetchPlanes();
    _fetchTarifarios();
    _isLoading = false;
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

          // **Seleccionar el primer plan por defecto si la lista no está vacía**
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

  Future<void> _fetchTarifarios() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/tarifarios/listar_tarifarios/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedResponse);
        setState(() {
          _tarifarios = data.map((tarifario) => tarifario as Map<String, dynamic>).toList();
        });
      } else {
        setState(() {
          _errorMessage = "Error al obtener tarifarios";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión";
      });
    }
  }

  void _showEditDialog(Map<String, dynamic> tarifario) {
    String selectedPlan = tarifario['plan_nombre'];
    final TextEditingController duracionController =
    TextEditingController(text: tarifario['duracion']);
    final TextEditingController costoTotalMinController =
    TextEditingController(text: tarifario['costo_total_minimo'].toString());
    final TextEditingController costoTotalMaxController =
    TextEditingController(text: tarifario['costo_total_maximo'].toString());
    final TextEditingController costoMensualMinController =
    TextEditingController(text: tarifario['costo_mensual_minimo'].toString());
    final TextEditingController costoMensualMaxController =
    TextEditingController(text: tarifario['costo_mensual_maximo'].toString());
    final TextEditingController notasController =
    TextEditingController(text: tarifario['notas']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Tarifario"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedPlan,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPlan = newValue!;
                  });
                },
                items: _planes.map((plan) {
                  return DropdownMenuItem(value: plan, child: Text(plan));
                }).toList(),
                decoration: const InputDecoration(
                  labelText: "Selecciona un nuevo plan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: duracionController,
                decoration: const InputDecoration(labelText: "Duración"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costoTotalMinController,
                decoration: const InputDecoration(labelText: "Costo total mínimo"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costoTotalMaxController,
                decoration: const InputDecoration(labelText: "Costo total máximo"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costoMensualMinController,
                decoration: const InputDecoration(labelText: "Costo mensual mínimo"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costoMensualMaxController,
                decoration: const InputDecoration(labelText: "Costo mensual máximo"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notasController,
                decoration: const InputDecoration(labelText: "Notas"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _editTarifario(
                  tarifario['id'],
                  selectedPlan,
                  duracionController.text, // **Nuevo campo**
                  costoTotalMinController.text,
                  costoTotalMaxController.text,
                  costoMensualMinController.text,
                  costoMensualMaxController.text,
                  notasController.text,
                );
                Navigator.pop(context);
              },
              child: const Text("Guardar cambios"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editTarifario(
      int tarifarioId,
      String planNombre,
      String duracion,
      String costoTotalMinimo,
      String costoTotalMaximo,
      String costoMensualMinimo,
      String costoMensualMaximo,
      String notas,
      ) async {
    final String apiUrl = 'http://127.0.0.1:8000/api/tarifarios/editar_tarifario/';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": tarifarioId,
        "plan_nombre": planNombre,
        "duracion": duracion,
        "costo_total_minimo": costoTotalMinimo,
        "costo_total_maximo": costoTotalMaximo,
        "costo_mensual_minimo": costoMensualMinimo,
        "costo_mensual_maximo": costoMensualMaximo,
        "notas": notas,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTarifarios(); // Recargar la lista después de editar
    } else {
      setState(() {
        _errorMessage = "Error al actualizar tarifario";
      });
    }
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> tarifario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Plan: ${tarifario['plan_nombre']}"),
              Text("Costo Total: ${tarifario['costo_total_minimo']} - ${tarifario['costo_total_maximo']}"),
              Text("Costo Mensual: ${tarifario['costo_mensual_minimo']} - ${tarifario['costo_mensual_maximo']}"),
              Text("Notas: ${tarifario['notas'].isEmpty ? 'Sin notas' : tarifario['notas']}"),
              const SizedBox(height: 16),
              const Text("¿Estás seguro de que deseas eliminar este tarifario?", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteTarifario(tarifario['id']);
                Navigator.pop(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _deleteTarifario(int tarifarioId) async {
    final String apiUrl = 'http://127.0.0.1:8000/api/tarifarios/eliminar_tarifario/';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": tarifarioId,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTarifarios();
    } else {
      setState(() {
        _errorMessage = "Error al eliminar tarifario";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Tarifarios')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _tarifarios.length + 1,
        itemBuilder: (context, index) {
          if (index == _tarifarios.length) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterTarifarioScreen()),
                      ).then((_) {
                        _fetchTarifarios();
                      });
                    },
                    child: const Text("Registrar nuevo tarifario"),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          final tarifario = _tarifarios[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(tarifario['plan_nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Duración: ${tarifario['duracion']}"),
                  Text("Costo total: ${tarifario['costo_total_minimo']} - ${tarifario['costo_total_maximo']}"),
                  Text("Costo mensual: ${tarifario['costo_mensual_minimo']} - ${tarifario['costo_mensual_maximo']}"),
                  Text("Notas: ${tarifario['notas'].isEmpty ? 'Sin notas' : tarifario['notas']}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _showEditDialog(tarifario),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(tarifario),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
