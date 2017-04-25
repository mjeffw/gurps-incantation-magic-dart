import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

void main() {
  final NAME = 0;
  final GAP1 = 1;

  Spell spell;

  setUp(() async {
    spell = new Spell();
  });

  test("Dispelling", () {
    spell.name = "Dispelling";
    String _description = "This spell cancels any other spell targeted. The caster gets a total of +10 "
        "to his Path roll to terminate the spell: +4 from the SP total of Dispelling "
        "and another +6 from Bestows a Bonus.";
    spell.description = _description;
    spell.addEffect(new SpellEffect(Effect.Destroy, Path.Arcanum));

    Bestows bestows = new Bestows(value: 6, inherent: true);
    bestows.specialization = "Dispelling";
    spell.addModifier(bestows);

    Girded girded = new Girded(value: 20, inherent: true);
    spell.addModifier(girded);

    expect(spell.name, equals("Dispelling"));
    expect(spell.spellPoints, equals(41));
    expect(spell.castingTime, equals(const GurpsDuration(minutes: 5)));
    expect(spell.description, equals(_description));
    expect(spell.skillPenalty, equals(-4));
  });

  group('Render tests', () {
    test('Alarm', () {
      String _description = "You create a mystical 'booby-trap,' akin to cans strung along a wire, in a "
          "five-yard radius from the starting point. When an unauthorized being (you may "
          "authorize up to six) enters the area, every authorized being automatically "
          "wakes up (if asleep) and becomes aware of the invasion. Mundane stealth cannot "
          "overcome this; resolve any supernatural attempts at stealth as a Quick Contest "
          "against the incanter's Path of Arcanum. This is a conditional spell (p. 20) "
          "that 'hangs' until triggered or until everyone wakes up for the day.";

      Spell spell = new Spell();
      spell.name = "Alarm";
      spell.conditional = true;
      spell.addEffect(new SpellEffect(Effect.Create, Path.Arcanum));
      AreaOfEffect m = new AreaOfEffect(value: 5, inherent: true)
        ..targets(6, true);
      spell.addModifier(m);
      spell.description = _description;

      SpellExporter exporter = new SpellExporter();
      spell.export(exporter);

      String text = exporter.toText();
      var split = text.split('\n');
      expect(split[NAME], equals('Alarm'));
      expect(split[GAP1], equals(''));
    });
  });
}
