import 'dart:math';
import 'enhancer.dart';
import 'die_roll.dart';
import '../util/repeating_sequence.dart';
import '../util/distance.dart';
import '../util/gurps_duration.dart';

class InputException implements Exception {
  String message;
  InputException(this.message);
}

typedef bool Predicate(int item);
Predicate zeroOnly = (x) => x == 0;
Predicate anyValue = (_) => true;
Predicate nonNegative = (x) => x >= 0;
Predicate validDuration = (x) => x >= 0 && x <= GurpsDuration.SECONDS_PER_DAY;

/// Describes a modifier to an Incantation Spell.
///
/// Modifiers add Damage, Range, GurpsDuration, and other features to a spell, and the cost of the spell is adjusted by
/// the value of the modifiers. Modifiers are identified by their name, and can be inherent (intrisic) or not.
///
/// For example, a spell might momentarily open a Gate between dimensions; a GurpsDuration modifier can be added to make
/// the Gate remain for a longer time. The GurpsDuration is not inherent or intrinsic in this case.
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

  Predicate _predicate = nonNegative;

  /// the current value of this modifier - depends on the modifier, it could represent character points, a time unit,
  /// distance unit, a percentage modifier, etc.
  int _value = 0;

  Modifier(this.name);

  Modifier.withPredicate(this.name, this._predicate);

  bool get inherent => _inherent;
  set inherent(bool i) => _inherent = i;

  int get value => _value;
  set value(int val) {
    if (_predicate(val)) {
      _value = val;
    } else {
      throw new InputException("Value out of range");
    }
  }
}
// ----------------------------------

/// Define the Enhanceable mixin.
///
/// Classes that are extended with _Enhanceable maintain a list of enhancements and limitations
abstract class _Enhanceable {
  EnhancerList _enhancers = new EnhancerList();

  void addEnhancer(String name, String detail, int value) {
    _enhancers.add(new Enhancer(name, detail, value));
  }
}
// ----------------------------------

/// Adds the Affliction: Stun (p. B36) effect to a spell.
///
/// A spell effect to stun a foe requires no additional SP.
class AfflictionStun extends Modifier {
  AfflictionStun() : super.withPredicate("Affliction, Stun", zeroOnly);
}
// ----------------------------------

/// Adds an Affliction (p. B36) effect to a spell.
///
/// This adds +1 SP for every +5% it’s worth as an enhancement to Affliction.
class Affliction extends Modifier {
  Affliction() : super("Affliction");

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
  AlteredTraits() : super.withPredicate("Altered Traits", anyValue);

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
///
/// Figure the circular area and add 10 SP per yard of radius from its center. Excluding potential targets is
/// possible – add another +1 SP for every two specific subjects in the area that won’t be affected by the spell.
/// Alternatively, you may exclude everyone in the area, but then include willing potential targets for +1 SP per
/// two specific subjects
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

  Bestows() : super.withPredicate("Bestows a (Bonus or Penalty)", anyValue);

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
/// If the spell will cause damage, use the table on p. 16, based on whether the damage is direct or indirect, and
/// on what type of damage is being done.
///
/// To convert from value to DieRoll: DieRoll dieRoll = new DieRoll(1, value);
class Damage extends Modifier with _Enhanceable {
  DamageType type = DamageType.crushing;
  bool _direct = true;
  bool _explosive = false;
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

  bool get direct => _direct;

  set direct(bool newValue) {
    _direct = newValue;
    if (_direct) {
      // explosive is incompatible with direct
      _explosive = false;
    }
  }

  bool get explosive => _explosive;

