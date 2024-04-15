import 'dart:async';

import 'package:bio_catcher/logic/eventHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'account.dart';

class User {
  User(FirebaseFirestore firestore, Map<String, dynamic> map) {
    _firestore = firestore;
    nickname = map["nickname"];
    handle = map["handle"];
    _coins = map["coins"];
    _level = map["level"].toDouble();
    picture = map["picture"];
    ownedAnimals = map["animals"];
  }

  late String nickname;
  late String handle;
  late String picture;
  int _coins = 0;
  double _level = 0;
  late FirebaseFirestore _firestore;

  // owned animals => (string animalId, double level)
  late Map<String, dynamic> ownedAnimals;

  void addCoins(int coins) {
    _coins = _coins + coins < 0 ? 0 : _coins + coins;
    EventHandler.updateUserData.add("added coins");
    _setUserField("coins", _coins);
  }

  void addLevel(double xp) {
    _level = xp < 0 ? _level : _level + xp;
    EventHandler.updateUserData.add("added xp");
    _setUserField("level", _level);
  }

  int getCoins() {
    return _coins;
  }

  double getLevel() {
    return _level;
  }
  
  void _setUserField(String key, dynamic value) async {
    await _firestore.collection("profiles")
        .doc(Account.instance.userId)
        .set({key: value}, SetOptions(merge: true));
  }

  Future<void> changeNickname(String nickname) async {
    // find doc in collection users referring to uid and change field nickname
  }

  Future<void> changeHandle(String handle) async {
    // check if repeat
    // same as nickname but field handle
  }
}