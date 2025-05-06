import 'dart:developer' as dev;

extension LoggerExtension<T> on T {
  T get log {
    dev.log(toString());
    return this;
  }

  T logWithName(String name) {
    dev.log(toString(), name: name);
    return this;
  }

  T get logRunTimeType {
    // ignore: no_runtimetype_tostring
    dev.log(toString(), name: runtimeType.toString());
    return this;
  }
}
