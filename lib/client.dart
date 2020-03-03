import 'package:args/args.dart';
import 'ai/reversi_ai.dart';
import 'network/reversi_client.dart';
import 'argument_reader.dart';

void main(List<String> args) {
  ArgumentParser parser = new ArgumentParser.client();
  ArgResults results = parser.parse(args);

  if (results["help"]){
    print(parser.usage);
    return;
  }
  
  String host = results["host"];
  int playerColor = results["color"] == "black" ? 1 : 2;
  ReversiAi ai = parser.getAi(args);

  ReversiClient reversiClient = new ReversiClient(ai);
  reversiClient.run(host, playerColor, port: int.tryParse(results["port"]));
}


