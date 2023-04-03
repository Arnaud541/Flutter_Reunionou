import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/screens/create_event_screen.dart';
import 'package:reunionou/screens/event_screen.dart';
import 'package:reunionou/screens/home_screen.dart';
import 'package:reunionou/screens/create_invitation_screen.dart';
import 'package:reunionou/screens/profile_screen.dart';
import 'package:reunionou/screens/signin_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Reunionou',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Provider.of<UserProvider>(context, listen: false).isConnected
            ? const CreateEventScreen()
            : const SigninScreen());
  }
}
