import 'package:hzlogger/level.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hzlogger_method_channel.dart';

abstract class HzloggerPlatform extends PlatformInterface {
  /// Constructs a HzloggerPlatform.
  HzloggerPlatform() : super(token: _token);

  static final Object _token = Object();

  static HzloggerPlatform _instance = MethodChannelHzlogger();

  /// The default instance of [HzloggerPlatform] to use.
  ///
  /// Defaults to [MethodChannelHzlogger].
  static HzloggerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HzloggerPlatform] when
  /// they register themselves.
  static set instance(HzloggerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///打印日志
  Future<void> logger(String log, String tag,
      Level? level,{ String? error, String? stack, bool report = false}) {
    throw UnimplementedError('logger() has not been implemented.');
  }

  ///设置or清除自定义字段
  Future<void> setExtra(String key, String? value) {
    throw UnimplementedError('setExtra() has not been implemented.');
  }

  ///设置打开/关闭飞书输出器
  Future<void> setFeishuOutput(String hookId, bool open,String projectId,String logStoreId) {
    throw UnimplementedError('setFeishuOutput() has not been implemented.');
  }

  ///设置打开/关闭文件输出器
  Future<void> setFileOutput(bool open) {
    throw UnimplementedError('setFileOutput() has not been implemented.');
  }

  ///设置打开/关闭logcat
  Future<void> openLogcat(bool open) {
    throw UnimplementedError('openLogcat() has not been implemented.');
  }

  ///设置打开/关闭ARMS
  Future<void> setCallbackOutput(bool open) {
    throw UnimplementedError('setCallbackOutput() has not been implemented.');
  }

  Future<void> t(String log, String tag,
      {String? error, String? stack, bool report = false}) async {
    logger(log, tag,
        Level.trace, error: error, stack: stack, report: report);
  }

  Future<void> d(String log, String tag,
      {String? error, String? stack, bool report = false}) async {
    logger(log, tag,
        Level.debug, error: error, stack: stack, report: report);
  }

  Future<void> i(
    String log,
    String tag, {
    String? error,
    String? stack,
    bool report = false,
  }) async {
    logger(log, tag,
        Level.info, error: error, stack: stack, report: report);
  }

  Future<void> w(
    String log,
    String tag, {
    String? error,
    String? stack,
    bool report = false,
  }) async {
    logger(log, tag,
        Level.warning, error: error, stack: stack, report: report);
  }

  Future<void> e(String log, String tag,
      {String? error, String? stack, bool report = false}) async {
    logger(log, tag,
        Level.error, error: error, stack: stack, report: report);
  }
}
