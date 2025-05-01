import 'package:app_vendedores_frontend/vendedor//registrar_empresa.dart';
import 'package:flutter/material.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendedor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Vendedor', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),

            // Botón para ir a la pantalla de registro de empresa
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterUserScreen()),
                );
              },
              child: const Text("Registrar nueva empresa"),
            ),
          ],
        ),
      ),
    );
  }
}