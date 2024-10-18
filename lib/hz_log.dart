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

  // 设置最大字符个数，最大值为8000
  static Future<void> setMaxServerLogSize(int maxSize) async {
    return await HzLogPlatform.instance.setMaxServerLogSize(maxSize);
  }

  // 设置最大合并日志个数
  static Future<void> setMaxServerLogCount(int maxLogCount) async {
    return await HzLogPlatform.instance.setMaxServerLogCount(maxLogCount);
  }

  // 设置最大日志上传间隔
  static Future<void> setMaxServerLogInterval(int timeInterval) async {
    return await HzLogPlatform.instance.setMaxServerLogInterval(timeInterval);
  }

  Future<void> log(
    String message, {
    String? tag,
    HzLevel? level,
    String? error,
    StackTrace? stackTrace,
    int stackLimit = 0,
    bool report = false,
  }) async {
    // 提前返回条件检查
    if (level == null || !_instance._shouldLog(level: level) || message.isEmpty) {
      return;
    }

    // 确定堆栈深度
    int limit = (stackLimit > 0) ? stackLimit : (level.value >= HzLevel.error.value ? 8 : 0);

    // 获取堆栈信息
    String? stack = stackTrace != null
        ? _getStackTrace(stackTrace, limit, skip: 0)
        : (limit > 0 ? _getStackTrace(StackTrace.current, limit) : null);

    // 获取当前时间并格式化
    DateTime nowDate = DateTime.now();
    String formattedDate = _dateFormat(nowDate);

    /// 控制台日志在Flutter打印，因为iOS原生打印无法再Android studio控制台展示
    if (Platform.isIOS) {
      _printFormattedLog(message,
          tagFormat: tag == null ? _prefix : '$_prefix|$tag',
          level: level,
          date: _timeFormat(nowDate),
          error: error,
          stack: stack);
    }
    // 调用平台日志接口
    HzLogPlatform.instance.log(
      message,
      tag,
      level,
      formattedDate,
      error: error,
      stack: stack,
      report: report,
    );
  }

  String _dateFormat(DateTime dateTime) {
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

  static void _printFormattedLog(
    message, {
    required String tagFormat,
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

    String fullMessage = "[$date]-[D]-[$tagFormat] $message";
    if (error != null) {
      fullMessage += "\nError: $error";
    }
    if (stack != null) {
      fullMessage += "\nStackTrace: $stack";
    }
    print(fullMessage);
    print(endLine);
  }

  static void reportLog(
    String message, {
    String? tag,
    HzLevel? level,
    DateTime? date,
    String? error,
    String? stack,
  }) {
    // 实现日志上报逻辑
    HzLogPlatform.instance.reportLog(
        message, tag, level, _instance._dateFormat(date ?? DateTime.now()),
        error: error, stack: stack);
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
      {String? tag,
      String? error,
      StackTrace? stackTrace,
      int stackLimit = 5,
      bool report = true}) async {
    await _instance.log(content,
        tag: tag,
        level: HzLevel.error,
        error: error,
        stackTrace: stackTrace,
        stackLimit: stackLimit,
        report: report);
  }

  static Future<void> f(String content,
      {String? tag,
      String? error,
      StackTrace? stackTrace,
      int stackLimit = 5,
      bool report = true}) async {
    await _instance.log(content,
        tag: tag,
        level: HzLevel.fatal,
        error: error,
        stackTrace: stackTrace,
        stackLimit: stackLimit,
        report: report);
  }

  /// 根据限制个数获取堆栈信息
  static String? _getStackTrace(StackTrace stackTrace, int stackLimit, {int skip = 2}) {
    String? stack;
    if (stackLimit > 0) {
      // StackTrace stackTrace = StackTrace.current;
      // 获取当前堆栈信息
      List<String> stackTraceLines = stackTrace.toString().split('\n');
      // 打印限定数量的堆栈信息
      int maxLines = stackLimit.clamp(0, stackTraceLines.length);
      stack = stackTraceLines.skip(skip).take(maxLines).join('\n');
    }
    return stack;
  }
}
