import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_vendedores_frontend/administrador/registrar_paquetes.dart';

class ManagePaquetesScreen extends StatefulWidget {
  const ManagePaquetesScreen({super.key});

  @override
  _ManagePaquetesScreenState createState() => _ManagePaquetesScreenState();
}

class _ManagePaquetesScreenState extends State<ManagePaquetesScreen> {
  List<Map<String, dynamic>> _paquetes = [];
  bool _isLoading = true;
  String _errorMessage = '';
  List<Map<String, dynamic>> _acciones = [];

  @override
  void initState() {
    super.initState();
    _fetchPaquetes();
  }

  Future<void> _fetchPaquetes() async {
    try {
      final String apiUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000/api/tarifarios/listar_paquetes/'
          : 'http://127.0.0.1:8000/api/tarifarios/listar_paquetes/';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedResponse);
        setState(() {
          _paquetes = data.map((paquete) => paquete as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Error al obtener paquetes";
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

  void _showDeleteConfirmationDialog(Map<String, dynamic> paquete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Plan: ${paquete['plan_nombre']}"),
              Text("Duración: ${paquete['duracion']}"),
              Text("Ideal para: ${paquete['ideal_para']}"),
              Text("Precio: ${paquete['precio_minimo']} - ${paquete['precio_maximo']} USD"),
              const SizedBox(height: 16),
              const Text("¿Estás seguro de que deseas eliminar este paquete?", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _deletePaquete(paquete['id']);
                Navigator.pop(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _deletePaquete(int paqueteId) async {
    final String apiUrl = Platform.isAndroid
        ? 'http://10.0.2.2:8000/api/tarifarios/eliminar_paquete/'
        : 'http://127.0.0.1:8000/api/tarifarios/eliminar_paquete/';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": paqueteId,
      }),
    );

    if (response.statusCode == 200) {
      _fetchPaquetes();
    } else {
      setState(() {
        _errorMessage = "Error al eliminar paquete";
      });
    }
  }

  void _showEditDialog(Map<String, dynamic> paquete) {
    final TextEditingController _duracionController = TextEditingController(text: paquete['duracion']);
    final TextEditingController _idealParaController = TextEditingController(text: paquete['ideal_para']);
    final TextEditingController _soporteController = TextEditingController(text: paquete['soporte']);
    final TextEditingController _entregablesController = TextEditingController(text: paquete['entregables']);
    final TextEditingController _kpisController = TextEditingController(text: paquete['kpis_sugeridos']);
    final TextEditingController _precioMinimoController = TextEditingController(text: paquete['precio_minimo'].toString());
    final TextEditingController _precioMaximoController = TextEditingController(text: paquete['precio_maximo'].toString());

    // Corrección: Inicializar los controladores de texto correctamente
    _acciones = (paquete['acciones'] as List<dynamic>).map<Map<String, dynamic>>((accion) {
      return {
        "nombre": accion["nombre"].toString(),
        "descripcion": accion["descripcion"].toString(),
        "controllerNombre": TextEditingController(text: accion["nombre"].toString()),
        "controllerDescripcion": TextEditingController(text: accion["descripcion"].toString()),
      };
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Editar Paquete"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: _duracionController, decoration: const InputDecoration(labelText: "Duración")),
                    TextField(controller: _idealParaController, decoration: const InputDecoration(labelText: "Ideal para")),
                    TextField(controller: _soporteController, decoration: const InputDecoration(labelText: "Soporte")),
                    TextField(controller: _entregablesController, decoration: const InputDecoration(labelText: "Entregables")),
                    TextField(controller: _kpisController, decoration: const InputDecoration(labelText: "KPIs sugeridos")),
                    TextField(controller: _precioMinimoController, decoration: const InputDecoration(labelText: "Precio mínimo"), keyboardType: TextInputType.number),
                    TextField(controller: _precioMaximoController, decoration: const InputDecoration(labelText: "Precio máximo"), keyboardType: TextInputType.number),
                    const SizedBox(height: 12),

                    // Lista de acciones
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
                                  controller: _acciones[index]["controllerNombre"],
                                  decoration: const InputDecoration(labelText: "Nombre de la acción"),
                                  onChanged: (value) {
                                    setState(() {
                                      _acciones[index]["nombre"] = value;
                                    });
                                  },
                                ),
                                TextField(
                                  controller: _acciones[index]["controllerDescripcion"],
                                  decoration: const InputDecoration(labelText: "Descripción de la acción"),
                                  onChanged: (value) {
                                    setState(() {
                                      _acciones[index]["descripcion"] = value;
                                    });
                                  },
                                ),
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

                    // Botón para agregar nueva acción
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _acciones.add({
                            "nombre": "",
                            "descripcion": "",
                            "controllerNombre": TextEditingController(),
                            "controllerDescripcion": TextEditingController(),
                          });
                        });
                      },
                      child: const Text("Agregar acción"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
                ElevatedButton(
                  onPressed: () {
                    _editPaquete(
                      paquete['id'],
                      _duracionController.text,
                      _idealParaController.text,
                      _soporteController.text,
                      _entregablesController.text,
                      _kpisController.text,
                      _precioMinimoController.text,
                      _precioMaximoController.text,
                      _acciones.map((accion) => {
                        "nombre": accion["controllerNombre"].text,
                        "descripcion": accion["controllerDescripcion"].text
                      }).toList(),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Guardar cambios"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _editPaquete(
      int paqueteId, String duracion, String idealPara, String soporte, String entregables,
      String kpisSugeridos, String precioMinimo, String precioMaximo, List<Map<String, dynamic>> acciones
      ) async {
    final String apiUrl = Platform.isAndroid
        ? 'http://10.0.2.2:8000/api/tarifarios/editar_paquete/'
        : 'http://127.0.0.1:8000/api/tarifarios/editar_paquete/';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": paqueteId,
        "duracion": duracion,
        "ideal_para": idealPara,
        "soporte": soporte,
        "entregables": entregables,
        "kpis_sugeridos": kpisSugeridos,
        "precio_minimo": precioMinimo,
        "precio_maximo": precioMaximo,
        "acciones": acciones,
      }),
    );

    if (response.statusCode == 200) {
      _fetchPaquetes();
    } else {
      setState(() {
        _errorMessage = "Error al actualizar paquete";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Paquetes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _paquetes.length + 1,
        itemBuilder: (context, index) {
          if (index == _paquetes.length) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPaqueteScreen()),
                      ).then((_) {
                        _fetchPaquetes();
                      });
                    },
                    child: const Text("Registrar nuevo paquete"),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          final paquete = _paquetes[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ExpansionTile(
              title: Text(paquete['plan_nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Duración: ${paquete['duracion']}"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ideal para: ${paquete['ideal_para']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Soporte: ${paquete['soporte']}"),
                      Text("Entregables: ${paquete['entregables']}"),
                      Text("KPIs sugeridos: ${paquete['kpis_sugeridos']}"),
                      Text("Precio: ${paquete['precio_minimo']} - ${paquete['precio_maximo']} USD", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Acciones:", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ...paquete['acciones'].map((accion) => Text("- ${accion['nombre']}: ${accion['descripcion']}")).toList(),
                      const SizedBox(height: 12),

                      // Botones para editar y eliminar el paquete
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showEditDialog(paquete),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmationDialog(paquete),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}