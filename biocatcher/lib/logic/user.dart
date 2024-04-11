import 'package:bio_catcher/logic/account.dart';

class User {
  User(Map<String, dynamic> map) {
    nickname = map["nickname"];
    handle = map["handle"];
    ownedAnimals = map["animals"];
  }

  late String nickname;
  late String handle;
  late Map<String, double> ownedAnimals;
  // owned animals => (string animalId, double level)
  // firebase store get for level and coin
  // level and coins should always be retrieved from db

  Future<void> changeNickname(String nickname) async {
    // find doc in collection users referring to uid and change field nickname
  }

  Future<void> changeHandle(String handle) async {
    // check if repeat
    // same as nickname but field handle
  }
}