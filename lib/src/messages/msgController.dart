import 'package:mvc_pattern/mvc_pattern.dart';

class MsgController extends ControllerMVC {
  factory MsgController() {
    if (_this == null) _this = MsgController._();
    return _this;
  }
  static MsgController _this;
  MsgController._();
  static MsgController get con => _this;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

}