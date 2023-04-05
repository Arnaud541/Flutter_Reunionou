import 'package:flutter/material.dart';
import 'package:reunionou/class/user.dart';

import '../class/event.dart';

class UserProvider extends ChangeNotifier {
  User? currentUser;
  bool isConnected = false;

  List<Event> eventsParticipated = [];
  List<Event> eventsCreated = [];
}
