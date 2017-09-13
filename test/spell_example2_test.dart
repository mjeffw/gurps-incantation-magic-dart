import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

void main() {
  final int NAME = 0;
  final int EFFECTS = 2;
  final int MODS = 3;
  final int PENALTY = 4;
  final int TIME = 5;
  final int TYPICAL = 9;

  Spell spell;

  setUp(() async {
    spell = new Spell();
  });

  test('Mule’s Strength', () {
    spell.name = "Mule's Strength";
    spell.effects.add(new SpellEffect(Effect.Strengthen, Path.Transfiguration));
    spell.ritualModifiers.add(new AlteredTraits("Lifting ST", 5, value: 15, inherent: true));
    spell.ritualModifiers.add(new DurationMod(value: new GurpsDuration(days: 1).inSeconds));
    spell.ritualModifiers.add(new SubjectWeight(value: 1000));

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
    spell.effects.add(new SpellEffect(Effect.Sense, Path.Augury));
    spell.ritualModifiers.add(new Bestows("Recognition", range: BestowsRange.single, value: 6, inherent: true));

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
    spell.effects.add(new SpellEffect(Effect.Transform, Path.Transfiguration));
    AlteredTraits t = new AlteredTraits("Flight", null, value: 40, inherent: true);
    t.addTraitModifier(new TraitModifier("Winged", null, -25));
    spell.ritualModifiers.add(t);
    spell.ritualModifiers.add(new DurationMod(value: 3600));
    spell.ritualModifiers.add(new SubjectWeight(value: 1000));

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
    spell.effects.add(new SpellEffect(Effect.Destroy, Path.Transfiguration));
    spell.ritualModifiers.add(new SubjectWeight(value: 300));

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
    spell.effects.add(new SpellEffect(Effect.Strengthen, Path.Protection));
    spell.ritualModifiers.add(new SubjectWeight(value: 30));
    spell.ritualModifiers.add(new DurationMod(value: 3600));
    AreaOfEffect areaOfEffect = new AreaOfEffect(value: 4, inherent: true);
    areaOfEffect.setTargetInfo(6, false);
    spell.ritualModifiers.add(areaOfEffect);
    spell.ritualModifiers.add(new AlteredTraits("Defense Bonus", 2, value: 60, inherent: true));
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
        equals("Typical Casting: "
            "Strengthen Protection (3) + Altered Traits, Defense Bonus 2 (60)"
            " + Area of Effect, 4 yards, Excludes 6 targets (43) + Duration, 1 hour (7)"
            " + Subject Weight, 30 lbs. (1)."
            " 114 SP."));
  });

  test('Repair Undead', () {
    spell.name = 'Repair Undead';
    spell.effects.add(new SpellEffect(Effect.Restore, Path.Necromancy));
    spell.ritualModifiers.add(new Repair("undead", value: 8, inherent: true));
    spell.ritualModifiers.add(new SubjectWeight(value: 300));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Repair Undead"));
    expect(lines[EFFECTS], equals("Spell Effects: Restore Necromancy."));
    expect(lines[MODS], equals('Inherent Modifiers: Repair.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Necromancy-1."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting:"
            " Restore Necromancy (4)"
            " + Repair undead, 3d (8)"
            " + Subject Weight, 300 lbs. (3)."
            " 15 SP."));
  });

  test('Safeguard', () {
    spell.name = 'Safeguard';
    spell.effects.add(new SpellEffect(Effect.Strengthen, Path.Protection));
    spell.effects.add(new SpellEffect(Effect.Strengthen, Path.Protection));
    spell.ritualModifiers.add(new AlteredTraits("Modified Altered Time Rate", 1, value: 60, inherent: true));
    spell.ritualModifiers.add(new Bestows("Active Defense rolls", range: BestowsRange.broad, value: 2, inherent: true));
    spell.ritualModifiers.add(new DurationMod(value: 10));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Safeguard"));
    expect(lines[EFFECTS], equals("Spell Effects: Strengthen Protection x2."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Altered Traits, Modified Altered Time Rate + Bestows a Bonus, Active Defense rolls.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Protection-7."));
    expect(lines[TIME], equals('Casting Time: 10 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting: "
            "Strengthen Protection (3) + Strengthen Protection (3)"
            " + Altered Traits, Modified Altered Time Rate 1 (60)"
            " + Bestows a Bonus, +2 to Active Defense rolls (10)"
            " + Duration, 10 seconds (1). 77 SP."));
  });

  test('Scry', () {
    spell.name = 'Scry';
    spell.effects.add(new SpellEffect(Effect.Strengthen, Path.Augury));
    spell.ritualModifiers.add(new Speed(value: 20000, inherent: true));
    spell.ritualModifiers.add(new DurationMod(value: 10800));
    spell.ritualModifiers.add(new RangeInformational(value: 200000));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Scry"));
    expect(lines[EFFECTS], equals("Spell Effects: Strengthen Augury."));
    expect(lines[MODS], equals('Inherent Modifiers: Speed.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Augury-4."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting: "
            "Strengthen Augury (3) + Duration, 3 hours (8) + Range, 100 miles (6)"
            " + Speed, 10 miles/second (24). 41 SP."));
  });

  test('Seek Treasure', () {
    spell.name = 'Seek Treasure';
    spell.effects.add(new SpellEffect(Effect.Sense, Path.Augury));
    spell.ritualModifiers.add(new RangeInformational(value: new GurpsDistance(miles: 100).inYards));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Seek Treasure"));
    expect(lines[EFFECTS], equals("Spell Effects: Sense Augury."));
    expect(lines[MODS], equals('Inherent Modifiers: None.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Augury-0."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(lines[TYPICAL], equals("Typical Casting: Sense Augury (2) + Range, 100 miles (6). 8 SP."));
  });

  test('Summon Flaming Skull', () {
    spell.name = 'Summon Flaming Skull';
    spell.effects.add(new SpellEffect(Effect.Control, Path.Demonology));
    spell.ritualModifiers.add(new DurationMod(value: 60));
    spell.ritualModifiers.add(new RangeDimensional(value: 1));
    spell.ritualModifiers.add(new Summoned(value: 100, inherent: true));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Summon Flaming Skull"));
    expect(lines[EFFECTS], equals("Spell Effects: Control Demonology."));
    expect(lines[MODS], equals('Inherent Modifiers: Summoned.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Demonology-3."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting:"
            " Control Demonology (5) + Duration, 1 minute (3) + Range, Extradimensional (10)"
            " + Summoned, 100% of Static Point Total (20). 38 SP."));
  });

  test('Twist of Fate', () {
    spell.name = 'Twist of Fate';
    spell.effects.add(new SpellEffect(Effect.Transform, Path.Augury));
    spell.ritualModifiers.add(new AlteredTraits("Destiny", null, value: 5, inherent: true));
    spell.ritualModifiers.add(new DurationMod(value: 3600));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Twist of Fate"));
    expect(lines[EFFECTS], equals("Spell Effects: Transform Augury."));
    expect(lines[MODS], equals('Inherent Modifiers: Altered Traits, Destiny.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Augury-2."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting:"
            " Transform Augury (8) + Altered Traits, Destiny (5) + Duration, 1 hour (7). 20 SP."));
  });

  test('Ward for Augury', () {
    spell.name = 'Ward for Augury';
    spell.effects.add(new SpellEffect(Effect.Control, Path.Augury));
    spell.ritualModifiers.add(new DurationMod(value: 3600));
    spell.ritualModifiers.add(new AreaOfEffect(value: 5, inherent: true));
    spell.ritualModifiers.add(new Bestows("Ward’s Power", range: BestowsRange.moderate, value: 2, inherent: true));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Ward for Augury"));
    expect(lines[EFFECTS], equals("Spell Effects: Control Augury."));
    expect(lines[MODS], equals("Inherent Modifiers: Area of Effect + Bestows a Bonus, Ward’s Power."));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Augury-6."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting:"
            " Control Augury (5)"
            " + Area of Effect, 5 yards (50) + Bestows a Bonus, +2 to Ward’s Power (4) + Duration, 1 hour (7)."
            " 66 SP."));
  });

  test('Whiplash', () {
    spell.name = 'Whiplash';
    spell.effects.add(new SpellEffect(Effect.Control, Path.Mesmerism));
    spell.ritualModifiers.add(new Affliction("Seizure", value: 100, inherent: true));
    spell.ritualModifiers.add(new Damage(value: 1, inherent: true));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Whiplash"));
    expect(lines[EFFECTS], equals("Spell Effects: Control Mesmerism."));
    expect(lines[MODS], equals("Inherent Modifiers: Afflictions, Seizure + Damage, Direct Crushing."));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Mesmerism-2."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting:"
            " Control Mesmerism (5)"
            " + Afflictions, Seizure (20)"
            " + Damage, Direct Crushing 1d+1 (1). 26 SP."));
  });

  test('Wrathchild', () {
    spell.name = 'Wrathchild';
    spell.effects.add(new SpellEffect(Effect.Control, Path.Mesmerism));
    spell.effects.add(new SpellEffect(Effect.Strengthen, Path.Transfiguration));
    spell.ritualModifiers.add(new AlteredTraits("ST +5 and Berserk (N/A)", null, value: 55, inherent: true));
    spell.ritualModifiers.add(
        new Bestows("HT rolls to remain conscious or alive", range: BestowsRange.single, value: 2, inherent: true));
    spell.ritualModifiers.add(new DurationMod(value: 30));
    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Wrathchild"));
    expect(lines[EFFECTS], equals("Spell Effects: Control Mesmerism + Strengthen Transfiguration."));
    expect(
        lines[MODS],
        equals("Inherent Modifiers: Altered Traits, ST +5 and Berserk (N/A)"
            " + Bestows a Bonus, HT rolls to remain conscious or alive."));
    expect(lines[PENALTY], equals("Skill Penalty: The lower of Path of Mesmerism-6 or Path of Transfiguration-6."));
    expect(lines[TIME], equals('Casting Time: 10 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting:"
            " Control Mesmerism (5) + Strengthen Transfiguration (3)"
            " + Altered Traits, ST +5 and Berserk (N/A) (55)"
            " + Bestows a Bonus, +2 to HT rolls to remain conscious or alive (2)"
            " + Duration, 30 seconds (2). 67 SP."));
  });

  test('Track Traveler', () {
    spell.name = 'Track Traveler';
    spell.effects.add(new SpellEffect(Effect.Sense, Path.Arcanum));
    spell.ritualModifiers.add(new RangeCrossTime(value: 24));
    TextSpellExporter exporter = new TextSpellExporter();

    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Track Traveler"));
    expect(lines[EFFECTS], equals("Spell Effects: Sense Arcanum."));
    expect(lines[MODS], equals("Inherent Modifiers: None."));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Arcanum-0."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting:"
            " Sense Arcanum (2)"
            " + Range (Cross-Time), 1 day (2). 4 SP."
        ));
  });

  test('Death Vison', () {
    spell.name = 'Death Vision';
    spell.effects.add(new SpellEffect(Effect.Sense, Path.Augury));
    spell.effects.add(new SpellEffect(Effect.Destroy, Path.Mesmerism));
    spell.ritualModifiers.add(new AfflictionStun(inherent: true));
    spell.ritualModifiers.add(new Range(value: 10));

    TextSpellExporter exporter = new TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals("Death Vision"));
    expect(lines[EFFECTS], equals("Spell Effects: Sense Augury + Destroy Mesmerism."));
    expect(lines[MODS], equals("Inherent Modifiers: Affliction, Stunning."));
    expect(lines[PENALTY], equals("Skill Penalty: The lower of Path of Augury-1 or Path of Mesmerism-1."));
    expect(lines[TIME], equals('Casting Time: 10 minutes.'));
    expect(
        lines[TYPICAL],
        equals("Typical Casting:"
            " Sense Augury (2) + Destroy Mesmerism (5)"
            " + Affliction, Stunning (0) + Range, 10 yards (4)."
            " 11 SP."
        ));
  });
}
