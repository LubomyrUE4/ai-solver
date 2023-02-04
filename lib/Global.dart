class GlobalConfig {
  static final GlobalConfig _singleton = GlobalConfig._internal();

  factory GlobalConfig() {
    return _singleton;
  }

  GlobalConfig._internal();

  bool enableAI1 = true;
  bool enableAI2 = false;
  bool enableAI3 = false;
  bool enableGoogleSearch = false;
}