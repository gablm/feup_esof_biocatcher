import 'package:bio_catcher/page/mainSections/animalview_section.dart';
import 'package:bio_catcher/page/mainSections/map_section.dart';
import 'package:bio_catcher/page/mainSections/menu_section.dart';
import 'package:bio_catcher/page/mainSections/shop_section.dart';
import 'package:bio_catcher/page/mainSections/storage_section.dart';
import 'package:flutter/material.dart';

import '../logic/account.dart';
import '../logic/eventHandler.dart';
import 'mainSections/error_section.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainState();
}

class MainState extends State<MainPage> {
  String page = "map";
  String arg = "";
  bool showAppBar = true;

  @override
  void initState() {
    super.initState();
    EventHandler.mainPageAppBarStream.listen(
            (event) => setState(() { if (event is bool) showAppBar = event; })
    );
    EventHandler.changeSectionStream.listen((event) {
      if (event is String) {
        setState(() {
          var args = event.split(" ");
          page = args.first;
          arg = args.last;
        });
      }
    });
    EventHandler.userDataStream.listen((event) { setState(() { });});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !showAppBar ? null : AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Directionality(
                textDirection: TextDirection.ltr,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.currency_bitcoin,
                    color: Colors.yellow
                  ),
                  label: Text(
                    Account.instance.profile?.getCoins().toString() ?? "0",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ),
                  onPressed: () {},
                )
            ),
            Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  icon: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        Account.instance.profile!.picture,
                        fit: BoxFit.cover,
                        width: 24,
                        height: 24,
                      )
                  ),
                  label: Text(
                    "Lvl. ${Account.instance.profile?.getLevel().round()}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ),
                  onPressed: () {
                    if (page == 'menu') return;
                    setState(() => page = "menu");
                  },
                )
            )
          ]
        ),
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              disabledColor: Colors.green,
              enableFeedback: false,
              onPressed: page == "storage" || page == "animal_view" ? null
                  : () async {
                await Account.instance.profile?.reloadAccountData();
                setState(() => page = "storage");
              },
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
        'map' => const MapSection(),
        'menu' => const MenuSection(),
        'storage' => const StorageSection(),
        'shop' => const ShopSection(),
        'animal_view' => AnimalViewSection(animalId: arg),
        _ => const ErrorSection(error: 'An invalid page was reached.'),
      },
    );
  }
}