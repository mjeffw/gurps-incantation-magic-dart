class Distance {
  static const int YARDS_PER_MILE = 1760;

  final int _value;

  const Distance._yards(this._value);

  const Distance({int yards: 0, int miles: 0}) : this._yards(YARDS_PER_MILE * miles + yards);

  int get inYards => _value;
}
