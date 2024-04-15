import 'package:flutter/material.dart';

import '../../logic/account.dart';
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

    switch(status) {
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
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    EventHandler.mainPageAppBar.add(false);
    if (widget.animal == null) {
      return const Center(
        child: Text('Invalid animal', style: TextStyle(fontSize: 20))
      );
    }
    return Center(
      child: Column(
        children: [
          SizedBox(
              height: 340,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                      footer: Container(
                        padding: const EdgeInsets.fromLTRB(32,8,8,8),
                        child: Text(
                          widget.animal!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      child: Image.network(
                        widget.animal!.pictureUri,
                        fit: BoxFit.cover,
                      )
                  ),
              )
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10)
            ),
            child: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Conservation Status: ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )
                      ),
                      conservationStatusText(widget.animal!.conservationStatus)
                    ]
                )
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Average Weight: ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )
                      ),
                      TextSpan(
                          text: "~${widget.animal!.avgWeight.round()}kg",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )
                      )
                    ]
                  )
                ),
              ),
              const SizedBox(width: 13),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Average Longevity: ",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                              )
                          ),
                          TextSpan(
                              text: "~${widget.animal!.avgLongevity.round()}y",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.inversePrimary,
                              )
                          )
                        ]
                    )
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10)
            ),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                text: widget.animal!.description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  height: 1.3
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}