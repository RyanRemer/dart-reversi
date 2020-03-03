import 'dart:io';

import '../reversi/action.dart';
import '../reversi/state.dart';
import '../reversi/color.dart';
import 'reversi_ai.dart';

class HumanAi extends ReversiAi {
  @override
  Future<Action> getAction(State state) async {
    showBoard(state);
    return getUserInput(state);
  }

  void showBoard(State state){
    print("");
    print("1 = black, 2 = white, x = possible move, . = empty");
    print("time1: ${state.time1.toStringAsFixed(2)} time2: ${state.time2.toStringAsFixed(2)}");

    String board = "";

    for (int row = 0; row < State.boardSize; row++){
      if (row == 0){
        board += "  a b c d e f g h\n";
      }
      for (int col = 0; col < State.boardSize; col++){
        if (col == 0){
          board += (row.toString() + " ");
        }
        
        if (state.board[row][col] == Color.Black){
          board += ("1 ");
        }
        else if (state.board[row][col] == Color.White){
          board += ("2 ");
        }
        else if (isPossibleAction(state, row, col)) {
          board += ("x ");
        }
        else {
          board += (". ");
        }
      }
      board += "\n";
    }
    
    print(board);
  }

  bool isPossibleAction(State state, int row, int col){
    Action action = new Action(row, col);
    return state.actions.contains(action);
  }

  Action getUserInput(State state) {
    Action action;

    while(action == null){
      List<String> userInput = input("enter column (a-h) then row (1-8) - example d3:").split("");
      
      int row = int.parse(userInput.last);
      int col = userInput.first.codeUnits.first - "a".codeUnits.first;
      action = new Action(row, col);
      print("$userInput : $action");

      if (state.actions.contains(action) == false){
        if (state.round < 4){
          print("You must place a piece in the middle");
        }
        else {
          print("Invalid move: $userInput - you must flip at least one piece");
        }
        action = null;
      }
    }

    return action;
  }

  String input(String prompt){
    print(prompt);
    return stdin.readLineSync();
  }



}