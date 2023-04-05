import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/class/event.dart';
import 'package:reunionou/class/user.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/widgets/event_preview.dart';
import 'package:reunionou/widgets/navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<List<Event>> getCurrentEvents(id) async {
    List<Event> currentEvents = [];

    final Dio dio = Dio();
    Response response =
        await dio.get('http://localhost:19185/user/$id/live-events');
    for (var event in response.data['events']) {
      currentEvents.add(Event(
          event["id"],
          event["title"],
          event["description"],
          event["longitude"],
          event["latitude"],
          event["street"],
          event["city"],
          event["zipcode"],
          event["date"]));
    }
    return currentEvents;
  }

  Future<List<Event>> getParticipatedEvents(id) async {
    List<Event> participatedEvents = [];
    final Dio dio = Dio();
    Response response =
        await dio.get('http://localhost:19185/user/$id/past-events');

    for (var event in response.data['past_events']) {
      participatedEvents.add(Event(
          event["id"],
          event["title"],
          event["description"],
          event["longitude"],
          event["latitude"],
          event["street"],
          event["city"],
          event["zipcode"],
          event["date"]));
    }

    return participatedEvents;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).currentUser!;
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: const Border.fromBorderSide(
                      BorderSide(width: 1, color: Colors.black45)),
                  image: DecorationImage(
                      image: NetworkImage(
                          Provider.of<UserProvider>(context, listen: false)
                              .currentUser!
                              .avatar),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${user.firstname} ${user.lastname}",
              style: TextStyle(fontSize: 17, color: Colors.grey[400]),
            ),
            const SizedBox(height: 50),
            Text(
              'Evènements en cours',
              style: TextStyle(fontSize: 17, color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: FutureBuilder(
              future: getCurrentEvents(user.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return EventPreview(event: snapshot.data![index]);
                      });
                }

                if (snapshot.hasError) {
                  return const Text("Erreur d'affichage");
                }

                return const CircularProgressIndicator();
              },
            )),
            const SizedBox(height: 25),
            Text(
              'Evènements auxquels vous avez participé',
              style: TextStyle(fontSize: 17, color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: getParticipatedEvents(user.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return EventPreview(event: snapshot.data![index]);
                        });
                  }

                  if (snapshot.hasError) {
                    return const Text("Erreur d'affichage");
                  }

                  return const CircularProgressIndicator();
                },
              ),
            )
          ],
        ));
  }
}
