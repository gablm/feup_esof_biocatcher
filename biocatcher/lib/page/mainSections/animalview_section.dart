
import 'package:bio_catcher/elements/text_with_highlight.dart';
import 'package:flutter/material.dart';

import '../../logic/animal.dart';
import '../../logic/eventHandler.dart';

class AnimalViewSection extends StatefulWidget {
  AnimalViewSection({
    super.key,
    required this.animalId,
    this.goBack
  }) {
    animal = Animal.animalCollection[animalId];
  }

  final String animalId;
  late final Animal? animal;
  void Function()? goBack;

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

  Column getAnimalStatCol(String? type, double? base, double? scale) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type ?? "???",
            style: const TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
          Text(
              "Base       $base"
          ),
          Text(
              "Scaling   $scale"
          )
        ],
    );
  }

  void showStats(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.background
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "Animal In-Game Stats",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(child: Text("All attributes are dependant on level.")),
                    const Center(child: Text("Stat = Base + Level * Scaling")),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getAnimalStatCol("ATK",
                            widget.animal?.stats.baseAtk,
                            widget.animal?.stats.scalingAtk
                        ),
                        getAnimalStatCol("HP",
                            widget.animal?.stats.baseHp,
                            widget.animal?.stats.scalingHp
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getAnimalStatCol("CRIT RATE",
                            widget.animal?.stats.baseCritRate,
                            widget.animal?.stats.scalingCritRate
                        ),
                        getAnimalStatCol("CRIT DMG",
                            widget.animal?.stats.baseCritDmg,
                            widget.animal?.stats.scalingCritDmg
                        )
                      ],
                    ),
                  ]
              ),
            ),
          );
        });
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
            onPressed: widget.goBack ?? () => EventHandler.changeSection.add("storage"),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
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
                              ),
                              ElevatedButton(
                                  onPressed: () => showStats(context),
                                  child: const Text(
                                    "Show stats",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )
                                  )
                              )
                            ],
                          ),
                      ),
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
