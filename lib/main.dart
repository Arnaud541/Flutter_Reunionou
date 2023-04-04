import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/screens/create_event_screen.dart';
import 'package:reunionou/screens/event_screen.dart';
import 'package:reunionou/screens/home_screen.dart';
import 'package:reunionou/screens/create_invitation_screen.dart';
import 'package:reunionou/screens/profile_screen.dart';
import 'package:reunionou/screens/signin_screen.dart';
import 'package:reunionou/screens/signin_invitation_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Reunionou',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Provider.of<UserProvider>(context, listen: false).isConnected
            ? const HomeScreen()
            : const SigninScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/profile':
              return MaterialPageRoute(
                  builder: (context) => const ProfileScreen());
            case '/invitation':
              return MaterialPageRoute(
                  builder: (context) => const CreateInvitationScreen());
            case '/create_event':
              return MaterialPageRoute(
                  builder: (context) => const CreateEventScreen());
            case '/signin':
              return MaterialPageRoute(
                  builder: (context) => const SigninScreen());

/*            case '/event':
              final eventId = "1";
              final event = Provider.of<UserProvider>(context, listen: false).getEventById(eventId);
              return MaterialPageRoute(builder: (context) => EventScreen(event));*/
            case '/signin_invitation':
              return MaterialPageRoute(
                  builder: (context) => const SigninInvitationScreen());
            default:
              return null;
          }
        });
  }
}
