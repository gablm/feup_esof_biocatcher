import 'package:bio_catcher/page/mapPage.dart';
import 'package:bio_catcher/page/menuPage.dart';
import 'package:bio_catcher/page/shopPage.dart';
import 'package:bio_catcher/page/storagePage.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainState();
}

class MainState extends State<MainPage> {
  String page = "map";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              disabledColor: Colors.green,
              enableFeedback: false,
              onPressed: page == "storage" ? null
                  : () => { setState(() => page = "storage") },
              icon: const Icon(
                Icons.catching_pokemon_sharp,
                size: 35,
              ),
            ),
            IconButton(
              disabledColor: Colors.green,
              enableFeedback: false,
              onPressed: page == "map" ? null
                : () => { setState(() => page = "map") },
              icon: const Icon(
                Icons.map,
                size: 35,
              ),
            ),
            IconButton(
              disabledColor: Colors.green,
              enableFeedback: false,
              onPressed: page == "shop" ? null
                  : () => { setState(() => page = "shop") },
              icon: const Icon(
                Icons.casino,
                size: 35,
              ),
            ),
            IconButton(
              disabledColor: Colors.green,
              enableFeedback: false,
              onPressed: page == "menu" ? null
                  : () => { setState(() => page = "menu") },
              icon: const Icon(
                Icons.menu,
                size: 35,
              ),
            )
          ],
        ),
      ),
      body: switch (page)
      {
        'map' => MapPage(),
        'menu' => MenuPage(),
        'storage' => StoragePage(),
        'shop' => ShopPage(),
        _ => MapPage(),
      },
    );
  }
}