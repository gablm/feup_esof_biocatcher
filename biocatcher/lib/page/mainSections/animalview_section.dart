
import 'package:bio_catcher/elements/text_with_highlight.dart';
import 'package:flutter/material.dart';

import '../../logic/animal.dart';
import '../../logic/eventHandler.dart';

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
  TextSpan conservationStatusText(ConservationStatus status) {
    Color finalColor = Colors.grey;
    String finalText = "Unknown type";

    switch (status) {
      case ConservationStatus.extinct:
        finalText = "Extinct";
        finalColor = Colors.black;
        break;
      case ConservationStatus.extinctWild:
        finalText = "Extinct in the wild";
        finalColor = Colors.brown;
        break;
      case ConservationStatus.criticallyEndangered:
        finalText = "Critically Endangered";
        finalColor = Colors.red;
        break;
      case ConservationStatus.endangered:
        finalText = "Endangered";
        finalColor = Colors.redAccent;
        break;
      case ConservationStatus.vulnerable:
        finalText = "Vulnerable";
        finalColor = Colors.orange;
        break;
      case ConservationStatus.nearThreatened:
        finalText = "Near threatened";
        finalColor = Colors.yellow;
        break;
      case ConservationStatus.conversationDependent:
        finalText = "Conversation dependent";
        finalColor = Colors.lightGreenAccent;
        break;
      case ConservationStatus.leastConcern:
        finalText = "Least concern";
        finalColor = Colors.green;
        break;
      case ConservationStatus.dataDeficient:
        finalText = "Data deficient";
        break;
      case ConservationStatus.notEvaluated:
        finalText = "Not evaluated";
        break;
    }
    return TextSpan(
        text: finalText,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: finalColor,
            fontSize: 16,
            shadows: const [Shadow(blurRadius: 10)]));
  }

  @override
  Widget build(BuildContext context) {
    EventHandler.mainPageAppBar.add(false);
    if (widget.animal == null) {
      return const Center(
          child: Text('Invalid animal', style: TextStyle(fontSize: 20)));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: IconButton(
            onPressed: () => EventHandler.changeSection.add("storage"),
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Container(
                height: 340,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                      footer: Container(
                          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.animal!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                              RichText(
                                  text: conservationStatusText(
                                      widget.animal!.conservationStatus))
                            ],
                          )),
                      child: Image.network(
                        widget.animal!.pictureUri,
                        fit: BoxFit.cover,
                      )),
                )),
            Wrap(
              children: [
                TextWithHighlight(
                    "Scientific Name",
                    widget.animal!.scientificName
                ),
                TextWithHighlight(
                    "Origin",
                    widget.animal!.origin
                ),
                TextWithHighlight(
                    "Average Longevity",
                    "~${widget.animal!.avgLongevity.round()}y"
                ),
                TextWithHighlight(
                    "Average Weight",
                    "~${widget.animal!.avgWeight.round()}kg"
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                    text: widget.animal!.description,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        height: 1.3)),
              ),
            )
          ],
        )
    );
  }
}