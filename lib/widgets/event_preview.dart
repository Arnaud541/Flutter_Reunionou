import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/class/event.dart';
import 'package:reunionou/providers/participant_provider.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/screens/event_screen.dart';

class EventPreview extends StatelessWidget {
  final Event event;
  const EventPreview({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(event.title),
      subtitle: Text(event.description),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventScreen(event: event)));
      },
    );
  }
}
