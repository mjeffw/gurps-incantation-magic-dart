import 'effect.dart';
import 'exporter.dart';
import 'path.dart';

typedef String toSpellEffectText();

class SpellEffect {
  final Effect effect;
  final Path path;

  const SpellEffect(this.effect, this.path);

  int get spellPoints => effect?.spellPoints ?? 0;

  @override
  bool operator ==(Object other) {
    if (other is! SpellEffect) return false;
    return effect == (other as SpellEffect).effect && path == (other as SpellEffect).path;
  }

  void export(EffectExporter exporter) {
    exporter.add(effect: effect.name, path: path.name, spellPoints: spellPoints);
  }
}
