import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

void main() {
  SpellEffect effect;

  test("defaults", () {
    effect = new SpellEffect(null, null);
    expect(effect.path, isNull);
    expect(effect.effect, isNull);
    expect(effect.spellPoints, equals(0));
  });

  test("Sense Augury", () {
    effect = new SpellEffect(Effect.Sense, Path.Augury);
    expect(effect.path, equals(Path.Augury));
    expect(effect.effect, equals(Effect.Sense));
    expect(effect.spellPoints, equals(2));
  });

  test("Control Elementalism", () {
    effect = new SpellEffect(Effect.Control, Path.Elementalism);
    expect(effect.path, equals(Path.Elementalism));
    expect(effect.effect, equals(Effect.Control));
    expect(effect.spellPoints, equals(5));
  });
}