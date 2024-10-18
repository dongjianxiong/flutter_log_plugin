import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hz_log_plugin/hz_log.dart';

class HzLogViewerPage extends StatefulWidget {
  const HzLogViewerPage({super.key});

  @override
  _LogViewerPageState createState() => _LogViewerPageState();
}

class _LogViewerPageState extends State<HzLogViewerPage> {
  List<String> logFiles = [];
  List<bool> isExpandedList = []; // 用于保存每个日志项的展开状态
  List<bool> isSelectedList = []; // 用于保存每个日志项的选择状态

  @override
  void initState() {
    super.initState();
    _getLogFiles();
  }

  // 获取日志文件内容
  Future<void> _getLogFiles() async {
    try {
      final String allLogs = await HzLog.getLogFiles();
      setState(() {
        // 将获取到的日志内容按文件拆分，并将最新日志放到最前面
        if (allLogs.isNotEmpty) {
          logFiles = allLogs.split('\n\n').reversed.toList();
          if (logFiles.isNotEmpty) {
            if (logFiles.first.isEmpty) {
              logFiles.removeAt(0);
            }
            if (logFiles.last.isEmpty) {
              logFiles.removeLast();
            }
          }
          isExpandedList = List<bool>.filled(logFiles.length, false); // 初始化展开状态
          isSelectedList = List<bool>.filled(logFiles.length, false); // 初始化选择状态
        }
      });
    } on PlatformException catch (e) {
      print("Failed to get log files: ${e.message}");
    }
  }

  // 复制选中的日志
  void _copySelectedLogs() {
    final selectedLogs = logFiles
        .asMap()
        .entries
        .where((entry) => isSelectedList[entry.key])
        .map((entry) => entry.value)
        .join('\n\n');

    if (selectedLogs.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: selectedLogs));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('选中的日志已复制到剪贴板')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有选中的日志')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日志记录(${logFiles.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copySelectedLogs, // 点击复制按钮
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: logFiles.length,
        itemBuilder: (context, index) {
          final logMap = _parseLog(index);
          return Card(
            child: Column(
              children: [
                ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  childrenPadding: const EdgeInsets.all(0),
                  title: CheckboxListTile(
                    contentPadding: const EdgeInsets.all(0),
                    value: isSelectedList[index],
                    onChanged: (bool? value) {
                      setState(() {
                        isSelectedList[index] = value ?? false; // 切换选择状态
                      });
                    },
                    title: Text(
                      logMap['title'] ?? 'Log File ${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ), // 隐藏ExpansionTile的标题
                  subtitle: isExpandedList[index]
                      ? null // 展开时不显示副标题
                      : Text(
                          logMap['subtitle'] ?? '',
                          maxLines: 1, // 限制显示一行
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                        ),
                  children: [
                    Text(logFiles[index]),
                  ],
                  onExpansionChanged: (isExpanded) {
                    setState(() {
                      isExpandedList[index] = isExpanded; // 更新展开状态
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 正则表达式提取时间作为标题，时间后的部分作为副标题
  Map<String, String> _parseLog(int index) {
    // 匹配时间部分和其后的日志内容
    final RegExp logRegExp =
        RegExp(r"\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3})\](.*)"); // 匹配时间及其后的内容
    final Match? match = logRegExp.firstMatch(logFiles[index]);

    return {
      'title': match?.group(1) ?? 'Log File ${index + 1}', // 只提取时间作为标题
      'subtitle': match?.group(2)?.trim() ?? '', // 提取时间后面的内容作为副标题
    };
  }
}
