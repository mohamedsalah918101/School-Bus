class Day {
  String name;
  bool isChecked;
  Day({required this.name, this.isChecked = false});
  void toggleCheck() {
    isChecked = !isChecked;
  }
}