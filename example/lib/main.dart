import 'package:alibabacloud_rum_flutter_plugin/alibabacloud_rum_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:hz_log_plugin/hz_log_plugin.dart';

import 'log_dropdown_widget.dart';
import 'log_level_dropdown_widget.dart';

void main() {
  AlibabaCloudRUM().start(
    const MyApp(),
    beforeRunApp: () async {
      WidgetsFlutterBinding.ensureInitialized();
      AlibabaCloudRUM().setUserName('Driver');
    },
  );
  AlibabaCloudRUM().onRUMErrorCallback((error, stack, isAsync) {
    // FlutterErrorDetails details = FlutterErrorDetails(exception: error ?? Error(), stack: stack);
    HzLog.e('A flutter exception log', tag: 'error', error: error.toString(), stackTrace: stack);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeLogging();
  }

  void _initializeLogging() {
    HzLog.setPrefix("Driver");
    HzLog.enableFileOutput(true);
    HzLog.setExtra('userId', 'D1674567263746WUETWUU');
    HzLog.setExtra('vimId', 'D1674567263746WUETWUuw7382643');
    HzLog.setMaxServerLogCount(5);
    HzLog.setMaxServerLogSize(2000);
    HzLog.setMaxServerLogInterval(2);
    HzLog.d('初始化Flutter APP', tag: 'init');
    // 设置其他初始化逻辑
  }

  // 可复用的 ElevatedButton 创建方法
  Widget _buildElevatedButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 30),
        primary: color,
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plugin Example App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Builder(builder: builder),
    );
  }

  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin Example App'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const LogLevelDropdownWidget(),
            const LogDropdownWidget(),
            _buildElevatedButton(
              text: '设置额外参数',
              onPressed: () {
                HzLog.setExtra("设备信息", "5876876113-12313144687654-24567");
              },
              color: Colors.green,
            ),
            _buildElevatedButton(
              text: '打开飞书接收',
              onPressed: () {
                HzLog.setFeishuOutput(
                  "abc094d5-058d-492a-8244-5430260afc12",
                  true,
                  "proj-xtrace-6311756af3b4f6b5d1720412b48f646-cn-hangzhou",
                  "logstore-rum",
                );
              },
              color: Colors.orange,
            ),
            _buildElevatedButton(
              text: '关闭飞书接收',
              onPressed: () {
                HzLog.setFeishuOutput("abc094d5-058d-492a-8244-5430260afc12", false, "", "");
              },
              color: Colors.pink,
            ),
            _buildElevatedButton(
              text: '打开文件接收',
              onPressed: () {
                HzLog.enableFileOutput(true);
              },
              color: Colors.red,
            ),
            _buildElevatedButton(
              text: '关闭文件接收',
              onPressed: () {
                HzLog.enableFileOutput(false);
              },
              color: Colors.purpleAccent,
            ),
            _buildElevatedButton(
              text: '打印异常',
              onPressed: () {
                try {
                  throw const FormatException("格式化失误");
                } catch (e) {
                  HzLog.e("捕获到异常", tag: "tag", error: e.toString());
                }
              },
              color: Colors.amber,
            ),
            _buildElevatedButton(
              text: '打开logcat',
              onPressed: () {
                HzLog.openLogcat(true);
              },
              color: Colors.brown,
            ),
            _buildElevatedButton(
              text: '开始接收回调',
              onPressed: () {
                HzLog.setCallbackOutput(true);
              },
              color: Colors.cyan,
            ),
            _buildElevatedButton(
              text: '清理日志',
              onPressed: () {
                HzLog.clearLog();
              },
              color: Colors.grey,
            ),
            _buildElevatedButton(
              text: '查看日志',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HzLogViewerPage()),
                );
              },
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
