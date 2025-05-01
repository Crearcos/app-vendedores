import 'package:flutter/material.dart';

class RegistroEmpresaPage extends StatefulWidget {
  @override
  _RegistroEmpresaPageState createState() => _RegistroEmpresaPageState();
}

class _RegistroEmpresaPageState extends State<RegistroEmpresaPage> {
  // Controladores para los campos de formulario
  final _formKey = GlobalKey<FormState>();
  final empresaController = TextEditingController();
  final contactoController = TextEditingController();
  final cargoController = TextEditingController();
  final telefonoController = TextEditingController();
  final especificacionController = TextEditingController();
  final necesidadController = TextEditingController();
  final ciudadController = TextEditingController();
  final modoContactoController = TextEditingController();

  @override
  void dispose() {
    // Limpia los controladores al destruir el widget
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Empresa/Cliente')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sección 1: Ingreso de datos de empresa/cliente
              Text('Datos de la Empresa/Cliente', style: Theme.of(context).textTheme.headline6),
              _buildTextField(empresaController, 'Empresa/Pyme'),
              _buildTextField(contactoController, 'Contacto'),
              _buildTextField(cargoController, 'Cargo'),
              _buildTextField(telefonoController, 'Teléfono', keyboardType: TextInputType.phone),
              _buildTextField(especificacionController, 'Especificación Negocio'),
              _buildTextField(necesidadController, 'Necesidad Especificada'),
              _buildTextField(ciudadController, 'Ciudad'),
              _buildTextField(modoContactoController, 'Modo de Contacto'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí puedes enviar los datos al backend Django
                  }
                },
                child: Text('Guardar Empresa/Cliente'),
              ),
              Divider(height: 40),
              // Sección 2: Tarifarios
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Ver Tarifarios'),
                onTap: () {
                  // Navegar a pantalla de tarifarios
                },
              ),
              // Sección 3: Paquetes y Cursos
              ListTile(
                leading: Icon(Icons.school),
                title: Text('Paquetes y Cursos Ofrecidos'),
                onTap: () {
                  // Navegar a pantalla de paquetes/cursos
                },
              ),
              // Sección 4: Proveedores y Clasificación
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Proveedores y Clasificación'),
                onTap: () {
                  // Navegar a pantalla de proveedores
                },
              ),
              // Sección 5: Descargar Catálogo
              ListTile(
                leading: Icon(Icons.download),
                title: Text('Descargar Catálogo'),
                onTap: () {
                  // Acción de descarga
                },
              ),
              // Sección 6: Soluciones Sugeridas
              ListTile(
                leading: Icon(Icons.lightbulb),
                title: Text('Ver Soluciones Sugeridas'),
                onTap: () {
                  // Navegar a pantalla de soluciones sugeridas
                },
              ),
              // Sección 7: Registrar Citas Futuras
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Registrar Cita Futura'),
                onTap: () {
                  // Navegar a pantalla de registro de citas
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: keyboardType,
        validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }
}