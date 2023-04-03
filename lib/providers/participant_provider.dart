import 'package:flutter/material.dart';
import 'package:reunionou/class/participant.dart';

class ParticipantProvider extends ChangeNotifier {
  void changeStatus(Participant p, BuildContext context, String status) {
    p.status = status;

    final snackBar = SnackBar(
      content: status == "accepted"
          ? const Text("Vous avez accepté l'évènement")
          : const Text("Vous avez refusé l'évènement"),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.orange,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    notifyListeners();
  }
}
