import '../../reversi/state.dart';
import 'heuristic.dart';

class WeightedHeuristic extends Heuristic {
  List<double> weights;
  List<Heuristic> heuristics;

  WeightedHeuristic({this.weights, this.heuristics}){
    if (weights.length != heuristics.length){
      throw("Must be equal amount of weights and heuristics");
    }
  }

  @override
  double calculate(State state) {
    double score = 0.0;
    for (int i = 0; i < heuristics.length; i++){
      score += weights[i] * heuristics[i].calculate(state);
    }
    return score;
  }

  @override
  double get maxValue => double.infinity;

  @override
  double get minValue => double.negativeInfinity;
}