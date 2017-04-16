class Spell {
  String _name = "";

  String get name => _name;
  set name(String name) {
    if (name == null) {
      _name = "";
    } else {
      _name = name;
    }
  }
}
