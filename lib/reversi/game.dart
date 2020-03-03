import 'package:reversi_dart/ai/reversi_ai.dart';
import 'package:reversi_dart/reversi/action.dart';
import 'package:reversi_dart/reversi/color.dart';
import 'package:reversi_dart/reversi/state.dart';

class Game {
  State state;
  Duration turnTime;
  final gameLength = 64;

  Game(this.turnTime) {
    this.state = new State.start(turnTime.inSeconds.toDouble());
  }

  Future<void> play(ReversiAi player1, ReversiAi player2) async {
    Stopwatch stopwatch = new Stopwatch();

    while (state.round < gameLength) {
      ReversiAi player;

      // if there are no valid moves for the player skip their turn
      if (state.actions.isEmpty) {
        print("No Valid Moves, Skipping Turn: ");
        state.skipTurn();
        if (state.actions.isEmpty){
          // if both players have no moves left, end the game
          break;
        }
        continue;
      }

      if (state.turn == Color.Black) {
        print("Black's Turn:");
        player = player1;
      } else {
        print("White's Turn");
        player = player2;
      }

      // get the players move
      stopwatch.start();
      Action action = await player.getAction(state);
      stopwatch.stop();

      // if the player tries an invalid move, send back the same state
      while (!state.actions.contains(action)) {
        print("Invalid move: $action");
        stopwatch.start();
        action = await player.getAction(state);
        stopwatch.stop();
      }

      // subtract the time that it took the player to move
      if (state.turn == Color.Black) {
        state.time1 -= stopwatch.elapsed.inSeconds;
      } else {
        state.time2 -= stopwatch.elapsed.inSeconds;
      }

      // end the game if either player ran out of time
      if (state.time1 < 0) {
        print("Player 1 ran out of time!");
        break;
      } else if (state.time2 < 0) {
        print("Player 2 ran out of time!");
        break;
      }

      state = state.getNextState(action);
      print(state);
      stopwatch.reset();
    }

    int numWhite = 0;
    int numBlack = 0;

    for (int row = 0; row < State.boardSize; row++) {
      for (int col = 0; col < State.boardSize; col++) {
        if (state.board[row][col] == Color.White) {
          numWhite++;
        } else if (state.board[row][col] == Color.Black) {
          numBlack++;
        }
      }
    }

    print(state);
    print("White: $numWhite\nBlack: $numBlack");
  }
}
