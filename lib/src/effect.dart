class Effect {
  Effect(this.name, this.spellPoints, this.description);

  final String name;
  final String description;
  final int spellPoints;

  static Effect fromString(String name) {
    return _values[name];
  }

  static Effect Sense = Effect(
      "Sense", 2, "Learn something about, or communicate with, the subject.");
  static Effect Strengthen = Effect(
      "Strengthen", 3, "Protect, enhance, or otherwise augment the subject.");
  static Effect Restore =
      Effect("Restore", 4, "Repair subject or undo a transformation.");
  static Effect Control = Effect("Control", 5,
      "Direct or move the subject without changing it fundamentally.");
  static Effect Destroy = Effect("Destroy", 5, "Damage or weaken the subject.");
  static Effect Create =
      Effect("Create", 6, "Bring subject into being from nothing.");
  static Effect Transform =
      Effect("Transform", 8, "Significantly alter the subject.");

  static Map<String, Effect> _values = {
    Sense.name: Sense,
    Strengthen.name: Strengthen,
    Restore.name: Restore,
    Control.name: Control,
    Destroy.name: Destroy,
    Create.name: Create,
    Transform.name: Transform
  };

  static List<Effect> get values => List.from(_values.keys);

  @override
  String toString() => name;
}
