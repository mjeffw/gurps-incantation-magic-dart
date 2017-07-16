import 'dart:math';

class RepeatingSequenceConverter {
  List<int> _pattern;
  int _base = 10; // this can be changed in case the repetition is based on another value than 10

  RepeatingSequenceConverter(this._pattern);

  // assume pattern = [10, 30], 100, 300, 1000, 3000, ...
  // if index = 5, then the result should be:
  // int x = index % pattern.length = 1
  // int y = floor(index / pattern.length) = 2
  // return pattern[x] * 10^y = 30 * 100 = 3000
  int ordinalToValue(int index) {
    int i = (index % _pattern.length);
    int exponent = index ~/ _pattern.length;
    int other = (pow(_base, exponent).toInt());
    int j = _pattern[i] * other;
    return j;
  }

  int valueToOrdinal(int value) {
    int loops = _numberOfLoops(value); // 0

    double val = value / pow(_base, loops); // 3 / 1 = 3

    int arrayValue = _smallestTableValueGreaterThanOrEqualTo(val);
    return _pattern.indexOf(arrayValue) + (loops * _pattern.length);
  }

  int _smallestTableValueGreaterThanOrEqualTo(double val) {
    return _pattern.where((i) => i >= val).first;
  }

  int _numberOfLoops(int value) {
    int loops = 0;
    while (value > (_pattern[_pattern.length - 1] * pow(_base, loops))) {
      loops++;
    }
    return loops;
  }
}
