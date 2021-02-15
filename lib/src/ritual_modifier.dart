import 'dart:math';

import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_incantation_magic_model/incantation_magic.dart';
import 'spell_exporter.dart';
import 'modifier_detail.dart';
import 'damage_modifier.dart';

class InputException implements Exception {
  InputException(this.message);

  final String message;
}

/// defines predicate methdos used to validate the range of values a RitualModifier can have
typedef bool Predicate(int item);

Predicate zeroOnly = (x) => x == 0;
Predicate anyValue = (x) => true;
Predicate nonNegative = (x) => x >= 0;
Predicate validDuration = (x) => x >= 0 && x <= GDuration.secondsPerDay;

abstract class HasSpecialization {
  String get specialization;
  set specialization(String x);

  HasSpecialization asHasSpecialization() => this;
}

abstract class HasTrait {
  Trait get trait;
  set trait(Trait x);

  HasTrait asHasTrait() => this;
}

abstract class HasBestowsRange {
  BestowsRange get range;
  set range(BestowsRange x);

  HasBestowsRange asHasBestowsRange() => this;
}

/// Describes a modifier to an Incantation Spell.
///
/// Modifiers add Damage, Range, GDuration, and other features to a spell, and the cost of the spell is adjusted by
/// the value of the modifiers. Modifiers are identified by their name, and can be inherent (intrisic) or not.
///
/// For example, a spell might momentarily open a Gate between dimensions; a GDuration modifier can be added to make
/// the Gate remain for a longer time. The GDuration is not inherent or intrinsic in this case.
///
/// A spell that adds +2 to the subject's Strength would need a Bestows a Bonus modifier; this effect is inherent to
/// the spell.
abstract class RitualModifier {
  RitualModifier(this.name, this._value, this.inherent);

  RitualModifier.withPredicateNew(
      this.name, this._predicate, this._value, this.inherent);

  RitualModifier.withPredicate(this.name, this._predicate,
      {int value: 0, bool inherent: false})
      : _value = value,
        inherent = inherent;

  /// the name of this Modifier
  final String name;

  /// number of spell points - dependent on the value and other data
  int get spellPoints => 0;

  /// is this Modifier instance inherent to the spell?
  bool inherent = false;

  // the current value of this modifier - depends on the modifier, it could represent character points, a time unit,
  // distance unit, a percentage modifier, etc.
  int _value = 0;
  int get value => _value;
  set value(int val) {
    if (_predicate(val)) {
      _value = val;
    } else {
      throw InputException("Value out of range");
    }
  }

  Predicate _predicate = nonNegative;
  bool get canDecrementValue => _predicate(_value - 1);
  bool get canIncrementValue => _predicate(_value + 1);
  void incrementValue() => value = value + 1;
  void decrementValue() => value = value - 1;

  ModifierExporter export(ModifierExporter exporter);
  ModifierDetail exportDetail(ModifierDetail exporter) {
    exporter.name = name;
    exporter.spellPoints = spellPoints;
    exporter.inherent = inherent;
    exporter.value = value;
    return exporter;
  }

  HasSpecialization asHasSpecialization() => null;
  TraitModifiable asTraitModifiable() => null;
  HasTrait asHasTrait() => null;
  AreaOfEffect asAreaOfEffect() => null;
  HasBestowsRange asHasBestowsRange() => null;
  Damage asDamage() => null;
}
// ----------------------------------

// ----------------------------------

/// Adds the Affliction: Stun (p. B36) effect to a spell.
///
/// A spell effect to stun a foe requires no additional SP.
class AfflictionStun extends RitualModifier {
  AfflictionStun({bool inherent: false})
      : super.withPredicate("Affliction, Stunning", zeroOnly,
            inherent: inherent);

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detail = exporter.createAfflictionStunDetail();
    super.exportDetail(detail);
    exporter.addDetail(detail);
    return exporter;
  }
}
// ----------------------------------

/// Adds an Affliction (p. B36) effect to a spell.
///
/// This adds +1 SP for every +5% it’s worth as an enhancement to Affliction.
class Affliction extends RitualModifier with HasSpecialization {
  Affliction(this.specialization, {int value: 0, bool inherent: false})
      : super("Afflictions", value, inherent);

  @override
  String specialization;

  @override
  int get spellPoints => (_value / 5.0).ceil();

