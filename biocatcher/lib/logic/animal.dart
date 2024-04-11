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
    baseAtk = map["baseAtk"];
    baseCritDmg = map["baseCritDmg"];
    baseHp = map["baseHp"];
    baseCritRate = map["baseCritRate"];
    scalingHp = map["scalingHp"];
    scalingAtk = map["scalingAtk"];
    scalingCritDmg = map["scalingCritDmg"];
    scalingCritRate = map["scalingCritRate"];
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
    conservationStatus = ConservationStatus.values[map["conservationStatus"]];
    avgWeight = map["avgWeight"];
    avgLongevity = map["avgLongevity"];
    origin = map["origin"];
    description = map["description"];
    stats = AnimalStats(map["stats"]);
  }

  late String name;
  late String scientificName;
  late ConservationStatus conservationStatus;
  late double avgWeight;
  late double avgLongevity;
  late String origin;
  late String description;
  late AnimalStats stats;
}
