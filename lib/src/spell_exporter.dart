import 'package:gurps_dart/gurps_dart.dart';
import 'modifier_detail.dart';

abstract class SpellExporter {
  set spellPoints(int spellPoints);
  set name(String name);
  set penalty(int skillPenalty);
  set time(GDuration time);
  set description(String description);
  set conditional(bool conditional);

  EffectExporter get effectExporter;
  ModifierExporter get modifierExporter;
  String get penaltyText;
  String get castingTime;
}

abstract class EffectExporter {
  String penaltyPath(int penalty);

  String get typicalText;

  String get briefText;

  void add({String effect: '', String path: '', int spellPoints: 0});

  void clear();
}

abstract class ModifierExporter {
  List<ModifierDetail> get details;

  void addDetail(ModifierDetail detailExporter);

  String get briefText;

  String get typicalText;

  void clear();

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
  ModifierDetail createRangeInformationalDetail();
  ModifierDetail createRangeTimeDetail();
  ModifierDetail createSpeedDetail();
  ModifierDetail createSubjectWeightDetail();
  ModifierDetail createSummonedDetail();
}
