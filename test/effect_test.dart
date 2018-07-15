import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

void main() {
  group("Sense:", () {
    Effect sense = Effect.fromString("Sense");

    test("has name", () {
      expect(sense.name, equals("Sense"));
    });

    test("has description", () {
      expect(sense.description,
          equals("Learn something about, or communicate with, the subject."));
    });

    test("has SpellPoints", () {
      expect(sense.spellPoints, equals(2));
    });

    test("can be constructed by name", () {
      expect(sense, equals(Effect.Sense));
    });
  });

  group("Strengthen:", () {
    Effect strengthen = Effect.fromString("Strengthen");

    test("can be constructed by name", () {
      expect(strengthen, equals(Effect.Strengthen));
    });

    test("has name", () {
      expect(strengthen.name, equals("Strengthen"));
    });

    test("has description", () {
      expect(strengthen.description,
          equals("Protect, enhance, or otherwise augment the subject."));
    });

    test("has SpellPoints", () {
      expect(strengthen.spellPoints, equals(3));
    });
  });

  group("Restore:", () {
    Effect restore = Effect.fromString("Restore");

    test("can be constructed by name", () {
      expect(restore, equals(Effect.Restore));
    });

    test("has name", () {
      expect(restore.name, equals("Restore"));
    });

    test("has description", () {
      expect(restore.description,
          equals("Repair subject or undo a transformation."));
    });

    test("has SpellPoints", () {
      expect(restore.spellPoints, equals(4));
    });
  });

  group("Control:", () {
    Effect control = Effect.fromString("Control");

    test("can be constructed by name", () {
      expect(control, equals(Effect.Control));
    });

    test("has name", () {
      expect(control.name, equals("Control"));
    });

    test("has description", () {
      expect(
          control.description,
          equals(
              "Direct or move the subject without changing it fundamentally."));
    });

    test("has SpellPoints", () {
      expect(control.spellPoints, equals(5));
    });
  });

  group("Destroy:", () {
    Effect destroy = Effect.fromString("Destroy");

    test("can be constructed by name", () {
      expect(destroy, equals(Effect.Destroy));
    });

    test("has name", () {
      expect(destroy.name, equals("Destroy"));
    });

    test("has description", () {
      expect(destroy.description, equals("Damage or weaken the subject."));
    });

    test("has SpellPoints", () {
      expect(destroy.spellPoints, equals(5));
    });
  });

  group("Create:", () {
    Effect create = Effect.fromString("Create");

    test("can be constructed by name", () {
      expect(create, equals(Effect.Create));
    });

    test("has name", () {
      expect(create.name, equals("Create"));
    });

    test("has description", () {
      expect(
          create.description, equals("Bring subject into being from nothing."));
    });

    test("has SpellPoints", () {
      expect(create.spellPoints, equals(6));
    });
  });

  group("Transform:", () {
    Effect transform = Effect.fromString("Transform");

    test("can be constructed by name", () {
      expect(transform, equals(Effect.Transform));
    });

    test("has name", () {
      expect(transform.name, equals("Transform"));
    });

    test("has description", () {
      expect(transform.description, equals("Significantly alter the subject."));
    });

    test("has SpellPoints", () {
      expect(transform.spellPoints, equals(8));
    });
  });
}
