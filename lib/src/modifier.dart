abstract class Modifier {
  static Modifier Affliction = new _Affliction();

  static List<Modifier> _list = [Affliction];

  final String name;

  Modifier(this.name);

  factory Modifier.fromString(String name) {
    return _list.where((Modifier e) => e.name == name).first;
  }
}

class _Affliction extends Modifier {
  _Affliction() : super("Affliction");
}
