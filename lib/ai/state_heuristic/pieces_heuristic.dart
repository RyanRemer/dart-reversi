import '../../reversi/color.dart';
import '../../reversi/state.dart';
import 'heuristic.dart';

class PiecesHeuristic extends Heuristic {
  @override
  double calculate(State state) {
    double score = 0.0;
    for (int row = 0; row < State.boardSize; row++) {
      for (int col = 0; col < State.boardSize; col++) {
        if (state.board[row][col] == Color.Black){
          score += 1.0;
        }
        else if (state.board[row][col] == Color.White){
          score -= 1.0;
        }
      }
    }
    return score;
  }

  @override
  double get maxValue => 65.0;

  @override
  double get minValue => -65.0;
}
