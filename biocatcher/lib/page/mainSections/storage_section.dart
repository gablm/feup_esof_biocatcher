
import 'package:bio_catcher/elements/animal_card.dart';
import 'package:flutter/material.dart';

import '../../logic/account.dart';

class StorageSection extends StatefulWidget {
  const StorageSection({super.key});

  @override
  State<StorageSection> createState() => StorageState();
}

class StorageState extends State<StorageSection> {
  @override
  Widget build(BuildContext context) {
    Account.instance.profile?.triggerUserDataEvent("enableAppBar");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text("Storage")
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: [
          for (var animal in Account.instance.profile!.ownedAnimals.entries)
            AnimalCard(animalId: animal.key, level: animal.value)
        ],
      ),
    );
    /*return const Center(
        child: Text('Storage', style: TextStyle(fontSize: 80))
    );*/
  }
}