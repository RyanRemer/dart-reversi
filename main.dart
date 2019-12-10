import 'ai/alpha_beta.dart';
import 'ai/random.dart';
import 'ai/reversi_ai.dart';
import 'ai/state_heuristic/corner_heuristic.dart';
import 'ai/state_heuristic/moves_heuristic.dart';
import 'ai/state_heuristic/pieces_heuristic.dart';
import 'ai/state_heuristic/random_heuristic.dart';
import 'ai/state_heuristic/weighted_heuristic.dart';
import 'network/reversi_client.dart';

void main(List<String> args) {
  if (args.length < 3) {
    print("Commage Usage: command host playerColor(1|2) aiType(random, alphabeta depth)");
    return;
  }

  String host = args[0];
  int playerColor = int.parse(args[1]); // Black is 1, White is 2
  String aiType = args[2];
  ReversiAi ai;

  if (aiType == "random") {
    ai = RandomAi();
  } else if (aiType == "alphabeta") {
    int depth = int.parse(args[3]);
    ai = AlphaBetaAi(
      depth: depth,
      heuristic: WeightedHeuristic(
        weights: [10, 1, 0.25, 1],
        heuristics: [
          CornerHeuristic(),
          MovesHeuristic(),
          PiecesHeuristic(),
          RandomHeuristic(),
        ],
      ),
    );
  } else {
    throw (aiType + "is not a supported aiType");
  }

  ReversiClient reversiClient = new ReversiClient(ai);
  reversiClient.run(host, playerColor);
}
