import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

void main() {
  SpellEffect effect;

  test("defaults", () {
    effect = SpellEffect(null, null);
    expect(effect.path, isNull);
    expect(effect.effect, isNull);
    expect(effect.spellPoints, equals(0));
  });

  test("Sense Augury", () {
    effect = SpellEffect(Effect.Sense, Path.augury);
    expect(effect.path, equals(Path.augury));
    expect(effect.effect, equals(Effect.Sense));
    expect(effect.spellPoints, equals(2));
  });

  test("Control Elementalism", () {
    effect = SpellEffect(Effect.Control, Path.elementalism);
    expect(effect.path, equals(Path.elementalism));
    expect(effect.effect, equals(Effect.Control));
    expect(effect.spellPoints, equals(5));
  });
}
