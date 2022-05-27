import 'dart:ui';
import 'package:flame/components.dart';

//call event
class TriggerAcction {
  VoidCallback? trigger;
  bool _running;
  TriggerAcction({this.trigger, bool autoStart = true}) : _running = autoStart;
  void CallAction() {
    if (_running) {
      trigger?.call();
    }
  }

  bool isRunning() => _running;
  void Stop() {
    _running = false;
  }

  void Start() {
    _running = true;
  }
}

//call event witha  position value
class TriggerAcctionPosition {
  Function(Vector2)? trigger;
  bool _running;
  TriggerAcctionPosition({this.trigger, bool autoStart = true})
      : _running = autoStart;
  void CallActionAt(Vector2 vector) {
    if (_running) {
      trigger?.call(vector);
    }
  }

  bool isRunning() => _running;
  void Stop() {
    _running = false;
  }

  void Start() {
    _running = true;
  }
}
