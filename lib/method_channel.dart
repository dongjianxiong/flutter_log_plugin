import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hz_log_plugin/platform_interface.dart';

import 'level.dart';

/// An implementation of [HzLogPlatform] that uses method channels.
class MethodChannelHzLog extends HzLogPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hz_log_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> log(String content, String tag, Level? level,
      {String? error, String? stack, bool report = false}) async {
    var params = {
      "content": content,
      "tag": tag,
      "level": level?.value,
      "error": error ?? "",
      "stack": stack ?? "",
      "report": report
    };
    print(params);
    await methodChannel.invokeMethod('log', params);
  }

  @override
  Future<void> setExtra(String key, String? value) async {
    var params = {"key": key, "value": value};
    await methodChannel.invokeMethod<bool>('setExtra', params);
  }

  @override
  Future<void> setCallbackOutput(bool open) async {
    await methodChannel.invokeMethod('setCallbackOutput', {"open": open});
  }

  @override
  Future<void> setFileOutput(bool open) async {
    await methodChannel.invokeMethod('setFileOutput', {'open': open});
  }

  @override
  Future<void> setFeishuOutput(
      String hookId, bool open, String projectId, String logStoreId) async {
    var params = {"hookId": hookId, "open": open, "projectId": projectId, "logStoreId": logStoreId};
    await methodChannel.invokeMethod('setFeishuOutput', params);
  }

  @override
  Future<void> openLogcat(bool open) async {
    await methodChannel.invokeMethod('openLogCat', {'open': open});
  }
}
