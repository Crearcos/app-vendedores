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
  final TextEditingController representanteController = TextEditingController();
  final TextEditingController cargoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController giroController = TextEditingController();
  final TextEditingController necesidadController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController modoContactoController = TextEditingController();

  String _message = '';
  bool _isLoading = false;

  @override
  void dispose() {
    empresaController.dispose();
    representanteController.dispose();
    cargoController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    giroController.dispose();
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
      "nombre_empresa": empresaController.text.trim(),
      "representante": representanteController.text.trim(),
      "cargo": cargoController.text.trim(),
      "telefono": telefonoController.text.trim(),
      "email": emailController.text.trim(),
      "giro": giroController.text.trim(),
      "necesidad_detectada": necesidadController.text.trim(),
      "ciudad": ciudadController.text.trim(),
      "modo_contacto": modoContactoController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(getApiUrl()),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      final decodedResponse = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(decodedResponse);

      if (response.statusCode == 201) {
        setState(() {
          _message = responseData['message'] ?? 'Empresa registrada correctamente';
        });
        _clearControllers();
      } else {
        setState(() {
          _message = responseData['message'] ?? 'Error al registrar empresa: ${response.body}';
        });
      }
    } catch (e) {
      setState(() => _message = 'Error de conexión: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearControllers() {
    empresaController.clear();
    representanteController.clear();
    cargoController.clear();
    telefonoController.clear();
    emailController.clear();
    giroController.clear();
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
              _buildTextField(empresaController, 'Nombre de la Empresa'),
              _buildTextField(representanteController, 'Representante'),
              _buildTextField(cargoController, 'Cargo'),
              _buildTextField(
                telefonoController,
                'Teléfono',
                keyboardType: TextInputType.phone,
                validator: _validateTelefono,
              ),
              _buildTextField(emailController, 'Correo Electrónico', keyboardType: TextInputType.emailAddress),
              _buildTextField(giroController, 'Giro Empresarial'),
              _buildTextField(necesidadController, 'Necesidad Detectada'),
              _buildTextField(ciudadController, 'Ciudad'),
              _buildTextField(modoContactoController, 'Modo de Contacto'),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
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
