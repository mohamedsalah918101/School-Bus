import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
bool isSwitched = false;
class CustomSwitch extends StatefulWidget {
  // bool isSwitched;
  CustomSwitch({
    super.key,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  // bool isSwitched = false;
  late SharedPreferences _prefs;

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = _prefs.getBool('switch_state') ?? false;
    });
  }
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        isSwitched = !isSwitched;
        _prefs.setBool('switch_state', isSwitched);
        setState(() {});
        // print(isSwitched);
      },
      child: Container(
        width: 42.30,
        height: 23.07,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                width: 42.30,
                height: 23.07,
                child: Stack(
                  children: [
                    Container(
                      width: 42.30,
                      height: 23.07,
                      decoration: ShapeDecoration(
                        color: isSwitched
                            ? const Color(0xFF442B72)
                            : const Color(0xffC8C8C8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.54),
                        ),
                      ),
                    ),
                    Positioned(
                      left: isSwitched ? 23.07 : 3,
                      top: isSwitched ? 3.85 : 4,
                      child: Container(
                        width: 15.38,
                        height: 15.38,
                        decoration: ShapeDecoration(
                          color: isSwitched ? Colors.white : const Color(0xff505050),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11.54),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
