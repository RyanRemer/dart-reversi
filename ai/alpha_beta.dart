import 'dart:math';

import '../reversi/action.dart';
import '../reversi/color.dart';
import '../reversi/state.dart';
import 'reversi_ai.dart';
import 'state_heuristic/heuristic.dart';

class AlphaBetaAi extends ReversiAi {
  Heuristic heuristic;
  int depth;

  AlphaBetaAi({this.depth, this.heuristic});

  @override
  Future<Action> getAction(State state) async {
    double alpha = heuristic.minValue;
    double beta = heuristic.maxValue;

    double value;
    Action bestAction;

    if (state.playerColor == Color.Black) {
      value = heuristic.minValue;
      for (Action action in state.actions) {
        State next = state.getNextState(action);
        double futureValue = alphaBeta(next, alpha, beta, depth - 1);

        if (value < futureValue) {
          bestAction = action;
          value = futureValue;
        }

        alpha = max(alpha, value);
        if (alpha >= beta) {
          break;
        }
      }
    } else {
      value = heuristic.maxValue;
      for (Action action in state.actions) {
        State next = state.getNextState(action);
        double futureValue = alphaBeta(next, alpha, beta, depth - 1);

        if (value > futureValue) {
          bestAction = action;
          value = futureValue;
        }

        beta = min(beta, value);
        if (alpha >= beta) {
          break;
        }
      }
    }

    print(value);
    return bestAction;
  }

  double alphaBeta(State state, double alpha, double beta, int depth) {
    if (state.isTerminal || depth == 0) {
      return heuristic.calculate(state);
    }

    double value;

    if (state.playerColor == Color.Black) {
      value = heuristic.minValue;
      for (Action action in state.actions) {
        State next = state.getNextState(action);
        value = max(value, alphaBeta(next, alpha, beta, depth - 1));
        alpha = max(alpha, value);
        if (alpha >= beta) {
          break;
        }
      }
    } else {
      value = heuristic.maxValue;
      for (Action action in state.actions) {
        State next = state.getNextState(action);
        value = min(value, alphaBeta(next, alpha, beta, depth - 1));
        beta = min(beta, value);
        if (alpha >= beta) {
          break;
        }
      }
    }
    return value;
  }
}
