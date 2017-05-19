import '../units/gurps_duration.dart';
import 'modifier_detail.dart';

abstract class SpellExporter {
  set spellPoints(int spellPoints);
  set name(String name);
  set penalty(int skillPenalty);
  set time(GurpsDuration time);
  set description(String description);
  set conditional(bool conditional);
  EffectExporter get effectExporter;
  ModifierExporter get modifierExporter;
}

abstract class EffectExporter {
  String penaltyPath(int penalty);

  String get typicalText;

  void add({String effect: '', String path: '', int spellPoints: 0});
}

abstract class ModifierExporter {
  void addDetail(ModifierDetail detailExporter);

  String get typicalText;

  ModifierDetail createAfflictionDetail();
  ModifierDetail createAfflictionStunDetail();
  ModifierDetail createAlteredTraitsDetail();
  ModifierDetail createAreaEffectDetail();
  ModifierDetail createBestowsDetail();
  ModifierDetail createDamageDetail();
  ModifierDetail createDurationDetail();
  ModifierDetail createGirdedDetail();
  ModifierDetail createRangeDetail();
  ModifierDetail createRepairDetail();
  ModifierDetail createRangeDimensionalDetail();
  ModifierDetail createRangeTimeDetail();
  ModifierDetail createSpeedDetail();
  ModifierDetail createSubjectWeightDetail();
  ModifierDetail createSummonedDetail();
}
