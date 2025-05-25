import 'dart:convert';
import 'dart:io';
import 'dart:developer';

class WebSocketService {
  late WebSocket _socket;

  // Método para conectar al servidor WebSocket
  Future<void> connect(String url) async {
    _socket = await WebSocket.connect(url);
    _socket.listen((message) {
      // Manejar mensajes recibidos
      // Log the received message for debugging purposes
      log('Mensaje recibido: $message');
    });
  }

  // Método para enviar datos al servidor
  void sendData(Map<String, dynamic> data) {
    _socket.add(jsonEncode(data));
  }

  // Método para cerrar la conexión
  void close() {
    _socket.close();
  }
}
