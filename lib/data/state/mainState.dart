class MainState {
  static final MainState _mainState = MainState._internal();
  String token = "";

  factory MainState() {
    return _mainState;
  }

  MainState._internal();
}