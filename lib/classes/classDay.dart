class Day {
  String name;
  final int weekdayIndex;
  bool isChecked;
  Day({required this.name, required this.weekdayIndex, this.isChecked = false});
  void toggleCheck() {
    isChecked = !isChecked;
  }

}