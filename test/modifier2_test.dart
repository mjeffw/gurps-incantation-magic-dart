import "package:test/test.dart";
import "package:gurps_incantation_magic_model/incantation_magic.dart";

void main() {
  group("Duration:", () {
    DurationMod dur;

    setUp(() async {
      dur = new DurationMod();
    });

    test("has initial state", () {
      expect(dur.inherent, equals(false));
      expect(dur.value, equals(0));
      expect(dur.name, equals("Duration"));
      expect(dur.spellPoints, equals(0));
    });

    test("has inherent", () {
      dur.inherent = true;
      expect(dur.inherent, equals(true));
    });

    test("should throw exception if negative", () {
      expect(() => dur.value = -1, throwsException);
    });

    test("should throw exception if more than one day", () {
      expect(() => dur.value = new Duration(days: 1).inSeconds + 1, throwsException);
    });

    /*
       | Duration      | SP |
       | Momentary     |  0 |
       | Up to 10 secs | +1 |
       | Up to 30 secs | +2 |
       | Up to 1 min   | +3 |
       | Up to 3 min   | +4 |
       | Up to 6 min   | +5 |
       | Up to 12 mins | +6 |
       | Up to 1 hour  | +7 |
       | Up to 3 hours | +8 |
       | Up to 6 hours | +9 |
       | Up to 12 hours|+10 |
       | Up to 1 day   |+11 |
     */
    test("should have SpellPoints", () {
      dur.value = 0;
      expect(dur.spellPoints, equals(0));
      dur.value = new Duration(seconds: 9).inSeconds;
      expect(dur.spellPoints, equals(1));
      dur.value = new Duration(seconds: 10).inSeconds;
      expect(dur.spellPoints, equals(1));
      dur.value = new Duration(seconds: 30).inSeconds;
      expect(dur.spellPoints, equals(2));
      dur.value = new Duration(minutes: 1).inSeconds;
      expect(dur.spellPoints, equals(3));
      dur.value = new Duration(minutes: 3).inSeconds;
      expect(dur.spellPoints, equals(4));
      dur.value = new Duration(minutes: 6).inSeconds;
      expect(dur.spellPoints, equals(5));
      dur.value = new Duration(minutes: 12).inSeconds;
      expect(dur.spellPoints, equals(6));
      dur.value = new Duration(hours: 1).inSeconds;
      expect(dur.spellPoints, equals(7));
      dur.value = new Duration(hours: 3).inSeconds;
      expect(dur.spellPoints, equals(8));
      dur.value = new Duration(hours: 6).inSeconds;
      expect(dur.spellPoints, equals(9));
      dur.value = new Duration(hours: 12).inSeconds;
      expect(dur.spellPoints, equals(10));
      dur.value = new Duration(days: 1).inSeconds;
      expect(dur.spellPoints, equals(11));
    });
  });

  group("Girded:", () {
    Modifier m;

    setUp(() async {
      m = new Girded();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Girded"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("should have spellPoints", () {
      m.value = 0;
      expect(m.spellPoints, equals(0));
      m.value = 1;
      expect(m.spellPoints, equals(1));
      m.value = 2;
      expect(m.spellPoints, equals(2));
      m.value = 3;
      expect(m.spellPoints, equals(3));
      m.value = 4;
      expect(m.spellPoints, equals(4));
      m.value = 7;
      expect(m.spellPoints, equals(7));
      m.value = 8;
      expect(m.spellPoints, equals(8));
      m.value = 11;
      expect(m.spellPoints, equals(11));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });
  });

  group("Range, Cross-Time:", () {
    Modifier m;

    setUp(() async {
      m = new RangeCrossTime();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Range, Cross-Time"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    /// Time          Spell Points
    /// Up to 2 hours  0
    /// 1/2 day       +1
    /// 1 day         +2
    /// 3 days        +3
    /// 10 days       +4
    /// 30 days       +5
    /// 100 days      +6
    /// 300 days      +7
    /// 1,000 days    +8
    /// Add another +2 per additional factor of 10.
    test("should have spellPoints", () {
      m.value = 0;
      expect(m.spellPoints, equals(0));

      m.value = 2;
      expect(m.spellPoints, equals(0));

      m.value = 3;
      expect(m.spellPoints, equals(1));

      m.value = 12;
      expect(m.spellPoints, equals(1));

      m.value = 13;
      expect(m.spellPoints, equals(2));

      m.value = new Duration(days: 1).inHours;
      expect(m.spellPoints, equals(2));

      m.value = new Duration(days: 3).inHours;
      expect(m.spellPoints, equals(3));

      m.value = new Duration(days: 10).inHours;
      expect(m.spellPoints, equals(4));

      m.value = new Duration(days: 30).inHours;
      expect(m.spellPoints, equals(5));

      m.value = new Duration(days: 100).inHours;
      expect(m.spellPoints, equals(6));

      m.value = new Duration(days: 300).inHours;
      expect(m.spellPoints, equals(7));

      m.value = new Duration(days: 1000).inHours;
      expect(m.spellPoints, equals(8));

      m.value = new Duration(days: 3000).inHours;
      expect(m.spellPoints, equals(9));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });
  });

  group("Range, Extradimensional:", () {
    Modifier m;

    setUp(() async {
      m = new RangeDimensional();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Range, Extradimensional"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("cost 10 spellPoints per Dimension crossed", () {
      m.value = 1;
      expect(m.spellPoints, equals(10));
      m.value = 2;
      expect(m.spellPoints, equals(20));
      m.value = 3;
      expect(m.spellPoints, equals(30));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });
  });

  group("Range, Informational", () {
    Modifier m;

    setUp(() async {
      m = new RangeInformational();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Range, Informational"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("has SpellPoints", () {
      m.value = 0;
      expect(m.spellPoints, equals(0));

      m.value = 200;
      expect(m.spellPoints, equals(0));

      m.value = 201;
      expect(m.spellPoints, equals(1));

      m.value = 880;
      expect(m.spellPoints, equals(1));

      m.value = 881;
      expect(m.spellPoints, equals(2));

      m.value = new Distance(miles: 1).inYards;
      expect(m.spellPoints, equals(2));

      m.value = new Distance(miles: 1).inYards + 1;
      expect(m.spellPoints, equals(3));

      m.value = new Distance(miles: 3).inYards;
      expect(m.spellPoints, equals(3));

      m.value = new Distance(miles: 10).inYards;
      expect(m.spellPoints, equals(4));

      m.value = new Distance(miles: 30).inYards;
      expect(m.spellPoints, equals(5));

      m.value = new Distance(miles: 100).inYards;
      expect(m.spellPoints, equals(6));

      m.value = new Distance(miles: 300).inYards;
      expect(m.spellPoints, equals(7));

      m.value = new Distance(miles: 1000).inYards;
      expect(m.spellPoints, equals(8));

      m.value = new Distance(miles: 3000).inYards;
      expect(m.spellPoints, equals(9));

    });
  });
}
