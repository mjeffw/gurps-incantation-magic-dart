import '../util/gurps_duration.dart';
import 'exporter.dart';
import 'modifier.dart';
import 'spell_effect.dart';

class Spell {
  static final List<GurpsDuration> times = [
    const GurpsDuration(seconds: 0), // Placeholder to make index equivalent to number of effects

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

  final List<Modifier> _modifiers = new List<Modifier>();

  String _name = "";

  bool conditional = false;

  String description;

  String get name => _name;

  /// The final SP total determines the penalty to Path skill to cast the spell; this is -(SP/10), rounded up, as shown
  /// by the Spell Penalty Table.
  int get skillPenalty => (spellPoints / -10).ceil();

  set name(String name) => _name = name ?? "";

  void addEffect(SpellEffect effect) => _effects.add(effect);

  List<SpellEffect> get effects => new List.unmodifiable(_effects);

  void addModifier(Modifier mod) => _modifiers.add(mod);

  List<Modifier> get inherentModifiers => new List.unmodifiable(_modifiers.where((it) => it.inherent == true));

  List<Modifier> get modifiers => new List.unmodifiable(_modifiers);

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
    return _modifiers.map((it) => it.spellPoints).fold(0, (int a, int b) => a + b);
  }

  GurpsDuration get castingTime {
    if (_effects.length < 13) {
      return times[_effects.length];
    } else {
      return new GurpsDuration(months: _effects.length - 11);
    }
  }

  void export(SpellExporter exporter) {
    exporter.name = name;

    EffectExporter effectExporter = exporter.effectExporter;
    _effects.forEach((it) => it.export(effectExporter));

    ModifierExporter modifierExporter = exporter.modifierExporter;
    _modifiers.forEach((it) => it.export(modifierExporter));

    exporter.penalty = skillPenalty;
    exporter.time = castingTime;
    exporter.description = description;
    exporter.conditional = conditional;
    exporter.spellPoints = spellPoints;
  }
}
