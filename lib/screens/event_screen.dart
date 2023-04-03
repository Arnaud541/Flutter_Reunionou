import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/participant_provider.dart';
import 'package:reunionou/widgets/comment_preview.dart';
import 'package:reunionou/widgets/navbar.dart';
import 'package:reunionou/class/participant.dart';
import 'package:reunionou/widgets/participant_preview.dart';

import '../class/comment.dart';
import '../class/event.dart';

class EventScreen extends StatelessWidget {
  final Event event;
  const EventScreen({super.key, required this.event});

  Future<List<Participant>> getParticipants() async {
    List<Participant> participants = [];
    final Dio dio = Dio();
    Response response =
        await dio.get('https://fruits.shrp.dev/items/fruits?fields=*.*');

    for (var participant in response.data['data']) {
      participants.add(Participant(
          participant["id"],
          participant["firstname"],
          participant["lastname"],
          participant["avatar"],
          participant["status"],
          participant["email"]));
    }
    return participants;
  }

  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];

    final Dio dio = Dio();
    Response response =
        await dio.get('https://fruits.shrp.dev/items/fruits?fields=*.*');

    for (var comment in response.data['data']) {
      comments.add(Comment(
          comment["participant_firstname"],
          comment["participant_lastname"],
          comment["content"],
          comment["created_at"]));
    }
    return comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75), child: Navbar()),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Center(
                  child: Text(
                "Nom de l'évènement",
                style: TextStyle(fontSize: 20, color: Colors.grey[400]),
              )),
              const SizedBox(height: 20),
              Center(
                child: Image.network('https://placehold.co/350x200/png'),
              ),
              const SizedBox(height: 25),
              const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Pellentesque habitant morbi tristique senectus et netus et malesuada fames. In cursus turpis massa tincidunt."),
              const SizedBox(height: 25),
              Row(children: const [
                Icon(Icons.group),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Participants")),
              ]),
              const SizedBox(height: 25),
              FutureBuilder(
                future: getParticipants(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ParticipantPreview(
                              participant: snapshot.data![index]);
                        });
                  }

                  if (snapshot.hasError) {
                    return const Text("Error");
                  }

                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 25),
              Center(
                  child: Text(
                "Commentaires",
                style: TextStyle(fontSize: 20, color: Colors.grey[400]),
              )),
              const SizedBox(height: 25),
              FutureBuilder(
                future: getComments(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return CommentPreview(comment: snapshot.data![index]);
                        });
                  }

                  if (snapshot.hasError) {
                    return const Text("Error");
                  }

                  return const CircularProgressIndicator();
                },
              ),
              FlutterMap(
                options: MapOptions(
                    center: LatLng(event.longitude, event.latitude), zoom: 9.2),
                nonRotatedChildren: [
                  AttributionWidget.defaultWidget(
                    source: 'OpenStreetMap contributors',
                    onSourceTapped: null,
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                          point: LatLng(event.longitude, event.latitude),
                          width: 80,
                          height: 80,
                          builder: (context) => const Icon(Icons.control_point))
                    ],
                  )
                ],
              ),
            ],
          )),
    );
  }
}
