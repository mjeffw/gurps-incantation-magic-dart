import '../modifier_detail.dart';
import '../../units/gurps_duration.dart';
import '../../units/gurps_distance.dart';
import '../../units/weight.dart';
import '../../gurps/modifier.dart';
import '../../util/core_utils.dart';
import 'package:gurps_incantation_magic_model/gurps/die_roll.dart';

class TextModifierDetail extends ModifierDetail {
  String name;
  bool inherent;
  int value;
  int spellPoints;

  @override
  String get typicalText => '${name} (${spellPoints})';

  @override
  String get summaryText => name;
}

class TextAfflictionDetail extends TextModifierDetail implements AfflictionDetail {
  String specialization;

  @override
  String get summaryText => '${name}, ${specialization}';

  @override
  String get typicalText => '${name}, ${specialization} (${spellPoints})';
}

class TextAlteredTraitsDetail extends TextModifierDetail implements AlteredTraitsDetail {
  final List<Modifier> modifiers = [];

  @override
  int specLevel;

  @override
  String specialization;

  @override
  void addModifier(Modifier e) => modifiers.add(e);

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

class TextAreaOfEffectDetail extends TextModifierDetail implements AreaOfEffectDetail {
  @override
  bool includes;

  @override
  int targets;

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

class TextBestowsDetail extends TextModifierDetail implements BestowsDetail {
  String specialization;
  String range;

  @override
  String get summaryText => 'Bestows a ${value < 0? 'Penalty': 'Bonus'}, ${specialization}';

  @override
  String get typicalText => 'Bestows a ${value < 0 ? 'Penalty' : 'Bonus'}, '
      '${toSignedString(value)} to ${specialization} (${spellPoints})';
}

class TextDamageDetail extends TextModifierDetail implements DamageDetail {
  DieRoll dieRoll;
  String type;
  bool direct;

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

class TextDurationDetail extends TextModifierDetail {
  @override
  String get typicalText => '${name}, ${GurpsDuration.toFormattedString(value)} (${spellPoints})';
}

class TextRangeDetail extends TextModifierDetail {
  @override
  String get typicalText => '${name}, ${GurpsDistance.toFormattedString(value)} (${spellPoints})';
}

class TextRangeDimensionalDetail extends TextModifierDetail {
  @override
  String get typicalText => '${name}${value == 1 ? "" : ", " + value.toString() + " dimensions"} (${spellPoints})';
}

class TextRangeInformationalDetail extends TextModifierDetail {
  @override
  String get typicalText => 'Range, ${GurpsDistance.toFormattedString(value)} (${spellPoints})';
}

class TextRangeTimeDetail extends TextModifierDetail {
  @override
  String get typicalText => '${name}, ${_valueText} (${spellPoints})';

  String get _valueText {
    if (value == 0) {
      return GurpsDuration.toFormattedString(new GurpsDuration(hours: 2).inSeconds);
    } else {
      return GurpsDuration.toFormattedString(new GurpsDuration(hours: value).inSeconds);
    }
  }
}

class TextRepairDetail extends TextModifierDetail implements RepairDetail {
  @override
  DieRoll dieRoll;

  @override
  String specialization;

  @override
  String get typicalText =>
      '${name}${specialization == null ? ' ' : ' ${specialization}'}, ${dieRoll} (${spellPoints})';
}

class TextSpeedDetail extends TextModifierDetail {
  @override
  String get typicalText => '${name}, ${GurpsDistance.toFormattedString(value)}/second (${spellPoints})';
}

class TextSubjectWeightDetail extends TextModifierDetail {
  @override
  String get typicalText => '${name}, ${Weight.toFormattedString(value)} (${spellPoints})';
}

class TextSummonedDetail extends TextModifierDetail {
  @override
  String get typicalText => '${name}, ${value}% of Static Point Total (${spellPoints})';
}
