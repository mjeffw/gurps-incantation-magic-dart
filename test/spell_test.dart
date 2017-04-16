import "package:test/test.dart";
import "package:gurps_incantation_magic_model/incantation_magic.dart";

void main(){
  Spell spell;

  setUp(() async {
    spell = new Spell();
  });

  test("creation", () {
    expect(spell, isNotNull);
  });

  test("has name", () {
    expect(spell.name, equals(""));
    spell.name = "Joe";
    expect(spell.name, equals("Joe"));
    spell.name = null;
    expect(spell.name, equals(""));
  });
}