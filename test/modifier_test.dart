import "package:test/test.dart";
import "package:gurps_incantation_magic_model/incantation_magic.dart";

void main() {
  group("Afflictions:",(){
    test("can be created by name",(){
      Modifier m = new Modifier.fromString("Affliction");
    });
  });
}