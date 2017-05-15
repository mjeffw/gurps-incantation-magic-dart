class GurpsDistance {
  static const int YARDS_PER_MILE = 2000;

  final int _value;

  const GurpsDistance._yards(this._value);

  const GurpsDistance({int yards: 0, int miles: 0}) : this._yards(YARDS_PER_MILE * miles + yards);

  int get inYards => _value;

  int get inMiles => _value ~/ YARDS_PER_MILE;

  String toFormattedString() {
    if (_value >= YARDS_PER_MILE) {
      return '${inMiles} miles${_yardsRemainder == 0 ? "": " ${_yardsRemainder} yards"}';
    }
    else {
      return '${_value} yards';
    }
  }

  int get _yardsRemainder => _value % YARDS_PER_MILE;
}
