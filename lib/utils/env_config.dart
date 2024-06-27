class EvnConfig {

  factory EvnConfig() {
    return _instance!;
  }

  EvnConfig._();

  static EvnConfig? _instance;

  String? envConfigType;
  String? versionEdition;

  static void init({String? envType, String setVersion = ''}) {

    _instance ??= EvnConfig._();
    _instance!.envConfigType = envType;
    _instance!.versionEdition = setVersion;

  }

  bool isDev(String evn) => evn == envConfigType;

}
