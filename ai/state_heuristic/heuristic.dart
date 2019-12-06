import '../../reversi/state.dart';

abstract class Heuristic {
  double calculate(State state);

  double get minValue;
  double get maxValue;
}