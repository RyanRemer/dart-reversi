import 'dart:math';

import '../reversi/action.dart';
import '../reversi/color.dart';
import '../reversi/state.dart';
import 'reversi_ai.dart';
import 'state_heuristic/heuristic.dart';

class AlphaBetaAi extends ReversiAi {
  Heuristic heuristic;
  int depth;
  int nodesVisited;
  Stopwatch stopwatch = new Stopwatch();

  AlphaBetaAi({this.depth, this.heuristic});

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
    adjustDepth(state);
    print ("value: ${value.toStringAsFixed(3)}\tnodes visited:${nodesVisited}\ttime:${stopwatch.elapsedMilliseconds} ms");
    stopwatch.reset();
    return bestAction;
  }

  void adjustDepth(State state) {
    double timeForTurn = (state.playerColor == Color.Black ? state.time1 : state.time2) / (64-state.round);
    double timeSpent = stopwatch.elapsed.inMilliseconds / Duration.millisecondsPerSecond;
    
    if (timeSpent > timeForTurn){
      depth -= 1;
      print("Depth Increased: ${depth}");
    }
    else if (timeSpent < timeForTurn * 0.25){
      depth += 1;
      print("Depth Decreased: ${depth}");
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
