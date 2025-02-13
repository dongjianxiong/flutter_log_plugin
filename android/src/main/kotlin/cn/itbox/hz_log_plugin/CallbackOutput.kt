package cn.itbox.hz_log_plugin

import cn.itbox.klogger.output.LogOutput
import cn.itbox.klogger.output.OutputEvent

class CallbackOutput(private val callback: (OutputEvent) -> Unit): LogOutput (){
    override fun onInit() {
    }

    override fun output(event: OutputEvent) {
        callback(event)
    }
}