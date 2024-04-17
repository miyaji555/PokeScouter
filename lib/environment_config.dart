const flavorDev = 'dev';
const flavorEmulator = 'emulator';
const flavorProd = 'prod';

class EnvironmentConfig {
  static final EnvironmentConfig _instance = EnvironmentConfig._internal();
  EnvironmentConfig._internal();
  Environment? _environment;

  factory EnvironmentConfig() {
    return _instance..setEnvironment();
  }

  Environment? get environment => _environment;
  bool get isProd {
    return _environment == Environment.product;
  }

  void setEnvironment() {
    switch (const String.fromEnvironment('FLAVOR')) {
      case flavorEmulator:
        _environment = Environment.emulator;
        break;
      case flavorDev:
        _environment = Environment.develop;
        break;
      case flavorProd:
        _environment = Environment.product;
        break;
      default:
        throw ArgumentError('Invalid environment specified.');
    }
  }
}

enum Environment {
  emulator,
  develop,
  product,
}
