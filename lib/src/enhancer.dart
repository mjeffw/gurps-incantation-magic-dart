import 'dart:mirrors';

class Enhancer {
  String name;
  String detail;
  int level;

  Enhancer(this.name, this.detail, this.level);
}

class EnhancerList implements List<Enhancer> {
  List<Enhancer> _delegate;
  InstanceMirror _mirror;

  EnhancerList() : _delegate = new List<Enhancer>() {
    _mirror = reflect(_delegate);
  }

  void noSuchMethod(Invocation invocation) {
    return _mirror.delegate(invocation);
  }

  int adjustment(int baseValue) {
//    if (_delegate.isEmpty) {
//      return 0;
//    }
//
    double x = _delegate.map<double>((i) => i.level / 100.0).fold(0.0, (a, b) => a + b);
    return (baseValue * x).ceil();
  }

  int get sum => _delegate.map<int>((e) => e.level).fold<int>(0, (a, b) => a + b);
}
