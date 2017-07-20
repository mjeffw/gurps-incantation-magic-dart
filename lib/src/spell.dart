import '../units/gurps_duration.dart';
import 'spell_exporter.dart';
import 'ritual_modifier.dart';
import 'spell_effect.dart';
import '../gurps/modifier.dart';

class Spell {
  static final List<GurpsDuration> times = [
    const GurpsDuration(minutes: 2), // Placeholder to make index equivalent to number of effects

    const GurpsDuration(minutes: 5),
    const GurpsDuration(minutes: 10),
    const GurpsDuration(minutes: 30),

    const GurpsDuration(hours: 1),
    const GurpsDuration(hours: 3),
    const GurpsDuration(hours: 6),

    const GurpsDuration(hours: 12),
    const GurpsDuration(hours: 24),
    const GurpsDuration(days: 3),

    const GurpsDuration(weeks: 1),
    const GurpsDuration(weeks: 2),
    const GurpsDuration(months: 1)
  ];

  // each spell has a name
  String _name = "";
  String get name => _name;
  set name(String name) => _name = name ?? "";

  // spells have a description
  String description;

  // spells have SpellEffects - the combination of a Path and an Effect ("Control Demonology", for example)
  final List<SpellEffect> effects = new List<SpellEffect>();
  void addEffect(SpellEffect effect) => effects.add(effect);
  SpellEffect removeEffect(int index) => effects.removeAt(index);
  SpellEffect setEffect(int index, SpellEffect n) =>  effects[index] = n;

  // spells have modifiers, to deliver specific effects at a cost
  final List<RitualModifier> _ritualMods = new List<RitualModifier>();
  void addRitualModifier(RitualModifier mod) => _ritualMods.add(mod);
  List<RitualModifier> get inherentModifiers => new List.unmodifiable(_ritualMods.where((it) => it.inherent == true));
  List<RitualModifier> get ritualModifiers => new List.unmodifiable(_ritualMods);

  /// Drawbacks can be added to spells to reduce the spell points needed
  final List<Modifier> _drawbacks = [];
  void addDrawback(String name, String detail, int value) {
    if (value > 0) {
      throw new InputException("only limitations are allowed in Spell");
    }
    _drawbacks.add(new Modifier(name, detail, value));
  }

  // spells may be conditional - this means there is a specific "trigger" that causes the spell to activate
  bool conditional = false;

  int get spellPoints {
    int effectCost = effects.map((it) => it.spellPoints).fold(0, (a, b) => a + b);
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
    return _ritualMods.map((it) => it.spellPoints).fold(0, (int a, int b) => a + b);
  }

  /// The time required to cast a spell depends exclusively on how many spell effects it has.
  GurpsDuration get castingTime {
    int effectiveNumberOfEffects = effects.length + _sumOfModifierLevels ~/ 40;
    if (effectiveNumberOfEffects < 13) {
      return times[effectiveNumberOfEffects];
    } else {
      return new GurpsDuration(months: effectiveNumberOfEffects - 11);
    }
  }

  int get _sumOfModifierLevels => _drawbacks.map((e) => e.level).fold(0, (a, b) => a + b);

  SpellExporter export(SpellExporter exporter) {
    exporter.name = name;

    EffectExporter effectExporter = exporter.effectExporter;
    effects.forEach((it) => it.export(effectExporter));

    ModifierExporter modifierExporter = exporter.modifierExporter;
    _ritualMods.forEach((it) => it.export(modifierExporter));

    exporter.penalty = skillPenalty;
    exporter.time = castingTime;
    exporter.description = description;
    exporter.conditional = conditional;
    exporter.spellPoints = spellPoints;

    return exporter;
  }
}
