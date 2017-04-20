import "package:test/test.dart";
import "package:gurps_incantation_magic_model/incantation_magic.dart";

void main() {
  group("Arcanum:", () {
    Path arcanum = new Path.fromString("Arcanum");

    test("can create from String", () {
      expect(arcanum, isNotNull);
    });

    test("has name", () {
      expect(arcanum.name, equals("Arcanum"));
    });

    test("has aspects", () {
      expect(arcanum.aspect, equals("Spells, mana, and the creations of the magical arts."));
    });
  });

  group("Augury:", () {
    Path augury = new Path.fromString("Augury");

    test("can create from String", () {
      expect(augury, isNotNull);
    });

    test("has name", () {
      expect(augury.name, equals("Augury"));
    });

    test("has aspects", () {
      expect(augury.aspect, equals("The past, the future, fate, and chance."));
    });
  });

  group("Demonology:", () {
    Path demonology = new Path.fromString("Demonology");

    test("can create from String", () {
      expect(demonology, isNotNull);
    });

    test("has name", () {
      expect(demonology.name, equals("Demonology"));
    });

    test("has aspects", () {
      expect(demonology.aspect, equals("Demons and angels; also traveling to and from Hell (but not Heaven!)."));
    });
  });

  group("Elementalism:", () {
    Path elementalism = new Path.fromString("Elementalism");

    test("can create from String", () {
      expect(elementalism, isNotNull);
    });

    test("has name", () {
      expect(elementalism.name, equals("Elementalism"));
    });

    test("has aspects", () {
      expect(elementalism.aspect,
          equals("Air, earth, fire, water, and wood -- as well as void/sound/ether, if used in the campaign."));
    });
  });

  group("Mesmerism:", () {
    Path mesmerism = new Path.fromString("Mesmerism");

    test("can create from String", () {
      expect(mesmerism, isNotNull);
    });

    test("has name", () {
      expect(mesmerism.name, equals("Mesmerism"));
    });

    test("has aspects", () {
      expect(mesmerism.aspect, equals("The minds of sapient (IQ6+) beings."));
    });
  });

  group("Necromancy:", () {
    Path necromancy = new Path.fromString("Necromancy");

    test("can create from String", () {
      expect(necromancy, isNotNull);
    });

    test("has name", () {
      expect(necromancy.name, equals("Necromancy"));
    });

    test("has aspects", () {
      expect(necromancy.aspect, equals("The dead and undead, as well as shadows and darkness."));
    });
  });

  group("Protection:", () {
    Path protection = new Path.fromString("Protection");

    test("can create from String", () {
      expect(protection, isNotNull);
    });

    test("has name", () {
      expect(protection.name, equals("Protection"));
    });

    test("has aspects", () {
      expect(protection.aspect, equals("All sorts of defensive magic."));
    });
  });

  group("Transfiguration:", () {
    Path protection = new Path.fromString("Transfiguration");

    test("can create from String", () {
      expect(protection, isNotNull);
    });

    test("has name", () {
      expect(protection.name, equals("Transfiguration"));
    });

    test("has aspects", () {
      expect(protection.aspect, equals("Living sapient beings, including their flesh and blood in general."));
    });
  });
}
