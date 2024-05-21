import 'dart:math';

import 'package:flutter/material.dart';
import '../../logic/lootBox.dart';
import '../../logic/account.dart';

class ShopSection extends StatefulWidget {
  const ShopSection({Key? key}) : super(key: key);

  @override
  State<ShopSection> createState() => _ShopSectionState();
}

class _ShopSectionState extends State<ShopSection> {
  List<LootBox> lootBoxes = [
    LootBox('Cheap Loot Box', 600, [0.5, 1.0, 3.0, 10.0]), // More common, less rare/legendary
    LootBox('Normal Loot Box', 1200, [0.5, 1.5, 5.0, 8.0]), // Balanced between common and rare/epic
    LootBox('Expensive Loot Box', 1800, [0.5, 2.0, 5.0, 4.0]), // More rare/epic, less common
    LootBox('Very Expensive Loot Box', 2500, [1.0, 3.0, 3.0, 0]), // More epic/legendary
    LootBox('Very Very Expensive Loot Box', 4000, [1.0, 3.0, 0, 0]), // Almost guaranteed epic/legendary
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Shop'),
      ),
      body: ListView.builder(
        itemCount: lootBoxes.length,
        itemBuilder: (context, index) {
          final lootBox = lootBoxes[index];
          return ListTile(
            title: Text(lootBox.name),
            subtitle: Text('Price: ${lootBox.price} coins'),
            trailing: ElevatedButton(
              onPressed: () async {
                int? userCoins = Account.instance.profile?.getCoins() ?? 0;
                if (userCoins >= lootBox.price) {
                  Account.instance.profile?.addCoins(-lootBox.price);

                  int tier = lootBox.weightedProb();
                  int animalId = lootBox.grabFromTier(tier);

                  // Check if the user already owns the item
                  String animalIdString = animalId.toString();
                  if (Account.instance.profile?.ownedAnimals.containsKey(animalIdString) ?? false) {
                    // If the user already owns the item, level it up by 1
                    int currentCards = Account.instance.profile?.ownedAnimalsCards[animalIdString] ?? 0;
                    var RanG = Random();
                    Account.instance.profile?.setAnimalCards(animalIdString, currentCards + RanG.nextInt(5) + 5);
                  } else {
                    // If the user doesn't own the item, add it to the inventory with a level of 1
                    Account.instance.profile?.addAnimal(animalIdString, 1);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('You bought ${lootBox.name}!'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Not enough coins to buy ${lootBox.name}!'),
                  ));
                }
              },
              child: const Text(
                'Buy',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
