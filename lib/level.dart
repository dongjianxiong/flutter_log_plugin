enum HzLevel {
  all(0),
  trace(1000),
  debug(2000),
  info(3000),
  warning(4000),
  error(5000),
  fatal(6000);

  final int value;
  const HzLevel(this.value);

  // 日志级别对应的字符串表示
  String levelString() {
    switch (this) {
      case HzLevel.all:
        return "ALL";
      case HzLevel.trace:
        return "TRACE";
      case HzLevel.debug:
        return "DEBUG";
      case HzLevel.info:
        return "INFO";
      case HzLevel.warning:
        return "WARNING";
      case HzLevel.error:
        return "ERROR";
      case HzLevel.fatal:
        return "FATAL";
    }
  }

  // 日志级别的短字符串表示
  String levelShortString() {
    switch (this) {
      case HzLevel.all:
        return "ALL";
      case HzLevel.trace:
        return "T";
      case HzLevel.debug:
        return "D";
      case HzLevel.info:
        return "I";
      case HzLevel.warning:
        return "W";
      case HzLevel.error:
        return "E";
      case HzLevel.fatal:
        return "F";
    }
  }

  // 日志级别对应的描述和表情
  String emoji() {
    switch (this) {
      case HzLevel.all:
        return "📝";
      case HzLevel.trace:
        return "🔍";
      case HzLevel.debug:
        return "🔧";
      case HzLevel.info:
        return "ℹ️";
      case HzLevel.warning:
        return "⚠️";
      case HzLevel.error:
        return "❌";
      case HzLevel.fatal:
        return "💀";
    }
  }
}
