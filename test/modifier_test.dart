import "package:test/test.dart";
import "package:gurps_incantation_magic_model/incantation_magic.dart";

void main() {
  // A spell effect to stun a foe requires no additional SP.
  group("Affliction (Stun):", () {
    Modifier m = new AfflictionStun();

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
    Modifier m = new Affliction();

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
    Modifier m = new AlteredTraits();

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
  });

  group("Area of Effect:", () {
    AreaOfEffect m = new AreaOfEffect();

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
      m.targets(7, false);
      expect(m.spellPoints, equals(44));
    });
  });

  group("Bestows a (Bonus or Penalty)", () {
    Bestows m = new Bestows();

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

    test("has Single roll cost", () {
      fail("not implemented");
    });
  });
}
