import "package:test/test.dart";
import "package:gurps_incantation_magic_model/incantation_magic.dart";

void main() {
  Spell spell;

  setUp(() async {
    spell = new Spell();
  });

  test("Dispelling", () {
    spell.name = "Dispelling";
    spell.addEffect(new SpellEffect(Effect.Destroy, Path.Arcanum));

    Bestows bestows = new Bestows(value: 6, inherent: true);
    spell.addModifier(bestows);

    Girded girded = new Girded(value: 20, inherent: true);
    spell.addModifier(girded);

    expect(spell.name, equals("Dispelling"));
    expect(spell.spellPoints, equals(41));
    expect(spell.castingTime, equals(const GurpsDuration(minutes: 5)));
  });
}
