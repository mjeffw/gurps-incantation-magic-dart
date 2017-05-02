import 'dart:mirrors';
import '../util/core_utils.dart';

typedef bool EnhancerPredicate(Modifier e);

EnhancerPredicate any = (x) => true;
EnhancerPredicate limitationOnly = (x) => x.level < 0;

/// Represents a single GURPS Modifier.
///
/// A modifier is a feature that you can add to a trait – usually an advantage – to change the way it works. There
/// are two basic types of modifiers: enhancements and limitations. Adding an enhancement makes the underlying
/// trait more useful, while applying a limitation attaches additional restrictions to your ability.
///
/// Modifiers adjust the base cost of a trait in proportion to their effects. Enhancements increase the cost, while
/// limitations reduce the cost. This is expressed as a percentage. For instance, a +20% enhancement would increase
/// the point cost of an advantage by 1/5 its base cost, while a -50% limitation would reduce it by half its base cost.
class Modifier {
  /// Name of this Modifier.
  String name;

  /// Optional detail about the Modifier.
  String detail;

  /// The value of the Modifier. This would be treated as a percentage as per B101.
  int level;

  Modifier(this.name, this.detail, this.level);

  String get summaryText {
    if (detail != null && detail.length > 0) {
      return '${name}, ${detail}';
    }
    return name;
  }

  String get typicalText {
    return '${summaryText}, ${toSignedString(level)}%';
  }
}

/// Represents a list of GURPS Modifiers, which can be either Enhancements or Limitations.
///
/// Provides some convenience methods for getting the sum of all Enhancement and Limitation values, or adjusting a
/// value
class ModifierList implements List<Modifier> {
  List<Modifier> _delegate;
  InstanceMirror _mirror;

  ModifierList() : _delegate = new List<Modifier>() {
    _mirror = reflect(_delegate);
  }

  void noSuchMethod(Invocation invocation) {
    return _mirror.delegate(invocation);
  }

  int adjustment(int baseValue) {
    double x = _delegate.map((i) => i.level / 100.0).fold(0.0, (a, b) => a + b);
    return (baseValue * x).ceil();
  }

  int get sum => _delegate.map((e) => e.level).fold(0, (a, b) => a + b);
}

/// Define the Enhanceable mixin.
///
/// Classes that are extended with _Enhanceable maintain a list of enhancements and limitations.
abstract class Modifiable {
  final ModifierList _modifiers = new ModifierList();

  void addModifier(String name, String detail, int value) {
    _modifiers.add(new Modifier(name, detail, value));
  }

  int adjustmentForModifiers(int baseValue) => _modifiers.adjustment(baseValue);
  int get sumOfModifierLevels => _modifiers.sum;
  List<Modifier> get modifiers => new List.unmodifiable(_modifiers._delegate);
}
