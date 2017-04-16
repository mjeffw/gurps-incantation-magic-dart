import "package:test/test.dart";
import "package:gurps_incantation_magic_model/incantation_magic.dart";

void main(){
  Spell spell;

  setUp(() async {
    spell = new Spell();
  });

  test("creation", () {
    expect(spell, isNotNull);
    expect(spell.spellPoints, equals(0));
  });

  test("has name", () {
    expect(spell.name, equals(""));
    spell.name = "Joe";
    expect(spell.name, equals("Joe"));
    spell.name = null;
    expect(spell.name, equals(""));
  });

  test("contains SpellEffects", () {
    spell.add(new SpellEffect(Effect.Sense, Path.Augury));
    expect(spell.spellPoints, equals(2));

    spell.add(new SpellEffect(Effect.Control, Path.Arcanum));
    expect(spell.spellPoints, equals(7));

    spell.add(new SpellEffect(Effect.Create, Path.Elementalism));
    expect(spell.spellPoints, equals(13));
  });

  test("contains Modifiers", () {

  });
}