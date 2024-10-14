package cn.itbox.hz_log_plugin

import android.content.Context
import cn.itbox.klogger.KLogger
import cn.itbox.klogger.Level
import cn.itbox.klogger.output.FeishuOutput
import cn.itbox.klogger.output.FileOutput
import cn.itbox.klogger.output.OutputEvent

class LoggerUtil private constructor() {

    companion object {
        @Volatile
        private var instance: LoggerUtil? = null

        fun getInstance(): LoggerUtil {
            if (instance == null) {
                synchronized(LoggerUtil::class.java) {
                    if (instance == null) {
                        instance = LoggerUtil()
                    }
                }
            }
            return instance!!
        }
    }

    fun log(
        level: Level,
        message: Any,
        tag: String,
        exception: String? = null,
        stackTrace: String? = null,
        report: Boolean = false
    ) {
        KLogger.log(level, tag,message, exception = exception, stackTrace = stackTrace,report = report)
    }

    fun setExtra(key: String, value: String) {
        KLogger.addExtraData(key,value)
    }

    fun openLogcat(open: Boolean){
        KLogger.setUseLogcat(open)
    }

    fun changeFeishuOutPut(hookId: String,open:Boolean,projectId:String,logStoreId:String){
        val outputManager = KLogger.getOutputManager()
        if(open){
            outputManager.replaceOutput(FeishuOutput(hookId,  mapOf(
                "projectId" to projectId,
                "logStoreId" to logStoreId,
            )))
        }else{
            outputManager.removeOutput(FeishuOutput::class.java)
        }
    }

    fun changeFileOutPut(context: Context, open:Boolean){
        val outputManager = KLogger.getOutputManager()
        if(open){
            outputManager.replaceOutput(FileOutput(context))
        }else{
            outputManager.removeOutput(FileOutput::class.java)
        }
    }

    fun changeCallbackOutPut(open:Boolean,callback: (OutputEvent) -> Unit){
        val outputManager = KLogger.getOutputManager()
        if(open){
            outputManager.replaceOutput(CallbackOutput(callback))
        }else{
            outputManager.removeOutput(CallbackOutput::class.java)
        }
    }
}