

import '../../reversi/color.dart';
import '../../reversi/state.dart';
import 'heuristic.dart';

class MovesHeuristic extends Heuristic {
  @override
  double calculate(State state) {
    if (state.playerColor == Color.Black){
      return state.actions.length.toDouble();
    }
    else {
       return -1 * state.actions.length.toDouble();
    }
  }

  @override
  double get maxValue => 20;

  @override
  double get minValue => -20;

}