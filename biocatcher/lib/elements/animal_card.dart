
import 'package:bio_catcher/logic/account.dart';
import 'package:bio_catcher/logic/animal.dart';
import 'package:bio_catcher/logic/eventHandler.dart';
import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  AnimalCard({super.key, required this.animalId, required level}) {
    animal = Animal.animalCollection[animalId];
    _level = level.toDouble();
  }

  final String animalId;
  late double _level;
  late Animal? animal;
  int currentCards = 10;
  int requiredCards = 100;

  @override
  Widget build(BuildContext context) {
    if (animal == null) {
      return const Center(
        child: Text(
          "Invalid animal",
        ),
      );
    }
    return Card(
      //onPressed: () {  },
        child: Center(
          child: Column(
            children: [
              Container(
                  width: 175,
                  height: 175,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                          animal!.pictureUri,
                          fit: BoxFit.cover
                      )
                  )
              ),
              const SizedBox(height: 6),
              Text(
                animal!.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Level ${_level.round()}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "$currentCards/$requiredCards",
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: LinearProgressIndicator(
                  value: currentCards / requiredCards,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => EventHandler.changeSection.add("animal_view $animalId"),
                    icon: Icon(
                      Icons.info_outline,
                      size: 30,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.upgrade,
                      size: 30,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

}