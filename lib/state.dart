import 'package:rxdart/rxdart.dart';

class Store<T> {
  BehaviorSubject<T> _state;

  Store() {
    this._state = BehaviorSubject();
  }

  get $ {
    return this._state.stream;
  }

  get value {
    return this._state.value;
  }

  set value(T state) {
    this._state.value = state;
  }
}
