import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'level.dart';
import 'method_channel.dart';

abstract class HzLogPlatform extends PlatformInterface {
  /// Constructs a HzLogPlatform.
  HzLogPlatform() : super(token: _token);

  static final Object _token = Object();

  static HzLogPlatform _instance = MethodChannelHzLog();

  /// The default instance of [HzLogPlatform] to use.
  ///
  /// Defaults to [MethodChannelHzLog].
  static HzLogPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HzLogPlatform] when
  /// they register themselves.
  static set instance(HzLogPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  ///打印日志
  Future<void> log(String message, String? tag, HzLevel? level, String date,
      {String? error, String? stack, bool report = false}) {
    throw UnimplementedError('log() has not been implemented.');
  }

  /// 设置日志级别
  Future<void> setLogLevel(HzLevel level) async {
    throw UnimplementedError('setLogLevel() has not been implemented.');
  }

  /// 设置日志前缀
  Future<void> setPrefix(String prefix) async {
    throw UnimplementedError('setPrefix() has not been implemented.');
  }

  // 设置最大字符个数，最大值为8000
  Future<void> setMaxServerLogSize(int maxSize) async {
    throw UnimplementedError('setMaxServerLogSize() has not been implemented.');
  }

  // 设置最大合并日志个数
  Future<void> setMaxServerLogCount(int logCount) async {
    throw UnimplementedError('setMaxServerLogCount() has not been implemented.');
  }

  // 设置最大日志上传间隔
  Future<void> setMaxServerLogInterval(int timeInterval) async {
    throw UnimplementedError('setMaxServerLogInterval() has not been implemented.');
  }

  /// 日志上报
  Future<void> reportLog(String message, String? tag, HzLevel? level, String date,
      {String? error, String? stack}) {
    throw UnimplementedError('reportLog() has not been implemented.');
  }

  ///设置or清除自定义字段
  Future<void> setExtra(String key, String? value) {
    throw UnimplementedError('setExtra() has not been implemented.');
  }

  ///设置打开/关闭飞书输出器
  Future<void> setFeishuOutput(String hookId, bool open, String projectId, String logStoreId) {
    throw UnimplementedError('setFeishuOutput() has not been implemented.');
  }

  ///设置打开/关闭文件输出器
  Future<void> enableFileOutput(bool enable) {
    throw UnimplementedError('enableFileOutput() has not been implemented.');
  }

  ///设置打开/关闭logcat
  Future<void> openLogcat(bool open) {
    throw UnimplementedError('openLogcat() has not been implemented.');
  }

  Future<void> clearLog() {
    throw UnimplementedError('clearLog() has not been implemented.');
  }

  Future<String> getLogFiles() {
    throw UnimplementedError('getLogFiles() has not been implemented.');
  }

  ///设置打开/关闭ARMS
  Future<void> setCallbackOutput(bool open) {
    throw UnimplementedError('setCallbackOutput() has not been implemented.');
  }

  // Future<void> t(String log, String tag,
  //     {String? error, String? stack, bool report = false}) async {
  //   logger(log, tag, Level.trace, error: error, stack: stack, report: report);
  // }
  //
  // Future<void> d(String log, String tag,
  //     {String? error, String? stack, bool report = false}) async {
  //   logger(log, tag, Level.debug, error: error, stack: stack, report: report);
  // }
  //
  // Future<void> i(
  //   String log,
  //   String tag, {
  //   String? error,
  //   String? stack,
  //   bool report = false,
  // }) async {
  //   logger(log, tag, Level.info, error: error, stack: stack, report: report);
  // }
  //
  // Future<void> w(
  //   String log,
  //   String tag, {
  //   String? error,
  //   String? stack,
  //   bool report = false,
  // }) async {
  //   logger(log, tag, Level.warning, error: error, stack: stack, report: report);
  // }
  //
  // Future<void> e(String log, String tag,
  //     {String? error, String? stack, bool report = false}) async {
  //   logger(log, tag, Level.error, error: error, stack: stack, report: report);
  // }
}
