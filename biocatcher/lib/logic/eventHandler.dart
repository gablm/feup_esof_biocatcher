import 'dart:async';

class EventHandler {
  static StreamController updateUserData = StreamController.broadcast();
  static Stream get userDataStream => updateUserData.stream;

  static StreamController mainPageAppBar = StreamController.broadcast();
  static Stream get mainPageAppBarStream => mainPageAppBar.stream;

  static StreamController changeSection = StreamController.broadcast();
  static Stream get changeSectionStream => changeSection.stream;
}