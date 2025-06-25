import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ManageTarifariosScreen extends StatefulWidget {
  const ManageTarifariosScreen({super.key});

  @override
  ManageTarifariosScreenState createState() => ManageTarifariosScreenState();
}

class ManageTarifariosScreenState extends State<ManageTarifariosScreen> {
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
    final String apiUrl = Platform.isAndroid
        ? 'http://10.0.2.2:8000/api/tarifarios/listar_planes/'
        : 'http://127.0.0.1:8000/api/tarifarios/listar_planes/';
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
    try {
      final String apiUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000/api/tarifarios/listar_tarifarios/'
          : 'http://127.0.0.1:8000/api/tarifarios/listar_tarifarios/';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar Tarifarios')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _tarifarios.length,
        itemBuilder: (context, index) {
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
                children: [],
              ),
            ),
          );
        },
      ),
    );
  }
}
