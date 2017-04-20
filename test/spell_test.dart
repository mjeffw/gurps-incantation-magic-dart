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
    expect(spell.name, equals(""));
    expect(spell.castingTime, equals(const GurpsDuration(seconds: 0)));
  });

  test("has name", () {
    expect(spell.name, equals(""));
    spell.name = "Joe";
    expect(spell.name, equals("Joe"));
    spell.name = null;
    expect(spell.name, equals(""));
  });

  test("contains SpellEffects", () {
    spell.addEffect(new SpellEffect(Effect.Sense, Path.Augury));
    expect(spell.spellPoints, equals(2));

    spell.addEffect(new SpellEffect(Effect.Control, Path.Arcanum));
    expect(spell.spellPoints, equals(7));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Elementalism));
    expect(spell.spellPoints, equals(13));
  });

  test("contains Modifiers", () {
    spell.addEffect(new SpellEffect(Effect.Sense, Path.Augury));
    spell.addModifier(new AfflictionStun());
    expect(spell.spellPoints, equals(2));
  });

  test("should have casting time", () {
    spell.addEffect(new SpellEffect(Effect.Create, Path.Arcanum));
    expect(spell.castingTime, equals(const GurpsDuration(minutes: 5)));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Augury));
    expect(spell.castingTime, equals(const GurpsDuration(minutes: 10)));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Demonology));
    expect(spell.castingTime, equals(const GurpsDuration(minutes: 30)));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Elementalism));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 1)));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Mesmerism));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 3)));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Necromancy));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 6)));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Protection));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 12)));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Transfiguration));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 24)));
    expect(spell.castingTime, equals(const GurpsDuration(days: 1)));

    spell.addEffect(new SpellEffect(Effect.Sense, Path.Arcanum));
    expect(spell.castingTime, equals(const GurpsDuration(days: 3)));

    spell.addEffect(new SpellEffect(Effect.Sense, Path.Augury));
    expect(spell.castingTime, equals(const GurpsDuration(days: 7)));
    expect(spell.castingTime, equals(const GurpsDuration(weeks: 1)));

    spell.addEffect(new SpellEffect(Effect.Sense, Path.Demonology));
    expect(spell.castingTime, equals(const GurpsDuration(weeks: 2)));

    spell.addEffect(new SpellEffect(Effect.Sense, Path.Elementalism));
    expect(spell.castingTime, equals(const GurpsDuration(months: 1)));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Mesmerism));
    expect(spell.castingTime, equals(const GurpsDuration(months: 2)));

    spell.addEffect(new SpellEffect(Effect.Create, Path.Necromancy));
    expect(spell.castingTime, equals(const GurpsDuration(months: 3)));
  });
}