  set explosive(bool newValue) {
    if (!_direct) {
      _explosive = newValue;
    }
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

/// Add a GurpsDuration to a spell.
///
/// Unless the spell is instantaneous, use the following table. GurpsDurations longer than a day are not normally
/// allowed; the GM will adjudicate a fair SP cost for any exceptions.
///
/// Value is number of seconds in GurpsDuration.
class DurationMod extends Modifier {
  static List<GurpsDuration> array = [
    const GurpsDuration(seconds: 0),
    const GurpsDuration(seconds: 10),
    const GurpsDuration(seconds: 30),
    const GurpsDuration(minutes: 1),
    const GurpsDuration(minutes: 3),
    const GurpsDuration(minutes: 6),
    const GurpsDuration(minutes: 12),
    const GurpsDuration(hours: 1),
    const GurpsDuration(hours: 3),
    const GurpsDuration(hours: 6),
    const GurpsDuration(hours: 12),
    const GurpsDuration(days: 1)
  ];

  DurationMod() : super.withPredicate("Duration", validDuration);

  @override
  int get spellPoints {
    if (_value == 0) {
      return 0;
    }
    return array.indexOf(array.lastWhere((d) => d.inSeconds < _value)) + 1;
  }
}

class Girded extends Modifier {
  Girded() : super("Girded");

  @override
  int get spellPoints => _value;
}

final RepeatingSequenceConverter longDistanceModifiers = new RepeatingSequenceConverter([1, 3]);

/// Value is in hours.
class RangeCrossTime extends Modifier {
  RangeCrossTime() : super("Range, Cross-Time");

  @override
  int get spellPoints {
    if (_value <= 2) {
      return 0;
    } else if (_value <= 12) {
      return 1;
    }

    var days = (_value / 24).ceil();
    return longDistanceModifiers.valueToOrdinal(days) + 2;
  }
}

class RangeDimensional extends Modifier {
  RangeDimensional() : super("Range, Extradimensional");

  /// Crossing dimensional barriers adds a flat 10 SP per dimension.
  @override
  int get spellPoints => _value * 10;
}

/// Range is _value in yards
class RangeInformational extends Modifier {
  RangeInformational() : super("Range, Informational");

  /// For information spells (e.g., Seek Treasure), consult Long-Distance Modifiers (p. B241) and apply the penalty
  /// (inverted) as additional SP; e.g., +2 SP for one mile.
  @override
  int get spellPoints {
    if (_value <= 200) {
      return 0;
    } else if (_value <= 880) {
      return 1;
    }

    var miles = (_value / Distance.YARDS_PER_MILE).ceil();
    return longDistanceModifiers.valueToOrdinal(miles) + 2;
  }
}

final RepeatingSequenceConverter rangeTable = new RepeatingSequenceConverter([2, 3, 5, 7, 10, 15]);

class Range extends Modifier {
  Range() : super("Range");

  int get spellPoints => rangeTable.valueToOrdinal(_value);
}

class Repair extends Modifier {
  Repair() : super("Repair");

  int get spellPoints => _value;
}

class Speed extends Modifier {
  Speed() : super("Speed");

  int get spellPoints => rangeTable.valueToOrdinal(_value);
}

class SubjectWeight extends Modifier {
  static RepeatingSequenceConverter sequence = new RepeatingSequenceConverter([10, 30]);

  SubjectWeight() : super("Subject Weight");

  int get spellPoints => sequence.valueToOrdinal(_value);
}

class Summoned extends Modifier {
  Summoned() : super("Summoned");

  //  | Power                                    | Add SP |
  //  |  25% of Static Point Total (62 points*)  |  +4 SP |
  //  |  50% of Static Point Total (125 points*) |  +8 SP |
  //  |  75% of Static Point Total (187 points*) | +12 SP |
  //  | 100% of Static Point Total (250 points*) | +20 SP |
  //  | 150% of Static Point Total (375 points*) | +40 SP |
  //  | +50% of Static Point Total (+125 points*)| +20 SP |
  int get spellPoints {
    if (_value <= 75)
    {
      return (value / 25.0).ceil() * 4;
    }
    return ((value / 50).ceil() - 1) * 20;
  }
}
