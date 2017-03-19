abstract class Path {
  static Path Arcanum = new _Arcanum();
  static Path Augury = new _Augury();
  static Path Demonology = new _Demonology();
  static Path Elementalism = new _Elementalism();
  static Path Mesmerism = new _Mesmerism();
  static Path Necromancy = new _Necromancy();

  static List<Path> _list = [Arcanum, Augury, Demonology, Elementalism, Mesmerism, Necromancy];

  final String name;
  final String aspect;

  Path(this.name, this.aspect);

  factory Path.fromString(String name) {
    return _list.where((Path e) => e.name == name).first;
  }
}

class _Arcanum extends Path {
  _Arcanum() : super("Arcanum", "Spells, mana, and the creations of the magical arts.");
}

class _Augury extends Path {
  _Augury() : super("Augury", "The past, the future, fate, and chance.");
}

class _Demonology extends Path {
  _Demonology() : super("Demonology", "Demons and angels; also traveling to and from Hell (but not Heaven!).");
}

class _Elementalism extends Path {
  _Elementalism()
      : super("Elementalism",
            "Air, earth, fire, water, and wood -- as well as void/sound/ether, if used in the campaign.");
}

class _Mesmerism extends Path {
  _Mesmerism() : super("Mesmerism", "The minds of sapient (IQ6+) beings.");
}

class _Necromancy extends Path {
  _Necromancy() : super("Necromancy", "The dead and undead, as well as shadows and darkness.");
}
