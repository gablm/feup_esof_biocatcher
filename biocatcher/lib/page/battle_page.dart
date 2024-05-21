import 'package:bio_catcher/logic/animal.dart';
import 'package:flutter/material.dart';

import '../logic/account.dart';
import 'dart:math';

enum GameState {
  botPlaying,
  userPlaying,
  botWin,
  userWin
}

class BattlePage extends StatefulWidget {
  BattlePage({super.key})
  {
    if (!Account.instance.isSignedIn())
      throw Exception("You need to be logged in for this!");

    var rng = Random();
    var ownAnim = Account.instance.profile?.ownedAnimals;
    var animCol = Animal.animalCollection;

    int animalId = rng.nextInt(ownAnim?.length ?? 0);
    user = animCol[animalId.toString()]!;
    userLevel = (ownAnim?[animalId.toString()]).toDouble();
    userAvoid = rng.nextDouble() * 10;

    int enemyId = rng.nextInt(animCol.length);
    enemy = animCol[enemyId.toString()]!;
    enemyLevel = max(userLevel + rng.nextInt(10) - 5, 1);
    enemyAvoid = rng.nextDouble() * 10;
  }

  late Animal user;
  late double userLevel;
  late double userAvoid;
  late Animal enemy;
  late double enemyLevel;
  late double enemyAvoid;

  late double userHp = user.stats.getActualHp(userLevel);
  late double userFullHp = userHp;
  late double enemyHp = enemy.stats.getActualHp(enemyLevel);
  late double enemyFullHp = enemyHp;

  GameState state = GameState.userPlaying;
  double roundCount = 0;
  int gainedCoins = 0;
  double gainedXp = 0;
  bool isCrit = false;
  bool isAvoided = false;

  double getDamage(double hp, double atk, double cRate, double cDmg, double cRng)
  {
    isCrit = cRng <= cRate;
    return hp - atk * (isCrit ? cDmg / 100 : 1);
  }

  String getTitle() {
    return isOver ? "Battle Results" : "Simulating Battle...";
  }

  String getPhaseTitle()
  {
    switch (state)
    {
      case GameState.botPlaying:
        return "Enemy's turn!";
      case GameState.userPlaying:
        return "Your turn!";
      default:
        return "Ups! This is not a valid phase.";
    }
  }

  bool get isOver => state == GameState.userWin || state == GameState.botWin;

  void nextRound()
  {
    var rng = Random();
    double avoided = rng.nextDouble() * 100;
    double crit = rng.nextDouble() * 100;
    isAvoided = false;

    switch (state)
    {
      case GameState.userPlaying:
        if (avoided <= enemyAvoid)
        {
          isAvoided = true;
          state = GameState.botPlaying;
          break;
        }
        enemyHp = getDamage(
            enemyHp,
            user.stats.getActualAtk(userLevel),
            user.stats.getActualCritRate(userLevel),
            user.stats.getActualCritDmg(userLevel),
            crit);
        state = enemyHp <= 0 ? GameState.userWin : GameState.botPlaying;
        break;
      case GameState.botPlaying:
        if (avoided <= userAvoid)
        {
          isAvoided = true;
          state = GameState.userPlaying;
          break;
        }
        userHp = getDamage(
            userHp,
            enemy.stats.getActualAtk(enemyLevel),
            enemy.stats.getActualCritRate(enemyLevel),
            enemy.stats.getActualCritDmg(enemyLevel),
            crit);
        state = userHp <= 0 ? GameState.botWin : GameState.userPlaying;
        break;
      default:
        break;
    }
    roundCount += 0.5;
    if (state == GameState.userWin) {
      gainedCoins = rng.nextInt(52) + 89;
      gainedXp = rng.nextDouble() / 5 + 0.5;
      Account.instance.profile?.addCoins(gainedCoins);
      Account.instance.profile?.addLevel(gainedXp);
    }

    if (state == GameState.botWin) {
      gainedCoins = 0;
      gainedXp = rng.nextDouble() / 5;
      Account.instance.profile?.addLevel(gainedXp);
    }
  }

  @override
  State<BattlePage> createState() => BattleState();
}

class BattleState extends State<BattlePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.getTitle(),
          style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary
          ),
        ),
      ),
      body: Center(
        child: !widget.isOver ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Round ${widget.roundCount.round()}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "YOU",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                          Text(
                            "Lvl. ${widget.userLevel.round()}",
                            style: const TextStyle(
                                fontSize: 15
                            ),
                          ),
                          const SizedBox(height: 5),
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
                                      widget.user.pictureUri,
                                      fit: BoxFit.cover
                                  )
                              )
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.user.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                          const SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: widget.userHp.round() / widget.userFullHp.round(),
                            color: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${widget.userHp.round()}/${widget.userFullHp.round()} HP",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.inversePrimary
                            ),
                          )
                        ],
                      )
                  ),
                  const SizedBox(width: 30),
                  Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "ENEMY",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                          Text(
                            "Lvl. ${widget.enemyLevel.round()}",
                            style: const TextStyle(
                                fontSize: 15
                            ),
                          ),
                          const SizedBox(height: 5),
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
                                      widget.enemy.pictureUri,
                                      fit: BoxFit.cover
                                  )
                              )
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.enemy.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                          const SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: widget.enemyHp.round() / widget.enemyFullHp.round(),
                            color: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${widget.enemyHp.round()}/${widget.enemyFullHp.round()} HP",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.inversePrimary
                            ),
                          )
                        ],
                      )
                  ),
                ]
              ),
            ),
            const SizedBox(height: 10),
            if (widget.isCrit)
              Text(
                "Critical hit!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
            if (widget.isAvoided)
              Text(
                "The attack was avoided!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            const SizedBox(height: 15),
            Text(
              widget.getPhaseTitle(),
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
            ),
          ],
        )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.state == GameState.botWin ? "You lose!" : "You win!",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Total number of rounds: ${widget.roundCount.round()}",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Rewards",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coins",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.inversePrimary
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.gainedCoins}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.inversePrimary
                            ),
                          ),
                          const Icon(
                            Icons.currency_bitcoin,
                            color: Colors.yellow,
                          )
                        ],
                      )
                    ],
                  ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "XP",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.inversePrimary
                      ),
                    ),
                    Text(
                      "${(widget.gainedXp * 100).round()} (${widget.gainedXp.toStringAsFixed(1)} levels)",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.inversePrimary
                      ),
                    )
                  ],
                )
              ),
            ]
        ),
      ),
      bottomSheet: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!widget.isOver)
            ElevatedButton.icon(
                onPressed: () => setState(() => widget.nextRound()),
                icon: const Icon(Icons.gamepad),
                label: const Text("Next phase"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white
              ),
            ),
            if (!widget.isOver)
            const SizedBox(width: 20),
            if (!widget.isOver)
            ElevatedButton.icon(
              onPressed: () => setState(() {
                widget.state = GameState.botWin;
                widget.nextRound();
              }),
              icon: const Icon(Icons.flag),
              label: const Text("Give up"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white
              ),
            ),
            if (widget.isOver)
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, "/main"),
                icon: const Icon(Icons.flag),
                label: const Text("Return to the main menu!"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: widget.state == GameState.botWin ? Colors.red : Colors.green,
                    foregroundColor: Colors.white
                ),
              )
          ],
        ),
      ),
    );
  }
}