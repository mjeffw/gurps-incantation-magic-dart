import "package:test/test.dart";
import "package:gurps_incantation_magic_model/incantation_magic.dart";

void main() {
  // A spell effect to stun a foe requires no additional SP.
  group("Affliction (Stun)", () {
    Modifier m = new AfflictionStun();

    test("has initial state",(){
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Affliction (Stun)"));
      expect(m.spellPoints, equals(0));
    });

    test("has 0 Spell Points regardless of value", () {
      m.value = 100;
      expect(m.spellPoints, equals(0));
    });

    test("has inherent", () {
      m.inherent = true;
      expect(m.inherent, equals(true));
    });

    test("has valueRange", () {
      expect(m.valueRange(0), equals([0, 0]));
      expect(m.valueRange(5), equals([0, 0]));
      expect(m.valueRange(-5), equals([0, 0]));
    });
  });

  group("Afflictions:", () {
    Modifier m = new Affliction();

    test("has initial state",(){
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

    test("each SP adds 1-5% value", () {
      expect(m.valueRange(0), equals([0, 0]));
      expect(m.valueRange(5), equals([21, 25]));
      expect(m.valueRange(-5), equals([0, 0]));
    });
  });
}
