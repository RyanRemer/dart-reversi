import '../reversi/state.dart';

class ReversiStateMessage {
  State state;

  ReversiStateMessage.fromData(List<String> socketData) {
    state = new State();
    state.turn = int.parse(socketData[0]);
    state.round = int.parse(socketData[1]);
    state.time1 = double.parse(socketData[2]);
    state.time2 = double.parse(socketData[3]);

    state.board = List.generate(State.boardSize, (row){
      return List.generate(State.boardSize, (col){
        return int.parse(socketData[row*State.boardSize + col + 4]);
      });
    });
  }

  @override
  String toString() {
    return state.toString();
  }
}