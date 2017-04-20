import 'spell_effect.dart';
import 'modifier.dart';
import '../util/gurps_duration.dart';

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

  String _name = "";

  final List<SpellEffect> _effects = new List<SpellEffect>();

  final List<Modifier> _modifiers = new List<Modifier>();

  bool conditional = false;

  String get name => _name;

  set name(String name) => _name = name ?? "";

  void addEffect(SpellEffect effect) => _effects.add(effect);

  void addModifier(Modifier mod) => _modifiers.add(mod);

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
}
