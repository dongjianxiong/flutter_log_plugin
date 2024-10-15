import 'package:flutter/material.dart';
import 'package:hz_log_plugin/hz_log_plugin.dart';

class LogLevelDropdownWidget extends StatefulWidget {
  const LogLevelDropdownWidget({super.key});

  @override
  _LogDropdownWidgetState createState() => _LogDropdownWidgetState();
}

class _LogDropdownWidgetState extends State<LogLevelDropdownWidget> {
  // 日志级别的选项
  // final List<String> _logLevels = ['All', 'Trace', 'Debug', 'Info', 'Warning', 'Error', 'Fatal'];
  final List<HzLevel> _logLevels = HzLevel.values;
  HzLevel? _selectedLogLevel;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<HzLevel>(
      hint: const Text('设置日志级别'),
      value: _selectedLogLevel,
      items: _logLevels.map((HzLevel value) {
        return DropdownMenuItem<HzLevel>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (HzLevel? newValue) {
        setState(() {
          _selectedLogLevel = newValue;
          HzLog.setLogLevel(newValue!);
        });
      },
    );
  }
}
