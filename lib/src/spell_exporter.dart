import 'spell.dart';

class SpellExporter implements Exporter {
  String _name;

  @override
  void addName(String name) {
    _name = name;
  }

  String toText() {
    return _name + '\n\n';
  }
}
