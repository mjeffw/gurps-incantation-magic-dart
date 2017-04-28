import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

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
      expect(() => dur.value = const GurpsDuration(days: 1).inSeconds + 1, throwsException);
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
      dur.value = const GurpsDuration(seconds: 9).inSeconds;
      expect(dur.spellPoints, equals(1));
      dur.value = const GurpsDuration(seconds: 10).inSeconds;
      expect(dur.spellPoints, equals(1));
      dur.value = const GurpsDuration(seconds: 30).inSeconds;
      expect(dur.spellPoints, equals(2));
      dur.value = const GurpsDuration(minutes: 1).inSeconds;
      expect(dur.spellPoints, equals(3));
      dur.value = const GurpsDuration(minutes: 3).inSeconds;
      expect(dur.spellPoints, equals(4));
      dur.value = const GurpsDuration(minutes: 6).inSeconds;
      expect(dur.spellPoints, equals(5));
      dur.value = const GurpsDuration(minutes: 12).inSeconds;
      expect(dur.spellPoints, equals(6));
      dur.value = const GurpsDuration(hours: 1).inSeconds;
      expect(dur.spellPoints, equals(7));
      dur.value = const GurpsDuration(hours: 3).inSeconds;
      expect(dur.spellPoints, equals(8));
      dur.value = const GurpsDuration(hours: 6).inSeconds;
      expect(dur.spellPoints, equals(9));
      dur.value = const GurpsDuration(hours: 12).inSeconds;
      expect(dur.spellPoints, equals(10));
      dur.value = const GurpsDuration(days: 1).inSeconds;
      expect(dur.spellPoints, equals(11));
    });
  });

  group("Girded:", () {
    RitualModifier m;

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
    RitualModifier m;

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

      m.value = const GurpsDuration(days: 1).inHours;
      expect(m.spellPoints, equals(2));

      m.value = const GurpsDuration(days: 3).inHours;
      expect(m.spellPoints, equals(3));

      m.value = const GurpsDuration(days: 10).inHours;
      expect(m.spellPoints, equals(4));

      m.value = const GurpsDuration(days: 30).inHours;
      expect(m.spellPoints, equals(5));

      m.value = const GurpsDuration(days: 100).inHours;
      expect(m.spellPoints, equals(6));

      m.value = const GurpsDuration(days: 300).inHours;
      expect(m.spellPoints, equals(7));

      m.value = const GurpsDuration(days: 1000).inHours;
      expect(m.spellPoints, equals(8));

      m.value = const GurpsDuration(days: 3000).inHours;
      expect(m.spellPoints, equals(9));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });
  });

  group("Range, Extradimensional:", () {
    RitualModifier m;

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
    RitualModifier m;

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

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
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

  group("Range:", () {
    RitualModifier m;

    setUp(() async {
      m = new Range();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Range"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });

    test("has SpellPoints", () {
      m.value = new Distance(yards: 0).inYards;
      expect(m.spellPoints, equals(0));

      m.value = new Distance(yards: 2).inYards;
      expect(m.spellPoints, equals(0));

      m.value = new Distance(yards: 3).inYards;
      expect(m.spellPoints, equals(1));

      m.value = new Distance(yards: 4).inYards;
      expect(m.spellPoints, equals(2));

      m.value = new Distance(yards: 5).inYards;
      expect(m.spellPoints, equals(2));

      m.value = new Distance(yards: 7).inYards;
      expect(m.spellPoints, equals(3));

      m.value = new Distance(yards: 10).inYards;
      expect(m.spellPoints, equals(4));

      m.value = new Distance(yards: 15).inYards;
      expect(m.spellPoints, equals(5));

      m.value = new Distance(yards: 20).inYards;
      expect(m.spellPoints, equals(6));

      m.value = new Distance(yards: 30).inYards;
      expect(m.spellPoints, equals(7));

      m.value = new Distance(yards: 50).inYards;
      expect(m.spellPoints, equals(8));

      m.value = new Distance(yards: 70).inYards;
      expect(m.spellPoints, equals(9));

      m.value = new Distance(yards: 100).inYards;
      expect(m.spellPoints, equals(10));

      m.value = new Distance(yards: 150).inYards;
      expect(m.spellPoints, equals(11));

      m.value = new Distance(yards: 200).inYards;
      expect(m.spellPoints, equals(12));

      m.value = new Distance(yards: 300).inYards;
      expect(m.spellPoints, equals(13));

      m.value = new Distance(yards: 500).inYards;
      expect(m.spellPoints, equals(14));

      m.value = new Distance(yards: 700).inYards;
      expect(m.spellPoints, equals(15));

      m.value = new Distance(yards: 1000).inYards;
      expect(m.spellPoints, equals(16));

      m.value = new Distance(yards: 1500).inYards;
      expect(m.spellPoints, equals(17));
    });
  });

  group("Repair:", () {
    RitualModifier m;

    setUp(() async {
      m = new Repair();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Repair"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });

    test("has SpellPoints", () {
      m.value = 1;
      expect(m.spellPoints, equals(1));

      m.value = 2;
      expect(m.spellPoints, equals(2));

      m.value = 3;
      expect(m.spellPoints, equals(3));

      m.value = 5;
      expect(m.spellPoints, equals(5));

      m.value = 9;
      expect(m.spellPoints, equals(9));
    });
  });

  group("Speed:", () {
    RitualModifier m;

    setUp(() async {
      m = new Speed();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Speed"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });

    // For movement spells (e.g., spells that use telekinesis or allow a subject to fly), look up the speed
    // in yards/second on the Size and Speed/Range Table (p. B550) and add the Size value for that line
    // (minimum +0) to SP.
    // Speed/Range Table:
    //  | Range | Size || Range | Size || Range | Size |
    //  |   0-2 |    0 ||    20 |    6 ||   200 |   12 |
    //  |     3 |    1 ||    30 |    7 ||   300 |   13 |
    //  |     5 |    2 ||    50 |    8 ||   500 |   14 |
    //  |     7 |    3 ||    70 |    9 ||   700 |   15 |
    //  |    10 |    4 ||   100 |   10 ||  1000 |   16 |
    //  |    15 |    5 ||   150 |   11 ||  1500 |   17 |
    test("has spellPoints", () {
      m.value = new Distance(yards: 0).inYards;
      expect(m.spellPoints, equals(0));

      m.value = new Distance(yards: 2).inYards;
      expect(m.spellPoints, equals(0));

      m.value = new Distance(yards: 3).inYards;
      expect(m.spellPoints, equals(1));

      m.value = new Distance(yards: 4).inYards;
      expect(m.spellPoints, equals(2));

      m.value = new Distance(yards: 5).inYards;
      expect(m.spellPoints, equals(2));

      m.value = new Distance(yards: 7).inYards;
      expect(m.spellPoints, equals(3));

      m.value = new Distance(yards: 10).inYards;
      expect(m.spellPoints, equals(4));

      m.value = new Distance(yards: 15).inYards;
      expect(m.spellPoints, equals(5));

      m.value = new Distance(yards: 20).inYards;
      expect(m.spellPoints, equals(6));

      m.value = new Distance(yards: 30).inYards;
      expect(m.spellPoints, equals(7));

      m.value = new Distance(yards: 50).inYards;
      expect(m.spellPoints, equals(8));

      m.value = new Distance(yards: 70).inYards;
      expect(m.spellPoints, equals(9));

      m.value = new Distance(yards: 100).inYards;
      expect(m.spellPoints, equals(10));

      m.value = new Distance(yards: 150).inYards;
      expect(m.spellPoints, equals(11));
    });
  });

  group("SubjectWeight:", () {
    RitualModifier m;

    setUp(() async {
      m = new SubjectWeight();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Subject Weight"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });

    //  |   Weight | SP  || Weight   | SP |
    //  | 0-10 lbs |   0 || 1,000 lb | +4 |
    //  |   30 lbs |  +1 || 1.5 tons | +5 |
    //  |  100 lbs |  +2 || 5 tons   | +6 |
    //  |  300 lbs |  +3 || x3       | +1 |")
    test("should have spell points", () {
      m.value = new Weight(pounds: 0).inPounds;
      expect(m.spellPoints, equals(0));

      m.value = new Weight(pounds: 10).inPounds;
      expect(m.spellPoints, equals(0));

      m.value = new Weight(pounds: 11).inPounds;
      expect(m.spellPoints, equals(1));

      m.value = new Weight(pounds: 30).inPounds;
      expect(m.spellPoints, equals(1));

      m.value = new Weight(pounds: 31).inPounds;
      expect(m.spellPoints, equals(2));

      m.value = new Weight(pounds: 100).inPounds;
      expect(m.spellPoints, equals(2));

      m.value = new Weight(pounds: 300).inPounds;
      expect(m.spellPoints, equals(3));

      m.value = new Weight(pounds: 1000).inPounds;
      expect(m.spellPoints, equals(4));

      m.value = new Weight(tons: 5).inPounds;
      expect(m.spellPoints, equals(6));

      m.value = new Weight(tons: 15).inPounds;
      expect(m.spellPoints, equals(7));
    });
  });

  group("Summoned:", () {
    RitualModifier m;

    setUp(() async {
      m = new Summoned();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Summoned"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });

    test("has SpellPoints", () {
      m.value = 0;
      expect(m.spellPoints, equals(0));

      m.value = 1;
      expect(m.spellPoints, equals(4));

      m.value = 25;
      expect(m.spellPoints, equals(4));

      m.value = 26;
      expect(m.spellPoints, equals(8));

      m.value = 50;
      expect(m.spellPoints, equals(8));

      m.value = 75;
      expect(m.spellPoints, equals(12));

      m.value = 100;
      expect(m.spellPoints, equals(20));

      m.value = 150;
      expect(m.spellPoints, equals(40));

      m.value = 200;
      expect(m.spellPoints, equals(60));

      m.value = 250;
      expect(m.spellPoints, equals(80));
    });
  });
}
