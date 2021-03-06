import 'package:gurps_dart/gurps_dart.dart';
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
    spell = Spell();
  });

  test('Alarm', () {
    String _description =
        "You create a mystical 'booby-trap,' akin to cans strung along a wire, in a "
        "five-yard radius from the starting point. When an unauthorized being (you may "
        "authorize up to six) enters the area, every authorized being automatically "
        "wakes up (if asleep) and becomes aware of the invasion. Mundane stealth cannot "
        "overcome this; resolve any supernatural attempts at stealth as a Quick Contest "
        "against the incanter's Path of Arcanum. This is a conditional spell (p. 20) "
        "that 'hangs' until triggered or until everyone wakes up for the day.";

    spell.name = "Alarm";
    spell.conditional = true;
    spell.effects.add(SpellEffect(Effect.Create, Path.arcanum));
    AreaOfEffect m = AreaOfEffect(value: 5, inherent: true)
      ..setTargetInfo(6, true);
    spell.ritualModifiers.add(m);
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
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
            'Area of Effect, 5 yards, Includes 6 targets (53). 64 SP.'));
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
    spell.name = "Animate Object";
    spell.effects.add(SpellEffect(Effect.Create, Path.arcanum));
    spell.effects.add(SpellEffect(Effect.Control, Path.arcanum));
    spell.ritualModifiers
        .add(DurationMod(value: GDuration(hours: 12).inSeconds));
    spell.ritualModifiers.add(SubjectWeight(value: 100));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Animate Object'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS],
        equals("Spell Effects: Create Arcanum + Control Arcanum."));
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
            '+ Subject Weight, 100 lbs. (2). 23 SP.'));
  });

  test('Arcane Fire', () {
    String _description =
        "This spell conjures a ball of pure magical energy. In addition to causing 6d burning damage, it also "
        "reduces the target's resistance to further magic. For each point of damage that penetrates the target's DR, "
        "he must make a HT roll (at -1 per 2 points of penetrating damage), or lose a level of Magic Resistance per "
        "point by which he failed. If the target has no Magic Resistance, he instead gains levels of Magical "
        "Susceptibility per point by which he failed his roll (maximum of five). These effects last for (20 - HT) "
        "minutes, minimum of one minute.";
    spell.name = 'Arcane Fire';
    spell.effects.add(SpellEffect(Effect.Create, Path.arcanum));
    Damage dam = Damage(
        type: DamageType.burning, value: 4, inherent: true, direct: false);
    dam.addTraitModifier(
        TraitModifier(name: "Alternative Enhancements", percent: 77));
    spell.ritualModifiers.add(dam);
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Arcane Fire'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Create Arcanum."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Damage, Indirect Burning (Alternative Enhancements).'));
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
    spell.name = 'Bewitchment';
    spell.effects.add(SpellEffect(Effect.Destroy, Path.mesmerism));
    spell.addDrawback("Requires eye contact", null, -40);
    spell.ritualModifiers.add(Affliction("Daze", value: 50, inherent: true));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
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
    spell.name = 'Black Blade';
    spell.effects.add(SpellEffect(Effect.Create, Path.necromancy));
    Damage dam = Damage(type: DamageType.toxic, value: 8, inherent: true);
    dam.addTraitModifier(TraitModifier(name: "Follow-Up", percent: 0));
    spell.ritualModifiers.add(dam);
    spell.ritualModifiers.add(DurationMod(value: 10));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Black Blade'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Create Necromancy."));
    expect(lines[MODS],
        equals('Inherent Modifiers: Damage, Direct Toxic (Follow-Up).'));
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
    spell.name = 'Bond of Servitude for (Demons)';
    spell.effects.add(SpellEffect(Effect.Control, Path.demonology));
    spell.ritualModifiers.add(Bestows("Resistance to Bond of Servitude",
        range: BestowsRange.single, value: -2, inherent: true));
    spell.ritualModifiers
        .add(DurationMod(value: GDuration(hours: 1).inSeconds));
    spell.ritualModifiers.add(Range(value: 20));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Bond of Servitude for (Demons)'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Control Demonology."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Bestows a Penalty, Resistance to Bond of Servitude.'));
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
    spell.name = 'Bulwark';
    spell.effects.add(SpellEffect(Effect.Strengthen, Path.protection));
    AlteredTraits alteredTraits = AlteredTraits(
        Trait(
            name: "Damage Resistance",
            levels: 6,
            hasLevels: true,
            costPerLevel: 5),
        inherent: true);
    alteredTraits
        .addTraitModifier(TraitModifier(name: "Hardened 2", percent: 40));
    alteredTraits
        .addTraitModifier(TraitModifier(name: "Tough Skin", percent: -40));
    spell.ritualModifiers.add(alteredTraits);
    spell.ritualModifiers
        .add(DurationMod(value: GDuration(minutes: 12).inSeconds));
    spell.ritualModifiers.add(SubjectWeight(value: 1000));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Bulwark'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Strengthen Protection."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Altered Traits, Damage Resistance (Hardened 2; Tough Skin).'));
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
            ' + Subject Weight, 1000 lbs. (4). ' // TODO would like comma-separated values, like '1,000'
            '43 SP.'));
  });

  test('Censure', () {
    String _description =
        "This spell banishes extradimensional entities, who must make a resistance roll at -6. Failure means "
        "instant banishment from their non-native reality. Critical success on the resistance roll means they "
        "cannot be banished by the caster for the next 24 hours!";
    spell.name = 'Censure';
    spell.effects.add(SpellEffect(Effect.Control, Path.protection));
    spell.ritualModifiers
        .add(Bestows("Resist Censure", value: -6, inherent: true));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Censure'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Control Protection."));
    expect(lines[MODS],
        equals('Inherent Modifiers: Bestows a Penalty, Resist Censure.'));
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
        "The caster conjures a cone of fire, emanating from his hands and extending out to a maximum width of five "
        "yards and length of 20 yards (see Area and Spreading Attacks, p. B413). This cone does 3d burning damage and "
        "requires a roll against Innate Attack (Beam) to hit.";
    spell.name = 'Cone of Flame';
    spell.effects.add(SpellEffect(Effect.Create, Path.elementalism));
    Damage dam =
        Damage(type: DamageType.burning, direct: false, inherent: true);
    dam.addTraitModifier(
        TraitModifier(name: "Cone", detail: "5 yards", percent: 100));
    dam.addTraitModifier(
        TraitModifier(name: "Reduced Range", detail: "x1/5", percent: -20));
    spell.ritualModifiers.add(dam);
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Cone of Flame'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Create Elementalism."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Damage, Indirect Burning (Cone; Reduced Range).'));
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
            '22 SP.'));
  });

  test("Create Golem warrior", () {
    String _description =
        "This spell summons a warrior simulacrum (below) to defend you for one hour. You may specify its combat "
        "skills when the spell is cast. (The two Create Arcanum effects are for its body and its independent "
        "spirit.) The warrior is a dedicated, fanatic guardian who will willingly lay down its life for its "
        "master. While it can be ordered to perform various unskilled tasks, it will refuse to be separated from "
        "its master, and will abandon all orders to rush to its master���s defense. It has the attitude of a "
        "faithful but jealous dog; it does not understand the motivations of the living beyond ���survival,��� and "
        "may mistake jokes and harmless social situations for aggression. The warrior is created without armor "
        "or weapons; these must be provided via another spell or given to it by hand.";
    spell.name = 'Create Golem Warrior';
    spell.effects.add(SpellEffect(Effect.Create, Path.arcanum));
    spell.effects.add(SpellEffect(Effect.Create, Path.arcanum));
    spell.ritualModifiers.add(Summoned(value: 50, inherent: true));
    spell.ritualModifiers
        .add(DurationMod(value: GDuration(hours: 1).inSeconds));
    spell.ritualModifiers.add(SubjectWeight(value: 300));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Create Golem Warrior'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Create Arcanum x2."));
    expect(lines[MODS], equals('Inherent Modifiers: Summoned.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Arcanum-3."));
    expect(lines[TIME], equals('Casting Time: 10 minutes.'));
    expect(lines[GAP2], '');
    expect(lines[DESC], equals(_description));
    expect(lines[GAP3], '');
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Create Arcanum (6) + Create Arcanum (6) '
            '+ Duration, 1 hour (7) + Subject Weight, 300 lbs. (3) + Summoned, 50% of Static Point Total (8). '
            '30 SP.'));
  });

  test("Create Undead Servitor", () {
    String _description =
        "You animate a servitor skeleton or zombie (Summoners, pp. 25-26) from a nearby dead body or grave. It "
        "does your bidding for the next day, after which it crumbles to dust or putrefies.";
    spell.name = 'Create Undead Servitor';
    spell.effects.add(SpellEffect(Effect.Control, Path.necromancy));
    spell.effects.add(SpellEffect(Effect.Create, Path.necromancy));
    spell.ritualModifiers.add(Summoned(value: 25, inherent: true));
    spell.ritualModifiers.add(DurationMod(value: GDuration(days: 1).inSeconds));
    spell.ritualModifiers.add(SubjectWeight(value: 300));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Create Undead Servitor'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS],
        equals("Spell Effects: Control Necromancy + Create Necromancy."));
    expect(lines[MODS], equals('Inherent Modifiers: Summoned.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Necromancy-2."));
    expect(lines[TIME], equals('Casting Time: 10 minutes.'));
    expect(lines[GAP2], '');
    expect(lines[DESC], equals(_description));
    expect(lines[GAP3], '');
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Control Necromancy (5) + Create Necromancy (6)'
            ' + Duration, 1 day (11) + Subject Weight, 300 lbs. (3) + Summoned, 25% of Static Point Total (4). '
            '29 SP.'));
  });

  test("Creeping Frost", () {
    String _description =
        "This spell slowly freezes anyone or anything caught in the area and weighing five tons or less. For the "
        "next minute, every target who failed to resist acquires Fragile (Brittle) and any crushing injury he "
        "receives is doubled. In addition, for the first seven seconds of that minute the subject takes 1d-3 "
        "burning damage per second that ignores DR. This spell cannot set fires, but subjects may need to make a "
        "Fright Check, at the GM's discretion./n"
        "Note that the 3d damage being spread out over multiple turns is a special effect: 1d-3 is effectively "
        "1.5 points of damage and 1.5 x 7 = 10.5, the average of rolling 3d.";
    spell.name = 'Creeping Frost';
    spell.effects.add(SpellEffect(Effect.Create, Path.elementalism));
    spell.ritualModifiers.add(AlteredTraits(
        Trait(name: 'Fragile (Brittle)', baseCost: -15),
        inherent: true));
    spell.ritualModifiers.add(AlteredTraits(
        Trait(name: 'Vulnerability (Crushing Attacks x2)', baseCost: -30),
        inherent: true));
    spell.ritualModifiers.add(AreaOfEffect(value: 3, inherent: true));
    Damage dam = Damage(
        type: DamageType.burning, direct: true, value: 8, inherent: true);
    dam.addTraitModifier(TraitModifier(name: "No Incendiary", percent: -10));
    spell.ritualModifiers.add(dam);
    spell.ritualModifiers.add(Range(value: 20));
    spell.ritualModifiers
        .add(DurationMod(value: GDuration(minutes: 1).inSeconds));
    spell.ritualModifiers.add(SubjectWeight(value: 10000));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Creeping Frost'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Create Elementalism."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Altered Traits, Fragile (Brittle) + Altered Traits, Vulnerability (Crushing Attacks x2)'
            ' + Area of Effect + Damage, Direct Burning (No Incendiary).'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Elementalism-6."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(lines[GAP2], '');
    expect(lines[DESC], equals(_description));
    expect(lines[GAP3], '');
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Create Elementalism (6)'
            ' + Altered Traits, Fragile (Brittle) (3) + Altered Traits, Vulnerability (Crushing Attacks x2) (6)'
            ' + Area of Effect, 3 yards (30) + Damage, Direct Burning 3d (No Incendiary, -10%) (8)'
            ' + Duration, 1 minute (3) + Range, 20 yards (6) + Subject Weight, 5 tons (6). '
            '68 SP.'));
  });

  test("Dispelling", () {
    String _description =
        "This spell cancels any other spell targeted. The caster gets a total of +10 to his Path roll to terminate "
        "the spell: +4 from the SP total of Dispelling and another +6 from Bestows a Bonus.";
    spell.name = 'Dispelling';
    spell.effects.add(SpellEffect(Effect.Destroy, Path.arcanum));
    spell.ritualModifiers.add(Bestows("Dispelling",
        range: BestowsRange.single, value: 6, inherent: true));
    spell.ritualModifiers.add(Girded(value: 20, inherent: true));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Dispelling'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Destroy Arcanum."));
    expect(lines[MODS],
        equals('Inherent Modifiers: Bestows a Bonus, Dispelling + Girded.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Arcanum-4."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(lines[GAP2], '');
    expect(lines[DESC], equals(_description));
    expect(lines[GAP3], '');
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Destroy Arcanum (5)'
            ' + Bestows a Bonus, +6 to Dispelling (16) + Girded (20). '
            '41 SP.'));
  });

  test("(Elemental) Blast", () {
    String _description =
        "This spell allows the caster to conjure a ball of elemental energy or matter which can be thrown using Innate "
        "Attack or delivered by touch. Unless otherwise noted, it has the following statistics when thrown: Acc 3, RoF "
        "1, and Rcl 1. Consult the table below for the specifics on a given type of energy; each blast is a separate "
        "spell.";
    spell.name = '(Elemental) Blast';
    spell.effects.add(SpellEffect(Effect.Create, Path.elementalism));
    Damage dam =
        Damage(type: DamageType.corrosive, direct: false, inherent: true);
    dam.addTraitModifier(TraitModifier(name: "Incendiary", percent: 10));
    dam.addTraitModifier(
        TraitModifier(name: "Increased 1/2D, 5x", percent: 10));
    spell.ritualModifiers.add(dam);
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('(Elemental) Blast'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Create Elementalism."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Damage, Indirect Corrosive (Incendiary; Increased 1/2D, 5x).'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Elementalism-1."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(lines[GAP2], '');
    expect(lines[DESC], equals(_description));
    expect(lines[GAP3], '');
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Create Elementalism (6)'
            ' + Damage, Indirect Corrosive 3d (Incendiary, +10%; Increased 1/2D, 5x, +10%) (4). '
            '10 SP.'));
  });

  test("Firebomb", () {
    String _description =
        "This spell allows the caster to conjure a ball of elemental energy or matter which can be thrown using Innate "
        "Attack or delivered by touch. Unless otherwise noted, it has the following statistics when thrown: Acc 3, RoF "
        "1, and Rcl 1. Consult the table below for the specifics on a given type of energy; each blast is a separate "
        "spell.";
    spell.name = 'Firebomb';
    spell.effects.add(SpellEffect(Effect.Create, Path.elementalism));
    spell.ritualModifiers.add(AreaOfEffect(value: 7, inherent: true));
    spell.ritualModifiers
        .add(Damage(type: DamageType.burning, direct: false, inherent: true));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Firebomb'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Create Elementalism."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Area of Effect + Damage, Indirect Burning.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Elementalism-7."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(lines[GAP2], '');
    expect(lines[DESC], equals(_description));
    expect(lines[GAP3], '');
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Create Elementalism (6)'
            ' + Area of Effect, 7 yards (70) + Damage, Indirect Burning 3d (0). '
            '76 SP.'));
  });

  test("Flesh Mask", () {
    String _description =
        "This ritual changes the appearance of the subject. If trying to make a target look like someone else, make "
        "an IQ roll or Disguise roll at +5. Success means the resemblance is close enough to the original to be "
        "mistaken for him. Success by 5 or more, or a critical success, gives +2 on all other rolls to emulate the "
        "target (Acting, Mimicry, etc.). This effect lasts for an hour.";
    spell.name = 'Flesh Mask';
    spell.effects.add(SpellEffect(Effect.Transform, Path.transfiguration));
    spell.ritualModifiers.add(SubjectWeight(value: 300));
    spell.ritualModifiers.add(Bestows("Disguise",
        range: BestowsRange.single, value: 5, inherent: true));
    spell.ritualModifiers.add(DurationMod(value: 3600));
    spell.description = _description;

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Flesh Mask'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Transform Transfiguration."));
    expect(
        lines[MODS], equals('Inherent Modifiers: Bestows a Bonus, Disguise.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Transfiguration-3."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(lines[GAP2], '');
    expect(lines[DESC], equals(_description));
    expect(lines[GAP3], '');
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Transform Transfiguration (8)'
            ' + Bestows a Bonus, +5 to Disguise (12) + Duration, 1 hour (7) + Subject Weight, 300 lbs. (3).'
            ' 30 SP.'));
  });

  test("Frozen Bonds", () {
    spell.name = 'Frozen Bonds';
    spell.effects.add(SpellEffect(Effect.Create, Path.elementalism));
    spell.ritualModifiers.add(Bestows("Binding ST",
        range: BestowsRange.single, value: 3, inherent: true));
    spell.ritualModifiers.add(Range(value: 20));

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);

    List<String> lines = exporter.toString().split('\n');
    expect(lines[NAME], equals('Frozen Bonds'));
    expect(lines[GAP1], equals(''));
    expect(lines[EFFECTS], equals("Spell Effects: Create Elementalism."));
    expect(lines[MODS],
        equals('Inherent Modifiers: Bestows a Bonus, Binding ST.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Elementalism-1."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(lines[GAP2], '');
    expect(lines[GAP3], '');
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Create Elementalism (6)'
            ' + Bestows a Bonus, +3 to Binding ST (4) + Range, 20 yards (6).'
            ' 16 SP.'));
  });

  test("Greater Solidify Spirit", () {
    spell.name = 'Solidify Spirit';
    spell.effects.add(SpellEffect(Effect.Control, Path.necromancy));
    spell.effects.add(SpellEffect(Effect.Strengthen, Path.necromancy));
    spell.ritualModifiers.add(AlteredTraits(
        Trait(name: "Negated Insubstantiality", baseCost: 16),
        inherent: true));
    spell.ritualModifiers.add(DurationMod(value: 720));
    spell.ritualModifiers.add(RangeDimensional(value: 1));

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals('Solidify Spirit'));
    expect(lines[EFFECTS],
        equals("Spell Effects: Control Necromancy + Strengthen Necromancy."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Altered Traits, Negated Insubstantiality.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Necromancy-4."));
    expect(lines[TIME], equals('Casting Time: 10 minutes.'));
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Control Necromancy (5) + Strengthen Necromancy (3)'
            ' + Altered Traits, Negated Insubstantiality (16) + Duration, 12 minutes (6)'
            ' + Range, Extradimensional (10).'
            ' 40 SP.'));
  });

  test("Greater Solidify Spirit", () {
    spell.name = 'Hellfire Aura';
    spell.effects.add(SpellEffect(Effect.Create, Path.demonology));
    Damage dam = Damage(
        type: DamageType.burning, direct: true, value: 4, inherent: true);
    dam.addTraitModifier(TraitModifier(name: "Aura", percent: 80));
    dam.addTraitModifier(TraitModifier(name: "Incendiary", percent: 10));
    dam.addTraitModifier(
        TraitModifier(name: "Melee Attack, Reach C", percent: -30));
    spell.ritualModifiers.add(dam);
    spell.ritualModifiers.add(DurationMod(value: 60));

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals('Hellfire Aura'));
    expect(lines[EFFECTS], equals("Spell Effects: Create Demonology."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Damage, Direct Burning (Aura; Incendiary; Melee Attack, Reach C).'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Demonology-2."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Create Demonology (6)'
            ' + Damage, Direct Burning 2d (Aura, +80%; Incendiary, +10%; Melee Attack, Reach C, -30%) (16)'
            ' + Duration, 1 minute (3).'
            ' 25 SP.'));
  });

  test("Illusion", () {
    spell.name = 'Illusion';
    spell.effects.add(SpellEffect(Effect.Create, Path.elementalism));
    spell.effects.add(SpellEffect(Effect.Create, Path.mesmerism));
    spell.ritualModifiers.add(DurationMod(value: 3600));

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals('Illusion'));
    expect(lines[EFFECTS],
        equals("Spell Effects: Create Elementalism + Create Mesmerism."));
    expect(lines[MODS], equals('Inherent Modifiers: None.'));
    expect(
        lines[PENALTY],
        equals(
            "Skill Penalty: The lower of Path of Elementalism-1 or Path of Mesmerism-1."));
    expect(lines[TIME], equals('Casting Time: 10 minutes.'));
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Create Elementalism (6) + Create Mesmerism (6)'
            ' + Duration, 1 hour (7).'
            ' 19 SP.'));
  });

  test("Invisibility", () {
    spell.name = 'Invisibility';
    spell.effects.add(SpellEffect(Effect.Control, Path.elementalism));
    AlteredTraits traits = AlteredTraits(
        Trait(name: "Invisibility", baseCost: 40),
        inherent: true);
    traits.addTraitModifier(TraitModifier(
        name: "Can Carry Objects", detail: "Heavy Encumbrance", percent: 100));
    spell.ritualModifiers.add(traits);
    spell.ritualModifiers.add(DurationMod(value: 60));
    spell.ritualModifiers.add(SubjectWeight(value: 1000));

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals('Invisibility'));
    expect(lines[EFFECTS], equals("Spell Effects: Control Elementalism."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Altered Traits, Invisibility (Can Carry Objects).'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Elementalism-9."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Control Elementalism (5)'
            ' + Altered Traits, Invisibility (Can Carry Objects, Heavy Encumbrance, +100%) (80)'
            ' + Duration, 1 minute (3) + Subject Weight, 1000 lbs. (4).'
            ' 92 SP.'));
  });

  test("Jinx", () {
    spell.name = 'Jinx';
    spell.effects.add(SpellEffect(Effect.Control, Path.augury));
    AreaOfEffect areaOfEffect = AreaOfEffect(value: 5, inherent: true);
    areaOfEffect.setTargetInfo(12, false);
    spell.ritualModifiers.add(areaOfEffect);
    spell.ritualModifiers.add(Bestows("critical failure range of all rolls",
        range: BestowsRange.broad, value: -3, inherent: true));
    spell.ritualModifiers.add(DurationMod(value: 3600));

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals('Jinx'));
    expect(lines[EFFECTS], equals("Spell Effects: Control Augury."));
    expect(
        lines[MODS],
        equals(
            'Inherent Modifiers: Area of Effect + Bestows a Penalty, critical failure range of all rolls.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Augury-8."));
    expect(lines[TIME], equals('Casting Time: 5 minutes.'));
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Control Augury (5)'
            ' + Area of Effect, 5 yards, Excludes 12 targets (56)'
            ' + Bestows a Penalty, -3 to critical failure range of all rolls (20)'
            ' + Duration, 1 hour (7).'
            ' 88 SP.'));
  });

  test("Lesser Solidify Spirit", () {
    spell.name = 'Lesser Solidify Spirit';
    spell.effects.add(SpellEffect(Effect.Control, Path.necromancy));
    spell.effects.add(SpellEffect(Effect.Strengthen, Path.necromancy));
    spell.ritualModifiers.add(DurationMod(value: 720));
    spell.ritualModifiers.add(RangeDimensional(value: 1));

    TextSpellExporter exporter = TextSpellExporter();
    spell.export(exporter);
    List<String> lines = exporter.toString().split('\n');

    expect(lines[NAME], equals('Lesser Solidify Spirit'));
    expect(lines[EFFECTS],
        equals("Spell Effects: Control Necromancy + Strengthen Necromancy."));
    expect(lines[MODS], equals('Inherent Modifiers: None.'));
    expect(lines[PENALTY], equals("Skill Penalty: Path of Necromancy-2."));
    expect(lines[TIME], equals('Casting Time: 10 minutes.'));
    expect(
        lines[TYPICAL],
        equals('Typical Casting: '
            'Control Necromancy (5) + Strengthen Necromancy (3)'
            ' + Duration, 12 minutes (6) + Range, Extradimensional (10).'
            ' 24 SP.'));
  });
}
