import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:reunionou/widgets/comment_preview.dart';
import 'package:reunionou/widgets/navbar.dart';
import 'package:reunionou/class/participant.dart';
import 'package:reunionou/widgets/participant_preview.dart';

import 'package:reunionou/class/comment.dart';
import 'package:reunionou/class/event.dart';

class EventScreen extends StatefulWidget {
  final Event event;
  const EventScreen({super.key, required this.event});

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen> {
  late Map<String, double> _coordinates;
  late String _address;
  late Event _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    if (_event.city != null &&
        _event.street != null &&
        _event.zipcode != null) {
      getCoordinates().then((map) {
        setState(() {
          _coordinates = map;
        });
      });
    }
    if (_event.latitude != null && _event.longitude != null) {
      setState(() {
        _address = getAddress() as String;
      });
    }
  }

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

  Future<Map<String, double>> getCoordinates() async {
    final Dio dio = Dio();
    Map<String, double> coordinates = {};

    Response response = await dio
        .get("https://api-adresse.data.gouv.fr/search/?", queryParameters: {
      "q": _event.street,
      "city": _event.city,
      "limit": "1"
    });

    if (response.statusCode == 200) {
      final lat =
          response.data['data']['features']['geometry']['coordinates'][0];
      final lng =
          response.data['data']['features']['geometry']['coordinates'][1];
      coordinates = {'latitude': lat, 'longitude': lng};
    }
    return coordinates;
  }

  Future<String> getAddress() async {
    final Dio dio = Dio();
    String address = "";

    Response response = await dio.get(
        "https://api-adresse.data.gouv.fr/reverse/",
        queryParameters: {"lon": _event.longitude, "lat": _event.latitude});

    if (response.statusCode == 200) {
      address = response.data['data']['features']['properties']["label"];
    }
    return address;
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
                _event.title,
                style: TextStyle(fontSize: 30, color: Colors.grey[400]),
              )),
              const SizedBox(height: 20),
              Center(
                child: Image.network('https://placehold.co/350x200/png'),
              ),
              const SizedBox(height: 25),
              Text(_event.description),
              const SizedBox(height: 25),
              Row(children: [
                const Icon(Icons.location_on_rounded),
                // _event.street == null && _event.city == null && _event.zipcode == null ? Text(_address[0]!["address"]) :
              ]),
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
                    center: LatLng(_event.longitude, _event.latitude),
                    zoom: 9.2),
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
                          point: LatLng(_event.longitude, _event.latitude),
                          width: 80,
                          height: 80,
                          builder: (context) => const Icon(Icons.location_on))
                    ],
                  )
                ],
              ),
            ],
          )),
    );
  }
}
