abstract class Path {
  static const Path arcanum = const _Arcanum();
  static const Path augury = const _Augury();
  static const Path demonology = const _Demonology();
  static const Path elementalism = const _Elementalism();
  static const Path mesmerism = const _Mesmerism();
  static const Path necromancy = const _Necromancy();
  static const Path protection = const _Protection();
  static const Path transfiguration = const _Transfiguration();

  static const List<Path> values = const [
    arcanum,
    augury,
    demonology,
    elementalism,
    mesmerism,
    necromancy,
    protection,
    transfiguration
  ];

  final String name;
  final String aspect;

  const Path(this.name, this.aspect);

  factory Path.fromString(String name) {
    return values.where((Path e) => e.name == name).first;
  }

  @override
  String toString() => name;
}

class _Arcanum extends Path {
  const _Arcanum()
      : super(
            "Arcanum", "Spells, mana, and the creations of the magical arts.");
}

class _Augury extends Path {
  const _Augury() : super("Augury", "The past, the future, fate, and chance.");
}

class _Demonology extends Path {
  const _Demonology()
      : super("Demonology",
            "Demons and angels; also traveling to and from Hell (but not Heaven!).");
}

class _Elementalism extends Path {
  const _Elementalism()
      : super("Elementalism",
            "Air, earth, fire, water, and wood -- as well as void/sound/ether, if used in the campaign.");
}

class _Mesmerism extends Path {
  const _Mesmerism()
      : super("Mesmerism", "The minds of sapient (IQ6+) beings.");
}

class _Necromancy extends Path {
  const _Necromancy()
      : super("Necromancy",
            "The dead and undead, as well as shadows and darkness.");
}

class _Protection extends Path {
  const _Protection() : super("Protection", "All sorts of defensive magic.");
}

class _Transfiguration extends Path {
  const _Transfiguration()
      : super("Transfiguration",
            "Living sapient beings, including their flesh and blood in general.");
}
