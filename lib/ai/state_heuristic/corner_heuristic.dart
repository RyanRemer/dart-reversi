import '../../reversi/color.dart';
import '../../reversi/state.dart';
import 'heuristic.dart';

class CornerHeuristic extends Heuristic {
  @override
  double calculate(State state) {
    List<int> corners = [0, State.boardSize - 1];

    double score = 0.0;
    for (int row in corners) {
      for (int col in corners) {
        if (state.board[row][col] == Color.Black) {
          score += 1.0;
        } else if (state.board[row][col] == Color.White) {
          score -= 1.0;
        }
      }
    }

    if (score > 3.0){
      return 3.0;
    }
    else if (score < -3.0){
      return -3.0;
    }
    else {
      return score;
    }
  }

  @override
  double get maxValue => 4;

  @override
  double get minValue => -4;
}
