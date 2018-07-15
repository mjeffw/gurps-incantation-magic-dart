import 'effect.dart';
import 'spell_exporter.dart';
import 'path.dart';

typedef String toSpellEffectText();

class SpellEffect {
  Effect effect;
  Path path;

  SpellEffect(this.effect, this.path);

  int get spellPoints => effect?.spellPoints ?? 0;

  @override
  bool operator ==(Object other) {
    if (other is! SpellEffect) return false;
    return effect == (other as SpellEffect).effect &&
        path == (other as SpellEffect).path;
  }

  void export(EffectExporter exporter) {
    exporter.add(
        effect: effect.name, path: path.name, spellPoints: spellPoints);
  }
}
