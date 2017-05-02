import '../units/gurps_duration.dart';
import 'modifier_detail.dart';

abstract class SpellExporter {
  set spellPoints(int spellPoints);

  set name(String name);

  EffectExporter get effectExporter;

  ModifierExporter get modifierExporter;

  set penalty(int skillPenalty);

  set time(GurpsDuration time);

  set description(String description);

  set conditional(bool conditional);
}

abstract class EffectExporter {
  String get penaltyPath;

  String get typicalText;

  void add({String effect: '', String path: '', int spellPoints: 0});
}

abstract class ModifierExporter {
  void addDetail(ModifierDetail detailExporter);

  String get typicalText;

  AfflictionDetail createAfflictionDetail();
  AlteredTraitsDetail createAlteredTraitsDetail();
  AreaOfEffectDetail createAreaEffectDetail();
  BestowsDetail createBestowsDetail();
  DamageDetail createDamageDetail();
  DurationDetail createDurationDetail();
  RangeDetail createRangeDetail();
  SubjectWeightDetail createSubjectWeightDetail();
}
