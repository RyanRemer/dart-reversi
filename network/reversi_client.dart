import 'dart:io';
import 'dart:typed_data';

import '../ai/reversi_ai.dart';
import '../reversi/action.dart';
import '../reversi/state.dart';
import 'connection_message.dart';
import 'reversi_state_message.dart';

///
/// [ReversiClient] establishes a connection with the server via [Socket]
/// The server is expected to respond with a [ReversiStateMessage] that
/// contains a [State], this [State] is given to the [ReversiAi] to
/// determine the best move to send back to the server
///
class ReversiClient {
  ReversiAi ai;
  Socket socket;

  int playerColor;
  int totalMinutes;

  ReversiClient(this.ai);

  Future<void> run(String host, int playerColor) async {
    socket = await Socket.connect(host, 3333 + playerColor);

    socket.listen((Uint8List socketData) async {
      List<String> data = convertToStrings(socketData);

      if (data.length == 2){
        ConnectionMessage connectionMessage = ConnectionMessage.fromData(data);

        playerColor = connectionMessage.playerColor;
        totalMinutes = connectionMessage.playerMinutes;
      }
      else if (data.length == 68){
        ReversiStateMessage reversiStateMessage = ReversiStateMessage.fromData(data);
        State state = reversiStateMessage.state;

        if (state.round >= 64){
          print(state);
          print("Game Over!");
          socket.destroy();
          return;
        }

        if (state.turn == playerColor){
          Action action = await ai.getAction(state);
          socket.write("${action.row}\n${action.col}\n");
          ai.waiting();
        }
      }
    });
  }

  List<String> convertToStrings(Uint8List socketData) {
    List<String> data =
        String.fromCharCodes(socketData).split(new RegExp(r"\s"));
    data.removeWhere((data) => data.isEmpty);
    return data;
  }
}
