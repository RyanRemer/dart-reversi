import 'dart:math';

import '../reversi/action.dart';
import '../reversi/state.dart';
import 'reversi_ai.dart';

class RandomAi extends ReversiAi {
  Random random = Random();

  @override
  Future<Action> getAction(State state) async {
    List<Action> actions = state.actions;
    return actions[random.nextInt(actions.length)];
  }

}