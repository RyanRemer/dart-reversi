import '../reversi/action.dart';
import '../reversi/state.dart';

abstract class ReversiAi {
  Future<Action> getAction(State state);
  Future waiting() async{
    return null;
  }
}