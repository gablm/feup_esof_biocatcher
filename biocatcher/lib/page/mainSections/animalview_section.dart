import 'package:flutter/material.dart';

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
    return const Center(
        child: Text('AnimalView', style: TextStyle(fontSize: 20))
    );
  }
}