import 'package:flutter/material.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendedor')),
      body: const Center(
        child: Text('Vendedor', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
