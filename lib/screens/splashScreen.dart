import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:school_account/screens/schoolData.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/no_invitation.dart';

import '../main.dart';
import '../supervisor_parent/screens/accept_invitation_parent.dart';
import '../supervisor_parent/screens/accept_invitation_supervisor.dart';
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
                    : openPage()));
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

  StatefulWidget openPage() {
    if(sharedpref!.getString('type').toString() == 'schooldata'){
    if(sharedpref!.getInt('allData') == 1)
    return HomeScreen();
        else return SchoolData();
    }else if(sharedpref!.getString('type').toString() == 'parent'){
      if( sharedpref!.getInt('invit') == 0 ){
        if(sharedpref!.getInt('skip') == 1)
          return HomeParent();
            else
          return NoInvitation(selectedImage: 3);

      }else{
        if(sharedpref!.getInt('invitstate') == 1){
          if (sharedpref!.getInt('address') == 1)
          return  HomeParent();
          else
            return  MapParentScreen();


        }
        else
          return  AcceptInvitationParent();
      }
    }else{
      if( sharedpref!.getInt('invit') == 0 ){
        if(sharedpref!.getInt('skip') == 1)
          return  HomeForSupervisor();
        else
          return   NoInvitation(selectedImage: 2);

      }else{
        if(sharedpref!.getInt('invitstate') == 1)
          return   HomeForSupervisor();
        else
          return   AcceptInvitationSupervisor();
      }
    }





  }
}
//invit lw mogod--lw gat invite b3d ---lw ft7t invite --otp
