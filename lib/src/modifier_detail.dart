import '../gurps/trait_modifier.dart';
import '../gurps/die_roll.dart';

abstract class ModifierDetail {
  set name(String name);
  set spellPoints(int sp);
  set inherent(bool inherent);
  set value(int value);

  String get typicalText;
  String get summaryText;
}

abstract class AfflictionDetail extends ModifierDetail {
  set specialization(String spec);
}

abstract class AlteredTraitsDetail extends ModifierDetail {
  String specialization;
  int specLevel;

  void addModifier(TraitModifier it);
}

abstract class AreaOfEffectDetail extends ModifierDetail {
  bool includes;
  int targets;
}

abstract class BestowsDetail extends ModifierDetail {
  set specialization(String spec);
  set range(String range);
}

abstract class DamageDetail extends ModifierDetail {
  set dieRoll(DieRoll d);
  set type(String type);
  set direct(bool direct);

  void addModifier(TraitModifier e);
}

abstract class RepairDetail extends ModifierDetail {
  set specialization(String spec);
  set dieRoll(DieRoll die);
}
