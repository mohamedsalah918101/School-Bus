import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:school_account/screens/schoolData.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/no_invitation.dart';

import '../main.dart';
import '../supervisor_parent/screens/final_invitation_parent.dart';
import '../supervisor_parent/screens/final_invitation_supervisor.dart';
import '../supervisor_parent/screens/home_parent.dart';
import '../supervisor_parent/screens/map_parent.dart';
import 'homeScreen.dart';
import 'loginScreen.dart';

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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => sharedpref!.getString('id').toString() ==
                            'null' ||
                        sharedpref!.getString('id').toString() == ''
                    ?
                    // AddParents(),
                    LoginScreen()
                    : sharedpref!.getString('type').toString() == 'schooldata'
                        ? sharedpref!.getInt('allData') == 1
                            ? HomeScreen()
                            : SchoolData()
                        : sharedpref!.getString('type').toString() == 'parent'
                            ? sharedpref!.getInt('invit') == 1
                                ? sharedpref!.getInt('invitstate') == 1
                                    ? MapParentScreen()
                                    : FinalAcceptInvitationParent()
                                : sharedpref!.getInt('skip') == 1 ?  MapParentScreen():NoInvitation(selectedImage: 3)
                            : sharedpref!.getInt('invit') == 1
                                ? sharedpref!.getInt('invitstate') == 1
                                    ? HomeForSupervisor()
                                    : FinalAcceptInvitationSupervisor()
                                :  sharedpref!.getInt('skip') == 1 ? HomeForSupervisor() :NoInvitation(selectedImage: 2)));
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
//invit lw mogod--lw gat invite b3d ---lw ft7t invite --otp
