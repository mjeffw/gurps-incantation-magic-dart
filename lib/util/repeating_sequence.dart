import 'dart:math';

class RepeatingSequenceConverter {
  List<int> _pattern;
  int _base = 10; // this can be changed in case the repetition is based on another value than 10

  RepeatingSequenceConverter(this._pattern);

  int ordinalToValue(int index) {
    return (index % _pattern.length) * (pow(_base, index / _pattern.length).toInt());
  }

  int valueToOrdinal(int value) {
    int loops = _numberOfLoops(value); // 0

    double val = value / pow(_base, loops); // 3 / 1 = 3

    int arrayValue = _smallestTableValueGreaterThanOrEqualTo(val);
    return _pattern.indexOf(arrayValue) + (loops * _pattern.length);
//    return _pattern.firstWhere((i) => i == arrayValue) + (loops * _pattern.length);
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