  @override
  ModifierExporter export(ModifierExporter exporter) {
    AfflictionDetail detail =
        exporter.createAfflictionDetail() as AfflictionDetail;
    super.exportDetail(detail);
    detail.specialization = specialization;
    exporter.addDetail(detail);
    return exporter;
  }

  @override
  void incrementValue() {
    this.value = (spellPoints + 1) * 5;
  }

  @override
  void decrementValue() {
    if (spellPoints == 0) return;
    this.value = (spellPoints - 1) * 5;
  }
}
// ----------------------------------

class Trait {
  Trait(
      {String name: '',
      int baseCost: 0,
      int costPerLevel: 0,
      int levels: 0,
      bool hasLevels: false})
      : this.name = name,
        this.baseCost = baseCost,
        this.costPerLevel = costPerLevel,
        this.levels = levels,
        this._hasLevels = hasLevels;

  String name = '';
  int baseCost = 0;
  int costPerLevel = 0;
  int levels = 0;

  bool _hasLevels = false;
  bool get hasLevels => _hasLevels;
  set hasLevels(bool b) {
    _hasLevels = b;
    if (!_hasLevels) {
      costPerLevel = 0;
      levels = 0;
    }
  }

  int get totalCost => baseCost + (costPerLevel * levels);
}

/// Adds an Altered Trait to a spell.
///
/// Any spell that adds disadvantages, reduces attributes, or reduces or removes advantages adds +1 SP for
/// every five character points removed. One that adds advantages, reduces or removes disadvantages, or increases
/// attributes adds +1 SP for every character point added.
class AlteredTraits extends RitualModifier with TraitModifiable, HasTrait {
  AlteredTraits(this.trait, {bool inherent: false})
      : super.withPredicateNew("Altered Traits", anyValue, 0, inherent);

  @override
  Trait trait;
//  String specialization;
//  int specLevel;
  @override
  int get value => trait.totalCost;

  @override
  set value(int val) {
    trait.baseCost = val;
    trait.hasLevels = false;
  }

  @override
  bool get canIncrementValue => false;

  @override
  bool get canDecrementValue => false;

  @override
  int get spellPoints =>
      _baseSpellPoints + adjustmentForTraitModifiers(_baseSpellPoints);
  int get _baseSpellPoints =>
      (value.isNegative) ? (value.abs() / 5.0).ceil() : value;

  @override
  ModifierExporter export(ModifierExporter exporter) {
    AlteredTraitsDetail detail =
        exporter.createAlteredTraitsDetail() as AlteredTraitsDetail;
    super.exportDetail(detail);

    detail.traitName = trait.name;
    detail.baseCost = trait.baseCost;
    detail.hasLevels = trait.hasLevels;
    detail.costPerLevel = trait.costPerLevel;
    detail.levels = trait.levels;

    traitModifiers.forEach((it) => detail.addModifier(it));
    exporter.addDetail(detail);
    return exporter;
  }
}
// ----------------------------------

/// Adds an Area of Effect, optionally including or excluding specific targets in the area, to the spell.
///
/// Figure the circular area and add 10 SP per yard of radius from its center. Excluding potential targets is
/// possible – add another +1 SP for every two specific subjects in the area that won’t be affected by the spell.
/// Alternatively, you may exclude everyone in the area, but then include willing potential targets for +1 SP per
/// two specific subjects
class AreaOfEffect extends RitualModifier {
  AreaOfEffect({int value: 0, bool inherent: false})
      : super("Area of Effect", value, inherent);

  int _targets = 0;
  int get targets => _targets;
  set targets(int targets) => _targets = max(targets, 0);

  bool includes = false;

  /// Figure the circular area and add 10 SP per yard of radius from its center.
  /// Add another +1 SP for every two specific subjects in the area that won’t be affected by the spell, or
  /// +1 per two subjects included in the spell, if excluding everyone except specific targets.
  @override
  int get spellPoints => _value * 10 + (targets / 2).ceil();

  /// Excluding potential targets is possible -- alternately, you can exclude everyone except specific targets.
  ///
  /// Number is the number of targets to exclude (or include); set includes = true to indicate includes, false
  /// for excludes.
  void setTargetInfo(int number, bool includes) {
    targets = number;
    this.includes = includes;
  }

