import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Account {
  static final Account _instance = Account._privateConstructor();
  static Account get instance => _instance;
  late FirebaseAuth _firebaseAuth;

  Account._privateConstructor() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  bool isSignedIn() => _firebaseAuth.currentUser != null;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> changePassword(String password) async =>
      currentUser?.updatePassword(password);
  Future<void> signOut() async => await _firebaseAuth.signOut();

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signInWithTwitter() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();
    await _firebaseAuth.signInWithProvider(twitterProvider);
  }

  Future<void> signInWithEmailAndPassword(
          String email, String password) async =>
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

  Future<void> linkGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    currentUser?.linkWithCredential(credential);
  }

  Future<void> linkTwitter() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();
    currentUser?.linkWithProvider(twitterProvider);
  }

  Future<void> linkPhone(String phoneNumber) async {
    currentUser?.linkWithPhoneNumber(phoneNumber);
  }
}
