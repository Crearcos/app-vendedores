import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:app_vendedores_frontend/administrador/registrar_planes.dart';

class ManagePlansScreen extends StatefulWidget {
  const ManagePlansScreen({super.key});

  @override
  ManagePlansScreenState createState() => ManagePlansScreenState();
}

class ManagePlansScreenState extends State<ManagePlansScreen> {
  List<Map<String, dynamic>> _planes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPlanes();
  }

  String getApiUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/tarifarios/listar_planes/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/tarifarios/listar_planes/'; // Para escritorio o navegador
    }
  }

  Future<void> _fetchPlanes() async {
    final String apiUrl = getApiUrl();

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedResponse);
        setState(() {
          _planes = data.map((plan) => plan as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Error al obtener planes";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión";
        _isLoading = false;
      });
    }
  }

  void _showEditDialog(Map<String, dynamic> plan) {
    final TextEditingController nameController = TextEditingController(text: plan['nombre']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Plan"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nuevo nombre del plan"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _editPlan(plan['id'], nameController.text);
                Navigator.pop(context);
              },
              child: const Text("Guardar cambios"),
            ),
          ],
        );
      },
    );
  }

  String getApiUrlEditPlan() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/tarifarios/editar_plan/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/tarifarios/editar_plan/'; // Para escritorio o navegador
    }
  }

  Future<void> _editPlan(int planId, String newName) async {
    final String apiUrl = getApiUrlEditPlan();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": planId,
        "nombre": newName,
      }),
    );

    if (response.statusCode == 200) {
      _fetchPlanes(); // **Recargar la lista después de editar**
    } else {
      setState(() {
        _errorMessage = "Error al actualizar el plan";
      });
    }
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Nombre del plan: ${plan['nombre']}"),
              const SizedBox(height: 16),
              const Text("¿Estás seguro de que deseas eliminar este plan?", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _deletePlan(plan['id']);
                Navigator.pop(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  String getApiUrlDeletePlan() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/tarifarios/eliminar_plan/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/tarifarios/eliminar_plan/'; // Para escritorio o navegador
    }
  }

  Future<void> _deletePlan(int planId) async {
    final String apiUrl = getApiUrlDeletePlan();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": planId,
      }),
    );

    if (response.statusCode == 200) {
      _fetchPlanes(); // **Recargar la lista después de eliminar**
    } else {
      setState(() {
        _errorMessage = "Error al eliminar el plan";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar planes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _planes.length + 1,
        itemBuilder: (context, index) {
          if (index == _planes.length) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPlanScreen()),
                      ).then((_) {
                        _fetchPlanes();
                      });
                    },
                    child: const Text("Registrar nuevo plan"),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          final plan = _planes[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(plan['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // Evita que ocupe todo el ancho
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _showEditDialog(plan), // Abrir diálogo de edición
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(plan), // Abrir diálogo antes de eliminar
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