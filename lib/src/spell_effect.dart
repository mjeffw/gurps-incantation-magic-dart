import 'effect.dart';
import 'path.dart';

class SpellEffect {
  Effect effect;
  Path path;

  SpellEffect(this. effect, this. path);

  int get spellPoints => effect?.spellPoints ?? 0;
}