  @override
  ModifierExporter export(ModifierExporter exporter) {
    AreaOfEffectDetail detail =
        exporter.createAreaEffectDetail() as AreaOfEffectDetail;
    super.exportDetail(detail);
    detail.targets = targets;
    detail.includes = includes;
    exporter.addDetail(detail);
    return exporter;
  }

  @override
  AreaOfEffect asAreaOfEffect() => this;
}
// ----------------------------------

/// Range of rolls affected by a Bestows modifier.
enum BestowsRange { single, moderate, broad }

// ----------------------------------

/// Adds a bonus or penalty to skills or attributes.
class Bestows extends RitualModifier with HasSpecialization, HasBestowsRange {
  Bestows(this.specialization,
      {BestowsRange range: BestowsRange.single,
      int value: 0,
      bool inherent: false})
      : this.range = range,
        super.withPredicateNew(
            "Bestows a (Bonus or Penalty)", anyValue, value, inherent);

  @override
  BestowsRange range = BestowsRange.single;

  @override
  String specialization;

  @override
  int get spellPoints => (_value == 0) ? 0 : _spellPointsForRange;

  int get _spellPointsForRange {
    int x;
    switch (range) {
      case BestowsRange.single:
        x = _baseSpellPoints(_value.abs());
        break;
      case BestowsRange.moderate:
        x = _baseSpellPoints(_value.abs()) * 2;
        break;
      case BestowsRange.broad:
        x = _baseSpellPoints(_value.abs()) * 5;
    }
    return x;
  }

  int _baseSpellPoints(int x) =>
      (x < 5) ? pow(2, x - 1).toInt() : 12 + ((x - 5) * 4);

  @override
  ModifierExporter export(ModifierExporter exporter) {
    BestowsDetail detail = exporter.createBestowsDetail() as BestowsDetail;
    super.exportDetail(detail);
    detail.specialization = specialization;
    detail.range = range.toString();
    exporter.addDetail(detail);
    return exporter;
  }
}
// ----------------------------------

/// Add a GDuration to a spell.
///
/// Unless the spell is instantaneous, use the following table. GDurations longer than a day are not normally
/// allowed; the GM will adjudicate a fair SP cost for any exceptions.
///
/// Value is number of seconds in GDuration.
class DurationMod extends RitualModifier {
  DurationMod({int value: 0, bool inherent: false})
      : super.withPredicate("Duration", validDuration,
            value: value, inherent: inherent);

  static List<GDuration> array = [
    const GDuration(seconds: 0),
    const GDuration(seconds: 10),
    const GDuration(seconds: 30),
    const GDuration(minutes: 1),
    const GDuration(minutes: 3),
    const GDuration(minutes: 6),
    const GDuration(minutes: 12),
    const GDuration(hours: 1),
    const GDuration(hours: 3),
    const GDuration(hours: 6),
    const GDuration(hours: 12),
    const GDuration(days: 1)
  ];

  @override
  int get spellPoints => (_value == 0)
      ? 0
      : array.indexOf(array.lastWhere((d) => d.inSeconds < _value)) + 1;

  @override
  void incrementValue() {
    if (spellPoints < array.length - 1) {
      this._value = array[spellPoints + 1].inSeconds;
    }
  }

  @override
  void decrementValue() {
    if (spellPoints > 0) {
      this._value = array[spellPoints - 1].inSeconds;
    }
  }

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detailExporter = exporter.createDurationDetail();
    super.exportDetail(detailExporter);
    exporter.addDetail(detailExporter);
    return exporter;
  }
}

class Girded extends RitualModifier {
  Girded({int value: 0, bool inherent: false})
      : super("Girded", value, inherent);

  @override
  int get spellPoints => _value;

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detail = exporter.createGirdedDetail();
    super.exportDetail(detail);
    exporter.addDetail(detail);
    return exporter;
  }
}

final RepeatingSequenceConverter longDistanceModifiers =
    RepeatingSequenceConverter([1, 3]);

/// Value is in hours.
class RangeCrossTime extends RitualModifier {
  RangeCrossTime({int value: 0, bool inherent: false})
      : super("Range (Cross-Time)", value, inherent);

