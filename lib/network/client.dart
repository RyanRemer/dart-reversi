import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
typedef ValueListener<T> = void Function(T value);

class Client {
  Socket socket;

  Future<void> connect(String host, int port) async {
    socket = await Socket.connect(host, port);
  }

  void listen(ValueListener<Uint8List> onData){
    socket.listen(onData);
  } 

  void write(String data){
    socket.write(data);
  }
}
