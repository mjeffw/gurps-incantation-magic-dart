import '../../units/gurps_duration.dart';
import '../exporter.dart';
import '../modifier_detail.dart';
import 'text_modifier_detail.dart';
import 'package:quiver/core.dart';

class TextSpellExporter implements SpellExporter {
  String name;
  EffectExporter effectExporter = new TextEffectExporter();
  ModifierExporter modifierExporter = new TextModifierExporter();
  int penalty;
  GurpsDuration time;
  String description;
  bool conditional;
  int spellPoints;

  @override
  String toString() {
    StringBuffer sb = new StringBuffer()
      ..writeln(name)
      ..writeln('')
      ..writeln(effectExporter)
      ..writeln(modifierExporter)
      ..writeln(penaltyText)
      ..writeln(timeText)
      ..writeln('')
      ..writeln(description)
      ..writeln('')
      ..writeln(typicalText);
    return sb.toString();
  }

  String get penaltyText => "Skill Penalty: ${effectExporter.penaltyPath(penalty)}.";

  String get timeText => "Casting Time: ${time.toFormattedString()}.";

  String get typicalText {
    List<String> components = [];
    components.add('${effectExporter.typicalText}');
    components.add('${_conditionalText}');
    components.add('${modifierExporter.typicalText}');
    components.removeWhere((it) => it.length == 0);
    return 'Typical Casting: ${components.join(' + ')}. ${spellPoints} SP.';
  }

  String get _conditionalText {
    if (conditional) {
      return 'Conditional Spell (5)';
    }
    return '';
  }
}

class _Effect {
  String effect;
  String path;
  int spellPoints;

  _Effect(this.effect, this.path, this.spellPoints);

  String get summaryText => '${effect} ${path}';

  String get typicalCastingText => '${effect} ${path} (${spellPoints})';

  bool operator ==(Object other) {
    if (other is! _Effect) {
      return false;
    }
    return ((other as _Effect).effect == effect) && ((other as _Effect).path == path);
  }

  @override
  int get hashCode => hash2(effect, path);

  @override
  String toString() {
    return '_Effect:[effect=${effect}, path=${path}]';
  }
}

class TextEffectExporter implements EffectExporter {
  final List<_Effect> values = [];

  @override
  void add({String effect: '', String path: '', int spellPoints: 0}) {
    values.add(new _Effect(effect, path, spellPoints));
  }

  @override
  String toString() {
    return "Spell Effects: ${_text}.";
  }

  String get _text {
    if (values.isEmpty) {
      return 'None';
    } else {
      // reduce duplicates ...
      Map<_Effect, int> countMap = {};

      values.forEach((it) {
        if (countMap.containsKey(it)) {
          countMap[it] = countMap[it] + 1;
        } else {
          countMap[it] = 1;
        }
      });

      return countMap.keys.map((it) => _summaryText(it, countMap)).reduce((a, b) => a + ' + ' + b);
    }
  }

  String _summaryText(_Effect effect, Map<_Effect, int> countMap) {
    if (countMap[effect] == 1) {
      return '${effect.summaryText}';
    }
    return '${effect.summaryText} x ${countMap[effect]}';
  }

  @override
  String penaltyPath(int penalty) {
    if (values.length > 0 && values.every((it) => it.path == values[0].path)) {
      return 'Path of ${values[0].path}${penalty}';
    } else if (values.length > 1) {
      return "The lower of ${values.map((it) =>
        'Path of ${it.path}').toSet().reduce((a, b) => '${a}${penalty} or ${b}${penalty}')}";
    }
    return 'Appropriate Path';
  }

  @override
  String get typicalText {
    if (values.isEmpty) {
      return 'None.';
    } else {
      return values.map((it) => it.typicalCastingText).reduce((a, b) => a + ' + ' + b);
    }
  }
}

class TextModifierExporter implements ModifierExporter {
  final List<ModifierDetail> _details = [];

  @override
  String toString() {
    return "Inherent Modifiers: ${_briefText}.";
  }

  String get _briefText {
    if (_details.every((f) => !f.inherent)) {
      return "None";
    } else {
      return _details.where((a) => a.inherent).map((a) => a.summaryText).join(' + ');
    }
  }

  @override
  String get typicalText {
    _details.sort((a,b) => a.name.compareTo(b.name));
    return _details.map((a) => a.typicalText).join(' + ');
  }

  @override
  void addDetail(ModifierDetail detailExporter) {
    _details.add(detailExporter);
  }

  @override
  AfflictionDetail createAfflictionDetail() {
    return new TextAfflictionDetail();
  }

  @override
  AlteredTraitsDetail createAlteredTraitsDetail() => new TextAlteredTraitsDetail();

  @override
  AreaOfEffectDetail createAreaEffectDetail() => new TextAreaOfEffectDetail();

  @override
  BestowsDetail createBestowsDetail() => new TextBestowsDetail();

  @override
  DamageDetail createDamageDetail() => new TextDamageDetail();

  @override
  DurationDetail createDurationDetail() => new TextDurationDetail();

  @override
  GirdedDetail createGirdedDetail() => new TextGirdedDetail();

  @override
  RangeDetail createRangeDetail() => new TextRangeDetail();

  @override
  RangeDimensionalDetail createRangeDimensionalDetail() => new TextRangeDimensionalDetail();

  @override
  SubjectWeightDetail createSubjectWeightDetail() => new TextSubjectWeightDetail();

  @override
  SummonedDetail createSummonedDetail() => new TextSummonedDetail();
}
