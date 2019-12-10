import 'dart:math';

import '../reversi/action.dart';
import '../reversi/color.dart';
import '../reversi/state.dart';
import 'reversi_ai.dart';
import 'state_heuristic/heuristic.dart';

class DepthAi extends ReversiAi {
  Heuristic heuristic;
  int depth;
  int nodesVisited;
  Stopwatch stopwatch = new Stopwatch();

  DepthAi({this.depth, this.heuristic});

  @override
  Future<Action> getAction(State state) async {
    stopwatch.start();
    double alpha = heuristic.minValue;
    double beta = heuristic.maxValue;

    double value;
    Action bestAction;
    nodesVisited = 0;

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

    stopwatch.stop();
    printInfo(value, state);
    adjustDepth(state);
    stopwatch.reset();
    return bestAction;
  }

  void printInfo(double value, State state) {
    String output =
        "value: ${value.toStringAsFixed(3)}\tnodes visited: $nodesVisited\ttime: ${stopwatch.elapsedMilliseconds} ms\tdepth: $depth";
    if (64 - state.round - depth <= 0) {
      output += "\t found terminal!";
    }
    print(output);
  }

  void adjustDepth(State state) {
    double totalTime = state.turn == Color.Black ? state.time1 : state.time2;
    double turnTime = (64.0 - state.round) / 2;
    double timePerTurn = totalTime / turnTime;

    double timeSpent =
        stopwatch.elapsed.inMilliseconds / Duration.millisecondsPerSecond;

    if (timeSpent > timePerTurn * 0.75) {
      depth -= 1;
    } else if (timeSpent < timePerTurn * 0.25) {
      depth += 1;
    }
  }

  double alphaBeta(State state, double alpha, double beta, int depth) {
    if (state.isTerminal || depth == 0) {
      nodesVisited += 1;
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
