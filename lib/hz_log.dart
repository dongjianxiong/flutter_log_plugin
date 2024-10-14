import 'package:hz_log_plugin/platform_interface.dart';

import 'level.dart';

class HzLog {
  Future<String?> getPlatformVersion() {
    return HzLogPlatform.instance.getPlatformVersion();
  }

  Future<void> log(String tag, String content,
      {Level? level, String? error, String? stack, bool report = false}) async {
    await HzLogPlatform.instance
        .log(content, tag, level, error: error, stack: stack, report: report);
  }

  Future<void> setExtra(String key, String? value) async {
    await HzLogPlatform.instance.setExtra(key, value);
  }

  Future<void> setCallbackOutput(bool open) async {
    await HzLogPlatform.instance.setCallbackOutput(open);
  }

  Future<void> setFileOutput(bool open) async {
    await HzLogPlatform.instance.setFileOutput(open);
  }

  Future<void> openLogcat(bool open) async {
    await HzLogPlatform.instance.openLogcat(open);
  }

  Future<void> setFeishuOutput(
      String hookId, bool open, String projectId, String logStoreId) async {
    await HzLogPlatform.instance.setFeishuOutput(hookId, open, projectId, logStoreId);
  }

  Future<void> t(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await HzLogPlatform.instance
        .log(content, tag, Level.trace, error: error, stack: stack, report: report);
  }

  Future<void> d(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await HzLogPlatform.instance
        .log(content, tag, Level.debug, error: error, stack: stack, report: report);
  }

  Future<void> i(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await HzLogPlatform.instance
        .log(content, tag, Level.info, error: error, stack: stack, report: report);
  }

  Future<void> w(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await HzLogPlatform.instance
        .log(content, tag, Level.warning, error: error, stack: stack, report: report);
  }

  Future<void> e(String tag, String content,
      {String? error, String? stack, bool report = false}) async {
    await HzLogPlatform.instance
        .log(content, tag, Level.error, error: error, stack: stack, report: report);
  }
}
