import 'effect.dart';
import 'spell_exporter.dart';
import 'path.dart';
import 'package:quiver/core.dart';

typedef String ToSpellEffectText();

class SpellEffect {
  Effect effect;
  Path path;

  SpellEffect(this.effect, this.path);

  int get spellPoints => effect?.spellPoints ?? 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SpellEffect && effect == other.effect && path == other.path;
  }

  @override
  int hashCode() => hash2(effect.name, path.name);

  void export(EffectExporter exporter) {
    exporter.add(
        effect: effect.name, path: path.name, spellPoints: spellPoints);
  }
}
