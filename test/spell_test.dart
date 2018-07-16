import 'package:gurps_dart/gurps_dart.dart';
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
    spell.effects.add(new SpellEffect(Effect.Sense, Path.augury));
    expect(spell.spellPoints, equals(2));
    expect(spell.effects.length, equals(1));
    expect(spell.effects, contains(new SpellEffect(Effect.Sense, Path.augury)));

    spell.effects.add(new SpellEffect(Effect.Control, Path.arcanum));
    expect(spell.spellPoints, equals(7));
    expect(spell.effects.length, equals(2));
    expect(spell.effects, contains(new SpellEffect(Effect.Sense, Path.augury)));
    expect(
        spell.effects, contains(new SpellEffect(Effect.Control, Path.arcanum)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.elementalism));
    expect(spell.spellPoints, equals(13));
    expect(spell.effects.length, equals(3));
    expect(spell.effects, contains(new SpellEffect(Effect.Sense, Path.augury)));
    expect(
        spell.effects, contains(new SpellEffect(Effect.Control, Path.arcanum)));
    expect(spell.effects,
        contains(new SpellEffect(Effect.Create, Path.elementalism)));
  });

  test("contains Modifiers", () {
    AfflictionStun afflictionStun = new AfflictionStun();
    spell.ritualModifiers.add(afflictionStun);
    expect(spell.inherentModifiers, isEmpty);
    expect(spell.ritualModifiers.length, equals(1));
    expect(spell.ritualModifiers, contains(afflictionStun));

    Range range = new Range();
    spell.ritualModifiers.add(range);
    expect(spell.inherentModifiers, isEmpty);
    expect(spell.ritualModifiers.length, equals(2));
    expect(spell.ritualModifiers, contains(afflictionStun));
    expect(spell.ritualModifiers, contains(range));
  });

  test("contains inherent Modifiers", () {
    AfflictionStun afflictionStun = new AfflictionStun(inherent: true);
    spell.ritualModifiers.add(afflictionStun);
    Range range = new Range();
    spell.ritualModifiers.add(range);

    expect(spell.inherentModifiers.length, equals(1));
    expect(spell.inherentModifiers, contains(afflictionStun));

    DurationMod dur = new DurationMod(inherent: true);
    spell.ritualModifiers.add(dur);

    expect(spell.inherentModifiers.length, equals(2));
    expect(spell.inherentModifiers, contains(afflictionStun));
    expect(spell.inherentModifiers, contains(dur));
  });

  test("should have casting time", () {
    spell.effects.add(new SpellEffect(Effect.Create, Path.arcanum));
    expect(spell.castingTime, equals(const GurpsDuration(minutes: 5)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.augury));
    expect(spell.castingTime, equals(const GurpsDuration(minutes: 10)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.demonology));
    expect(spell.castingTime, equals(const GurpsDuration(minutes: 30)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.elementalism));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 1)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.mesmerism));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 3)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.necromancy));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 6)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.protection));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 12)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.transfiguration));
    expect(spell.castingTime, equals(const GurpsDuration(hours: 24)));
    expect(spell.castingTime, equals(const GurpsDuration(days: 1)));

    spell.effects.add(new SpellEffect(Effect.Sense, Path.arcanum));
    expect(spell.castingTime, equals(const GurpsDuration(days: 3)));

    spell.effects.add(new SpellEffect(Effect.Sense, Path.augury));
    expect(spell.castingTime, equals(const GurpsDuration(days: 7)));
    expect(spell.castingTime, equals(const GurpsDuration(weeks: 1)));

    spell.effects.add(new SpellEffect(Effect.Sense, Path.demonology));
    expect(spell.castingTime, equals(const GurpsDuration(weeks: 2)));

    spell.effects.add(new SpellEffect(Effect.Sense, Path.elementalism));
    expect(spell.castingTime, equals(const GurpsDuration(months: 1)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.mesmerism));
    expect(spell.castingTime, equals(const GurpsDuration(months: 2)));

    spell.effects.add(new SpellEffect(Effect.Create, Path.necromancy));
    expect(spell.castingTime, equals(const GurpsDuration(months: 3)));
  });

  test("conditional spells require an additional +5 SP", () {
    spell.effects.add(new SpellEffect(Effect.Sense, Path.augury));
    spell.effects.add(new SpellEffect(Effect.Control, Path.arcanum));
    spell.effects.add(new SpellEffect(Effect.Create, Path.demonology));
    expect(spell.spellPoints, equals(13));

    spell.conditional = true;
    expect(spell.spellPoints, equals(18));
  });

  test("should add Modifier cost to spellPoints", () {
    spell.effects.add(new SpellEffect(Effect.Sense, Path.augury));
    spell.effects.add(new SpellEffect(Effect.Control, Path.arcanum));
    spell.effects.add(new SpellEffect(Effect.Create, Path.demonology));
    expect(spell.spellPoints, equals(13));

    Bestows bestows = new Bestows("Foo");
    bestows.value = 5;
    spell.ritualModifiers.add(bestows);

    expect(spell.spellPoints, equals(25));

    AlteredTraits traits =
        new AlteredTraits(new Trait(name: 'bar', baseCost: -15));
    spell.ritualModifiers.add(traits);

    expect(spell.spellPoints, equals(28));
  });

  test("skill penalty", () {
    spell.effects.add(new SpellEffect(Effect.Sense, Path.augury));
    spell.effects.add(new SpellEffect(Effect.Control, Path.arcanum));
    spell.effects.add(new SpellEffect(Effect.Create, Path.demonology));
    spell.ritualModifiers.add(new Bestows("Bar", value: 5));
    Trait trait = new Trait(name: 'baz', baseCost: -15);
    spell.ritualModifiers.add(new AlteredTraits(trait));
    spell.conditional = true;

    expect(spell.skillPenalty, equals(-3));
  });
}
