import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_vendedores_frontend/administrador/registrar_soluciones.dart';

class ManageSolucionScreen extends StatefulWidget {
  const ManageSolucionScreen({super.key});

  @override
  State<ManageSolucionScreen> createState() => _ManageSolucionScreenState();
}

class _ManageSolucionScreenState extends State<ManageSolucionScreen> {
  List<Map<String, dynamic>> _soluciones = [];
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchSoluciones();
  }

  Future<void> _fetchSoluciones() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        "http://127.0.0.1:8000/api/tarifarios/listar_soluciones/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded) as List<dynamic>;
        setState(() {
          _soluciones = data.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Error al obtener soluciones";
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        _errorMessage = "Error de conexión";
        _isLoading = false;
      });
    }
  }

  void _eliminarSolucion(int id) async {
    final url = Uri.parse(
        "http://127.0.0.1:8000/api/tarifarios/eliminar_solucion/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );
    if (response.statusCode == 200) {
      _fetchSoluciones();
    } else {
      setState(() {
        _errorMessage = "No se pudo eliminar la solución";
      });
    }
  }

  void _mostrarConfirmacionEliminar(Map<String, dynamic> solucion) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text("Eliminar solución"),
            content: Text(
                "¿Seguro que deseas eliminar \"${solucion['nombre']}\"?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _eliminarSolucion(solucion['id']);
                },
                child: const Text("Eliminar"),
              ),
            ],
          ),
    );
  }

  void _editarSolucion(int id, String nombre, String descripcion, List<int> paqueteIds) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/tarifarios/editar_solucion/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "paquetes": paqueteIds,
      }),
    );

    if (response.statusCode == 200) {
      _fetchSoluciones();
    } else {
      setState(() {
        _errorMessage = "Error al actualizar la solución";
      });
    }
  }

  void _mostrarDialogoEditarSolucion(Map<String, dynamic> solucion) async {
    final nombreController = TextEditingController(text: solucion['nombre']);
    final descripcionController = TextEditingController(text: solucion['descripcion']);

    List<Map<String, dynamic>> paquetesDisponibles = [];
    Set<int> paquetesSeleccionados = {
      for (var p in solucion['paquetes']) p['id'] as int
    };

    // Cargar todos los paquetes disponibles
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/tarifarios/listar_paquetes/'));
    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decoded) as List<dynamic>;
      paquetesDisponibles = data.cast<Map<String, dynamic>>();
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Editar Solución"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: "Nombre"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: "Descripción"),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                const Text("Paquetes asociados:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...paquetesDisponibles.map((paquete) {
                  final isSelected = paquetesSeleccionados.contains(paquete['id']);
                  return CheckboxListTile(
                    title: Text("${paquete['plan_nombre']} - ${paquete['duracion']}"),
                    subtitle: Text("Ideal para: ${paquete['ideal_para']}"),
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          paquetesSeleccionados.add(paquete['id']);
                        } else {
                          paquetesSeleccionados.remove(paquete['id']);
                        }
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () {
                _editarSolucion(
                  solucion['id'],
                  nombreController.text,
                  descripcionController.text,
                  paquetesSeleccionados.toList(),
                );
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestionar Soluciones")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : ListView.builder(
        itemCount: _soluciones.length + 1, // 1 adicional para el botón
        itemBuilder: (context, index) {
          if (index < _soluciones.length) {
            final solucion = _soluciones[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: ExpansionTile(
                title: Text(solucion['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("ID: ${solucion['id']}"),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Descripción:", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(solucion['descripcion']),
                        const SizedBox(height: 8),
                        Text("Paquetes asociados:", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ...solucion['paquetes'].map<Widget>((paquete) {
                          return Text("- ${paquete['plan_nombre']} (${paquete['duracion']})");
                        }).toList(),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _mostrarDialogoEditarSolucion(solucion),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _mostrarConfirmacionEliminar(solucion),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Botón final después de la última solución
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterSolucionScreen()),
                    );
                    _fetchSoluciones();
                  },
                  child: const Text("Registrar nueva solución"),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
