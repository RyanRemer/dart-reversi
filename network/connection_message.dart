class ConnectionMessage {
  int playerColor;
  int playerMinutes;

  ConnectionMessage.fromData(List<String> data){
    playerColor = int.parse(data[0]);
    playerMinutes = int.parse(data[1]);
  }

  @override
  String toString() {
    return "playerNumber: ${playerColor}\nplayerMinutes: ${playerMinutes}\n";
  }
}