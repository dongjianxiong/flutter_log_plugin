enum Level {
  all,
  trace,
  debug,
  info,
  warning,
  error,
}

extension LevelExtension on Level {
  int get value {
    switch (this) {
      case Level.all:
        return 0;
      case Level.trace:
        return 1000;
      case Level.debug:
        return 2000;
      case Level.info:
        return 3000;
      case Level.warning:
        return 4000;
      case Level.error:
        return 5000;
    }
  }
}
