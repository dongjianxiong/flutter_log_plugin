import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hz_log_plugin/hz_log.dart';
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
  Future<void> log(String message, String? tag, HzLevel? level, String date,
      {String? error, String? stack, bool report = false}) async {
    var params = {
      "message": message,
      "tag": tag,
      "level": level?.value,
      'date': date,
      "error": error ?? "",
      "stack": stack ?? "",
      "report": report
    };
    await methodChannel.invokeMethod('log', params);
  }

  @override
  Future<void> setLogLevel(HzLevel level) async {
    await methodChannel.invokeMethod('setLogLevel', {'level': level.value});
  }

  @override
  Future<void> setPrefix(String prefix) async {
    await methodChannel.invokeMethod('setPrefix', {'prefix': prefix});
  }

  @override
  Future<void> reportLog(String content, String? tag, HzLevel? level, String date,
      {String? error, String? stack}) async {
    var params = {
      'content': content,
      'tag': tag,
      'level': level?.value,
      'formattedDate': date,
      'error': error ?? '',
      'stack': stack ?? '',
    };
    await methodChannel.invokeMethod('reportLog', params);
  }

  @override
  Future<void> setExtra(String key, String? value) async {
    var params = {"key": key, "value": value};
    await methodChannel.invokeMethod<bool>('setExtra', params);
  }

  // 设置最大字符个数，最大值为8000
  @override
  Future<void> setMaxServerLogSize(int maxSize) async {
    try {
      await methodChannel.invokeMethod('setMaxServerLogSize', {'maxSize': maxSize});
    } on PlatformException catch (e) {
      HzLog.w('Failed to set max server log size: ${e.message}');
    }
  }

  // 设置最大合并日志个数
  @override
  Future<void> setMaxServerLogCount(int logCount) async {
    try {
      await methodChannel.invokeMethod('setMaxServerLogCount', {'maxCount': logCount});
    } on PlatformException catch (e) {
      HzLog.w('Failed to set max server log count: ${e.message}');
    }
  }

  // 设置最大日志上传间隔
  @override
  Future<void> setMaxServerLogInterval(int timeInterval) async {
    try {
      await methodChannel.invokeMethod('setMaxServerLogInterval', {'maxInterval': timeInterval});
    } on PlatformException catch (e) {
      HzLog.w('Failed to set max server log interval: ${e.message}');
    }
  }

  @override
  Future<void> setCallbackOutput(bool open) async {
    await methodChannel.invokeMethod('setCallbackOutput', {"open": open});
  }

  @override
  Future<void> enableFileOutput(bool enable) async {
    await methodChannel.invokeMethod('enableFileOutput', {'enable': enable});
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

  @override
  Future<void> clearLog() async {
    await methodChannel.invokeMethod('clearLog');
  }

  @override
  Future<String> getLogFiles() async {
    final log = await methodChannel.invokeMethod('getLogFiles');
    if (log == null) {
      return 'null';
    }
    if (log is! String) {
      return log.toString();
    }
    return log;
  }
}
