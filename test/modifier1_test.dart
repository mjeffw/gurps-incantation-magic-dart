import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

void main() {
  // A spell effect to stun a foe requires no additional SP.
  group("Affliction, Stun:", () {
    AfflictionStun m;

    setUp(() async {
      m = new AfflictionStun();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Affliction, Stunning"));
      expect(m.spellPoints, equals(0));
    });

    test("should throw exception if value is set", () {
      expect(() => m.value = 1, throwsException);
      expect(() => m.value = -1, throwsException);
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });
  });

  group("Afflictions:", () {
    Affliction m;

    setUp(() async {
      m = new Affliction("Foo");
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Afflictions"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("+1 SP for every +5% it’s worth as an enhancement to Affliction", () {
      m.value = 10;
      expect(m.value, equals(10));
      expect(m.spellPoints, equals(2));

      m.value = 9;
      expect(m.value, equals(9));
      expect(m.spellPoints, equals(2));

      m.value = 11;
      expect(m.value, equals(11));
      expect(m.spellPoints, equals(3));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });
  });

  group("Altered Traits", () {
    AlteredTraits m;

    setUp(() async {
      m = new AlteredTraits("foo", null);
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Altered Traits"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("adds +1 SP for every five character points removed", () {
      m.value = -1;
      expect(m.spellPoints, equals(1));
      m.value = -5;
      expect(m.spellPoints, equals(1));
      m.value = -6;
      expect(m.spellPoints, equals(2));
      m.value = -10;
      expect(m.spellPoints, equals(2));
      m.value = -11;
      expect(m.spellPoints, equals(3));
    });

    test("adds +1 SP for every character point added", () {
      m.value = 1;
      expect(m.spellPoints, equals(1));
      m.value = 11;
      expect(m.spellPoints, equals(11));
      m.value = 24;
      expect(m.spellPoints, equals(24));
      m.value = 100;
      expect(m.spellPoints, equals(100));
    });

    test("allows for Limitations/Enhancements", () {
      m.value = 24;
      m.addModifier("Ten percent", null, 10);
      expect(m.spellPoints, equals(27));

      m.addModifier("Another enhancer", null, 5);
      expect(m.spellPoints, equals(28));

      m.addModifier("Limitation", null, -10);
      expect(m.spellPoints, equals(26));
    });

    test("another test for Limitations/Enhancements", () {
      m.addModifier("foo", null, 35);
      m.addModifier("bar", "detail", -10);

      m.value = 0;
      expect(m.spellPoints, equals(0));
      m.value = 30;
      expect(m.spellPoints, equals(38));
      m.value = 100;
      expect(m.spellPoints, equals(125));
      m.value = -10;
      expect(m.spellPoints, equals(3));
      m.value = -40;
      expect(m.spellPoints, equals(10));
    });
  });

  group("Area of Effect:", () {
    AreaOfEffect m;

    setUp(() async {
      m = new AreaOfEffect();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Area of Effect"));
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("add 10 SP per yard of radius", () {
      m.value = 1;
      expect(m.spellPoints, equals(10));
      m.value = 4;
      expect(m.spellPoints, equals(40));
      m.value = 10;
      expect(m.spellPoints, equals(100));
    });

    test("add +1 SP for every two specific subjects not affected", () {
      m.value = 4;
      expect(m.spellPoints, equals(40));
      m.setTargetInfo(2, false);
      expect(m.spellPoints, equals(41));
      m.setTargetInfo(6, false);
      expect(m.spellPoints, equals(43));
      m.setTargetInfo(7, true);
      expect(m.spellPoints, equals(44));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });
  });

  group("Bestows a (Bonus or Penalty)", () {
    Bestows m;

    setUp(() async {
      m = new Bestows("Test");
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Bestows a (Bonus or Penalty)"));
      expect(m.spellPoints, equals(0));
      expect(m.range, equals(BestowsRange.single));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("has range", () {
      m.range = BestowsRange.moderate;
      expect(m.range, equals(BestowsRange.moderate));
      m.range = BestowsRange.broad;
      expect(m.range, equals(BestowsRange.broad));
    });

    test("has Single roll cost", () {
      m.value = -4;
      expect(m.spellPoints, equals(8));
      m.value = -3;
      expect(m.spellPoints, equals(4));
      m.value = -2;
      expect(m.spellPoints, equals(2));
      m.value = -1;
      expect(m.spellPoints, equals(1));
      m.value = 0;
      expect(m.spellPoints, equals(0));
      m.value = 1;
      expect(m.spellPoints, equals(1));
      m.value = 2;
      expect(m.spellPoints, equals(2));
      m.value = 3;
      expect(m.spellPoints, equals(4));
      m.value = 4;
      expect(m.spellPoints, equals(8));
    });

    test("should have moderate cost", () {
      m.range = BestowsRange.moderate;

      m.value = -4;
      expect(m.spellPoints, equals(16));
      m.value = -3;
      expect(m.spellPoints, equals(8));
      m.value = -2;
      expect(m.spellPoints, equals(4));
      m.value = -1;
      expect(m.spellPoints, equals(2));
      m.value = 0;
      expect(m.spellPoints, equals(0));
      m.value = 1;
      expect(m.spellPoints, equals(2));
      m.value = 2;
      expect(m.spellPoints, equals(4));
      m.value = 3;
      expect(m.spellPoints, equals(8));
      m.value = 4;
      expect(m.spellPoints, equals(16));
    });

    test("should have broad cost", () {
      m.range = BestowsRange.broad;

      m.value = -4;
      expect(m.spellPoints, equals(40));
      m.value = -3;
      expect(m.spellPoints, equals(20));
      m.value = -2;
      expect(m.spellPoints, equals(10));
      m.value = -1;
      expect(m.spellPoints, equals(5));
      m.value = 0;
      expect(m.spellPoints, equals(0));
      m.value = 1;
      expect(m.spellPoints, equals(5));
      m.value = 2;
      expect(m.spellPoints, equals(10));
      m.value = 3;
      expect(m.spellPoints, equals(20));
      m.value = 4;
      expect(m.spellPoints, equals(40));
    });

    test("should have specialization", () {
      m.specialization = "Foo";
      expect(m.specialization, equals("Foo"));

      m.specialization = null;
      expect(m.specialization, equals(null));
    });
  });

  group("Damage:", () {
    Damage m;

    setUp(() async {
      m = new Damage();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Damage"));
      expect(m.spellPoints, equals(0));

      expect(m.type, equals((DamageType.crushing)));
      expect(m.direct, equals((true)));
      expect(m.explosive, equals((false)));
      expect(m.vampiric, equals((false)));
    });

    test("should throw exception if negative", () {
      expect(() => m.value = -1, throwsException);
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("has type", () {
      m.type = DamageType.cutting;
      expect(m.type, equals(DamageType.cutting));
    });

    test("has direct", () {
      m.direct = false;
      expect(m.direct, equals(false));
    });

    test("has explosive", () {
      // setting explosive to true when direct is also true has no effect
      m.explosive = true;
      expect(m.explosive, equals(false));

      m.direct = false;
      m.explosive = true;
      expect(m.explosive, equals(true));

      // setting direct to true will set explosive to false
      m.direct = true;
      expect(m.explosive, equals(false));
    });

    test("has vampiric", () {
      m.vampiric = true;
      expect(m.vampiric, equals(true));
    });

    // If the spell will cause damage, use (this table), based on whether the damage is direct or indirect, and
    // on what type of damage is being done.
    final List<String> values = [
      // |^^^^^^^^|^^^^^| cor,fat, | cr,burn, |^^^^^^^^^|
      // | direct | pi- | imp,pi++ | pi, tox .| cut,pi+ |
      // ---------------------------------------------------
      "        1d |   0 |        0 |        0 |       0 ", //
      "      1d+1 |   1 |        2 |        1 |       2 ", //
      "      1d+2 |   1 |        4 |        2 |       3 ", //
      "      2d-1 |   2 |        6 |        3 |       5 ", //
      "        2d |   2 |        8 |        4 |       6 ", //
      "      2d+1 |   3 |       10 |        5 |       8 ", //
      "      2d+2 |   3 |       12 |        6 |       9 ", //
      "      3d-1 |   4 |       14 |        7 |      11 ",
    ];

    void _testCost(DieRoll dice, DamageType type, int expectedCost) {
      m.vampiric = false;
      m.direct = true;
      m.type = type;
      m.value = 0;
      int adds = DieRoll.denormalize(dice);

      m.value = adds;
      expect(m.spellPoints, equals(expectedCost));

      m.vampiric = true;
      m.value = adds;
      expect(m.spellPoints, equals(expectedCost * 2));
    }

    void _testDice(DieRoll dice, DamageType type) {
      m.vampiric = false;
      m.direct = true;
      m.type = type;
      int adds = DieRoll.denormalize(dice);
      m.value = adds;

      expect(m.dice, equals(dice));

      m.direct = false;
      m.explosive = true;
      expect(m.dice, equals(dice * 2));

      m.explosive = false;
      expect(m.dice, equals(dice * 3));
    }

    test("has small piercing damage", () {
      for (String line in values) {
        var dice = new DieRoll.fromString(_colFromTable(line, 0));
        var cost = int.parse(_colFromTable(line, 1));
        _testCost(dice, DamageType.smallPiercing, cost);
        _testDice(dice, DamageType.smallPiercing);
      }
    });

    test("should have Cor Fat Imp HugePi damage", () {
      for (var type in impalingTypes) {
        for (String line in values) {
          var dice = new DieRoll.fromString(_colFromTable(line, 0));
          var cost = int.parse(_colFromTable(line, 2));
          _testCost(dice, type, cost);
          _testDice(dice, type);
        }
      }
    });

    test("should have Cr Burn Pi Tox damage", () {
      for (var type in crushingTypes) {
        for (String line in values) {
          var dice = new DieRoll.fromString(_colFromTable(line, 0));
          var cost = int.parse(_colFromTable(line, 3));
          _testCost(dice, type, cost);
          _testDice(dice, type);
        }
      }
    });

    test("should have Cut LargePi damage", () {
      for (var type in cuttingTypes) {
        for (String line in values) {
          var dice = new DieRoll.fromString(_colFromTable(line, 0));
          var cost = int.parse(_colFromTable(line, 4));
          _testCost(dice, type, cost);
          _testDice(dice, type);
        }
      }
    });

    // Each +5% adds 1 SP if the base cost for Damage is 20 SP or less.
    test("should add 1 SP per 5 Percent of Enhancers", () {
      m.addModifier("foo", null, 1);
      m.value = 10;
      expect(m.spellPoints, equals(11));
      m.value = 20;
      expect(m.spellPoints, equals(21));

      m.addModifier("bar", null, 4);
      m.value = 10;
      expect(m.spellPoints, equals(11));
      m.value = 20;
      expect(m.spellPoints, equals(21));

      m.addModifier("baz", null, 2);
      m.value = 10;
      expect(m.spellPoints, equals(12));
      m.value = 20;
      expect(m.spellPoints, equals(22));

      m.addModifier("dum", null, 8);
      m.value = 10;
      expect(m.spellPoints, equals(13));
      m.value = 20;
      expect(m.spellPoints, equals(23));
    });

    // If Damage costs 21 SP or more, apply the enhancement percentage to the SP cost for Damage only (not to the cost
    // of the whole spell); round up.
    test("should Add 1 Point Per 1 Percent", () {
      m.addModifier("foo", null, 1);
      m.value = 25;
      expect(m.spellPoints, equals(26));

      m.addModifier("foo", null, 4);
      m.value = 30;
      expect(m.spellPoints, equals(35));

      m.addModifier("foo", null, 2);
      m.value = 33;
      expect(m.spellPoints, equals(40));

      m.addModifier("foo", null, 8);
      m.value = 50;
      expect(m.spellPoints, equals(65));
    });

    // Added limitations reduce this surcharge, but will never provide a net SP discount.
    test("should Not Add 1 Point", () {
      m.addModifier("foo", null, 10);
      m.addModifier("bar", null, -5);
      m.value = 10;
      expect(m.spellPoints, equals(11));
      m.value = 30;
      expect(m.spellPoints, equals(35));

      m.addModifier("baz", null, -10);
      m.value = 10;
      expect(m.spellPoints, equals(10));
      m.value = 30;
      expect(m.spellPoints, equals(30));
    });
  });
}

String _colFromTable(String line, int index2) => line.split("|")[index2].trim();
