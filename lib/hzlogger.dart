import 'hzlogger_platform_interface.dart';
import 'level.dart';

class Hzlogger {
  Future<String?> getPlatformVersion() {
    return HzloggerPlatform.instance.getPlatformVersion();
  }

  Future<void> logger(String tag,String log,
      {Level? level, String? error, String? stack, bool report = false}) async {
    await HzloggerPlatform.instance.logger(log, tag,
        level, error: error, stack: stack, report: report);
  }

  Future<void> setExtra(String key, String? value) async {
    await HzloggerPlatform.instance.setExtra(key, value);
  }

  Future<void> setCallbackOutput(bool open) async {
    await HzloggerPlatform.instance.setCallbackOutput(open);
  }

  Future<void> setFileOutput(bool open) async {
    await HzloggerPlatform.instance.setFileOutput(open);
  }

  Future<void> openLogcat(bool open) async {
    await HzloggerPlatform.instance.openLogcat(open);
  }

  Future<void> setFeishuOutput(String hookId, bool open,String projectId,String logStoreId) async {
    await HzloggerPlatform.instance.setFeishuOutput(hookId, open,projectId,logStoreId);
  }

  Future<void> T(String tag,String log,
      {String? error, String? stack, bool report = false}) async {
    await HzloggerPlatform.instance.logger(log, tag,
        Level.trace, error: error, stack: stack, report: report);
  }

  Future<void> D(String tag,String log,
      {String? error, String? stack, bool report = false}) async {
    await HzloggerPlatform.instance.logger(log, tag,
        Level.debug, error: error, stack: stack, report: report);
  }

  Future<void> I(String tag,String log,
      {String? error, String? stack, bool report = false}) async {
    await HzloggerPlatform.instance.logger(log, tag,
        Level.info, error: error, stack: stack, report: report);
  }

  Future<void> W(String tag,String log,
      {String? error, String? stack, bool report = false}) async {
    await HzloggerPlatform.instance.logger(log, tag,
        Level.warning, error: error, stack: stack, report: report);
  }

  Future<void> E(String tag,String log,
      {String? error, String? stack, bool report = false}) async {
    await HzloggerPlatform.instance.logger(log, tag,
        Level.error, error: error, stack: stack, report: report);
  }
}
