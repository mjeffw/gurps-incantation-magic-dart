import '../modifier_detail.dart';
import '../../units/gurps_duration.dart';
import '../../units/gurps_distance.dart';
import '../../units/weight.dart';
import '../../gurps/modifier.dart';
import '../../util/core_utils.dart';

abstract class TextModifierDetail implements ModifierDetail {
  @override
  String get typicalText => '${name} (${spellPoints})';

  @override
  String get summaryText => name;
}

class TextAfflictionDetail extends AfflictionDetail {
  @override
  String get summaryText => '${name}, ${specialization}';

  @override
  String get typicalText => '${name}, ${specialization} (${spellPoints})';
}

class TextAlteredTraitsDetail extends AlteredTraitsDetail with TextModifierDetail {
  final List<Modifier> modifiers = [];

  @override
  void addModifier(Modifier e) {
    modifiers.add(e);
  }

  @override
  String get summaryText {
    String temp = '${name}, ${specialization}';
    if (modifiers.isNotEmpty) {
      temp += ' (${modifiers.map((e) => e.summaryText).join('; ')})';
    }
    return temp;
  }

  @override
  String get typicalText {
    String temp = '${name}, ${specialization}';
    if (specLevel != null && specLevel != 0) {
      temp += ' ${specLevel}';
    }
    if (modifiers.isNotEmpty) {
      temp += ' (${modifiers.map((e) => e.typicalText).join('; ')})';
    }
    return temp + ' (${spellPoints})';
  }
}

class TextAreaOfEffectDetail extends AreaOfEffectDetail with TextModifierDetail {
  @override
  String get typicalText {
    List<String> components = [];
    components.add(name);
    components.add('${value} yards');
    if (targets > 0) {
      components.add('${includes ? 'including' : 'excluding'} ${targets} targets');
    }
    return '${components.join(', ')} (${spellPoints})';
  }
}

class TextBestowsDetail extends BestowsDetail {
  @override
  String get summaryText => 'Bestows a ${value < 0? 'Penalty': 'Bonus'}, ${specialization}';

  @override
  String get typicalText => 'Bestows a ${value < 0 ? 'Penalty' : 'Bonus'}, '
      '${toSignedString(value)} to ${specialization} (${spellPoints})';
}

class TextDamageDetail extends DamageDetail {
  final List<Modifier> modifiers = [];

  @override
  String get summaryText {
    String temp = '${name}, ${direct ? 'Direct' : 'Indirect'} ${type}';
    if (modifiers.isNotEmpty) {
      temp += ' (${modifiers.map((e) => e.name).join('; ')})';
    }
    return temp;
  }

  @override
  String get typicalText {
    String temp = '${name}, ${direct ? 'Direct' : 'Indirect'} ${type} ${dieRoll}';
    if (modifiers.isNotEmpty) {
      temp += ' (${modifiers.map((e) => "${e.typicalText}").join('; ')})';
    }
    return '${temp} (${spellPoints})';
  }

  @override
  void addModifier(Modifier e) {
    modifiers.add(e);
  }
}

class TextDurationDetail extends DurationDetail with TextModifierDetail {
  @override
  String get typicalText => '${name}, ${new GurpsDuration(seconds: value).toFormattedString()} (${spellPoints})';
}

class TextGirdedDetail extends GirdedDetail with TextModifierDetail {}

class TextRangeDetail extends RangeDetail with TextModifierDetail {
  @override
  String get typicalText => '${name}, ${new GurpsDistance(yards: value).toFormattedString()} (${spellPoints})';
}

class TextRangeDimensionalDetail extends RangeDimensionalDetail with TextModifierDetail {
  @override
  String get typicalText => '${name}${value == 1 ? "" : ", " + value.toString() + " dimensions"} (${spellPoints})';
}

class TextRepairDetail extends RepairDetail with TextModifierDetail {
  @override
  String get typicalText =>
      '${name}${specialization == null ? ' ' : ' ${specialization}'}, ${dieRoll} (${spellPoints})';
}

class TextSpeedDetail extends SpeedDetail with TextModifierDetail {
  @override
  String get typicalText => '${name}, ${new GurpsDistance(yards: value).toFormattedString()}/second (${spellPoints})';
}

class TextSubjectWeightDetail extends SubjectWeightDetail with TextModifierDetail {
  @override
  String get typicalText => '${name}, ${Weight.toFormattedString(value)} (${spellPoints})';
}

class TextSummonedDetail extends SummonedDetail with TextModifierDetail {
  @override
  String get typicalText => '${name}, ${value}% of Static Point Total (${spellPoints})';
}
