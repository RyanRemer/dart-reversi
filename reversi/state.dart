import 'action.dart';
import 'color.dart';
import 'state_utils.dart';

class State {
  static const int boardSize = 8;
  double time1;
  double time2;
  int turn;
  int round;
  List<List<int>> board;
  StateUtils stateUtils = new StateUtils.singleton();

  int get playerColor => turn;
  int get enemyColor => turn == Color.Black ? Color.White : Color.Black;
  bool get isTerminal => round >= 64 || actions.length == 0;

  State();

  List<Action> _actions;
  List<Action> get actions {
    if (_actions == null) {
      _actions = stateUtils.getActions(this);
    }
    return _actions;
  }

  State getNextState(Action action) {
    return stateUtils.getNextState(this, action);
  }

  void skipTurn() {
    this.turn = (this.turn == Color.White) ? Color.Black : Color.White;
  }

  State.from(State state) {
    this.time1 = state.time1;
    this.time2 = state.time2;
    this.round = state.round;
    this.turn = state.turn;
    this.board = List.generate(State.boardSize, (int row) {
      return List.generate(State.boardSize, (int col) {
        return state.board[row][col];
      });
    });
  }

  State.start(double milliseconds) {
    this.time1 = milliseconds;
    this.time2 = milliseconds;
    this.turn = Color.Black;
    this.round = 0;
    this.board = List.generate(State.boardSize, (int row) {
      return List.filled(State.boardSize, Color.Empty);
    });
  }

  @override
  int get hashCode =>
      this.turn + this.board.first.fold(0, (value, cell) => value + cell);

  @override
  bool operator ==(other) {
    if (other is State && other.turn == this.turn) {
      for (int row = 0; row < State.boardSize; row++) {
        for (int col = 0; col < State.boardSize; col++) {
          if (other.board[row][col] != this.board[row][col]) {
            return false;
          }
        }
      }
      return true;
    }
    return false;
  }

  @override
  String toString() {
    String output = "turn: ${turn}\nround: ${round}\n\n";
    for (int row = State.boardSize - 1; row >= 0; row--) {
      for (int col = 0; col < State.boardSize; col++) {
        output += board[row][col].toString() + " ";
      }
      output += "\n";
    }
    output += "\n";
    return output;
  }
}
