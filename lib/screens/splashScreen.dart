import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

import 'loginScreen.dart';

class SplashScreen extends StatefulWidget{
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
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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
            "assets/imgs/school/render-162-1088-plugin-IBW5F4ayzqXb-Qlw7fCdfGx8JoucpToH8M.gif",
          ),
          controller: controller,
          repeat: ImageRepeat.noRepeat,
        ),
      ),

      // body: Stack(
      //   children: [
      //     Center(
      //       child: Image.asset(
      //         'assets/images/Layer_1.png',
      //         width: 290,
      //       ),
      //     ),
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Center(
      //           child: FadeAndTranslate(
      //             duration: Duration(milliseconds: 1500),
      //             visible: true,
      //             autoStart: true,
      //             translate: Offset(0, height!),
      //             child: Image.asset(
      //               'assets/images/animated.png',
      //               width: 200,
      //             ),
      //           ),
      //         ),
      //         SizedBox(
      //           height: 60,
      //         )
      //       ],
      //     ),
      //   ],
      // )
      //
    );
  }
}