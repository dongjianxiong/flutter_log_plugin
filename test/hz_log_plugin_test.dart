import 'package:flutter_test/flutter_test.dart';
import 'package:hz_log_plugin/hz_log.dart';
import 'package:hz_log_plugin/level.dart';
import 'package:hz_log_plugin/method_channel.dart';
import 'package:hz_log_plugin/platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHzLogPlatform with MockPlatformInterfaceMixin implements HzLogPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
  //
  // @override
  // Future<void> d(String log, String tag, {String? error, String? stack, bool report = false}) {
  //   // TODO: implement d
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<void> e(String log, String tag, {String? error, String? stack, bool report = false}) {
  //   // TODO: implement e
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<void> i(String log, String tag, {String? error, String? stack, bool report = false}) {
  //   // TODO: implement i
  //   throw UnimplementedError();
  // }

  @override
  Future<void> openLogcat(bool open) {
    // TODO: implement openLogcat
    throw UnimplementedError();
  }

  @override
  Future<void> setARMSOutput(Map<String, String> log, bool open) {
    // TODO: implement setARMSOutput
    throw UnimplementedError();
  }

  @override
  Future<void> setExtra(String key, String? value) {
    // TODO: implement setExtra
    throw UnimplementedError();
  }

  @override
  Future<void> setFileOutput(bool open) {
    // TODO: implement setFileOutput
    throw UnimplementedError();
  }

  // @override
  // Future<void> t(String log, String tag, {String? error, String? stack, bool report = false}) {
  //   // TODO: implement t
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<void> w(String log, String tag, {String? error, String? stack, bool report = false}) {
  //   // TODO: implement w
  //   throw UnimplementedError();
  // }

  @override
  Future<void> setCallbackOutput(bool open) {
    // TODO: implement setCallbackOutput
    throw UnimplementedError();
  }

  @override
  Future<void> setFeishuOutput(String hookId, bool open, String projectId, String logStoreId) {
    // TODO: implement setFeishuOutput
    throw UnimplementedError();
  }

  @override
  Future<void> log(String log, String tag, HzLevel? level,
      {String? error, String? stack, bool report = false}) {
    // TODO: implement logger
    throw UnimplementedError();
  }

  @override
  Future<void> setLogLevel(HzLevel level) {
    // TODO: implement setLogLevel
    throw UnimplementedError();
  }

  @override
  Future<void> reportLog(String content, String tag, HzLevel? level,
      {String? error, String? stack}) {
    // TODO: implement reportLog
    throw UnimplementedError();
  }

  @override
  Future<void> setPrefix(String prefix) {
    // TODO: implement setPrefix
    throw UnimplementedError();
  }
}

void main() {
  final HzLogPlatform initialPlatform = HzLogPlatform.instance;

  test('$MethodChannelHzLog is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHzLog>());
  });

  test('getPlatformVersion', () async {
    HzLog hzLogPlugin = HzLog();
    MockHzLogPlatform fakePlatform = MockHzLogPlatform();
    HzLogPlatform.instance = fakePlatform;
  });
}
