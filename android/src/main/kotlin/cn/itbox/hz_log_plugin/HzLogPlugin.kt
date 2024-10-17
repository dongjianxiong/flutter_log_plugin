package cn.itbox.hz_log_plugin

import android.content.Context
import cn.itbox.klogger.Level
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** HzLogPlugin */
class HzLogPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hz_log_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "log") {
            val log = call.argument<String>("content")
            val tag = call.argument<String>("tag") ?: ""
            val level = call.argument<Int>("level") ?: 1000
            val error = call.argument<String>("error")
            val stack = call.argument<String>("stack")
            val report = call.argument<Boolean>("report") ?: false
            if (log != null) {
                LoggerUtil.getInstance().log(
                    Level.fromInt(level),
                    tag,
                    log,
                    exception = error,
                    stackTrace = stack,
                    report = report
                )
            }
        } else if (call.method == "setExtra") {
            val key = call.argument<String>("key")
            val value = call.argument<String>("value") ?: ""
            if (key != null) {
                LoggerUtil.getInstance().setExtra(key, value)
            }
        } else if (call.method == "setFeishuOutput") {
            val hookId = call.argument<String>("hookId")
            val open = call.argument<Boolean>("open") ?: false
            val projectId = call.argument<String>("projectId") ?: ""
            val logStoreId = call.argument<String>("logStoreId") ?: ""
            if (hookId != null) {
                LoggerUtil.getInstance().changeFeishuOutPut(hookId, open,projectId,logStoreId)
            }
        } else if (call.method == "enableFileOutput") {
            val open = call.argument<Boolean>("enbale") ?: false
            LoggerUtil.getInstance().changeFileOutPut(applicationContext, open)
        } else if (call.method == "setCallbackOutput") {
            val open = call.argument<Boolean>("open") ?: false
            LoggerUtil.getInstance().changeCallbackOutPut(open) { outputEvent ->
                 channel.invokeMethod("outputCallback",outputEvent.toMap())
            }
        } else if (call.method == "openLogCat") {
            val open = call.argument<Boolean>("open") ?: false
            LoggerUtil.getInstance().openLogcat(open)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