  @override
  int get spellPoints {
    if (_value <= 2) {
      return 0;
    } else if (_value <= 12) {
      return 1;
    }

    var days = (_value / 24).ceil();
    return longDistanceModifiers.valueToIndex(days) + 2;
  }

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detail = exporter.createRangeTimeDetail();
    super.exportDetail(detail);
    exporter.addDetail(detail);
    return exporter;
  }

  @override
  void incrementValue() {
    if (spellPoints == 0) {
      _value = 12;
    } else if (spellPoints == 1) {
      _value = 24;
    } else {
      int currentIndex =
          longDistanceModifiers.valueToIndex((_value / 24).ceil());
      int newValue = longDistanceModifiers.indexToValue(currentIndex + 1) * 24;
      if (_predicate(newValue)) {
        _value = newValue;
      }
    }
  }

  @override
  void decrementValue() {
    if (spellPoints == 0) {
      return;
    } else if (spellPoints == 1) {
      _value = 2;
    } else if (spellPoints == 2) {
      _value = 12;
    } else {
      int currentIndex =
          longDistanceModifiers.valueToIndex((_value / 24).ceil());
      int newValue = longDistanceModifiers.indexToValue(currentIndex - 1) * 24;

      if (_predicate(newValue)) {
        _value = newValue;
      }
    }
  }
}

class RangeDimensional extends RitualModifier {
  RangeDimensional({int value: 0, bool inherent: false})
      : super("Range, Extradimensional", value, inherent);

  /// Crossing dimensional barriers adds a flat 10 SP per dimension.
  @override
  int get spellPoints => _value * 10;

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detail = exporter.createRangeDimensionalDetail();
    super.exportDetail(detail);
    exporter.addDetail(detail);
    return exporter;
  }
}

/// Range is _value in yards
class RangeInformational extends RitualModifier {
  RangeInformational({int value: 0, bool inherent: false})
      : super("Range, Informational", value, inherent);

  /// For information spells (e.g., Seek Treasure), consult Long-Distance Modifiers (p. B241) and apply the penalty
  /// (inverted) as additional SP; e.g., +2 SP for one mile.
  @override
  int get spellPoints {
    if (_value <= 200) {
      return 0;
    } else if (_value <= 880) {
      return 1;
    }

    var miles = (_value / GDistance.yardsPerMile).ceil();
    return longDistanceModifiers.valueToIndex(miles) + 2;
  }

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detail = exporter.createRangeInformationalDetail();
    super.exportDetail(detail);
    exporter.addDetail(detail);
    return exporter;
  }

  @override
  void incrementValue() {
    if (spellPoints == 0) {
      _value = 880;
    } else if (spellPoints == 1) {
      _value = GDistance.yardsPerMile;
    } else {
      int currentIndex = longDistanceModifiers
          .valueToIndex((_value / GDistance.yardsPerMile).ceil());
      int newValue = longDistanceModifiers.indexToValue(currentIndex + 1) *
          GDistance.yardsPerMile;
      if (_predicate(newValue)) {
        _value = newValue;
      }
    }
  }

  @override
  void decrementValue() {
    if (spellPoints == 0) {
      return;
    } else if (spellPoints == 1) {
      _value = 200;
    } else if (spellPoints == 2) {
      _value = 880;
    } else {
      int currentIndex = longDistanceModifiers
          .valueToIndex((_value / GDistance.yardsPerMile).ceil());
      int newValue = longDistanceModifiers.indexToValue(currentIndex - 1) *
          GDistance.yardsPerMile;

      if (_predicate(newValue)) {
        _value = newValue;
      }
    }
  }
}

final RepeatingSequenceConverter rangeTable =
    RepeatingSequenceConverter([2, 3, 5, 7, 10, 15]);

class Range extends RitualModifier {
  Range({int value: 0, bool inherent: false}) : super("Range", value, inherent);

  @override
  int get spellPoints => rangeTable.valueToIndex(_value);

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detail = exporter.createRangeDetail();
    super.exportDetail(detail);
    exporter.addDetail(detail);
    return exporter;
  }

  @override
  void incrementValue() {
    int currentIndex = rangeTable.valueToIndex(_value);
    int newValue = rangeTable.indexToValue(currentIndex + 1);

    if (_predicate(newValue)) {
      _value = newValue;
    }
  }

  @override
  void decrementValue() {
    if (spellPoints == 0) {
      return;
    }
    int currentIndex = rangeTable.valueToIndex(_value);
    int newValue = rangeTable.indexToValue(currentIndex - 1);

    if (_predicate(newValue)) {
      _value = newValue;
    }
  }
}

