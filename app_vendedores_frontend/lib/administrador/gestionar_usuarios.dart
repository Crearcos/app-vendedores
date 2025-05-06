import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ManageUsersScreen extends StatefulWidget {
  final String adminEmail; // Correo del administrador en sesión

  const ManageUsersScreen({super.key, required this.adminEmail});

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  String getApiUrlFetchUsers() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/users/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/users/'; // Para escritorio o navegador
    }
  }

  Future<void> _fetchUsers() async {
    final String apiUrl = getApiUrlFetchUsers();  // Ruta del backend para obtener usuarios

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedResponse);
        setState(() {
          _users = data.map((user) => user as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Error al obtener usuarios";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión";
        _isLoading = false;
      });
    }
  }

  String getApiUrlDeleteUsers() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/delete_user/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/delete_user/'; // Para escritorio o navegador
    }
  }

  Future<void> _deleteUser(String email) async {
    if (email == widget.adminEmail) {
      setState(() {
        _errorMessage = "No puedes eliminar tu propio usuario";
      });
      return;
    }

    final String apiUrl = getApiUrlDeleteUsers();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _users.removeWhere((user) => user['email'] == email);
      });
    } else {
      setState(() {
        _errorMessage = "Error al eliminar usuario";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar usuarios')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(user['username']),
              subtitle: Text(user['email']),
              trailing: user['email'] == widget.adminEmail
                  ? const Icon(Icons.lock, color: Colors.grey) // No se puede eliminar al admin en sesión
                  : IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteUser(user['email']),
              ),
            ),
          );
        },
      ),
    );
  }
}