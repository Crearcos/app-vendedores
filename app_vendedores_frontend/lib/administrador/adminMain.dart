import 'package:flutter/material.dart';
import 'package:app_vendedores_frontend/administrador/gestionar_usuarios.dart';

class AdminScreen extends StatelessWidget {
  final String adminEmail; // Guardar el correo del administrador en sesión

  const AdminScreen({super.key, required this.adminEmail}); // Se requiere el correo del admin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Administrador: $adminEmail', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),

            // Botón para gestionar usuarios
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageUsersScreen(adminEmail: adminEmail)), // Envía el correo del admin
                );
              },
              child: const Text("Gestionar usuarios"),
            ),
          ],
        ),
      ),
    );
  }
}
