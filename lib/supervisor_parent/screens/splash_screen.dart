import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import '../../screens/loginScreen.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double? height;
  late FlutterGifController controller;

  @override
  void initState() {
    super.initState();
    controller = FlutterGifController(vsync: this);
    Future.delayed(const Duration(milliseconds: 900), () {
      controller.animateTo(
        16,
        duration: const Duration(milliseconds: 900),
      );
    });
    controller.addListener(() {
      if (controller.isCompleted) {
        controller.stop();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) =>
                  // TrackHaveData()));
        // TrackScreen()));
               LoginScreen()));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 14;

    return Scaffold(
      backgroundColor: const Color(0xff442B72),
      body: Center(
        child: GifImage(
          width: 200,
          height: 200,
          image: const AssetImage(
            "assets/images/render-162-1088-plugin-IBW5F4ayzqXb-Qlw7fCdfGx8JoucpToH8M.gif",
          ),
          controller: controller,
          repeat: ImageRepeat.noRepeat,
        ),
      ),

    );
  }
}
