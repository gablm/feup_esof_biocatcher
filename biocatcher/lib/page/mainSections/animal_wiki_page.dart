import 'package:flutter/material.dart';

import '../../elements/animal_card.dart';
import '../../logic/animal.dart';

class AnimalWikiPage extends StatefulWidget {
  AnimalWikiPage({super.key});

  var animalMap = Animal.animalCollection;

  @override
  State<AnimalWikiPage> createState() => AnimalWikiPageState();
}

class AnimalWikiPageState extends State<AnimalWikiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text("Wiki - All Animals")
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.70,
        shrinkWrap: true,
        children: [
          for (var animal in widget.animalMap.entries)
            AnimalCard(
              animalId: animal.key,
              onUpdate: () => setState(() {}),
              level: 0,
            )
        ],
      ),
    );
  }
}