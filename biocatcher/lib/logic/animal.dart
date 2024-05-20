enum ConservationStatus {
  extinct,
  extinctWild,
  criticallyEndangered,
  endangered,
  vulnerable,
  nearThreatened,
  conversationDependent,
  leastConcern,
  dataDeficient,
  notEvaluated
}

class AnimalStats {
  AnimalStats(Map<String, dynamic> map) {
    baseAtk = map["baseAtk"].toDouble();
    baseCritDmg = map["baseCritDmg"].toDouble();
    baseHp = map["baseHp"].toDouble();
    baseCritRate = map["baseCritRate"].toDouble();
    scalingHp = map["scalingHp"].toDouble();
    scalingAtk = map["scalingAtk"].toDouble();
    scalingCritDmg = map["scalingCritDmg"].toDouble();
    scalingCritRate = map["scalingCritRate"].toDouble();
  }

  double baseHp = 0;
  double baseAtk = 0;
  double baseCritRate = 0;
  double baseCritDmg = 0;
  double scalingHp = 0;
  double scalingAtk = 0;
  double scalingCritDmg = 0;
  double scalingCritRate = 0;

  double getActualHp(double level) => baseHp + scalingHp * (level - 1);
  double getActualAtk(double level) => baseAtk + scalingAtk * (level - 1);
  double getActualCritRate(double level) => baseCritRate + scalingCritRate * (level - 1);
  double getActualCritDmg(double level) => baseCritDmg + scalingCritDmg * (level - 1);
}

class Animal {
  Animal(Map<String, dynamic> map) {
    name = map["name"];
    scientificName = map["scientificName"];
    pictureUri = map["pictureUri"];
    conservationStatus = ConservationStatus.values[map["conservationStatus"]];
    avgWeight = map["avgWeight"].toDouble();
    avgLongevity = map["avgLongevity"].toDouble();
    origin = map["origin"];
    description = map["description"];
    region = map["region"];
    stats = AnimalStats(map["stats"]);
  }

  static Map<String, Animal> animalCollection = {};

  late String name;
  late String scientificName;
  late String pictureUri;
  late ConservationStatus conservationStatus;
  late double avgWeight;
  late double avgLongevity;
  late String origin;
  late String description;
  late String region;
  late AnimalStats stats;
}
