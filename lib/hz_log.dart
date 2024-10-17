import 'dart:io';

import 'package:hz_log_plugin/platform_interface.dart';

import 'level.dart';

class HzLog {
  static final HzLog _instance = HzLog._internal();
  // 私有构造函数
  HzLog._internal() {
    // 初始化操作
    HzLogPlatform.instance.setPrefix(_prefix);
    HzLogPlatform.instance.setLogLevel(HzLevel.all);
  }

  // 工厂构造函数，返回单例
  factory HzLog() {
    return _instance;
  }

  HzLevel _currentLevel = HzLevel.all; // 默认日志级别
  String _prefix = "HzLog";
  bool _shouldLog({required HzLevel level}) {
    return level.value >= _currentLevel.value;
  }

  // 设置当前日志级别
  static Future<void> setLogLevel(HzLevel level) async {
    _instance._currentLevel = level;
    HzLogPlatform.instance.setLogLevel(level);
  }

  static Future<void> setPrefix(String prefix) async {
    _instance._prefix = prefix;
    HzLogPlatform.instance.setPrefix(prefix);
  }

  Future<void> log(
    String content, {
    String? tag,
    HzLevel? level,
    String? error,
    StackTrace? stackTrace,
    int stackLimit = 0,
    bool report = false,
  }) async {
    if (level == null || !_instance._shouldLog(level: level)) {
      return; // 不打印低于当前日志级别的日志
    }
    int limit = stackLimit;
    if (limit <= 0 && level.value > HzLevel.warning.value) {
      limit = 8;
    }
    stackTrace = stackTrace ?? StackTrace.current;
    String? stack;
    if (limit > 0) {
      stack = _getStackTrace(stackTrace, limit);
    }
    // 获取当前时间并格式化
    DateTime nowDate = DateTime.now();
    String formattedDate = _dateFormat(nowDate);

    /// 判断是iOS还是Android
    if (Platform.isIOS) {
      // 打印开始行、日志内容和结束行
      _printFormattedLog(
          prefix: tag == null ? _prefix : '$_prefix|$tag',
          content: content,
          level: level,
          date: _timeFormat(nowDate),
          error: error,
          stack: stack);
    }
    HzLogPlatform.instance.log(
      content,
      tag == null ? _prefix : '$_prefix|$tag',
      level,
      formattedDate,
      error: error,
      stack: stack,
      report: report,
    );
  }

  String _dateFormat(DateTime dateTime) {
    // return "${date.year.toString().padLeft(4, '0')}-"
    //     "${date.month.toString().padLeft(2, '0')}-"
    //     "${date.day.toString().padLeft(2, '0')} "
    //     "${date.hour.toString().padLeft(2, '0')}:"
    //     "${date.minute.toString().padLeft(2, '0')}:"
    //     "${date.second.toString().padLeft(2, '0')}";

    String year = dateTime.year.toString().padLeft(4, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');
    String millisecond = dateTime.millisecond.toString().padLeft(3, '0');
    return '$year-$month-$day $hour:$minute:$second.$millisecond';
  }

  String _timeFormat(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');
    String millisecond = dateTime.millisecond.toString().padLeft(3, '0');
    return '$hour:$minute:$second.$millisecond';
  }

  static void _printFormattedLog({
    required String prefix,
    required String content,
    required HzLevel level,
    required String date,
    String? error,
    String? stack,
  }) {
    String startLine =
        "┌-------------------------${level.emoji()} ${level.levelString()} START ${level.emoji()}--------------------------------";
    String endLine =
        "└-------------------------${level.emoji()} ${level.levelString()}  END  ${level.emoji()}--------------------------------";

    print(startLine);
    // print('[$prefix]');

    String fullMessage = "[$date]-[D]-[$prefix] $content";
    if (error != null) {
      fullMessage += "\nError: $error";
    }
    if (stack != null) {
      fullMessage += "\nStackTrace: $stack";
    }
    print(fullMessage);
    print(endLine);
  }

  static void reportLog({
    required String tag,
    required String content,
    required HzLevel level,
    required DateTime date,
    String? error,
    String? stack,
  }) {
    // 实现日志上报逻辑
    HzLogPlatform.instance
        .reportLog(content, tag, level, _instance._dateFormat(date), error: error, stack: stack);
  }

  static Future<void> setExtra(String key, String? value) async {
    await HzLogPlatform.instance.setExtra(key, value);
  }

  static Future<void> setCallbackOutput(bool open) async {
    await HzLogPlatform.instance.setCallbackOutput(open);
  }

  static Future<void> enableFileOutput(bool enable) async {
    await HzLogPlatform.instance.enableFileOutput(enable);
  }

  static Future<void> openLogcat(bool open) async {
    if (Platform.isAndroid) {
      await HzLogPlatform.instance.openLogcat(open);
    } else {
      return;
    }
  }

  static Future<void> clearLog() async {
    await HzLogPlatform.instance.clearLog();
  }

  static Future<String> getLogFiles() async {
    return await HzLogPlatform.instance.getLogFiles();
  }

  static Future<void> setFeishuOutput(
      String hookId, bool open, String projectId, String logStoreId) async {
    await HzLogPlatform.instance.setFeishuOutput(hookId, open, projectId, logStoreId);
  }

  static Future<void> t(String content, {String? tag, String? error, int stackLimit = 0}) async {
    _instance.log(content,
        tag: tag, level: HzLevel.trace, error: error, stackLimit: stackLimit, report: false);
  }

  static Future<void> d(String content, {String? tag, String? error, int stackLimit = 0}) async {
    await _instance.log(content,
        tag: tag, level: HzLevel.debug, error: error, stackLimit: stackLimit, report: false);
  }

  static Future<void> i(String content,
      {String? tag, String? error, int stackLimit = 0, bool report = true}) async {
    await _instance.log(content,
        tag: tag, level: HzLevel.info, error: error, stackLimit: stackLimit, report: report);
  }

  static Future<void> w(String content,
      {String? tag, String? error, int stackLimit = 0, bool report = true}) async {
    await _instance.log(content,
        tag: tag, level: HzLevel.warning, error: error, stackLimit: stackLimit, report: report);
  }

  static Future<void> e(String content,
      {String? tag, String? error, StackTrace? stackTrace, bool report = true}) async {
    await _instance.log(content,
        tag: tag,
        level: HzLevel.error,
        error: error,
        stackTrace: stackTrace,
        stackLimit: 10,
        report: report);
  }

  static Future<void> f(String content,
      {String? tag, String? error, StackTrace? stackTrace, bool report = true}) async {
    await _instance.log(content,
        tag: tag,
        level: HzLevel.fatal,
        error: error,
        stackTrace: stackTrace,
        stackLimit: 10,
        report: report);
  }

  /// 根据限制个数获取堆栈信息
  static String? _getStackTrace(StackTrace stackTrace, int stackLimit) {
    String? stack;
    if (stackLimit > 0) {
      // StackTrace stackTrace = StackTrace.current;
      // 获取当前堆栈信息
      List<String> stackTraceLines = stackTrace.toString().split('\n');
      // 打印限定数量的堆栈信息
      int maxLines = stackLimit.clamp(0, stackTraceLines.length);
      stack = stackTraceLines.skip(2).take(maxLines).join('\n');
    }
    return stack;
  }
}
