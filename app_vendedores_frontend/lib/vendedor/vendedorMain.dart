import 'package:flutter/material.dart';
import 'package:app_vendedores_frontend/vendedor/registrar_empresa.dart';

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
            ElevatedButton(
              onPressed: () {
                print("Navegando a RegistroEmpresaPage");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistroEmpresaPage()),
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
