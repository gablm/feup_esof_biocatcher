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
    ownedAnimalsCards = map["cards"];
  }

  late String nickname;
  late String handle;
  late String picture;
  int _coins = 0;
  double _level = 0;
  late FirebaseFirestore _firestore;

  // owned animals => (string animalId, double level)
  late Map<String, dynamic> ownedAnimals;
  late Map<String, dynamic> ownedAnimalsCards;

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

  Future<void> reloadAccountData() async {
    var res = _firestore.collection("profiles")
        .doc(Account.instance.userId);
    var map = (await res.get()).data();
    if (map == null) return;

    nickname = map["nickname"];
    handle = map["handle"];
    _coins = map["coins"];
    _level = map["level"].toDouble();
    picture = map["picture"];
    ownedAnimals = map["animals"];
    ownedAnimalsCards = map["cards"];
  }
  
  Future<void> removeAnimal(String id) async {
    var res = _firestore.collection("profiles")
        .doc(Account.instance.userId);
    var resData = (await res.get()).data();
    if (resData == null) return;
    resData["animals"].remove(id);
    resData["cards"].remove(id);
    res.update(resData);
    ownedAnimals = resData["animals"];
    ownedAnimalsCards = resData["cards"];
  }

  Future<void> addAnimal(String id, double level) async {
    var res = _firestore.collection("profiles").doc(Account.instance.userId);
    var resData = (await res.get()).data();
    if (resData == null) return;

    // Update the animal's level regardless of whether it already exists
    resData["animals"][id] = level;

    // Update the Firestore document with the modified animal data
    await res.update(resData);

    // Update the local ownedAnimals map
    ownedAnimals = resData["animals"];
  }

  Future<void> setAnimalCards(String id, int cards) async {
    var res = _firestore.collection("profiles").doc(Account.instance.userId);
    var resData = (await res.get()).data();
    if (resData == null) return;

    resData["cards"][id] = cards;

    // Update the Firestore document with the modified animal data
    await res.update(resData);

    // Update the local ownedAnimals map
    ownedAnimalsCards = resData["cards"];
  }

  static Future<User?> newUser(FirebaseFirestore firestore, String userId,
      String nickname, String handle) async {
    var data = {
      "nickname": nickname,
      "handle": handle,
      "coins": 0,
      "level": 0,
      "picture": "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png",
      "animals": {},
      "cards": {}
    };
    var res = firestore.collection("profiles").doc(userId);
    if ((await res.get()).exists) return null;
    res.set(data);
    return User(firestore, data);
  }
}