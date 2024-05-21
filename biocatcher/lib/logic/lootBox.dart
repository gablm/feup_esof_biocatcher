import 'dart:math';

Random random = Random();

List<int> allAnimals = List.generate(100, (index) => index + 1);
List<int> legendaryAnimals = [1, 2, 3, 4, 5];
List<int> epicAnimals = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
List<int> rareAnimals = [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35];
List<int> commonAnimals = List.generate(50, (index) => index + 36);

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

void main() {
  List<String> tiers = ["Legendary", "Epic", "Rare", "Common"];
  LootBox cheapLootBox = LootBox(
    'Cheap Loot Box',
    100,
    [1.0, 2.0, 5.0, 10.0],
  );
  LootBox expensiveLootBox = LootBox(
    'Expensive Loot Box',
    200,
    [5.0, 10.0, 2.0, 1.0],
  );
}
