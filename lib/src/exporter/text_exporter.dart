import 'package:gurps_dart/gurps_dart.dart';
import '../spell_exporter.dart';
import '../modifier_detail.dart';
import 'text_modifier_detail.dart';
import 'package:quiver/core.dart';

class TextSpellExporter implements SpellExporter {
  @override
  String name;

  @override
  EffectExporter effectExporter = TextEffectExporter();

  @override
  ModifierExporter modifierExporter = TextModifierExporter();
  int penalty;
  GDuration time;
  String description;
  bool conditional;
  int spellPoints;

  @override
  String toString() {
    StringBuffer sb = StringBuffer()
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

  @override
  String get penaltyText => "Skill Penalty: ${penaltyPath}.";

  String get penaltyPath => effectExporter.penaltyPath(penalty);

  String get timeText => "Casting Time: ${castingTime}.";

  @override
  String get castingTime => GDuration.toFormattedString(time.inSeconds);

  String get typical {
    List<String> components = [];
    components
      ..add('${effectExporter.typicalText}')
      ..add('${_conditionalText}')
      ..add('${modifierExporter.typicalText}')
      ..removeWhere((it) => it.length == 0);
    return components.join(' + ');
  }

  String get typicalText {
    List<String> components = [];
    components.add('${effectExporter.typicalText}');
    components.add('${_conditionalText}');
    components.add('${modifierExporter.typicalText}');
    components.removeWhere((it) => it.length == 0);
    return 'Typical Casting: ${components.join(' + ')}. ${spellPoints} SP.';
  }

  String get _conditionalText => (conditional) ? 'Conditional Spell (5)' : '';
}

class _Effect {
  _Effect(this.effect, this.path, this.spellPoints);

  String effect;
  String path;
  int spellPoints;

  String get summaryText => '${effect} ${path}';

  String get typicalCastingText => '${effect} ${path} (${spellPoints})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _Effect && other.effect == effect && other.path == path;
  }

  @override
  int get hashCode => hash2(effect, path);

  @override
  String toString() => '_Effect:[effect=${effect}, path=${path}]';
}

class TextEffectExporter implements EffectExporter {
  final List<_Effect> values = [];

  @override
  void add({String effect: '', String path: '', int spellPoints: 0}) {
    values.add(_Effect(effect, path, spellPoints));
  }

  @override
  String toString() => "Spell Effects: ${_text}.";

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

      return countMap.keys
          .map((it) => _summaryText(it, countMap))
          .reduce((a, b) => a + ' + ' + b);
    }
  }

  String _summaryText(_Effect effect, Map<_Effect, int> countMap) =>
      (countMap[effect] == 1)
          ? '${effect.summaryText}'
          : '${effect.summaryText} x${countMap[effect]}';

  @override
  String penaltyPath(int penalty) {
    String penaltyValueText =
        "${(penalty == 0) ? '' : toSignedString(penalty)}";

    if (values.length > 0 && values.every((it) => it.path == values[0].path)) {
      return 'Path of ${values[0].path}-${penalty.abs()}';
    } else if (values.length > 1) {
      return "The lower of ${values.map((it) => 'Path of ${it.path}').toSet().reduce((a, b) => '${a}${penaltyValueText} or ${b}${penaltyValueText}')}";
    }
    return 'Appropriate Path';
  }

  @override
  String get typicalText => (values.isEmpty)
      ? 'None.'
      : values
          .map((it) => it.typicalCastingText)
          .reduce((a, b) => a + ' + ' + b);

  @override
  String get briefText => _text;

  @override
  void clear() {
    values.clear();
  }
}

class TextModifierExporter implements ModifierExporter {
  final List<TextModifierDetail> _details = [];

  @override
  String toString() => "Inherent Modifiers: ${_briefText}.";

  @override
  String get briefText => _briefText;

  String get _briefText {
    _details.sort((a, b) => a.name.compareTo(b.name));
    if (_details.every((f) => !f.inherent)) {
      return "None";
    } else {
      return _details
          .where((a) => a.inherent)
          .map((a) => a.summaryText)
          .join(' + ');
    }
  }

  @override
  String get typicalText {
    _details.sort((a, b) => a.name.compareTo(b.name));
    return _details.map((a) => a.typicalText).join(' + ');
  }

  @override
  void addDetail(ModifierDetail detailExporter) {
    _details.add(detailExporter as TextModifierDetail);
  }

  @override
  void clear() {
    _details.clear();
  }

  @override
  List<ModifierDetail> get details => _details;

  @override
  ModifierDetail createAfflictionDetail() => TextAfflictionDetail();

  @override
  ModifierDetail createAfflictionStunDetail() => TextModifierDetail();

  @override
  ModifierDetail createAlteredTraitsDetail() => TextAlteredTraitsDetail();

  @override
  ModifierDetail createAreaEffectDetail() => TextAreaOfEffectDetail();

  @override
  ModifierDetail createBestowsDetail() => TextBestowsDetail();

  @override
  ModifierDetail createDamageDetail() => TextDamageDetail();

  @override
  ModifierDetail createDurationDetail() => TextDurationDetail();

  @override
  ModifierDetail createGirdedDetail() => TextModifierDetail();

  @override
  ModifierDetail createRangeDetail() => TextRangeDetail();

  @override
  ModifierDetail createRangeDimensionalDetail() => TextRangeDimensionalDetail();

  @override
  ModifierDetail createRangeInformationalDetail() =>
      TextRangeInformationalDetail();

  @override
  ModifierDetail createRangeTimeDetail() => TextRangeTimeDetail();

  @override
  ModifierDetail createRepairDetail() => TextRepairDetail();

  @override
  ModifierDetail createSpeedDetail() => TextSpeedDetail();

  @override
  ModifierDetail createSubjectWeightDetail() => TextSubjectWeightDetail();

  @override
  ModifierDetail createSummonedDetail() => TextSummonedDetail();
}
