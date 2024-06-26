import 'package:bio_catcher/elements/animal_card.dart';
import 'package:bio_catcher/logic/animal.dart';
import 'package:bio_catcher/logic/eventHandler.dart';
import 'package:flutter/material.dart';

import '../../logic/account.dart';

class StorageSection extends StatefulWidget {
  const StorageSection({super.key});

  @override
  State<StorageSection> createState() => StorageState();
}

class StorageState extends State<StorageSection> {
  int getTotalPercentage() {
    return ((Account.instance.profile?.ownedAnimals.length ?? 0)
    / Animal.animalCollection.length * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    EventHandler.mainPageAppBar.add(true);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Storage - ${getTotalPercentage()}% collected")
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.60,
        shrinkWrap: true,
        children: [
          for (var animal in Account.instance.profile!.ownedAnimals.entries)
            AnimalCard(
                animalId: animal.key,
                level: animal.value,
                onUpdate: () => setState(() {}),
                showDetails: true,
            )
        ],
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            setState(() {
              EventHandler.changeSection.add("animal_wiki");
            });
          },
          child: const Icon(Icons.book),
        )
    );
    /*return const Center(
        child: Text('Storage', style: TextStyle(fontSize: 80))
    );*/
  }
}