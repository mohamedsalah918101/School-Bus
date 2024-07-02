import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStatusService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> setUserStatus(String status) async {
    String? userId = _auth.currentUser?.uid;

    if (userId != null) {
      await _fireStore.collection('users').doc(userId).update({
        'status': status,
      });
    }
  }

  void setOnline(String userId) {
    _fireStore.collection('users').doc(userId).update({'status': 'online'});
    setUserStatus('Online');
  }

  void setOffline(String userId) {
    _fireStore.collection('users').doc(userId).update({'status': 'offline'});
    setUserStatus('Offline');
  }
}