import 'package:args/args.dart';
import 'package:reversi_dart/ai/human_ai.dart';
import 'package:reversi_dart/ai/reversi_ai.dart';
import 'package:reversi_dart/reversi/game.dart';
import 'argument_reader.dart';

void main(List<String> args){
  ArgumentParser parser = new ArgumentParser.server();
  ArgResults results = parser.parse(args);

  if (results["help"]){
    print(parser.usage);
    return;
  }

  ReversiAi human = new HumanAi();
  ReversiAi ai = parser.getAi(args);
  

  Duration time = new Duration(seconds: int.parse(results["time"]));
  Game game = new Game(time);
  
  game.play(human, ai);
}