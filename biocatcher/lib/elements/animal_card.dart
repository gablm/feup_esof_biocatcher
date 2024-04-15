
import 'package:bio_catcher/logic/account.dart';
import 'package:bio_catcher/logic/animal.dart';
import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  AnimalCard({super.key, required this.animalId, required level}) {
    animal = Animal.animalCollection[animalId];
    _level = level.toDouble();
  }

  final String animalId;
  late double _level;
  late Animal? animal;

  @override
  Widget build(BuildContext context) {
    if (animal == null) {
      return const Center(
        child: Text(
          "Invalid animal",
        ),
      );
    }
    return GestureDetector(
      onTap: () => Account.instance.profile?.triggerUserDataEvent("AnimalView $animalId"),
      child: Card(
        //onPressed: () {  },
          child: Center(
            child: Column(
              children: [
                Container(
                    width: double.maxFinite,
                    height: 130,
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
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(animal!.name),
                    Text("Level ${_level.round()}")
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

}