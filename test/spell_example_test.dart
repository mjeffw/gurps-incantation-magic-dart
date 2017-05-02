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

    Bestows bestows = new Bestows("Test", value: 6, inherent: true);
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
      spell.addDrawback("Requires eye contact", null, -40);
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
      // TODO Add a line for Drawbacks?
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          equals('Typical Casting: '
              'Destroy Mesmerism (5) '
              '+ Afflictions, Daze (10). '
              '15 SP.'));
    });

    test('Black Blade', () {
      String _description =
          "This spell causes a weapon, weighing no more than 10 lbs., to gain a 3d toxic follow-up for the next 10 "
          "seconds. This spells manifests as a visible halo of black energy around the weapon and is resisted like "
          "a normal spell. This essentially uses the rules for conjured weaponry (p. 21), but the weapon itself is "
          "the carrier for the damage.";
      Spell spell = new Spell();
      spell.name = 'Black Blade';
      spell.addEffect(new SpellEffect(Effect.Create, Path.Necromancy));
      Damage dam = new Damage(type: DamageType.toxic, value: 8, inherent: true);
      dam.addModifier("Follow-Up", null, 0);
      spell.addRitualModifier(dam);
      spell.addRitualModifier(new DurationMod(value: 10));
      spell.description = _description;

      TextSpellExporter exporter = new TextSpellExporter();
      spell.export(exporter);

      List<String> lines = exporter.toString().split('\n');
      expect(lines[NAME], equals('Black Blade'));
      expect(lines[GAP1], equals(''));
      expect(lines[EFFECTS], equals("Spell Effects: Create Necromancy."));
      expect(lines[MODS], equals('Inherent Modifiers: Damage, Direct Toxic (Follow-Up).'));
      expect(lines[PENALTY], equals("Skill Penalty: Path of Necromancy-1."));
      expect(lines[TIME], equals('Casting Time: 5 minutes.'));
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          equals('Typical Casting: '
              'Create Necromancy (6) '
              '+ Damage, Direct Toxic 3d (Follow-Up, +0%) (8) '
              '+ Duration, 10 seconds (1). '
              '15 SP.'));
    });

    test('Bond of Servitude for (Demons)', () {
      String _description =
          "This spell imposes a magical compulsion on the target (who resists at -2), forcing him to obey all the "
          "caster's commands for an hour. The target cannot go against a direct command, but may interpret "
          "commands creatively. This spell doesn't provide any special means of communication or understanding of "
          "commands. If the subject is ordered to do something suicidal or radically against his nature (e.g., "
          "attack a co-religionist to whom he has a Sense of Duty) he gets a roll to resist that command by "
          "rolling Will vs. the caster's effective skill. The caster may not repeat a resisted order, even "
          "rephrased, if the outcome would be similar! Different orders are still possible; e.g., if \"Throw your "
          "friend in the lava\" fails, \"Make your friend leave\" may still work, so long as leaving doesn't require "
          "a lava-swim.";
      Spell spell = new Spell();
      spell.name = 'Bond of Servitude for (Demons)';
      spell.addEffect(new SpellEffect(Effect.Control, Path.Demonology));
      spell.addRitualModifier(
          new Bestows("Resistance to Bond of Servitude", range: BestowsRange.single, value: -2, inherent: true));
      spell.addRitualModifier(new DurationMod(value: new GurpsDuration(hours: 1).inSeconds));
      spell.addRitualModifier(new Range(value: 20));
      spell.description = _description;

      TextSpellExporter exporter = new TextSpellExporter();
      spell.export(exporter);

      List<String> lines = exporter.toString().split('\n');
      expect(lines[NAME], equals('Bond of Servitude for (Demons)'));
      expect(lines[GAP1], equals(''));
      expect(lines[EFFECTS], equals("Spell Effects: Control Demonology."));
      expect(lines[MODS], equals('Inherent Modifiers: Bestows a Penalty, Resistance to Bond of Servitude.'));
      expect(lines[PENALTY], equals("Skill Penalty: Path of Demonology-2."));
      expect(lines[TIME], equals('Casting Time: 5 minutes.'));
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          equals('Typical Casting: '
              'Control Demonology (5) '
              '+ Bestows a Penalty, -2 to Resistance to Bond of Servitude (2) '
              '+ Duration, 1 hour (7) '
              '+ Range, 20 yards (6). '
              '20 SP.'));
    });

    test('Bulwark', () {
      String _description =
          "This spell grants the subject DR 6 with the Tough Skin and Hardened 2 modifiers. This protection lasts for "
          "12 minutes.";
      Spell spell = new Spell();
      spell.name = 'Bulwark';
      spell.addEffect(new SpellEffect(Effect.Strengthen, Path.Protection));
      AlteredTraits alteredTraits = new AlteredTraits("Damage Resistance", 6, value: 30, inherent: true);
      alteredTraits.addModifier("Hardened 2", null, 40);
      alteredTraits.addModifier("Tough Skin", null, -40);
      spell.addRitualModifier(alteredTraits);
      spell.addRitualModifier(new DurationMod(value: new GurpsDuration(minutes: 12).inSeconds));
      spell.addRitualModifier(new SubjectWeight(value: 1000));
      spell.description = _description;

      TextSpellExporter exporter = new TextSpellExporter();
      spell.export(exporter);

      List<String> lines = exporter.toString().split('\n');
      expect(lines[NAME], equals('Bulwark'));
      expect(lines[GAP1], equals(''));
      expect(lines[EFFECTS], equals("Spell Effects: Strengthen Protection."));
      expect(lines[MODS], equals('Inherent Modifiers: Altered Traits, Damage Resistance (Hardened 2; Tough Skin).'));
      expect(lines[PENALTY], equals("Skill Penalty: Path of Protection-4."));
      expect(lines[TIME], equals('Casting Time: 5 minutes.'));
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          equals('Typical Casting: '
              'Strengthen Protection (3) '
              '+ Altered Traits, Damage Resistance 6 (Hardened 2, +40%; Tough Skin, -40%) (30)'
              ' + Duration, 12 minutes (6)'
              ' + Subject Weight, 1000 pounds (4). ' // TODO would like comma-separated values, like '1,000'
              '43 SP.'));
    });

    test('Censure', () {
      String _description =
          "This spell banishes extradimensional entities, who must make a resistance roll at -6. Failure means "
          "instant banishment from their non-native reality. Critical success on the resistance roll means they "
          "cannot be banished by the caster for the next 24 hours!";
      Spell spell = new Spell();
      spell.name = 'Censure';
      spell.addEffect(new SpellEffect(Effect.Control, Path.Protection));
      spell.addRitualModifier(new Bestows("Resist Censure", value: -6, inherent: true));
      spell.description = _description;

      TextSpellExporter exporter = new TextSpellExporter();
      spell.export(exporter);

      List<String> lines = exporter.toString().split('\n');
      expect(lines[NAME], equals('Censure'));
      expect(lines[GAP1], equals(''));
      expect(lines[EFFECTS], equals("Spell Effects: Control Protection."));
      expect(lines[MODS], equals('Inherent Modifiers: Bestows a Penalty, Resist Censure.'));
      expect(lines[PENALTY], equals("Skill Penalty: Path of Protection-2."));
      expect(lines[TIME], equals('Casting Time: 5 minutes.'));
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          equals('Typical Casting: '
              'Control Protection (5) '
              '+ Bestows a Penalty, -6 to Resist Censure (16). '
              '21 SP.'));
    });

    test('Cone of Flame', () {
      String _description =
          "The caster conjures a cone of fire, emanating from his hands and extending out to a maximum width of five yards and length of 20 "
           "yards (see Area and Spreading Attacks, p. B413). This cone does 3d burning damage and requires a roll against Innate Attack (Beam) to hit.";
      Spell spell = new Spell();
      spell.name = 'Cone of Flame';
      spell.addEffect(new SpellEffect(Effect.Create, Path.Elementalism));
      Damage dam = new Damage(type: DamageType.burning, direct: false, inherent: true);
      dam.addModifier("Cone", "5 yards", 100);
      dam.addModifier("Reduced Range", "x1/5", -20);
      spell.addRitualModifier(dam);
      spell.description = _description;

      TextSpellExporter exporter = new TextSpellExporter();
      spell.export(exporter);

      List<String> lines = exporter.toString().split('\n');
      expect(lines[NAME], equals('Cone of Flame'));
      expect(lines[GAP1], equals(''));
      expect(lines[EFFECTS], equals("Spell Effects: Create Elementalism."));
      expect(lines[MODS], equals('Inherent Modifiers: Damage, Indirect Burning (Cone; Reduced Range).'));
      expect(lines[PENALTY], equals("Skill Penalty: Path of Elementalism-2."));
      expect(lines[TIME], equals('Casting Time: 5 minutes.'));
      expect(lines[GAP2], '');
      expect(lines[DESC], equals(_description));
      expect(lines[GAP3], '');
      expect(
          lines[TYPICAL],
          equals('Typical Casting: '
              'Create Elementalism (6) '
              '+ Damage, Indirect Burning 3d (Cone, 5 yards, +100%; Reduced Range, x1/5, -20%) (16). '
              '22 SP.'
          ));
    });
  });
}
