import 'action.dart';
import 'color.dart';
import 'state.dart';

class StateUtils {
  static StateUtils instance = new StateUtils._();
  StateUtils._();
  factory StateUtils.singleton(){
    return instance; 
  }


  List<Action> getActions(State state) {
    List<Action> actions = new List();

    if (state.round < 4) {
      if (state.board[3][3] == Color.Empty) {
        actions.add(new Action(3, 3));
      }
      if (state.board[3][4] == Color.Empty) {
        actions.add(new Action(3, 4));
      }
      if (state.board[4][3] == Color.Empty) {
        actions.add(new Action(4, 3));
      }
      if (state.board[4][4] == Color.Empty) {
        actions.add(new Action(4, 4));
      }
    } else {
      for (int row = 0; row < State.boardSize; row++) {
        for (int col = 0; col < State.boardSize; col++) {
          if (state.board[row][col] == Color.Empty &&
              isValidAction(state, row, col)) {
            actions.add(new Action(row, col));
          }
        }
      }
    }
    
    return actions;
  }

  bool isValidAction(State state, int row, int col) {
    if (state.board[row][col] != Color.Empty) {
      return false;
    }

    for (int xDir = -1; xDir <= 1; xDir++) {
      for (int yDir = -1; yDir <= 1; yDir++) {
        if (xDir == 0 && yDir == 0) {
          continue;
        }

        if (checkDirection(state, row, col, xDir, yDir)) {
          return true;
        }
      }
    }

    return false;
  }

  bool checkDirection(State state, int row, int col, int xDir, int yDir) {
    int playerColor = state.turn;
    int enemyColor = (playerColor == Color.White) ? Color.Black : Color.White;
    List<int> sequence = new List();

    for (int i = 1; i < State.boardSize; i++) {
      int checkRow = row + (i * yDir);
      int checkCol = col + (i * xDir);

      if (checkRow < 0 || checkRow > 7 || checkCol < 0 || checkCol > 7) {
        break;
      }

      sequence.add(state.board[checkRow][checkCol]);
    }

    bool enemeyInPath = false;
    for (int i = 0; i < sequence.length; i++) {
      if (sequence[i] == enemyColor) {
        enemeyInPath = true;
      } else {
        if (sequence[i] == playerColor && enemeyInPath) {
          return true;
        }
        break;
      }
    }

    return false;
  }

  State getNextState(State state, Action action) {
    State nextState = new State();
    nextState.turn = state.turn;
    nextState.round = state.round;
    nextState.board = List.generate(state.board.length, (int row){
      return List.from(state.board[row]);
    });

    nextState.board[action.row][action.col] = state.turn;
    
    for (int xDir = -1; xDir <= 1; xDir++){
      for (int yDir = -1; yDir <= 1; yDir++){
        if (xDir == 0 && yDir == 0){
          continue;
        }

        flipPieces(nextState, action, xDir, yDir);
      }
    }

    nextState.turn = (state.turn == Color.White) ? Color.Black : Color.White;
    nextState.round = state.round+ 1;
    return nextState;
  }

  void flipPieces(State state, Action action, int xDir, int yDir){
    int playerColor = state.board[action.row][action.col];
    int enemyColor = (playerColor == Color.White) ? Color.Black : Color.White;
    
    if (checkDirection(state, action.row, action.col, xDir, yDir)){
      for (int i = 1; i < State.boardSize; i++){
        int flipRow = action.row + (i * yDir);
        int flipCol = action.col + (i * xDir);

        if (flipRow < 0 || flipRow > 7 || flipCol < 0 || flipCol > 7){
          break;
        }

        if (state.board[flipRow][flipCol] == enemyColor){
          state.board[flipRow][flipCol] = playerColor;
        }
        else {
          break;
        }
      }
    }
  }
}