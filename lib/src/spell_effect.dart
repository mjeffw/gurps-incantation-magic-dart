import 'effect.dart';
import 'path.dart';

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
}
