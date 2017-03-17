/// Describes a modifier to an Incantation Spell.
///
/// Modifiers add Damage, Range, Duration, and other features to a spell, and the cost of the spell is adjusted by
/// the value of the modifiers. Modifiers are identified by their name, and can be inherent (intrisic) or not.
///
/// For example, a spell might momentarily open a Gate between dimensions; a Duration modifier can be added to make
/// the Gate remain for a longer time. The Duration is not inherent or intrinsic in this case.
///
/// A spell that adds +2 to the subject's Strength would need a Bestows a Bonus modifier; this effect is inherent to
/// the spell.
abstract class Modifier {
  /// the name of this Modifier
  final String name;

  /// number of spell points - dependent on the value and other data
  int get spellPoints => 0;

  /// is this Modifier instance inherent to the spell?
  bool _inherent = false;

  /// the current value of this modifier - depends on the modifier, it could represent character points, a time unit,
  /// distance unit, a percentage modifier, etc.
  int _value = 0;

  Modifier(this.name);

  bool get inherent => _inherent;
  set inherent(bool i) => _inherent = i;

  int get value => _value;
  set value(int val) => _value = val;

  /// while SPs depend on value, it is not a one-for-one mapping; a single SP might cover a range of values. this
  /// returns the min and max values for a given amount of SPs
  List<int> valueRange(int sp) {
    return [0, 0];
  }
}

/// Adds the Affliction: Stun (p. B36) effect to a spell.
///
/// This effect can be added without additional SP cost.
class AfflictionStun extends Modifier {
  AfflictionStun() : super("Affliction (Stun)");

  /// value cannot be set for AfflictionStun
  @override
  set value(_) => _;
}

/// Adds an Affliction (p. B36) effect to a spell.
///
/// This adds +1 SP for every +5% it’s worth as an enhancement to Affliction.
class Affliction extends Modifier {
  Affliction() : super("Affliction");

  @override
  set value(int percent) {
    // negative percent is not allowed
    if (percent >= 0) {
      _value = percent;
    }
  }

  @override
  int get spellPoints => (_value / 5.0).ceil();

  @override
  List<int> valueRange(int sp) {
    if (sp <= 0) {
      return [0, 0];
    }
    return [((sp-1) * 5) + 1, sp * 5];
  }
}
