import 'dart:math';
import 'enhancer.dart';
import 'package:gurps_incantation_magic_model/src/die_roll.dart';

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

/// Define the Enhanceable mixin
abstract class _Enhanceable {
  EnhancerList _enhancers = new EnhancerList();

  void addEnhancer(String name, String detail, int value) {
    _enhancers.add(new Enhancer(name, detail, value));
  }
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
class AlteredTraits extends Modifier with _Enhanceable {
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
enum DamageType {
  burning,
  corrosive,
  crushing,
  cutting,
  fatigue,
  impaling,
  hugePiercing,
  largePiercing,
  piercing,
  smallPiercing,
  toxic
}

final List<DamageType> impalingTypes = [
  DamageType.corrosive,
  DamageType.fatigue,
  DamageType.impaling,
  DamageType.hugePiercing
];
final List<DamageType> crushingTypes = [DamageType.burning, DamageType.crushing, DamageType.piercing, DamageType.toxic];
final List<DamageType> cuttingTypes = [DamageType.cutting, DamageType.largePiercing];

/// For spells that damage its targets.
///
/// To convert from value to DieRoll: DieRoll dieRoll = new DieRoll(1, value);
class Damage extends Modifier with _Enhanceable {
  DamageType type = DamageType.crushing;
  bool direct = true;
  bool explosive = false;
  bool vampiric = false;

  Damage() : super("Damage");

  @override
  int get spellPoints {
    int sp = _spellPointsForDamageType;
    return (sp + _adjustmentForEnhancements(sp)) * _vampiricFactor;
  }

  int get _spellPointsForDamageType {
    int sp = 0;
    if (type == DamageType.smallPiercing) {
      sp = ((_value + 1) / 2).floor();
    } else if (impalingTypes.contains(type)) {
      sp = _value * 2;
    } else if (crushingTypes.contains(type)) {
      sp = value;
    } else if (cuttingTypes.contains(type)) {
      sp = (value + (value + 1) / 2).floor();
    }
    return sp;
  }

  // Enhancements may be added to Damage.
  int _adjustmentForEnhancements(int sp) {
    // Added limitations reduce this surcharge, but will never provide a net SP discount.
    int sum = _enhancers.sum;
    if (sum < 0) {
      return 0;
    }

    // If Damage costs 21 SP or more, apply the enhancement percentage to the SP cost for Damage only (not to the cost
    // of the whole spell); round up
    if (sp > 20) {
      return sum;
    }

    // Each +5% adds 1 SP if the base cost for Damage is 20 SP or less.
    return (sum / 5).ceil();
  }

  int get _vampiricFactor {
    if (vampiric) {
      return 2;
    }
    return 1;
  }

  DieRoll get dice {
    DieRoll d = new DieRoll(1, value);
    return d * _explosiveFactor();
  }

  int _explosiveFactor() {
    if (explosive) {
      return 2;
    } else if (direct) {
      return 1;
    } else {
      return 3;
    }
  }
}

/// Add a Duration to a spell.
///
/// Value is number of seconds in duration.
class DurationMod extends Modifier {
  static List<Duration> array = [
    new Duration(seconds: 0),
    new Duration(seconds: 10),
    new Duration(seconds: 30),
    new Duration(minutes: 1),
    new Duration(minutes: 3),
    new Duration(minutes: 6),
    new Duration(minutes: 12),
    new Duration(hours: 1),
    new Duration(hours: 3),
    new Duration(hours: 6),
    new Duration(hours: 12),
    new Duration(days: 1)
  ];

  DurationMod() : super("Duration");

  @override
  int get spellPoints {
    if (_value == 0) {
      return 0;
    }
    return array.indexOf(array.lastWhere((d) => d.inSeconds < _value)) + 1;
  }
}
