import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

void main() {
  final int NAME = 0;
  final int GAP1 = 1;
  final int EFFECTS = 2;
  final int MODS = 3;
  final int PENALTY = 4;
  final int TIME = 5;
  final int GAP2 = 6;
  final int DESC = 7;
  final int GAP3 = 8;
  final int TYPICAL = 9;

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
    spell.addRitualModifier(bestows);

    Girded girded = new Girded(value: 20, inherent: true);
    spell.addRitualModifier(girded);

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
      AreaOfEffect m = new AreaOfEffect(value: 5, inherent: true)..targets(6, true);
      spell.addRitualModifier(m);
      spell.description = _description;

      TextSpellExporter exporter = new TextSpellExporter();
      spell.export(exporter);

      List<String> lines = exporter.toString().split('\n');
      expect(lines[NAME], equals('Alarm'));
      expect(lines[GAP1], equals(''));
      expect(lines[EFFECTS], equals("Spell Effects: Create Arcanum."));
      expect(lines[MODS], equals('Inherent Modifiers: Area of Effect.'));
      expect(lines[PENALTY], equals("Skill Penalty: Path of Arcanum-6."));
      expect(lines[TIME], equals('Casting Time: 5 minutes.'));
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          equals('Typical Casting: '
              'Create Arcanum (6) + Conditional Spell (5) + '
              'Area of Effect, 5 yards, including 6 targets (53). 64 SP.'));
    });

    test('Animate Object', () {
      String _description =
          'This spell gives any inanimate object the ability move, and to understand and follow simple commands. '
          'It has DX equal to your Path level-5, Move equal to Path/3 (round down), and ST/HP based on its weight '
          '(see p. B558). It has whatever skills (equal to your Path of Arcanum level) and advantages the GM '
          'thinks are appropriate to an object of its shape or purpose. For example, if a caster had Path of '
          'Arcanum-15 and he animated a 3 lb. broom, it might have ST/HP 12, DX 10, Move 5, and Housekeeping-15. '
          'Many casters will customize this spell, using Bestows a Bonus (p. 15) to give higher skills or '
          'attributes. Botches usually produce an animated object with creative and hostile intent!';
      Spell spell = new Spell();
      spell.name = "Animate Object";
      spell.addEffect(new SpellEffect(Effect.Create, Path.Arcanum));
      spell.addEffect(new SpellEffect(Effect.Control, Path.Arcanum));
      spell.addRitualModifier(new DurationMod(value: new GurpsDuration(hours: 12).inSeconds));
      spell.addRitualModifier(new SubjectWeight(value: 100));
      spell.description = _description;

      TextSpellExporter exporter = new TextSpellExporter();
      spell.export(exporter);

      List<String> lines = exporter.toString().split('\n');
      expect(lines[NAME], equals('Animate Object'));
      expect(lines[GAP1], equals(''));
      expect(lines[EFFECTS], equals("Spell Effects: Create Arcanum + Control Arcanum."));
      expect(lines[MODS], equals('Inherent Modifiers: None.'));
      expect(lines[PENALTY], equals("Skill Penalty: Path of Arcanum-2."));
      expect(lines[TIME], equals('Casting Time: 10 minutes.'));
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          equals('Typical Casting: '
              'Create Arcanum (6) + Control Arcanum (5) '
              '+ Duration, 12 hours (10) '
              '+ Subject Weight, 100 pounds (2). 23 SP.'));
    });

    test('Arcane Fire', () {
      String _description =
          "This spell conjures a ball of pure magical energy. In addition to causing 6d burning damage, it also "
          "reduces the target's resistance to further magic. For each point of damage that penetrates the target's DR, "
          "he must make a HT roll (at -1 per 2 points of penetrating damage), or lose a level of Magic Resistance per "
          "point by which he failed. If the target has no Magic Resistance, he instead gains levels of Magical "
          "Susceptibility per point by which he failed his roll (maximum of five). These effects last for (20 - HT) "
          "minutes, minimum of one minute.";
      Spell spell = new Spell();
      spell.name = 'Arcane Fire';
      spell.addEffect(new SpellEffect(Effect.Create, Path.Arcanum));
      Damage dam = new Damage(type: DamageType.burning, value: 4, inherent: true, direct: false);
      dam.addModifier("Alternative Enhancements", null, 77);
      spell.addRitualModifier(dam);
      spell.description = _description;

      TextSpellExporter exporter = new TextSpellExporter();
      spell.export(exporter);

      List<String> lines = exporter.toString().split('\n');
      expect(lines[NAME], equals('Arcane Fire'));
      expect(lines[GAP1], equals(''));
      expect(lines[EFFECTS], equals("Spell Effects: Create Arcanum."));
      expect(lines[MODS], equals('Inherent Modifiers: Damage, Indirect Burning (Alternative Enhancements).'));
      expect(lines[PENALTY], equals("Skill Penalty: Path of Arcanum-2."));
      expect(lines[TIME], equals('Casting Time: 5 minutes.'));
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          equals('Typical Casting: '
              'Create Arcanum (6) '
              '+ Damage, Indirect Burning 6d (Alternative Enhancements, +77%) (20). '
              '26 SP.'));
    });

    test('Bewitchment', () {
      String _description =
          "This spell holds the subject (who must have an IQ of 6 or higher) motionless and unaware of time's "
          "passage (treat as dazed, p. B428). The subject may roll against the better of HT or Will to 'shake "
          "off' the effect every (margin of loss) minutes. Otherwise, this lasts as long as the caster and the "
          "subject's eyes meet; if either one can no longer see the other's eyes, the spell is instantly broken. "
          "(The short casting time is due to this drawback; see Limited Spells, p. 15.) This is often cast as a "
          "'blocking' spell (p. 20) at the usual -10 to skill.";
      Spell spell = new Spell();
      spell.name = 'Bewitchment';
      spell.addEffect(new SpellEffect(Effect.Destroy, Path.Mesmerism));
      spell.addModifier("Requires eye contact", null, -40);
      spell.addRitualModifier(new Affliction("Daze", value: 50, inherent: true));
      spell.description = _description;

      TextSpellExporter exporter = new TextSpellExporter();
      spell.export(exporter);

      List<String> lines = exporter.toString().split('\n');
      expect(lines[NAME], equals('Bewitchment'));
      expect(lines[GAP1], equals(''));
      expect(lines[EFFECTS], equals("Spell Effects: Destroy Mesmerism."));
      expect(lines[MODS], equals('Inherent Modifiers: Afflictions, Daze.'));
      expect(lines[PENALTY], equals("Skill Penalty: Path of Mesmerism-1."));
      expect(lines[TIME], equals('Casting Time: 2 minutes.'));
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          startsWith('Typical Casting: '
              'Destroy Mesmerism (5) '
              '+ Afflictions, Daze (10). '
              '15 SP.'));
    });
  });
}
