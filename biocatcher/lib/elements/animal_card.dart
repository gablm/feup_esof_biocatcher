
import 'package:bio_catcher/logic/account.dart';
import 'package:bio_catcher/logic/animal.dart';
import 'package:bio_catcher/logic/eventHandler.dart';
import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  AnimalCard({
    super.key,
    required this.animalId,
    required level,
    required void Function() this.onUpdate,
    bool showDetails = false
  }) {
    animal = Animal.animalCollection[animalId];
    _level = level.toDouble();
    _showDetails = showDetails;
    currentCards = Account.instance.profile?.ownedAnimalsCards[animalId] ?? 0;
    requiredCards = (_level == 1 ? 10 : 20 * _level).round();
  }

  final String animalId;
  late double _level;
  late Animal? animal;
  late Function() onUpdate;
  bool _showDetails = false;
  int currentCards = 0;
  int requiredCards = 1;

  Future<void> deleteAnimal(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 50,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "This is an irreversible action!",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.red,
                        fontSize: 15
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Are you sure?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.none,
                        backgroundColor: Colors.red,
                        fontSize: 13
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                        ),
                        onPressed: () async => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await Account.instance.profile?.removeAnimal(animalId);
                          onUpdate();
                        },
                      )
                    ],
                  )
                ]
            ),
          ),
    ));
  }

Future<void> upgradeAnimal(BuildContext context) async {
  if (currentCards >= requiredCards) {
    await Account.instance.profile?.setAnimalCards(animalId, currentCards - requiredCards);
    _level += 1;
    await Account.instance.profile?.addAnimal(animalId, _level);
    onUpdate();
    return;
  }
  FocusManager.instance.primaryFocus?.unfocus();
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 20),
                Text(
                  "Not enough cards to upgrade!",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.red,
                      fontSize: 15
                  ),
                ),
              ]
          ),
        ),
      ));
}

@override
  Widget build(BuildContext context) {
    if (animal == null) {
      return const Center(
        child: Text(
          "Invalid animal",
        ),
      );
    }
    if (_showDetails) {
      return Card(
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
                    onPressed: () => upgradeAnimal(context),
                    icon: Icon(
                      Icons.upgrade,
                      size: 30,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => deleteAnimal(context),
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
    } else {
      return Card(
          child: GestureDetector(
            onTap: () => EventHandler.changeSection.add("animal_view $animalId"),
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
                      )
                    ]
                )
            )
          )
      );
    }
  }
}