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

  test('Mule’s Strength', () {
    spell.name = "Mule's Strength";
    spell.addEffect(new SpellEffect(Effect.Strengthen, Path.Transfiguration));
    spell.addRitualModifier(new AlteredTraits("Lifting ST", 5, value: 15, inherent: true));
    spell.addRitualModifier(new DurationMod(value: new GurpsDuration(days: 1).inSeconds));
    spell.addRitualModifier(new SubjectWeight(value: 1000));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Mule's Strength"));
    expect(lines[EFFECTS], equals("Spell Effects: Strengthen Transfiguration."));
    expect(lines[MODS], equals('Inherent Modifiers: Altered Traits, Lifting ST.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Transfiguration-3."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Strengthen Transfiguration (3) + Altered Traits, Lifting ST 5 (15)'
            ' + Duration, 1 day (11) + Subject Weight, 1000 lbs. (4).'
            ' 33 SP.'));
  });

  test('Occultus Oculus', () {
    spell.name = 'Occultus Oculus';
    spell.addEffect(new SpellEffect(Effect.Sense, Path.Augury));
    spell.addRitualModifier(new Bestows("Recognition", range: BestowsRange.single, value: 6, inherent: true));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Occultus Oculus"));
    expect(lines[EFFECTS], equals("Spell Effects: Sense Augury."));
    expect(lines[MODS], equals('Inherent Modifiers: Bestows a Bonus, Recognition.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Augury-1."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Sense Augury (2)'
            ' + Bestows a Bonus, +6 to Recognition (16).'
            ' 18 SP.'));
  });

  test('Partial Shapeshifting (Bat Wings)', () {
    spell.name = 'Partial Shapeshifting (Bat Wings)';
    spell.addEffect(new SpellEffect(Effect.Transform, Path.Transfiguration));
    AlteredTraits t = new AlteredTraits("Flight", null, value: 40, inherent: true);
    t.addModifier("Winged", null, -25);
    spell.addRitualModifier(t);
    spell.addRitualModifier(new DurationMod(value: 3600));
    spell.addRitualModifier(new SubjectWeight(value: 1000));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Partial Shapeshifting (Bat Wings)"));
    expect(lines[EFFECTS], equals("Spell Effects: Transform Transfiguration."));
    expect(lines[MODS], equals('Inherent Modifiers: Altered Traits, Flight (Winged).'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Transfiguration-4."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting: "
            "Transform Transfiguration (8)"
            " + Altered Traits, Flight (Winged, -25%) (30)"
            " + Duration, 1 hour (7)"
            " + Subject Weight, 1000 lbs. (4)."
            " 49 SP."));
  });

  test('Peel Back the Skin', () {
    spell.name = 'Peel Back the Skin';
    spell.addEffect(new SpellEffect(Effect.Destroy, Path.Transfiguration));
    spell.addRitualModifier(new SubjectWeight(value: 300));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Peel Back the Skin"));
    expect(lines[EFFECTS], equals("Spell Effects: Destroy Transfiguration."));
    expect(lines[MODS], equals('Inherent Modifiers: None.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Transfiguration-0."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL], equals("Typical Casting: Destroy Transfiguration (5) + Subject Weight, 300 lbs. (3). 8 SP."));
  });

  test('Radiant Shield', () {
    spell.name = 'Radiant Shield';
    spell.addEffect(new SpellEffect(Effect.Strengthen, Path.Protection));
    spell.addRitualModifier(new SubjectWeight(value: 30));
    spell.addRitualModifier(new DurationMod(value: 3600));
    AreaOfEffect areaOfEffect = new AreaOfEffect(value: 4, inherent: true);
    areaOfEffect.targets(6, false);
    spell.addRitualModifier(areaOfEffect);
    spell.addRitualModifier(new AlteredTraits("Defense Bonus", 2, value: 60, inherent: true));
    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Radiant Shield"));
    expect(lines[EFFECTS], equals("Spell Effects: Strengthen Protection."));
    expect(lines[MODS], equals('Inherent Modifiers: Altered Traits, Defense Bonus + Area of Effect.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Protection-11."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        startsWith("Typical Casting: "
            "Strengthen Protection (3) + Altered Traits, Defense Bonus 2 (60)"
            " + Area of Effect, 4 yards, excluding 6 targets (43) + Duration, 1 hour (7)"
            " + Subject Weight, 30 lbs. (1)."
            " 114 SP."));
  });

  test('Repair Undead', () {
    spell.name = 'Repair Undead';
    spell.addEffect(new SpellEffect(Effect.Restore, Path.Necromancy));
    spell.addRitualModifier(new Repair("undead", value: 8, inherent: true));
    spell.addRitualModifier(new SubjectWeight(value: 300));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Repair Undead"));
    expect(lines[EFFECTS], equals("Spell Effects: Restore Necromancy."));
    expect(lines[MODS], equals('Inherent Modifiers: Repair.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Necromancy-1."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL], startsWith("Typical Casting:"
        " Restore Necromancy (4)"
        " + Repair undead, 3d (8)"
        " + Subject Weight, 300 lbs. (3)."
        " 15 SP."
    ));
  });

}
