import "package:test/test.dart";
import "package:gurps_incantation_magic_model/incantation_magic.dart";

void main() {
  // A spell effect to stun a foe requires no additional SP.
  group("Affliction (Stun):", () {
    Modifier m;

    setUp(() async {
      m = new AfflictionStun();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Affliction (Stun)"));
      expect(m.spellPoints, equals(0));
    });

    test("has 0 Spell Points regardless of value", () {
      m.value = 100;
      expect(m.spellPoints, equals(0));
      m.value = -100;
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });
  });

  group("Afflictions:", () {
    Modifier m;

    setUp(() async {
      m = new Affliction();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Affliction"));
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

    test("negative percentage does nothing", () {
      m.value = -15;
      expect(m.value, equals(0));
    });
  });

  group("Altered Traits", () {
    AlteredTraits m;

    setUp(() async {
      m = new AlteredTraits();
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
      m.value = -20;
      expect(m.spellPoints, equals(4));
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
      m.addEnhancer("Ten percent", null, 10);
      expect(m.spellPoints, equals(27));

      m.addEnhancer("Another enhancer", null, 5);
      expect(m.spellPoints, equals(28));

      m.addEnhancer("Limitation", null, -10);
      expect(m.spellPoints, equals(26));
    });

    test("another test for Limitations/Enhancements", () {
      m.addEnhancer("foo", null, 35);
      m.addEnhancer("bar", "detail", -10);

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
      m.targets(2, false);
      expect(m.spellPoints, equals(41));
      m.targets(6, false);
      expect(m.spellPoints, equals(43));
      m.targets(7, true);
      expect(m.spellPoints, equals(44));
    });
  });

  group("Bestows a (Bonus or Penalty)", () {
    Bestows m;

    setUp(() async {
      m = new Bestows();
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
      m.value = -7;
      expect(m.spellPoints, equals(20));
      m.value = -6;
      expect(m.spellPoints, equals(16));
      m.value = -5;
      expect(m.spellPoints, equals(12));
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
      m.value = 5;
      expect(m.spellPoints, equals(12));
      m.value = 6;
      expect(m.spellPoints, equals(16));
      m.value = 7;
      expect(m.spellPoints, equals(20));
    });

    test("should have moderate cost", () {
      m.range = BestowsRange.moderate;

      m.value = -7;
      expect(m.spellPoints, equals(40));
      m.value = -6;
      expect(m.spellPoints, equals(32));
      m.value = -5;
      expect(m.spellPoints, equals(24));
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
      m.value = 5;
      expect(m.spellPoints, equals(24));
      m.value = 6;
      expect(m.spellPoints, equals(32));
      m.value = 7;
      expect(m.spellPoints, equals(40));
    });

    test("should have broad cost", () {
      m.range = BestowsRange.broad;

      m.value = -7;
      expect(m.spellPoints, equals(100));
      m.value = -6;
      expect(m.spellPoints, equals(80));
      m.value = -5;
      expect(m.spellPoints, equals(60));
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
      m.value = 5;
      expect(m.spellPoints, equals(60));
      m.value = 6;
      expect(m.spellPoints, equals(80));
      m.value = 7;
      expect(m.spellPoints, equals(100));
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
  });
}
