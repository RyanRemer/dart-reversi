class Action {
  int row;
  int col;

  Action(this.row, this.col);

  @override
  bool operator ==(object) {
    return object is Action &&
        object.row == this.row &&
        object.col == this.col;
  }

  @override
  int get hashCode {
    return (row + col).hashCode;
  }

  @override
  String toString() {
    return "${row},${col}";
  }
}
