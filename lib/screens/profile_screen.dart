import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/class/event.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/widgets/event_preview.dart';
import 'package:reunionou/widgets/navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<List<Event>> getCurrentEvents() async {
    List<Event> currentEvents = [];

    final Dio dio = Dio();
    Response response =
        await dio.get('https://fruits.shrp.dev/items/fruits?fields=*.*');

    for (var element in response.data['data']) {
      currentEvents.add(Event(
          element["id"],
          element["title"],
          element["description"],
          element["longitude"],
          element["latitude"],
          element["street"],
          element["city"],
          element["zipcode"],
          element["eventDate"]));
    }

    return currentEvents;
  }

  Future<List<Event>> getParticipatedEvents() async {
    List<Event> participatedEvents = [];

    final Dio dio = Dio();
    Response response =
        await dio.get('https://fruits.shrp.dev/items/fruits?fields=*.*');

    for (var element in response.data['data']) {
      participatedEvents.add(Event(
          element["id"],
          element["title"],
          element["description"],
          element["longitude"],
          element["latitude"],
          element["street"],
          element["city"],
          element["zipcode"],
          element["eventDate"]));
    }

    return participatedEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(100), child: Navbar()),
        body: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                      BorderSide(width: 1, color: Colors.black45)),
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://gravatar.com/avatar/7f4560dbdee0a44569dc3fdb22ea9c8b?s=400&d=robohash&r=x'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              Provider.of<UserProvider>(context, listen: false)
                      .currentUser!
                      .firstname +
                  Provider.of<UserProvider>(context, listen: false)
                      .currentUser!
                      .lastname,
              style: TextStyle(fontSize: 17, color: Colors.grey[400]),
            ),
            const SizedBox(height: 50),
            Text(
              'Evènements en cours',
              style: TextStyle(fontSize: 17, color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: getCurrentEvents(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return EventPreview(event: snapshot.data![index]);
                      });
                }

                if (snapshot.hasError) {
                  return const Text("Error");
                }

                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 50),
            Text(
              'Evènements auxquels vous avez participé',
              style: TextStyle(fontSize: 17, color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: getParticipatedEvents(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return EventPreview(event: snapshot.data![index]);
                      });
                }

                if (snapshot.hasError) {
                  return const Text("Error");
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        ));
  }
}
