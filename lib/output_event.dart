class OutPutEvent {
  final List<String> lines;
  final Origin origin;
  final String tag;
  final String? exception;
  final String? stack;
  final Map<dynamic, dynamic> extraData;
  final bool useLogCat;

  OutPutEvent({
    required this.lines,
    required this.origin,
    required this.tag,
    this.exception,
    this.stack,
    this.extraData = const {},
    this.useLogCat = false,
  });

  factory OutPutEvent.fromJson(Map<dynamic, dynamic> json) {
    final lines = List<String>.from(json['lines'] ?? []);
    final origin = Origin.fromJson(json['origin']);
    final tag = json['tag'] ?? '';
    final exception = json['exception'] ?? '';
    final stack = json['stack'] ?? '';
    final extraData = Map<dynamic, dynamic>.from(json['extraData'] ?? {});
    final useLogCat = json['useLogCat'] ?? false;
    return OutPutEvent(
      lines: lines,
      origin: origin,
      tag: tag,
      exception: exception,
      stack: stack,
      extraData: extraData,
      useLogCat: useLogCat,
    );
  }
}

class Origin {
  final int level;
  final String message;
  final num time;

  Origin({required this.level, required this.message, required this.time});

  factory Origin.fromJson(Map<dynamic, dynamic> json) {
    return Origin(
      level: json['level'],
      message: json['message'],
      time: json['time'],
    );
  }
}
