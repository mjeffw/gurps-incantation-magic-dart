import '../util/core_utils.dart';

import 'package:collection/collection.dart';

typedef bool TraitModifierPredicate(TraitModifier e);

TraitModifierPredicate any = (x) => true;
TraitModifierPredicate limitationOnly = (x) => x.level < 0;

/// Represents a single GURPS Modifier.
///
/// A modifier is a feature that you can add to a trait – usually an advantage – to change the way it works. There
/// are two basic types of modifiers: enhancements and limitations. Adding an enhancement makes the underlying
/// trait more useful, while applying a limitation attaches additional restrictions to your ability.
///
/// Modifiers adjust the base cost of a trait in proportion to their effects. Enhancements increase the cost, while
/// limitations reduce the cost. This is expressed as a percentage. For instance, a +20% enhancement would increase
/// the point cost of an advantage by 1/5 its base cost, while a -50% limitation would reduce it by half its base cost.
class TraitModifier {
  /// Name of this Modifier.
  String name;

  /// Optional detail about the Modifier.
  String detail;

  /// The value of the Modifier. This would be treated as a percentage as per B101.
  int level;

  TraitModifier(this.name, this.detail, this.level);

  String get summaryText => name;

  String get typicalText {
    return '${name}${detail != null && detail.length > 0 ? ", ${detail}" : ""}, ${toSignedString(level)}%';
  }
}

/// Represents a list of GURPS Modifiers, which can be either Enhancements or Limitations.
///
/// Provides some convenience methods for getting the sum of all Enhancement and Limitation values, or adjusting a
/// value
class TraitModifierList extends DelegatingList<TraitModifier>  {
  TraitModifierList() : super(new List<TraitModifier>());

  int adjustment(int baseValue) {
    double x = this.map((i) => i.level / 100.0).fold(0.0, (a, b) => a + b);
    return (baseValue * x).ceil();
  }

  int get sum => this.map((e) => e.level).fold(0, (a, b) => a + b);
}

/// Define the TraitModifiable mixin.
///
/// Classes that are extended with _Enhanceable maintain a list of enhancements and limitations.
abstract class TraitModifiable {
  final TraitModifierList _modifiers = new TraitModifierList();

  void addTraitModifier(TraitModifier t) {
    _modifiers.add(t);
  }

  int adjustmentForTraitModifiers(int baseValue) => _modifiers.adjustment(baseValue);

  int get sumOfTraitModifierLevels => _modifiers.sum;

  List<TraitModifier> get traitModifiers => _modifiers;

  TraitModifier getAt(int index) => _modifiers[index];

  void removeAt(int index) {
    _modifiers.removeAt(index);
  }
}
