import '../gurps/modifier.dart';
import '../gurps/die_roll.dart';

abstract class ModifierDetail {
  String get name;
  set name(String name);

  set spellPoints(int sp);

  bool get inherent;
  set inherent(bool inherent);

  set value(int value);

  String get typicalText;
  String get summaryText;
}

abstract class AfflictionDetail extends ModifierDetail {
  set specialization(String spec);
}

abstract class AreaOfEffectDetail extends ModifierDetail {
  set includes(bool includes);
  set targets(int targets);
}

abstract class DurationDetail extends ModifierDetail {}

abstract class SubjectWeightDetail extends ModifierDetail {}

abstract class DamageDetail extends ModifierDetail {
  set dieRoll(DieRoll d);

  set type(String type);
  set direct(bool direct);
  void addEnhancer(Modifier e);
}