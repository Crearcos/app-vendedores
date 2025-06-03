import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarEmpresaScreen extends StatefulWidget {
  final int empresaId; // ID de la empresa a editar

  const EditarEmpresaScreen({super.key, required this.empresaId});

  @override
  EditarEmpresaScreenState createState() => EditarEmpresaScreenState();
}

class EditarEmpresaScreenState extends State<EditarEmpresaScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // Agrega otros controladores según los campos que necesites

  @override
  void initState() {
    super.initState();
    _fetchEmpresaData(); // Cargar datos de la empresa al iniciar
  }

  Future<void> _fetchEmpresaData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/empresa/${widget.empresaId}/'));
    if (response.statusCode == 200) {
      final empresaData = jsonDecode(response.body);
      nombreController.text = empresaData['nombre_empresa'];
      emailController.text = empresaData['email'];
      // Cargar otros campos según sea necesario
    } else {
      // Manejar error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los datos de la empresa')),
        );
      }
    }
  }

  Future<void> _editarEmpresa() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/empresa/edit/${widget.empresaId}/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre_empresa": nombreController.text,
        "email": emailController.text,
        // Agrega otros campos que necesites editar
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cambios guardados exitosamente')),
        );
        Navigator.pop(context); // Regresar a la pantalla anterior
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los cambios')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Empresa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre de la Empresa'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            // Agrega otros campos según sea necesario
            ElevatedButton(
              onPressed: _editarEmpresa,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}