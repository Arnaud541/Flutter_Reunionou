import 'package:flutter/material.dart';
import 'package:reunionou/screens/create_event_screen.dart';
import 'package:reunionou/widgets/navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100), child: Navbar()),
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          Row(
            children: const [Text("Reunionou")],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateEventScreen()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA084DC)),
                child: const Text('Créer un évenement'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
