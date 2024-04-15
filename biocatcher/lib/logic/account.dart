import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bio_catcher/logic/user.dart' as logic;

enum AuthType {
  password,
  twitter,
  google,
  phone
}

class Account {
  //#region Properties
  static final Account _instance = Account._privateConstructor();
  static Account get instance => _instance;
  late FirebaseAuth _firebaseAuth;
  late FirebaseFirestore _firestore;
  User? get currentUser => _firebaseAuth.currentUser;
  String get userId => _firebaseAuth.currentUser?.uid ?? "";
  List<UserInfo> get loginMethods => currentUser?.providerData ?? [];
  logic.User? profile;
  //#endregion

  //#region Private Constructor
  Account._privateConstructor() {
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }
  //#endregion

  //#region Misc
  bool isSignedIn() => _firebaseAuth.currentUser != null;
  Future<void> changePassword(String password) async =>
      currentUser?.updatePassword(password);
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    profile = null;
  }

  Future<void> loadUser() async {
    if (!isSignedIn()) return;

    await _firestore.collection("profiles")
        .doc(userId).get()
        .then((value) {
          if (value.data() == null) throw Exception("Invalid user id");
          profile = logic.User(_firestore, value.data()!);
        }
    );
  }
  //#endregion

  //#region Sign-in
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
    await loadUser();
  }

  Future<void> signInWithTwitter() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();
    await _firebaseAuth.signInWithProvider(twitterProvider);
    await loadUser();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    await loadUser();
  }

  //#endregion

  //#region Linking accounts
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
  //#endregion

  void deleteAccount()
  {
    currentUser?.delete();
    profile = null;
  }

  void unlink(AuthType type)
  {
    switch (type)
    {
      case AuthType.twitter:
        currentUser?.unlink("twitter.com");
        break;
      case AuthType.google:
        currentUser?.unlink("google.com");
        break;
      default:
        throw Exception("Invalid unlink type");
    }
  }
}
