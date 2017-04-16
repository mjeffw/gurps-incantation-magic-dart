import 'spell_effect.dart';

class Spell {
  String _name = "";
  final List<SpellEffect> _effects = new List<SpellEffect>();

  String get name => _name;

  set name(String name) => _name = name ?? "";

  void add(SpellEffect effect) => _effects.add(effect);

  int get spellPoints => _effects.map((it) => it.spellPoints).fold(0, (a, b) => a + b);
}
