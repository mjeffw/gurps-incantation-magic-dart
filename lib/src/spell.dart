import '../units/gurps_duration.dart';
import 'exporter.dart';
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

  final List<SpellEffect> _effects = new List<SpellEffect>();
  final List<RitualModifier> _ritualMods = new List<RitualModifier>();
  final List<Modifier> _drawbacks = [];

  String _name = "";

  bool conditional = false;

  String description;

  String get name => _name;
  set name(String name) => _name = name ?? "";

  /// The final SP total determines the penalty to Path skill to cast the spell; this is -(SP/10), rounded up, as shown
  /// by the Spell Penalty Table.
  int get skillPenalty => (spellPoints / -10).ceil();

  void addEffect(SpellEffect effect) => _effects.add(effect);

  List<SpellEffect> get effects => new List.unmodifiable(_effects);

  void addRitualModifier(RitualModifier mod) => _ritualMods.add(mod);

  List<RitualModifier> get inherentModifiers => new List.unmodifiable(_ritualMods.where((it) => it.inherent == true));

  List<RitualModifier> get ritualModifiers => new List.unmodifiable(_ritualMods);

  @override
  void addDrawback(String name, String detail, int value) {
    if (value > 0) {
      throw new InputException("only limitations are allowed in Spell");
    }
    _drawbacks.add(new Modifier(name, detail, value));
  }

  int get spellPoints {
    int effectCost = _effects.map((it) => it.spellPoints).fold(0, (a, b) => a + b);
    int conditionalCost = _addForConditional();
    int modifierCost = _addForModifiers();
    return effectCost + conditionalCost + modifierCost;
  }

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

  GurpsDuration get castingTime {
    int effectiveNumberOfEffects = _effects.length + _sumOfModifierLevels ~/ 40;
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
    _effects.forEach((it) => it.export(effectExporter));

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
