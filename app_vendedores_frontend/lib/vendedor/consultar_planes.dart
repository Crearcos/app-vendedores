import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar planes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _planes.length,
        itemBuilder: (context, index) {
          final plan = _planes[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(plan['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // Evita que ocupe todo el ancho
                children: [],
              ),
            ),
          );
        },
      ),
    );
  }
}