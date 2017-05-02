import '../gurps/modifier.dart';
import '../gurps/die_roll.dart';

abstract class ModifierDetail {
  String name;
  int spellPoints;
  bool inherent;
  int value;

  String get typicalText;
  String get summaryText;
}

abstract class AfflictionDetail extends ModifierDetail {
  String specialization;
}

abstract class AlteredTraitsDetail extends ModifierDetail {
  String specialization;
  int specLevel;

  void addModifier(Modifier it);
}

abstract class AreaOfEffectDetail extends ModifierDetail {
  bool includes;
  int targets;
}

abstract class BestowsDetail extends ModifierDetail {
  String specialization;
  String range;
}

abstract class DamageDetail extends ModifierDetail {
  DieRoll dieRoll;
  String type;
  bool direct;

  void addModifier(Modifier e);
}

abstract class DurationDetail extends ModifierDetail {}
abstract class RangeDetail extends ModifierDetail {}
abstract class SubjectWeightDetail extends ModifierDetail {}
