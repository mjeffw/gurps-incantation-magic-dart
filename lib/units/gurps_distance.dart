class GurpsDistance {
  static const int YARDS_PER_MILE = 2000;

  static String toFormattedString(int yards, {bool yardsPlusMiles: false}) {
    if (yards >= YARDS_PER_MILE) {
      if (yardsPlusMiles) {
        return '${yards}${yards % YARDS_PER_MILE == 0 ? " (${yards ~/ YARDS_PER_MILE} miles)" : ""}';
      }
      return '${yards ~/ YARDS_PER_MILE} miles${yards % YARDS_PER_MILE == 0 ? "": " ${yards % YARDS_PER_MILE} yards"}';
    } else {
      return '${yards} yards';
    }
  }

  final int _value;

  const GurpsDistance._yards(this._value);

  const GurpsDistance({int yards: 0, int miles: 0}) : this._yards(YARDS_PER_MILE * miles + yards);

  int get inYards => _value;

  int get inMiles => _value ~/ YARDS_PER_MILE;
}
