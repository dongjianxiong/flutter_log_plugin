import 'package:hz_log_plugin/platform_interface.dart';

import 'level.dart';

class HzLog {
  static final HzLog _instance = HzLog._internal();
  // 私有构造函数
  HzLog._internal() {
    // 初始化操作
  }

  // 工厂构造函数，返回单例
  factory HzLog() {
    return _instance;
  }

  static Future<String?> getPlatformVersion() {
    return HzLogPlatform.instance.getPlatformVersion();
  }

  Future<void> log(String tag, String content,
      {HzLevel? level, String? error, String? stack, bool report = false}) async {
    await HzLogPlatform.instance
        .log(content, tag, level, error: error, stack: stack, report: report);
  }

  static Future<void> setExtra(String key, String? value) async {
    await HzLogPlatform.instance.setExtra(key, value);
  }

  static Future<void> setCallbackOutput(bool open) async {
    await HzLogPlatform.instance.setCallbackOutput(open);
  }

  static Future<void> setFileOutput(bool open) async {
    await HzLogPlatform.instance.setFileOutput(open);
  }

  static Future<void> openLogcat(bool open) async {
    await HzLogPlatform.instance.openLogcat(open);
  }

  // 设置当前日志级别
  static Future<void> setLogLevel(HzLevel level) async {}

  static Future<void> setFeishuOutput(
      String hookId, bool open, String projectId, String logStoreId) async {
    await HzLogPlatform.instance.setFeishuOutput(hookId, open, projectId, logStoreId);
  }

  static Future<void> t(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await _instance.log(content, tag,
        level: HzLevel.trace, error: error, stack: stack, report: report);
  }

  static Future<void> d(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await _instance.log(content, tag,
        level: HzLevel.debug, error: error, stack: stack, report: report);
  }

  static Future<void> i(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await _instance.log(content, tag,
        level: HzLevel.info, error: error, stack: stack, report: report);
  }

  static Future<void> w(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await _instance.log(content, tag,
        level: HzLevel.warning, error: error, stack: stack, report: report);
  }

  static Future<void> e(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await _instance.log(content, tag,
        level: HzLevel.error, error: error, stack: stack, report: report);
  }

  static Future<void> f(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await _instance.log(content, tag,
        level: HzLevel.fatal, error: error, stack: stack, report: report);
  }
}
