import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class RegistroEmpresaPage extends StatefulWidget {
  const RegistroEmpresaPage({Key? key}) : super(key: key);

  @override
  _RegistroEmpresaPageState createState() => _RegistroEmpresaPageState();
}

class _RegistroEmpresaPageState extends State<RegistroEmpresaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController empresaController = TextEditingController();
  final TextEditingController contactoController = TextEditingController();
  final TextEditingController cargoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController especificacionController = TextEditingController();
  final TextEditingController necesidadController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController modoContactoController = TextEditingController();

  String _message = '';
  bool _isLoading = false; // Estado de carga para mostrar el proceso

  @override
  void dispose() {
    empresaController.dispose();
    contactoController.dispose();
    cargoController.dispose();
    telefonoController.dispose();
    especificacionController.dispose();
    necesidadController.dispose();
    ciudadController.dispose();
    modoContactoController.dispose();
    super.dispose();
  }

  String getApiUrl() {
    return Platform.isAndroid
        ? 'http://10.0.2.2:8000/api/empresa/registro/'
        : 'http://127.0.0.1:8000/api/empresa/registro/';
  }

  Future<void> _guardarEmpresa() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _message = 'Por favor, complete todos los campos correctamente.');
      return;
    }

    setState(() => _isLoading = true);

    final Map<String, dynamic> data = {
      "empresa": empresaController.text.trim(),
      "contacto": contactoController.text.trim(),
      "cargo": cargoController.text.trim(),
      "telefono": telefonoController.text.trim(),
      "especificacion_negocio": especificacionController.text.trim(),
      "necesidad_especificada": necesidadController.text.trim(),
      "ciudad": ciudadController.text.trim(),
      "modo_contacto": modoContactoController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(getApiUrl()),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _message = responseData['message'] ?? 'Empresa registrada correctamente';
        });
        _formKey.currentState!.reset();
        _clearControllers();
      } else {
        setState(() => _message = 'Error al registrar empresa: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _message = 'Error de conexión: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearControllers() {
    empresaController.clear();
    contactoController.clear();
    cargoController.clear();
    telefonoController.clear();
    especificacionController.clear();
    necesidadController.clear();
    ciudadController.clear();
    modoContactoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Empresa/Cliente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(empresaController, 'Empresa/Pyme'),
              _buildTextField(contactoController, 'Contacto'),
              _buildTextField(cargoController, 'Cargo'),
              _buildTextField(
                telefonoController,
                'Teléfono',
                keyboardType: TextInputType.phone,
                validator: _validateTelefono,
              ),
              _buildTextField(especificacionController, 'Especificación Negocio'),
              _buildTextField(necesidadController, 'Necesidad Especificada'),
              _buildTextField(ciudadController, 'Ciudad'),
              _buildTextField(modoContactoController, 'Modo de Contacto'),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator() // Indicador de carga
                  : ElevatedButton(
                onPressed: _guardarEmpresa,
                child: const Text('Guardar Empresa/Cliente'),
              ),
              const SizedBox(height: 16),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.toLowerCase().contains('error') ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator ?? (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
      ),
    );
  }

  String? _validateTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    final regex = RegExp(r'^\+?[\d\s\-]{7,15}$');
    return regex.hasMatch(value) ? null : 'Número de teléfono inválido';
  }
}
