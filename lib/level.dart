enum HzLevel {
  all(0),
  trace(1000),
  debug(2000),
  info(3000),
  warning(4000),
  error(5000),
  fatal(6000),
  ;

  final int value;
  const HzLevel(this.value);
}
