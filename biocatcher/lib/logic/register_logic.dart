import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bio_catcher/logic/user.dart' as logic;

class RegisterLogic {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(String name, String email, String password, String handle) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String userId = userCredential.user?.uid ?? "";

      Map<String, dynamic> userData = {
        'nickname': name.trim(),
        'handle': handle.trim(),
        'coins': 600,
        'level': 1,
        'picture': 'https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png',
        'cards': {},
      };

      await _firestore.collection('profiles').doc(userId).set(userData);

      logic.User(_firestore, userData);

    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
