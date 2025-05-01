import 'package:flutter/material.dart';
import 'package:app_vendedores_frontend/administrador/registrar_usuarios.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Administrador', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),

            // Botón para ir a la pantalla de registro de usuario
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterUserScreen()),
                );
              },
              child: const Text("Registrar nuevo usuario"),
            ),
          ],
        ),
      ),
    );
  }
}