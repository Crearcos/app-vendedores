import 'package:flutter/material.dart';
import 'package:app_vendedores_frontend/vendedor/registrar_empresa.dart';
import 'package:app_vendedores_frontend/vendedor/consultar_planes.dart';
import 'package:app_vendedores_frontend/vendedor/consultar_paquetes.dart';
import 'package:app_vendedores_frontend/vendedor/consultar_soluciones.dart';
import 'package:app_vendedores_frontend/vendedor/consultar_tarifarios.dart';
import 'package:app_vendedores_frontend/vendedor/consultar_catalogo.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistroEmpresaPage()),
                );
              },
              child: const Text("Registrar nueva empresa"),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManagePlansScreen()),
                );
              },
              child: const Text("Consultar planes"),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageTarifariosScreen()),
                );
              },
              child: const Text("Consultar tarifarios"),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManagePaquetesScreen()),
                );
              },
              child: const Text("Consultar paquetes"),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageSolucionScreen()),
                );
              },
              child: const Text("Consultar soluciones"),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CatalogoScreen()),
                );
              },
              child: const Text("Consultar catálogo"),
            ),
          ],
        ),
      ),
    );
  }
}