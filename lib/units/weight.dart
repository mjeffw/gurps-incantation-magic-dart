class Weight {
  static const int POUNDS_PER_TON = 2000;

  final int _value;

  const Weight._pounds(this._value);

  const Weight({int pounds: 0, int tons: 0}) : this._pounds(POUNDS_PER_TON * tons + pounds);

  int get inPounds => _value;

  static String toFormattedString(int pounds) {
    if (pounds > POUNDS_PER_TON) {
      num total = pounds / POUNDS_PER_TON;
      if (pounds % POUNDS_PER_TON == 0)
        return '${(pounds ~/ POUNDS_PER_TON)} tons';
      return '${total} tons';
    }
    return '${pounds} lbs.';
  }
}
