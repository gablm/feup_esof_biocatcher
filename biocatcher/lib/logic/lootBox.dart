import 'dart:math';

Random random = Random();

List<int> allAnimals = [0, 1, 2];
List<int> legendaryAnimals = [0, 1, 2];
List<int> epicAnimals = [0, 1, 2];
List<int> rareAnimals = [0, 1, 2];
List<int> commonAnimals = [0, 1, 2];

class LootBox {
  late String name;
  late int price;
  late List<double> weights;

  LootBox(this.name, this.price, this.weights);

  int weightedProb() {
    double totalWeight = weights.reduce((a, b) => a + b);
    double p = random.nextDouble() * totalWeight;
    double runningTotal = 0;
    for (int i = 0; i < weights.length; i++) {
      runningTotal += weights[i];
      if (p < runningTotal) return i;
    }

    // code never reached, returning last tier as failsafe
    return weights.length - 1;
  }

  int grabFromTier(int tier) {
    int animal = 101; // placeholder number
    late int randomIndex;
    switch(tier) {
      case 0:
        randomIndex = random.nextInt(legendaryAnimals.length);
        animal = legendaryAnimals[randomIndex];
        break;
      case 1:
        randomIndex = random.nextInt(epicAnimals.length);
        animal = epicAnimals[randomIndex];
        break;
      case 2:
        randomIndex = random.nextInt(rareAnimals.length);
        animal = rareAnimals[randomIndex];
        break;
      case 3:
        randomIndex = random.nextInt(commonAnimals.length);
        animal = commonAnimals[randomIndex];
        break;
    }
    return animal;
  }
}