class Repair extends RitualModifier with HasSpecialization {
  Repair(this.specialization, {int value: 0, bool inherent: false})
      : super("Repair", value, inherent);

  @override
  String specialization;

  @override
  int get spellPoints => _value;

  DieRoll get dice => DieRoll(dice: 1, adds: value);

  @override
  ModifierExporter export(ModifierExporter exporter) {
    RepairDetail detail = exporter.createRepairDetail() as RepairDetail;
    super.exportDetail(detail);
    detail.specialization = specialization;
    detail.dieRoll = dice;
    exporter.addDetail(detail);
    return exporter;
  }
}

class Speed extends RitualModifier {
  Speed({int value: 0, bool inherent: false}) : super("Speed", value, inherent);

  @override
  int get spellPoints => rangeTable.valueToIndex(_value);

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detail = exporter.createSpeedDetail();
    super.exportDetail(detail);
    exporter.addDetail(detail);
    return exporter;
  }

  @override
  void incrementValue() {
    int currentIndex = rangeTable.valueToIndex(_value);
    int newValue = rangeTable.indexToValue(currentIndex + 1);

    if (_predicate(newValue)) {
      _value = newValue;
    }
  }

  @override
  void decrementValue() {
    if (spellPoints == 0) {
      return;
    }
    int currentIndex = rangeTable.valueToIndex(_value);
    int newValue = rangeTable.indexToValue(currentIndex - 1);

    if (_predicate(newValue)) {
      _value = newValue;
    }
  }
}

class SubjectWeight extends RitualModifier {
  SubjectWeight({int value: 0, bool inherent: false})
      : super("Subject Weight", value, inherent);

  static RepeatingSequenceConverter sequence =
      RepeatingSequenceConverter([10, 30]);

  @override
  int get spellPoints => sequence.valueToIndex(_value);

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detailExporter = exporter.createSubjectWeightDetail();
    super.exportDetail(detailExporter);
    exporter.addDetail(detailExporter);
    return exporter;
  }

  @override
  void incrementValue() {
    int currentIndex = sequence.valueToIndex(_value);
    int newValue = sequence.indexToValue(currentIndex + 1);

    if (_predicate(newValue)) {
      _value = newValue;
    }
  }

  @override
  void decrementValue() {
    if (spellPoints == 0) {
      return;
    }
    int currentIndex = sequence.valueToIndex(_value);
    int newValue = sequence.indexToValue(currentIndex - 1);

    if (_predicate(newValue)) {
      _value = newValue;
    }
  }
}

class Summoned extends RitualModifier {
  Summoned({int value: 0, bool inherent: false})
      : super("Summoned", value, inherent);

  //  | Power                                    | Add SP |
  //  |  25% of Static Point Total (62 points*)  |  +4 SP |
  //  |  50% of Static Point Total (125 points*) |  +8 SP |
  //  |  75% of Static Point Total (187 points*) | +12 SP |
  //  | 100% of Static Point Total (250 points*) | +20 SP |
  //  | 150% of Static Point Total (375 points*) | +40 SP |
  //  | +50% of Static Point Total (+125 points*)| +20 SP |
  @override
  int get spellPoints =>
      (_value <= 75) ? (value / 25).ceil() * 4 : ((value / 50).ceil() - 1) * 20;

  @override
  ModifierExporter export(ModifierExporter exporter) {
    ModifierDetail detail = exporter.createSummonedDetail();
    super.exportDetail(detail);
    exporter.addDetail(detail);
    return exporter;
  }

  int _valueForSpellPoints(int sp) {
    if (sp <= 12) {
      int sp1 = (sp / 4).ceil().toInt();
      return sp1 * 25;
    } else {
      int sp1 = (sp / 20).ceil().toInt();
      return 50 + sp1 * 50;
    }
  }

  @override
  void incrementValue() {
    int value = (spellPoints <= 12)
        ? _valueForSpellPoints(spellPoints) + 25
        : _valueForSpellPoints(spellPoints) + 50;
    if (_predicate(value)) {
      _value = value;
    }
  }

  @override
  void decrementValue() {
    int value = (spellPoints <= 20)
        ? _valueForSpellPoints(spellPoints) - 25
        : _valueForSpellPoints(spellPoints) - 50;
    if (_predicate(value)) {
      _value = value;
    }
  }
}
