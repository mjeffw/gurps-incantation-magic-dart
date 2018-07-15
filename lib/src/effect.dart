abstract class Effect {
  final String name;

  String get description;
  int get spellPoints;

  const Effect(this.name);

  @override
  String toString() => name;

  static Effect fromString(String name) {
    return values.where((Effect e) => e.name == name).first;
  }

  static const Effect Sense = const _Sense();
  static const Effect Strengthen = const _Strengthen();
  static const Effect Restore = const _Restore();
  static const Effect Control = const _Control();
  static const Effect Destroy = const _Destroy();
  static const Effect Create = const _Create();
  static const Effect Transform = const _Transform();

  static const List<Effect> values = const [
    Sense,
    Strengthen,
    Restore,
    Control,
    Destroy,
    Create,
    Transform
  ];
}

class _Sense extends Effect {
  const _Sense() : super("Sense");

  @override
  String get description =>
      "Learn something about, or communicate with, the subject.";

  @override
  int get spellPoints => 2;
}

class _Strengthen extends Effect {
  const _Strengthen() : super("Strengthen");

  @override
  String get description =>
      "Protect, enhance, or otherwise augment the subject.";

  @override
  int get spellPoints => 3;
}

class _Restore extends Effect {
  const _Restore() : super("Restore");

  @override
  String get description => "Repair subject or undo a transformation.";

  @override
  int get spellPoints => 4;
}

class _Control extends Effect {
  const _Control() : super("Control");

  @override
  String get description =>
      "Direct or move the subject without changing it fundamentally.";

  @override
  int get spellPoints => 5;
}

class _Destroy extends Effect {
  const _Destroy() : super("Destroy");

  @override
  String get description => "Damage or weaken the subject.";

  @override
  int get spellPoints => 5;
}

class _Create extends Effect {
  const _Create() : super("Create");

  @override
  String get description => "Bring subject into being from nothing.";

  @override
  int get spellPoints => 6;
}

class _Transform extends Effect {
  const _Transform() : super("Transform");

  @override
  String get description => "Significantly alter the subject.";

  @override
  int get spellPoints => 8;
}
