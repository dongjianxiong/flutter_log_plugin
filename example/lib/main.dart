import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hz_log_plugin/hz_log_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _hzLogPlugin = HzLog();
  static const platform = MethodChannel('hzlogger');

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _setListeners();
  }

  void _setListeners() async {
    // 监听来自Android的消息
    platform.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    try {
      if (call.method == 'outputCallback') {
        final eventMap = call.arguments;
        final event = OutPutEvent.fromJson(eventMap);
      } else {
        throw PlatformException(
            code: 'Unimplemented', details: 'Method not supported on this platform.');
      }
    } catch (e) {
      print('$e');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _hzLogPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    HzLog().i("????测试中", "tag", report: true);
                  },
                  child: Container(
                      color: Colors.blue, width: 120, height: 30, child: const Text('普通打印')),
                ),
                GestureDetector(
                  onTap: () {
                    HzLog().setExtra("设备信息", "5876876113-12313144687654-24567");
                  },
                  child: Container(
                      color: Colors.green, width: 120, height: 30, child: const Text('设置额外参数')),
                ),
                GestureDetector(
                  onTap: () {
                    HzLog().setFeishuOutput("abc094d5-058d-492a-8244-5430260afc12", true,
                        "proj-xtrace-6311756af3b4f6b5d1720412b48f646-cn-hangzhou", "logstore-rum");
                  },
                  child: Container(
                      color: Colors.orange, width: 120, height: 30, child: const Text('打开飞书接收')),
                ),
                GestureDetector(
                  onTap: () {
                    HzLog().setFeishuOutput("abc094d5-058d-492a-8244-5430260afc12", false, "", "");
                  },
                  child: Container(
                      color: Colors.pink, width: 120, height: 30, child: const Text('关闭飞书接收')),
                ),
                GestureDetector(
                  onTap: () {
                    HzLog().setFileOutput(true);
                  },
                  child: Container(
                      color: Colors.red, width: 120, height: 30, child: const Text('打开文件接收')),
                ),
                GestureDetector(
                  onTap: () {
                    HzLog().setFileOutput(false);
                  },
                  child: Container(
                      color: Colors.purpleAccent,
                      width: 120,
                      height: 30,
                      child: const Text('关闭文件接收')),
                ),
                GestureDetector(
                  onTap: () {
                    try {
                      throw const FormatException("格式化失误");
                    } catch (e, stack) {
                      HzLog().e("捕获到异常", "tag", error: e.toString(), stack: stack.toString());
                    }
                  },
                  child: Container(
                      color: Colors.amber, width: 120, height: 30, child: const Text('打印异常')),
                ),
                GestureDetector(
                  onTap: () {
                    HzLog().openLogcat(true);
                  },
                  child: Container(
                      color: Colors.brown, width: 120, height: 30, child: const Text('打开logcat')),
                ),
                GestureDetector(
                  onTap: () {
                    HzLog().setCallbackOutput(true);
                  },
                  child: Container(
                      color: Colors.cyan, width: 120, height: 30, child: const Text('开始接收回调')),
                ),
              ],
            ),
          )),
    );
  }
}
