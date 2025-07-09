import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  bool _existeCatalogo = false;
  String _mensaje = "";
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _verificarCatalogo();
  }

  Future<void> _verificarCatalogo() async {
    final String apiUrl = Platform.isAndroid
        ? 'http://10.0.2.2:8000/api/catalogo/existe/'
        : 'http://127.0.0.1:8000/api/catalogo/existe/';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _existeCatalogo = data["existe"] ?? false;
        _cargando = false;
      });
    } else {
      setState(() {
        _mensaje = "Error al verificar el catálogo.";
        _cargando = false;
      });
    }
  }

  Future<void> _descargarCatalogo() async {
    final String apiUrl = Platform.isAndroid
        ? 'http://10.0.2.2:8000/api/catalogo/descargar/'
        : 'http://127.0.0.1:8000/api/catalogo/descargar/'; // Obtiene la URL correcta
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final path = "${dir.path}/catalogo.pdf";
      File file = File(path);
      await file.writeAsBytes(response.bodyBytes);
      await OpenFile.open(file.path);
    } else {
      setState(() {
        _mensaje = "No se pudo descargar el catálogo.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consultar catálogo")),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _existeCatalogo
                    ? "Ya existe un archivo catálogo.pdf"
                    : "No hay catálogo cargado actualmente.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_mensaje.isNotEmpty)
                Text(
                  _mensaje,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              if (_existeCatalogo) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Descargar catálogo"),
                  onPressed: _descargarCatalogo,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
