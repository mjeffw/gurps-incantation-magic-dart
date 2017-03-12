abstract class Effect {
  final String name;

  String get description;
  int get spellPoints;

  Effect(this.name);

  factory Effect.fromString(String name) {
    return _list.where((Effect e) => e.name == name).first;
  }

  static Effect Sense = new _Sense();
  static Effect Strengthen = new _Strengthen();
  static Effect Restore = new _Restore();
  static Effect Control = new _Control();
  static Effect Destroy = new _Destroy();
  static Effect Create = new _Create();
  static Effect Transform = new _Transform();

  static List<Effect> _list = [Sense, Strengthen, Restore, Control, Destroy, Create, Transform];
}

class _Sense extends Effect {
  _Sense() : super("Sense");

  @override
  String get description => "Learn something about, or communicate with, the subject.";

  @override
  int get spellPoints => 2;
}

class _Strengthen extends Effect {
  _Strengthen() : super("Strengthen");

  @override
  String get description => "Protect, enhance, or otherwise augment the subject.";

  @override
  int get spellPoints => 3;
}

class _Restore extends Effect {
  _Restore() : super("Restore");

  @override
  String get description => "Repair subject or undo a transformation.";

  @override
  int get spellPoints => 4;
}

class _Control extends Effect {
  _Control() : super("Control");

  @override
  String get description => "Direct or move the subject without changing it fundamentally.";

  @override
  int get spellPoints => 5;
}

class _Destroy extends Effect {
  _Destroy() : super("Destroy");

  @override
  String get description => "Damage or weaken the subject.";

  @override
  int get spellPoints => 5;
}

class _Create extends Effect {
  _Create() : super("Create");

  @override
  String get description => "Bring subject into being from nothing.";

  @override
  int get spellPoints => 6;
}

class _Transform extends Effect {
  _Transform() : super("Transform");

  @override
  String get description => "Significantly alter the subject.";

  @override
  int get spellPoints => 8;
}
