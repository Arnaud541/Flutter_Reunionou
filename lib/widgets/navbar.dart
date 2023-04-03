import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/widgets/signout.dart';

import '../screens/profile_screen.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color(0xFF645CBB),
        centerTitle: true,
        title: Image.asset(
          "./assets/logo.png",
          fit: BoxFit.contain,
          width: 50,
        ),
        actions: Provider.of<UserProvider>(context, listen: true).isConnected
            ? [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()));
                    },
                    icon: const Icon(Icons.person)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signout()));
                    },
                    icon: const Icon(Icons.exit_to_app))
              ]
            : null);
  }
}
