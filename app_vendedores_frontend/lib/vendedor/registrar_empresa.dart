import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class RegistroEmpresaPage extends StatefulWidget {
  const RegistroEmpresaPage({super.key});

  @override
  RegistroEmpresaPageState createState() => RegistroEmpresaPageState();
}

class RegistroEmpresaPageState extends State<RegistroEmpresaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controladores para campos de texto
  final TextEditingController empresaController = TextEditingController();
  final TextEditingController giroController = TextEditingController();
  final TextEditingController representanteController = TextEditingController();
  final TextEditingController cargoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController necesidadController = TextEditingController();
  final TextEditingController productoServicioController = TextEditingController();
  final TextEditingController proximaCitaController = TextEditingController();
  final TextEditingController notasCitaController = TextEditingController();

  // Listas para dropdowns (tipo empresa y modo contacto)
  final List<Map<String, String>> tiposEmpresa = [
    {'value': 'PYME', 'label': 'Pequeña y Mediana Empresa'},
    {'value': 'CORP', 'label': 'Corporación'},
    {'value': 'STARTUP', 'label': 'Startup'},
    {'value': 'ONG', 'label': 'Organización No Gubernamental'},
    {'value': 'GUB', 'label': 'Entidad Gubernamental'},
    {'value': 'OTRO', 'label': 'Otro tipo de organización'},
  ];

  final List<Map<String, String>> modosContacto = [
    {'value': 'EMAIL', 'label': 'Correo Electrónico'},
    {'value': 'WHATSAPP', 'label': 'WhatsApp'},
    {'value': 'LLAMADA', 'label': 'Llamada Telefónica'},
    {'value': 'VISITA', 'label': 'Visita Presencial'},
    {'value': 'VIDEOCALL', 'label': 'Videollamada'},
  ];

  // Variables para almacenar selección dropdown
  String? _tipoEmpresaSeleccionado;
  String? _modoContactoSeleccionado;

  String _message = '';
  bool _isLoading = false;

  @override
  void dispose() {
    empresaController.dispose();
    giroController.dispose();
    representanteController.dispose();
    cargoController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    direccionController.dispose();
    necesidadController.dispose();
    productoServicioController.dispose();
    proximaCitaController.dispose();
    super.dispose();
  }

  Future<void> _guardarEmpresa() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _message = 'Por favor, complete todos los campos obligatorios correctamente.');
      return;
    }

    if (_tipoEmpresaSeleccionado == null) {
      setState(() => _message = 'Por favor, seleccione un Tipo de Empresa.');
      return;
    }

    if (_modoContactoSeleccionado == null) {
      setState(() => _message = 'Por favor, seleccione un Modo de Contacto.');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    final Map<String, dynamic> data = {
      "nombre_empresa": empresaController.text.trim(),
      "tipo_empresa": _tipoEmpresaSeleccionado!,
      "giro": giroController.text.trim(),
      "representante": representanteController.text.trim(),
      "cargo": cargoController.text.trim(),
      "telefono": telefonoController.text.trim(),
      "email": emailController.text.trim(),
      "direccion": direccionController.text.trim(),
      "necesidad_detectada": necesidadController.text.trim(),
      "producto_servicio_interes": productoServicioController.text.trim(),
      "proxima_cita": proximaCitaController.text.trim(),
      "modo_contacto": _modoContactoSeleccionado!,
      "notas_cita": notasCitaController.text.trim(),
    };

    try {
      final String apiUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000/api/empresa/registro/'
          : 'http://127.0.0.1:8000/api/empresa/registro/';
      final response = await http.post(
        Uri.parse(apiUrl),
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
          _message = responseData['message'] ?? 'Error al registrar empresa';
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
    giroController.clear();
    representanteController.clear();
    cargoController.clear();
    telefonoController.clear();
    emailController.clear();
    direccionController.clear();
    necesidadController.clear();
    productoServicioController.clear();
    proximaCitaController.clear();
    setState(() {
      _tipoEmpresaSeleccionado = null;
      _modoContactoSeleccionado = null;
    });
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
              // 1. Empresa (ObligatorempresaControllerio)
              _buildTextField(empresaController, 'Nombre de la Empresa', validator: _campoObligatorio),

              const SizedBox(height: 12),

              // 2. Tipo de empresa (dropdown obligatorio)
              DropdownButtonFormField<String>(
                value: _tipoEmpresaSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Empresa',
                  border: OutlineInputBorder(),
                ),
                items: tiposEmpresa.map((tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo['value'],
                    child: Text(tipo['value']!), // Mostrar siglas
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoEmpresaSeleccionado = value;
                  });
                },
                validator: (value) => value == null ? 'Seleccione un tipo de empresa' : null,
              ),

              const SizedBox(height: 12),

              // 3. Giro (Opcional)
              _buildTextField(giroController, 'Giro Empresarial'),

              const SizedBox(height: 12),

              // 4. Nombre representante (Obligatorio)
              _buildTextField(representanteController, 'Nombre del Representante', validator: _campoObligatorio),

              const SizedBox(height: 12),

              // 5. Cargo (Opcional)
              _buildTextField(cargoController, 'Cargo'),

              const SizedBox(height: 12),

              // 6. Teléfono (Obligatorio)
              _buildTextField(telefonoController, 'Teléfono', keyboardType: TextInputType.phone, validator: _campoObligatorio),

              const SizedBox(height: 12),

              // 7. Correo electrónico (Opcional)
              _buildTextField(emailController, 'Correo Electrónico', keyboardType: TextInputType.emailAddress, validator: _validarEmailOpcional),

              const SizedBox(height: 12),

              // 8. Dirección (Opcional)
              _buildTextField(direccionController, 'Dirección Completa'),

              const SizedBox(height: 12),

              // 9. Necesidad detectada (Obligatorio)
              _buildTextField(necesidadController, 'Necesidad Detectada', validator: _campoObligatorio),

              const SizedBox(height: 12),

              // 10. Producto/Servicio de interés (Opcional)
              _buildTextField(productoServicioController, 'Producto/Servicio de Interés'),

              const SizedBox(height: 12),

              // 11. Agendamiento cita (Opcional)
              TextField(
                controller: proximaCitaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha y Hora de la Cita',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // 12. Notas adicionales (Opcional)
              TextField(
                controller: notasCitaController,
                decoration: const InputDecoration(
                  labelText: 'Notas Adicionales',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Modo de contacto (dropdown obligatorio)
              DropdownButtonFormField<String>(
                value: _modoContactoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Modo de Contacto',
                  border: OutlineInputBorder(),
                ),
                items: modosContacto.map((modo) {
                  return DropdownMenuItem<String>(
                    value: modo['value'],
                    child: Text(modo['value']!), // Mostrar siglas
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _modoContactoSeleccionado = value;
                  });
                },
                validator: (value) => value == null ? 'Seleccione un modo de contacto' : null,
              ),

              const SizedBox(height: 24),

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
        validator: validator ?? (value) => null, // Por defecto no obligatorio
      ),
    );
  }

  String? _campoObligatorio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }

  String? _validarEmailOpcional(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Opcional
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Correo electrónico inválido';
    }
    return null;
  }
}
