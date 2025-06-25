import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final String apiUrl = Platform.isAndroid
        ? 'http://10.0.2.2:8000/api/tarifarios/listar_soluciones/'
        : 'http://127.0.0.1:8000/api/tarifarios/listar_soluciones/';
    final url = Uri.parse(apiUrl);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consultar Soluciones")),
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
        itemCount: _soluciones.length,
        itemBuilder: (context, index) {
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
