import 'package:gurps_dart/gurps_dart.dart';
import 'spell_exporter.dart';
import 'ritual_modifier.dart';
import 'spell_effect.dart';

class Spell {
  static final List<GDuration> times = [
    const GDuration(
        minutes:
            2), // Placeholder to make index equivalent to number of effects

    const GDuration(minutes: 5),
    const GDuration(minutes: 10),
    const GDuration(minutes: 30),

    const GDuration(hours: 1),
    const GDuration(hours: 3),
    const GDuration(hours: 6),

    const GDuration(hours: 12),
    const GDuration(hours: 24),
    const GDuration(days: 3),

    const GDuration(weeks: 1),
    const GDuration(weeks: 2),
    const GDuration(months: 1)
  ];

  // each spell has a name
  String _name = "";
  String get name => _name;
  set name(String name) => _name = name ?? "";

  // spells have a description
  String description;

  // spells have SpellEffects - the combination of a Path and an Effect ("Control Demonology", for example)
  final List<SpellEffect> effects = [];

  // spells have modifiers, to deliver specific effects at a cost
  final List<RitualModifier> ritualModifiers = [];
  List<RitualModifier> get inherentModifiers =>
      List.unmodifiable(ritualModifiers.where((it) => it.inherent == true));

  /// Drawbacks can be added to spells to reduce the spell points needed
  final List<TraitModifier> drawbacks = [];
  void addDrawback(String name, String detail, int value) {
    if (value > 0) {
      throw InputException("only limitations are allowed in Spell");
    }
    drawbacks.add(TraitModifier(name: name, detail: detail, percent: value));
  }

  // spells may be conditional - this means there is a specific "trigger" that causes the spell to activate
  bool conditional = false;

  int get spellPoints {
    int effectCost =
        effects.map((it) => it.spellPoints).fold(0, (a, b) => a + b);
    int conditionalCost = _addForConditional();
    int modifierCost = _addForModifiers();
    return effectCost + conditionalCost + modifierCost;
  }

  /// The final SP total determines the penalty to Path skill to cast the spell; this is -(SP/10), rounded up, as shown
  /// by the Spell Penalty Table.
  int get skillPenalty => (spellPoints / -10).ceil();

  int _addForConditional() {
    if (conditional) {
      return 5;
    } else {
      return 0;
    }
  }

  int _addForModifiers() {
    return ritualModifiers
        .map((it) => it.spellPoints)
        .fold(0, (int a, int b) => a + b);
  }

  /// The time required to cast a spell depends exclusively on how many spell effects it has.
  GDuration get castingTime {
    int effectiveNumberOfEffects =
        effects.length + _sumOfDrawbackModifierLevels ~/ 40;
    if (effectiveNumberOfEffects < 13) {
      return times[effectiveNumberOfEffects];
    } else {
      return GDuration(months: effectiveNumberOfEffects - 11);
    }
  }

  int get _sumOfDrawbackModifierLevels =>
      drawbacks.map((e) => e.percent).fold(0, (a, b) => a + b);

  SpellExporter export(SpellExporter exporter) {
    exporter.name = name;

    EffectExporter effectExporter = exporter.effectExporter;
    effectExporter.clear();
    effects.forEach((it) => it.export(effectExporter));

    ModifierExporter modifierExporter = exporter.modifierExporter;
    modifierExporter.clear();
    ritualModifiers.forEach((it) => it.export(modifierExporter));

    exporter.penalty = skillPenalty;
    exporter.time = castingTime;
    exporter.description = description;
    exporter.conditional = conditional;
    exporter.spellPoints = spellPoints;

    return exporter;
  }
}
