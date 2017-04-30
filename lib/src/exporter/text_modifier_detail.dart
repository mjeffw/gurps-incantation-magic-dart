import '../modifier_detail.dart';
import '../../units/gurps_duration.dart';
import '../../gurps/modifier.dart';
import '../../gurps/die_roll.dart';

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

class TextAreaOfEffectDetail extends AreaOfEffectDetail with TextModifierDetail {
  @override
  String get typicalText {
    List<String> components = [];
    components.add(name);
    components.add('${value} yards');
    components.add(_targetText);
    return '${components.join(', ')} (${spellPoints})';
  }

  String get _targetText {
    if (targets == 0) {
      return '';
    } else {
      return '${_includesText} ${targets} targets';
    }
  }

  String get _includesText {
    if (includes) {
      return 'including';
    } else {
      return 'excluding';
    }
  }
}

class TextBestowsDetail extends BestowsDetail {
  @override
  String get summaryText => 'Bestows a ${_nameCompletionText}, ${specialization}';

  String get _nameCompletionText {
    String temp = 'Bonus';
    if (value < 0) {
      temp = 'Penalty';
    }
    return temp;
  }

  @override
  String get typicalText => 'Bestows a ${_nameCompletionText}, ${value} to ${specialization} (${spellPoints})';
}

class TextDamageDetail extends DamageDetail {
  bool direct;
  String type;
  final List<Modifier> enhancers = [];
  DieRoll dieRoll;

  @override
  String get summaryText {
    String temp = '${name}, ${_directText} ${type}';
    if (enhancers.isNotEmpty) {
      temp += ' (${enhancers.map((e) => e.name).join(', ')})';
    }
    return temp;
  }

  String get _directText {
    if (direct) {
      return 'Direct';
    } else {
      return "Indirect";
    }
  }

  @override
  String get typicalText {
    String temp = '${name}, ${_directText} ${type} ${dieRoll}';
    if (enhancers.isNotEmpty) {
      temp += ' (${enhancers.map((e) => "${e.name}, ${toSignedString(e.level)}%").join(', ')})';
    }
    return '${temp} (${spellPoints})';
  }

  @override
  void addEnhancer(Modifier e) {
    enhancers.add(e);
  }
}

class TextDurationDetail extends DurationDetail with TextModifierDetail {
  @override
  String get typicalText => '${name}, ${new GurpsDuration(seconds: value).toFormattedString()} (${spellPoints})';
}

class TextRangeDetail extends RangeDetail with TextModifierDetail {
  @override
  String get typicalText => '${name}, ${value} yards (${spellPoints})';
}

class TextSubjectWeightDetail extends SubjectWeightDetail with TextModifierDetail {
  @override
  String get typicalText => '${name}, ${value} pounds (${spellPoints})';
}

String toSignedString(int x) {
  if (x < 0) {
    return x.toString();
  } else {
    return '+${x}';
  }
}
