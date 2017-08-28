import '../gurps/die_roll.dart';
import '../gurps/trait_modifier.dart';
import 'ritual_modifier.dart';
import 'spell_exporter.dart';
import 'modifier_detail.dart';

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

final Map<DamageType, String> damageTypeLabels = {
  DamageType.burning: "Burning",
  DamageType.corrosive: "Corrosive",
  DamageType.crushing: "Crushing",
  DamageType.cutting: "Cutting",
  DamageType.fatigue: "Fatigue",
  DamageType.impaling: "Impaling",
  DamageType.hugePiercing: "Huge Piercing",
  DamageType.largePiercing: "Large Piercing",
  DamageType.piercing: "Piercing",
  DamageType.smallPiercing: "Small Piercing",
  DamageType.toxic: "Toxic"
};

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
class Damage extends RitualModifier with TraitModifiable {
  DamageType type = DamageType.crushing;
  bool _direct = true;
  bool _explosive = false;
  bool vampiric = false;

  Damage({DamageType type: DamageType.crushing, bool direct: true, int value: 0, bool inherent: false})
      : this.type = type,
        this._direct = direct,
        super("Damage", value, inherent);

  @override
  int get spellPoints {
    int sp = _spellPointsForDamageType;
    return (sp + _adjustmentForEnhancements(sp)) * _vampiricFactor;
  }

  int get _spellPointsForDamageType {
    int sp = 0;
    if (type == DamageType.smallPiercing) {
      sp = ((value + 1) / 2).floor();
    } else if (impalingTypes.contains(type)) {
      sp = value * 2;
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
    if (sumOfTraitModifierLevels < 0) {
      return 0;
    }

    // If Damage costs 21 SP or more, apply the enhancement percentage to the SP cost for Damage only (not to the cost
    // of the whole spell); round up
    if (sp > 20) {
      return sumOfTraitModifierLevels;
    }

    // Each +5% adds 1 SP if the base cost for Damage is 20 SP or less.
    return (sumOfTraitModifierLevels / 5).ceil();
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

  @override
  ModifierExporter export(ModifierExporter exporter) {
    DamageDetail detail = exporter.createDamageDetail() as DamageDetail;
    super.exportDetail(detail);
    detail.type = damageTypeLabels[type];
    detail.direct = _direct;
    detail.vampiric = vampiric;
    detail.explosive = _explosive;
    traitModifiers.forEach((it) => detail.addTraitModifier(it));
    detail.dieRoll = dice;
    exporter.addDetail(detail);
    return exporter;
  }
}
