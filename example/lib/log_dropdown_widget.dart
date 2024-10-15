import 'package:flutter/material.dart';
import 'package:hz_log_plugin/hz_log_plugin.dart';

class LogDropdownWidget extends StatefulWidget {
  const LogDropdownWidget({super.key});

  @override
  _LogDropdownWidgetState createState() => _LogDropdownWidgetState();
}

class _LogDropdownWidgetState extends State<LogDropdownWidget> {
  // 日志级别的选项
  final List<String> _logLevels = ['Trace', 'Debug', 'Info', 'Warning', 'Error', 'Fatal'];
  String? _selectedLogLevel;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text('打印日志'),
      value: _selectedLogLevel,
      items: _logLevels.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedLogLevel = newValue;
          _logMessage(newValue);
        });
      },
    );
  }

  // 模拟日志输出
  void _logMessage(String? logLevel) {
    switch (logLevel) {
      case 'Trace':
        HzLog.t(
            'This is a trace log.You can see it in the logcat or file or feishu. I hope you enjoy it!',
            tag: 'Home');
        break;
      case 'Debug':
        HzLog.d('This is a debug log.', tag: 'Login');
        break;
      case 'Info':
        HzLog.i('This is an info log.', tag: 'Logout');
        break;
      case 'Warning':
        try {
          throw const FormatException("格式化失误");
        } catch (e, stack) {
          HzLog.w('This is a warning log.', tag: 'HTTP');
          // HzLog.w("捕获到异常", tag: "tag", error: e.toString(), stack: stack.toString());
        }
        break;
      case 'Error':
        HzLog.e('This is an error log.', tag: 'Trip', error: Error().toString());
        break;
      case 'Fatal':
        HzLog.f('This is a fatal log.', tag: 'Order');
        break;
      default:
        print('No log level selected.');
    }
  }
}
