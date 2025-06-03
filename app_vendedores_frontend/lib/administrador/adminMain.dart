import 'package:flutter/material.dart';
import 'package:app_vendedores_frontend/administrador/gestionar_usuarios.dart';
import 'package:app_vendedores_frontend/administrador/gestionar_planes.dart';
import 'package:app_vendedores_frontend/administrador/gestionar_tarifarios.dart';
import 'package:app_vendedores_frontend/administrador/gestionar_paquetes.dart';

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
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManagePlansScreen()),
                );
              },
              child: const Text("Gestionar planes"),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageTarifariosScreen()),
                );
              },
              child: const Text("Gestionar tarifarios"),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManagePaquetesScreen()),
                );
              },
              child: const Text("Gestionar paquetes"),
            ),
          ],
        ),
      ),
    );
  }
}
