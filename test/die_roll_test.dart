import "package:gurps_incantation_magic_model/incantation_magic.dart";
import "package:test/test.dart";

void main() {
  test("can be constructed from a String", () {
    expect(new DieRoll.fromString("1d-1"), equals(new DieRoll(1, -1)));
    expect(new DieRoll.fromString("1d"), equals(new DieRoll(1, 0)));
    expect(new DieRoll.fromString("1d+1"), equals(new DieRoll(1, 1)));
    expect(new DieRoll.fromString("1d+2"), equals(new DieRoll(1, 2)));
    expect(new DieRoll.fromString("4d-1"), equals(new DieRoll(4, -1)));
    expect(new DieRoll.fromString("4d"), equals(new DieRoll(4, 0)));
    expect(new DieRoll.fromString("4d+1"), equals(new DieRoll(4, 1)));
    expect(new DieRoll.fromString("4d+2"), equals(new DieRoll(4, 2)));
  });

  test("should create normalized DieRoll", () {
    DieRoll d = new DieRoll(1, 0);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(0));

    d = new DieRoll(1, -2);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(-2));

    d = new DieRoll(1, 1);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(1));

    d = new DieRoll(1, 2);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(2));

    d = new DieRoll(1, 3);
    expect(d.numberOfDice, equals(2));
    expect(d.adds, equals(-1));

    d = new DieRoll(3, 2);
    expect(d.numberOfDice, equals(3));
    expect(d.adds, equals(2));

    d = new DieRoll(3, 3);
    expect(d.numberOfDice, equals(4));
    expect(d.adds, equals(-1));

    d = new DieRoll(5, -1);
    expect(d.numberOfDice, equals(5));
    expect(d.adds, equals(-1));

    d = new DieRoll(5, -2);
    expect(d.numberOfDice, equals(4));
    expect(d.adds, equals(2));

    d = new DieRoll(5, 20);
    expect(d.numberOfDice, equals(10));
    expect(d.adds, equals(0));

    d = new DieRoll(7, -21);
    expect(d.numberOfDice, equals(2));
    expect(d.adds, equals(-1));
  });

  test("can denormalize", () {
    expect(DieRoll.denormalize(new DieRoll(1, 0)), equals(0));
    expect(DieRoll.denormalize(new DieRoll(1, 1)), equals(1));
    expect(DieRoll.denormalize(new DieRoll(1, 2)), equals(2));
    expect(DieRoll.denormalize(new DieRoll(2, -1)), equals(3));
    expect(DieRoll.denormalize(new DieRoll(4, 2)), equals(14));
    expect(DieRoll.denormalize(new DieRoll(10, 0)), equals(36));
  });

  test("can add", () {
    expect(new DieRoll(1, 0) + 1, equals(new DieRoll(1, 1)));

    expect(new DieRoll(2, 0) + 2, equals(new DieRoll(2, 2)));
    expect(new DieRoll(2, 2) + 2, equals(new DieRoll(3, 0)));
    expect(new DieRoll(5, 0) + 2, equals(new DieRoll(5, 2)));
    expect(new DieRoll(1, -1) + 2, equals(new DieRoll(1, 1)));

    expect(new DieRoll(2, 0) + 3, equals(new DieRoll(3, -1)));
    expect(new DieRoll(2, 3) + 3, equals(new DieRoll(3, 2)));
    expect(new DieRoll(5, 0) + 3, equals(new DieRoll(6, -1)));
    expect(new DieRoll(1, -1) + 3, equals(new DieRoll(1, 2)));

    expect(new DieRoll(2, 0) + -3, equals(new DieRoll(1, 1)));
    expect(new DieRoll(2, 3) + -3, equals(new DieRoll(2, 0)));
    expect(new DieRoll(5, 0) + -3, equals(new DieRoll(4, 1)));
  });

  test("can subtract", () {
    expect(new DieRoll(2, 0) - 3, equals(new DieRoll(1, 1)));
    expect(new DieRoll(2, 3) - 3, equals(new DieRoll(2, 0)));
    expect(new DieRoll(5, 0) - 3, equals(new DieRoll(4, 1)));
  });

  test("can multiply", () {
    expect(new DieRoll(1, 0) * 1, equals(new DieRoll(1, 0)));

    expect(new DieRoll(2, 0) * 2, equals(new DieRoll(4, 0)));
    expect(new DieRoll(2, 2) * 2, equals(new DieRoll(5, 0)));
    expect(new DieRoll(5, 0) * 2, equals(new DieRoll(10, 0)));
    expect(new DieRoll(1, -1) * 2, equals(new DieRoll(1, 2)));

    expect(new DieRoll(2, 0) * 3, equals(new DieRoll(6, 0)));
    expect(new DieRoll(2, 3) * 3, equals(new DieRoll(8, 1)));
    expect(new DieRoll(5, 0) * 3, equals(new DieRoll(15, 0)));
    expect(new DieRoll(1, -1) * 3, equals(new DieRoll(2, 1)));
  });

  test("can divide", () {
    expect(new DieRoll(1, 0) / 1, equals(new DieRoll(1, 0)));

    expect(new DieRoll(2, 0) / 2, equals(new DieRoll(1, 0)));
    expect(new DieRoll(2, 2) / 2, equals(new DieRoll(1, 1)));
    expect(new DieRoll(5, 0) / 2, equals(new DieRoll(2, 2)));
    expect(new DieRoll(1, -1) / 2, equals(new DieRoll(0, 1)));

    expect(new DieRoll(2, 0) / 3, equals(new DieRoll(0, 2)));
    expect(new DieRoll(2, 3) / 3, equals(new DieRoll(1, -1)));
    expect(new DieRoll(5, 0) / 3, equals(new DieRoll(1, 2)));
    expect(new DieRoll(1, -1) / 3, equals(new DieRoll(0, 1)));

    expect(new DieRoll(0, 6) / 2, equals(new DieRoll(1, -1)));
    expect(new DieRoll(0, 7) / 2, equals(new DieRoll(1, -1)));
    expect(new DieRoll(0, 8) / 2, equals(new DieRoll(1, 0)));
  });
}
