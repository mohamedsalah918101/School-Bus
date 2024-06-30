import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  static final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;

  static String verifyId='';

  //To send the OTP to the user
  static Future sendOtp({
    required int Phone,
    required Function errorStep,
    required Function nextStep,
  }) async{
    await _firebaseAuth.verifyPhoneNumber(
      timeout: Duration(seconds: 30),
        phoneNumber: '+20$Phone',
        verificationCompleted: (phoneAuthCredential) async{
          return ;
        },
        verificationFailed: (error) async{
          return ;
        }, codeSent: (verificationId , forceResendingToken) async{
          verifyId = verificationId ;
          nextStep();
    },
        codeAutoRetrievalTimeout: (verificationId) async{
          return;
        }).onError((error, stackTrace) {
          errorStep();
    });
  }

//  verify the otp and login
static Future loginWithOtp({
    required String Otp
})async{
    final cred =PhoneAuthProvider.credential(
        verificationId: verifyId, smsCode: Otp);
    try{
      final user= await _firebaseAuth.signInWithCredential(cred);
      if (user.user!=null){
        return 'Success';
      }
      else {
        return 'error in otp login';
      }
    }
    on FirebaseAuthException catch(e){
      return e.message.toString();
    }
    catch(e){
      return e.toString();
    }
}

//to logout the user
static Future logOut() async {
    await _firebaseAuth.signOut();
}

//check whether the user is logged in or not
static Future<bool> isLoggedIn()async{
    var user = _firebaseAuth.currentUser;
    return user!=null;
}
}