import 'dart:math';

import '../../reversi/state.dart';
import 'heuristic.dart';

class RandomHeuristic extends Heuristic {
  Random random = new Random();

  @override
  double calculate(State state) {
    return random.nextDouble() * (2.0) - 1.0;
  }

  @override
  double get maxValue => 1.0;

  @override
  double get minValue => -1.0;

}