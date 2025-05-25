import 'package:app_vendedores_frontend/websocket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_vendedores_frontend/vendedor/registrar_empresa.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

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
                if (kDebugMode) {
                  print("Navegando a RegistroEmpresaPage");
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistroEmpresaPage()),
                );
              },
              child: const Text("Registrar nueva empresa"),
            ),
            Text(
              'Este es un texto que no se puede seleccionar.',
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}

class SellerScreenSecure extends StatefulWidget {
  const SellerScreenSecure({super.key});

  @override
  SellerScreenSecureState createState() => SellerScreenSecureState();
}

class SellerScreenSecureState extends State<SellerScreenSecure> {
  @override
  void initState() {
    super.initState();
    _preventScreenshot();
  }

  Future<void> _preventScreenshot() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

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
                // Navegar a la página de registro de empresa
              },
              child: const Text("Registrar nueva empresa"),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  SellerHomeScreenState createState() => SellerHomeScreenState();
}

class SellerHomeScreenState extends State<SellerHomeScreen> {
  final WebSocketService _webSocketService = WebSocketService();
  final TextEditingController _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _webSocketService.connect('ws://tu-servidor-websocket'); // Reemplaza con tu URL
  }

  void _sendData() {
    if (_dataController.text.isNotEmpty) {
      _webSocketService.sendData({
        'data': _dataController.text,
        // Agrega otros campos según sea necesario
      });
      _dataController.clear(); // Limpiar el campo después de enviar
    }
  }

  @override
  void dispose() {
    _webSocketService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendedor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _dataController,
              decoration: const InputDecoration(labelText: 'Ingresa datos'),
            ),
            ElevatedButton(
              onPressed: _sendData,
              child: const Text('Enviar Datos'),
            ),
          ],
        ),
      ),
    );
  }
}