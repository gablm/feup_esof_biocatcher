import 'package:flutter/material.dart';

import '../../logic/account.dart';
import '../../logic/animal.dart';

class AnimalViewSection extends StatefulWidget {
  AnimalViewSection({super.key, required this.animalId}) {
    animal = Animal.animalCollection[animalId];
  }

  final String animalId;
  late final Animal? animal;

  @override
  State<AnimalViewSection> createState() => AnimalViewState();
}

class AnimalViewState extends State<AnimalViewSection> {
  @override
  Widget build(BuildContext context) {
    Account.instance.profile?.triggerUserDataEvent("disableAppBar");
    if (widget.animal == null) {
      return const Center(
        child: Text('Invalid animal', style: TextStyle(fontSize: 20))
      );
    }
    return Center(
      child: Column(
        children: [
          Container(
              width: double.maxFinite,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                      widget.animal!.pictureUri,
                      fit: BoxFit.cover
                  )
              )
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.animal!.name),
            ],
          )
        ],
      ),
    );
  }
}