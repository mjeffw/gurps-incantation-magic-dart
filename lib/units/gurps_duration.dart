class GurpsDuration {
  static const int SECONDS_PER_YEAR = Duration.secondsPerDay * 365;
  static const int SECONDS_PER_MONTH = 2628000;
  static const int SECONDS_PER_WEEK = Duration.secondsPerDay * 7;
  static const int SECONDS_PER_DAY = Duration.secondsPerDay;
  static const int SECONDS_PER_HOUR = Duration.secondsPerHour;
  static const int SECONDS_PER_MINUTE = Duration.secondsPerMinute;

  final int _duration;

  const GurpsDuration(
      {int years: 0,
      int months: 0,
      int weeks: 0,
      int days: 0,
      int hours: 0,
      int minutes: 0,
      int seconds: 0})
      : this._seconds(SECONDS_PER_YEAR * years +
            SECONDS_PER_MONTH * months +
            SECONDS_PER_WEEK * weeks +
            SECONDS_PER_DAY * days +
            SECONDS_PER_HOUR * hours +
            SECONDS_PER_MINUTE * minutes +
            seconds);

  const GurpsDuration._seconds(this._duration);

  int get inSeconds => _duration;

  int get inHours => _duration ~/ SECONDS_PER_HOUR;

  GurpsDuration operator +(GurpsDuration other) =>
      new GurpsDuration._seconds(_duration + other._duration);

  GurpsDuration operator -(GurpsDuration other) =>
      new GurpsDuration._seconds(_duration - other._duration);

  GurpsDuration operator *(GurpsDuration other) =>
      new GurpsDuration._seconds(_duration * other._duration);

  GurpsDuration operator ~/(GurpsDuration other) =>
      new GurpsDuration._seconds(_duration ~/ other._duration);

  bool operator <(GurpsDuration other) => _duration < other._duration;

  bool operator >(GurpsDuration other) => _duration > other._duration;

  bool operator <=(GurpsDuration other) => _duration <= other._duration;

  bool operator >=(GurpsDuration other) => _duration >= other._duration;

  static String toFormattedString(int duration) {
    int years = duration ~/ SECONDS_PER_YEAR;
    int temp = duration - (years * SECONDS_PER_YEAR);
    int months = temp ~/ SECONDS_PER_MONTH;
    temp -= (months * SECONDS_PER_MONTH);
    int weeks = temp ~/ SECONDS_PER_WEEK;
    temp -= (weeks * SECONDS_PER_WEEK);
    int days = temp ~/ SECONDS_PER_DAY;
    temp -= (days * SECONDS_PER_DAY);
    int hours = temp ~/ SECONDS_PER_HOUR;
    temp -= (hours * SECONDS_PER_HOUR);
    int minutes = temp ~/ SECONDS_PER_MINUTE;
    temp -= (minutes * SECONDS_PER_MINUTE);
    int seconds = temp;

    StringBuffer sb = new StringBuffer();
    if (years > 0) sb.write('${years} year${_pluralize(years)} ');
    if (months > 0) sb.write('${months} month${_pluralize(months)} ');
    if (weeks > 0) sb.write('${weeks} week${_pluralize(weeks)} ');
    if (days > 0) sb.write('${days} day${_pluralize(days)} ');
    if (hours > 0) sb.write('${hours} hour${_pluralize(hours)} ');
    if (minutes > 0) sb.write('${minutes} minute${_pluralize(minutes)} ');
    if (seconds > 0) sb.write('${seconds} second${_pluralize(seconds)}');

    return sb.toString().trim();
  }

  static String _pluralize(int number) {
    if (number > 1) return 's';
    return '';
  }

  @override
  String toString() => 'GurpsDuration[seconds: ${_duration}]';

  int compareTo(GurpsDuration other) => _duration.compareTo(other._duration);

  @override
  bool operator ==(Object other) {
    if (other is! GurpsDuration) return false;
    return _duration == (other as GurpsDuration)._duration;
  }
}
