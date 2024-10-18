import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hz_log_plugin/hz_log_plugin.dart';

class LogDropdownWidget extends StatefulWidget {
  const LogDropdownWidget({super.key});

  @override
  _LogDropdownWidgetState createState() => _LogDropdownWidgetState();
}

class _LogDropdownWidgetState extends State<LogDropdownWidget> {
  // 日志级别的选项
  final List<String> _logLevels = ['Trace', 'Debug', 'Info', 'Warning', 'Error', 'Fatal', '压测'];
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
        HzLog.w('This is a warning log.', tag: 'HTTP');
        break;
      case 'Error':
        try {
          throw const FormatException("格式化失误");
        } catch (e, stack) {
          HzLog.e('This is an error log.', tag: 'Trip', error: e.toString());
        }
        break;
      case 'Fatal':
        HzLog.f('This is a fatal log.', tag: 'Order');
        break;
      case '压测':
        for (int i = 0; i < 1000; i++) {
          print("这是用print打印的日志信息");
          Random random = Random();
          // 生成 0 到 5 之间的随机数（包含 0，不包含 6）
          int randomNumber = random.nextInt(6);
          print('随机数: $randomNumber');
          switch (randomNumber) {
            case 0:
              HzLog.t('This is a trace log.', tag: 'Home');
              break;
            case 1:
              HzLog.d('This is a debug log.', tag: 'Login');
              break;
            case 2:
              HzLog.i('This is an info log.', tag: 'Logout');
              break;
            case 3:
              HzLog.w('This is a warning log.', tag: 'HTTP');
              break;
            case 4:
              try {
                throw const FormatException("格式化失误");
              } catch (e, stack) {
                HzLog.e(
                    'This is a Error log.You can see it in the logcat or file or feishu. I hope you enjoy it!',
                    tag: 'Order',
                    stackLimit: 3,
                    error: 'Error');
              }
              break;
            case 5:
              HzLog.f(
                  'This is a Fatal log.You can see it in the logcat or file or feishu. I hope you enjoy it!',
                  tag: 'Order',
                  stackLimit: 5,
                  error: 'Error');
              break;
          }
        }
        break;
      default:
        print('No log level selected.');
    }
  }
}
