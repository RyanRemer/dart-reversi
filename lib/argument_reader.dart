import 'package:args/args.dart';
import 'package:reversi_dart/ai/alpha_beta.dart';
import 'package:reversi_dart/ai/depth_ai.dart';
import 'package:reversi_dart/ai/human_ai.dart';
import 'package:reversi_dart/ai/random.dart';
import 'package:reversi_dart/ai/reversi_ai.dart';
import 'package:reversi_dart/ai/state_heuristic/corner_heuristic.dart';
import 'package:reversi_dart/ai/state_heuristic/heuristic.dart';
import 'package:reversi_dart/ai/state_heuristic/moves_heuristic.dart';
import 'package:reversi_dart/ai/state_heuristic/pieces_heuristic.dart';
import 'package:reversi_dart/ai/state_heuristic/random_heuristic.dart';
import 'package:reversi_dart/ai/state_heuristic/weighted_heuristic.dart';

class ArgumentParser {
  ArgParser parser;

  ArgumentParser.server() {
    parser = _serverParser;
  }

  ArgumentParser.client() {
    parser = _clientParser;
  }

  ArgParser get _parser {
    var parser = new ArgParser();
    parser.addOption("color",
        abbr: "c",
        allowed: [
          "white",
          "black",
        ],
        help: 'the color of the player',
        defaultsTo: "white");
    parser.addOption("ai",
        allowed: ["random", "alphabeta", "adjust", "human"],
        help: 'type of ai to load',
        defaultsTo: "random");
    parser.addOption(
      "depth",
      abbr: "d",
      help: "depth for the alphabeta or adjust ai",
      defaultsTo: "5",
    );
    parser.addFlag(
      "help",
      abbr: "?",
      negatable: false,
    );
    return parser;
  }

  ArgParser get _clientParser {
    var serverParser = _parser;
    serverParser.addOption(
      "host",
      abbr: "h",
      help: 'the ipaddress for the host',
      defaultsTo: "localhost",
    );
    serverParser.addOption(
      "port",
      abbr: "p",
      callback: (port) {
        print("port: $port");
      },
      defaultsTo: "3333",
    );
    return serverParser;
  }

  ArgParser get _serverParser {
    ArgParser parser = _parser;
    parser.addOption("port", abbr: "p", defaultsTo: "3333");
    parser.addOption(
      "time",
      abbr: "t",
      help: "time in seconds that both players get",
      defaultsTo: "300",
    );
    return parser;
  }

  ReversiAi getAi(List<String> args) {
    ArgResults results = parse(args);
    String aiType = results["ai"];
    ReversiAi ai;

    if (aiType == "random") {
      ai = RandomAi();
    } else if (aiType == "alphabeta") {
      ai = loadAlphaBetaAi(results);
    } else if (aiType == "adjust") {
      ai = loadDepthAi(results);
    } else if (aiType == "human") {
      ai = new HumanAi();
    } else {
      throw (aiType + "is not a supported aiType");
    }

    return ai;
  }

  ReversiAi loadAlphaBetaAi(ArgResults results) {
    int depth = int.parse(results["depth"]);
    return AlphaBetaAi(
      depth: depth,
      heuristic: defaultHeuristic,
    );
  }

  ReversiAi loadDepthAi(ArgResults results) {
    int depth = int.parse(results["depth"]);
    return DepthAi(
      depth: depth,
      heuristic: defaultHeuristic,
    );
  }

  Heuristic get defaultHeuristic {
    return WeightedHeuristic(
      weights: [10, 1, 0.25, 1],
      heuristics: [
        CornerHeuristic(),
        MovesHeuristic(),
        PiecesHeuristic(),
        RandomHeuristic(),
      ],
    );
  }

  ArgResults parse(List<String> args) {
    return parser.parse(args);
  }

  String get usage {
    return parser.usage;
  }
}
