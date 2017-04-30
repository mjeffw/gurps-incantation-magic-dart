import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

void main() {
  Spell spell;

  setUp(() async {
    spell = new Spell();
  });

  test("creation", () {
    expect(spell, isNotNull);
    expect(spell.spellPoints, equals(0));
    expect(spell.name, equals(""));
    expect(spell.castingTime, equals(const GurpsDuration(minutes: 2)));
    expect(spell.effects, isEmpty);
    expect(spell.inherentModifiers, isEmpty);
    expect(spell.skillPenalty, equals(0));
  });

  test("has name", () {
    expect(spell.name, equals(""));
    spell.name = "Joe";
    expect(spell.name, equals("Joe"));
    spell.name = null;
    expect(spell.name, equals(""));
  });

  test("contains SpellEffects", () {
    spell.addEffect(const SpellEffect(Effect.Sense, Path.Augury));
    expect(spell.spellPoints, equals(2));
    expect(spell.effects.length, equals(1));
    expect(spell.effects, contains(const SpellEffect(Effect.Sense, Path.Augury)));

    spell.addEffect(const SpellEffect(Effect.Control, Path.Arcanum));
    expect(spell.spellPoints, equals(7));
    expect(spell.effects.length, equals(2));
    expect(spell.effects, contains(const SpellEffect(Effect.Sense, Path.Augury)));
    expect(spell.effects, contains(const SpellEffect(Effect.Control, Path.Arcanum)));

    spell.addEffect(const SpellEffect(Effect.Create, Path.Elementalism));
    expect(spell.spellPoints, equals(13));
    expect(spell.effects.length, equals(3));
    expect(spell.effects, contains(const SpellEffect(Effect.Sense, Path.Augury)));
    expect(spell.effects, contains(const SpellEffect(Effect.Control, Path.Arcanum)));
    expect(spell.effects, contains(const SpellEffect(Effect.Create, Path.Elementalism)));
  });

  test("contains Modifiers", () {
    AfflictionStun afflictionStun = new AfflictionStun();
    spell.addRitualModifier(afflictionStun);
    expect(spell.inherentModifiers, isEmpty);
    expect(spell.ritualModifiers.length, equals(1));
    expect(spell.ritualModifiers, contains(afflictionStun));

    Range range = new Range();
    spell.addRitualModifier(range);
    expect(spell.inherentModifiers, isEmpty);
    expect(spell.ritualModifiers.length, equals(2));
    expect(spell.ritualModifiers, contains(afflictionStun));
    expect(spell.ritualModifiers, contains(range));
  });

  test("contains inherent Modifiers", () {
    AfflictionStun afflictionStun = new AfflictionStun(inherent: true);
    spell.addRitualModifier(afflictionStun);
    Range range = new Range();
    spell.addRitualModifier(range);

    expect(spell.inherentModifiers.length, equals(1));
    expect(spell.inherentModifiers, contains(afflictionStun));

    DurationMod dur = new DurationMod(inherent: true);
    spell.addRitualModifier(dur);

    expect(spell.inherentModifiers.length, equals(2));
    expect(spell.inherentModifiers, contains(afflictionStun));
    expect(spell.inherentModifiers, contains(dur));
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

  test("conditional spells require an additional +5 SP", () {
    spell.addEffect(new SpellEffect(Effect.Sense, Path.Augury));
    spell.addEffect(new SpellEffect(Effect.Control, Path.Arcanum));
    spell.addEffect(new SpellEffect(Effect.Create, Path.Demonology));
    expect(spell.spellPoints, equals(13));

    spell.conditional = true;
    expect(spell.spellPoints, equals(18));
  });

  test("should add Modifier cost to spellPoints", () {
    spell.addEffect(new SpellEffect(Effect.Sense, Path.Augury));
    spell.addEffect(new SpellEffect(Effect.Control, Path.Arcanum));
    spell.addEffect(new SpellEffect(Effect.Create, Path.Demonology));
    expect(spell.spellPoints, equals(13));

    Bestows bestows = new Bestows("Foo");
    bestows.value = 5;
    spell.addRitualModifier(bestows);

    expect(spell.spellPoints, equals(25));

    AlteredTraits traits = new AlteredTraits();
    traits.value = -15;
    spell.addRitualModifier(traits);

    expect(spell.spellPoints, equals(28));
  });

  test("skill penalty", () {
    spell.addEffect(new SpellEffect(Effect.Sense, Path.Augury));
    spell.addEffect(new SpellEffect(Effect.Control, Path.Arcanum));
    spell.addEffect(new SpellEffect(Effect.Create, Path.Demonology));
    spell.addRitualModifier(new Bestows("Bar", value: 5));
    spell.addRitualModifier(new AlteredTraits(value: -15));
    spell.conditional = true;

    expect(spell.skillPenalty, equals(-3));
  });
}
