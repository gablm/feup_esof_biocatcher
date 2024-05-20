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
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.getPhaseTitle(),
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
            ),
            const SizedBox(height: 10),
            if (widget.isCrit)
              Text(
                "Crit!",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
            if (widget.isAvoided)
              Text(
                "Attack was avoided!",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                      child: LinearProgressIndicator(
                        value: widget.userHp.round() / widget.userFullHp.round(),
                        color: Colors.red,
                        backgroundColor: Colors.black,
                      )
                  ),
                  SizedBox(width: 50),
                  Expanded(
                      child: LinearProgressIndicator(
                        value: widget.enemyHp.round() / widget.enemyFullHp.round(),
                        color: Colors.red,
                        backgroundColor: Colors.black,
                      )
                  )
                ]
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "You - ${widget.userHp.round()}/${widget.userFullHp.round()} HP",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inversePrimary
                      ),
                    ),
                    SizedBox(width: 50),
                    Text(
                      "Enemy - ${widget.enemyHp.round()}/${widget.enemyFullHp.round()} HP",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inversePrimary
                      ),
                    )
                  ]
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
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Total number of rounds: ${widget.roundCount.round()}",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Coins won: ${widget.gainedCoins}",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "XP won: ${(widget.gainedXp * 100).round()} (${widget.gainedXp.toStringAsFixed(1)} levels)",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
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