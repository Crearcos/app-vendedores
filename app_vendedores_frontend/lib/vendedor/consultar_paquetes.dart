import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManagePaquetesScreen extends StatefulWidget {
  const ManagePaquetesScreen({super.key});

  @override
  _ManagePaquetesScreenState createState() => _ManagePaquetesScreenState();
}

class _ManagePaquetesScreenState extends State<ManagePaquetesScreen> {
  List<Map<String, dynamic>> _paquetes = [];
  bool _isLoading = true;
  String _errorMessage = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar Paquetes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _paquetes.length,
        itemBuilder: (context, index) {
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