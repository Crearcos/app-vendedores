import 'package:app_vendedores_frontend/administrador/registrar_usuarios.dart';
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

  String getApiUrlEditUsers() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/edit_user/'; // Para emulador Android
    } else {
      return 'http://127.0.0.1:8000/api/edit_user/'; // Para escritorio o navegador
    }
  }

  Future<void> _editUser(String email, String newUsername, String newRole) async {
    final String apiUrl = getApiUrlEditUsers();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "username": newUsername,
        "role": newRole,
      }),
    );

    if (response.statusCode == 200) {
      _fetchUsers(); // Recargar la lista de usuarios después de editar
    } else {
      setState(() {
        _errorMessage = "Error al actualizar usuario";
      });
    }
  }

  void _showEditDialog(Map<String, dynamic> user) {
    final TextEditingController usernameController = TextEditingController(text: user['username']);
    String selectedRole = user['role'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Usuario"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Nombre de usuario"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: (String? newValue) {
                  selectedRole = newValue!;
                },
                items: const [
                  DropdownMenuItem(value: "administrador", child: Text("Administrador")),
                  DropdownMenuItem(value: "vendedor", child: Text("Vendedor")),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _editUser(user['email'], usernameController.text, selectedRole);
                Navigator.pop(context);
              },
              child: const Text("Guardar cambios"),
            ),
          ],
        );
      },
    );
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

  void _showDeleteConfirmationDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Nombre: ${user['username']}"),
              Text("Correo: ${user['email']}"),
              Text("Rol: ${user['role']}"),
              const SizedBox(height: 16),
              const Text("¿Estás seguro de que deseas eliminar este usuario?", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteUser(user['email']);
                Navigator.pop(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
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
        itemCount: _users.length + 1, // Agregamos espacio para el botón
        itemBuilder: (context, index) {
          if (index == _users.length) {
            // Botón de "Registrar nuevo usuario" al final
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterUserScreen()),
                      ).then((_) {
                        _fetchUsers(); // Recargar toda la lista cuando regrese
                      });
                    },
                    child: const Text("Registrar nuevo usuario"),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          final user = _users[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(user['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Correo: ${user['email']}"),
                  Text("Rol: ${user['role']}", style: const TextStyle(color: Colors.blue)),
                ],
              ),
              trailing: user['email'] == widget.adminEmail
                  ? const Icon(Icons.lock, color: Colors.grey)
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _showEditDialog(user), // Abrir edición
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(user), // Abrir diálogo antes de eliminar
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}