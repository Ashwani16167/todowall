enum TaskPriority {
  high, medium, low;
  String get label => name[0].toUpperCase() + name.substring(1);
  int get sortWeight => index;
}
