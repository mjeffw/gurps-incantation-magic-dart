import 'dart:math';
import 'enhancer.dart';

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
}
// ----------------------------------

/// Adds the Affliction: Stun (p. B36) effect to a spell.
///
/// This effect can be added without additional SP cost.
class AfflictionStun extends Modifier {
  AfflictionStun() : super("Affliction (Stun)");

  /// value cannot be set for AfflictionStun
  @override
  set value(_) => _;
}
// ----------------------------------

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
    } else {
      _value = 0;
    }
  }

  @override
  int get spellPoints => (_value / 5.0).ceil();

  @override
  List<int> valueRange(int sp) {
    if (sp <= 0) {
      return [0, 0];
    }
    return [((sp - 1) * 5) + 1, sp * 5];
  }
}
// ----------------------------------

/// Adds an Altered Trait to a spell.
///
/// Any spell that adds disadvantages, reduces attributes, or reduces or removes advantages adds +1 SP for
/// every five character points removed. One that adds advantages, reduces or removes disadvantages, or increases
/// attributes adds +1 SP for every character point added.
class AlteredTraits extends Modifier {
  /// list of enhancers/limitations to apply to the cost of this modifier.
  /// Enahncers apply to the cost of the AlteredTrait and are calculated before determining spell points.
  EnhancerList _enhancers = new EnhancerList();

  void addEnhancer(String name, String detail, int value) {
    _enhancers.add(new Enhancer(name, detail, value));
  }

  AlteredTraits() : super("Altered Traits");

  @override
  int get spellPoints {
    int result = _baseSpellPoints();
    return result + _enhancers.adjustment(result);
  }

  int _baseSpellPoints() {
    int result;
    if (_value < 0) {
      result = (_value.abs() / 5.0).ceil();
    } else {
      result = _value;
    }
    return result;
  }
}
// ----------------------------------

/// Adds an Area of Effect, optionally including or excluding specific targets in the area, to the spell.
class AreaOfEffect extends Modifier {
  int _targets = 0;
  bool _includes = false; // ignore: unused_field

  AreaOfEffect() : super("Area of Effect");

  /// Figure the circular area and add 10 SP per yard of radius from its center.
  /// Add another +1 SP for every two specific subjects in the area that won’t be affected by the spell, or
  /// +1 per two subjects included in the spell, if excluding everyone except specific targets.
  @override
  int get spellPoints {
    return _value * 10 + (_targets / 2).ceil();
  }

  /// Excluding potential targets is possible -- alternately, you can exclude everyone except specific targets.
  ///
  /// Number is the number of targets to exclude (or include); set includes = true to indicate includes, false
  /// for excludes.
  void targets(int number, bool includes) {
    _targets = number;
    _includes = includes;
  }
}
// ----------------------------------

/// Range of rolls affected by a Bestows modifier.
enum BestowsRange { single, moderate, broad }

// ----------------------------------

/// Adds a bonus or penalty to skills or attributes.
class Bestows extends Modifier {
  BestowsRange range = BestowsRange.single;

  String specialization;

  Bestows() : super("Bestows a (Bonus or Penalty)");

  @override
  int get spellPoints {
    if (_value == 0) {
      return 0;
    }

    var x = _value.abs();
    switch (range) {
      case BestowsRange.single:
        return _baseSpellPoints(x);

      case BestowsRange.moderate:
        return _baseSpellPoints(x) * 2;

      case BestowsRange.broad:
        return _baseSpellPoints(x) * 5;
    }
  }

  int _baseSpellPoints(int x) {
    if (x < 5) {
      return pow(2, x - 1).toInt();
    }
    return 12 + ((x - 5) * 4);
  }
}
// ----------------------------------

/// Damage types
enum DamageType { crushing, cutting }

/// For spells that damage its targets.
class Damage extends Modifier {
  DamageType type = DamageType.crushing;
  bool direct = true;
  bool explosive = false;
  bool vampiric = false;

  Damage() : super("Damage");
}
