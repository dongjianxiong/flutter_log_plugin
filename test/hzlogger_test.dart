import 'package:flutter_test/flutter_test.dart';
import 'package:hzlogger/hzlogger.dart';
import 'package:hzlogger/hzlogger_platform_interface.dart';
import 'package:hzlogger/hzlogger_method_channel.dart';
import 'package:hzlogger/level.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHzloggerPlatform
    with MockPlatformInterfaceMixin
    implements HzloggerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> d(String log, String tag, {String? error, String? stack, bool report = false}) {
    // TODO: implement d
    throw UnimplementedError();
  }

  @override
  Future<void> e(String log, String tag, {String? error, String? stack, bool report = false}) {
    // TODO: implement e
    throw UnimplementedError();
  }

  @override
  Future<void> i(String log, String tag, {String? error, String? stack, bool report = false}) {
    // TODO: implement i
    throw UnimplementedError();
  }

  @override
  Future<void> logger(String log, String tag, {Level? level, String? error, String? stack, bool report = false}) {
    // TODO: implement logger
    throw UnimplementedError();
  }

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
  Future<void> setFeishuOutput(String hookId, bool open) {
    // TODO: implement setFeishuOutput
    throw UnimplementedError();
  }

  @override
  Future<void> setFileOutput(bool open) {
    // TODO: implement setFileOutput
    throw UnimplementedError();
  }

  @override
  Future<void> t(String log, String tag, {String? error, String? stack, bool report = false}) {
    // TODO: implement t
    throw UnimplementedError();
  }

  @override
  Future<void> w(String log, String tag, {String? error, String? stack, bool report = false}) {
    // TODO: implement w
    throw UnimplementedError();
  }


}

void main() {
  final HzloggerPlatform initialPlatform = HzloggerPlatform.instance;

  test('$MethodChannelHzlogger is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHzlogger>());
  });

  test('getPlatformVersion', () async {
    Hzlogger hzloggerPlugin = Hzlogger();
    MockHzloggerPlatform fakePlatform = MockHzloggerPlatform();
    HzloggerPlatform.instance = fakePlatform;

    expect(await hzloggerPlugin.getPlatformVersion(), '42');
  });
}
