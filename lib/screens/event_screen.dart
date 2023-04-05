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
  Map<String, double> _coordinates = {};
  String _address = "";
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
      getAddress().then((add) {
        setState(() {
          _address = add;
        });
      });
    }
  }

  Future<List<Participant>> getParticipants() async {
    List<Participant> participants = [];
    final Dio dio = Dio();

    int id = _event.id;
    Response response =
        await dio.get('http://localhost:19185/event/$id/participants');

    if (response.statusCode == 200) {
      for (var participant in response.data['participants']) {
        participants.add(Participant(
            participant["user_id"] ?? participant["id"],
            participant["firstname"],
            participant["lastname"],
            'https://gravatar.com/avatar/7f4560dbdee0a44569dc3fdb22ea9c8b?s=400&d=robohash&r=x',
            participant["status"],
            participant["email"]));
      }
    }
    return participants;
  }

  // Future<List<Comment>> getComments() async {
  //   List<Comment> comments = [];
  //   int id = _event.id;
  //   print(id);
  //   final Dio dio = Dio();
  //   Response response =
  //       await dio.get('http://localhost:19185/event/$id/comments');

  //   for (var comment in response.data['comments']) {
  //     comments.add(Comment(
  //         comment["participant_firstname"],
  //         comment["participant_lastname"],
  //         comment["created_at"],
  //         comment["content"]));
  //   }
  //   return comments;
  // }

  Future<Map<String, double>> getCoordinates() async {
    final Dio dio = Dio();
    Map<String, double> coordinates = {};

    String zipcode = _event.zipcode!;
    String address = _event.street!;

    Response response = await dio.get(
        "https://api-adresse.data.gouv.fr/search/?q=$address&postcode=$zipcode&limit=1");

    if (response.statusCode == 200) {
      double lat =
          response.data['features']['geometry']['coordinates'][0].toDouble();
      double lng =
          response.data['features']['geometry']['coordinates'][1].toDouble();
      coordinates = {'latitude': lat, 'longitude': lng};
    }
    return coordinates;
  }

  Future<String> getAddress() async {
    final Dio dio = Dio();
    String address = "";
    double longitude = _event.longitude!;
    double latitude = _event.latitude!;
    Response response = await dio.get(
        "https://api-adresse.data.gouv.fr/reverse/?lon=$longitude&lat=$latitude");

    if (response.statusCode == 200) {
      address = response.data['features']['properties']["label"];
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
                _event.street == null &&
                        _event.city == null &&
                        _event.zipcode == null
                    ? Text(_address)
                    : Text("${_event.street} ${_event.city} ${_event.zipcode}")
              ]),
              Row(children: const [
                Icon(Icons.group),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Participants")),
              ]),
              const SizedBox(height: 25),
              Expanded(
                  child: FutureBuilder(
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
              )),
              const SizedBox(height: 25),
              // Center(
              //     child: Text(
              //   "Commentaires",
              //   style: TextStyle(fontSize: 20, color: Colors.grey[400]),
              // )),
              // const SizedBox(height: 25),
              // Expanded(
              //     child: FutureBuilder(
              //   future: getComments(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return ListView.builder(
              //           itemCount: snapshot.data!.length,
              //           itemBuilder: (context, index) {
              //             return CommentPreview(comment: snapshot.data![index]);
              //           });
              //     }

              //     if (snapshot.hasError) {
              //       return const Text("Error");
              //     }

              //     return const CircularProgressIndicator();
              //   },
              // )),
              Expanded(
                  child: FlutterMap(
                options: MapOptions(
                    minZoom: 3,
                    maxZoom: 18,
                    center: _event.longitude == null && _event.latitude == null
                        ? LatLng(_coordinates["latitude"]!,
                            _coordinates["longitude"]!)
                        : LatLng(_event.latitude!, _event.longitude!),
                    zoom: 5),
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
                          point: _event.longitude == null &&
                                  _event.latitude == null
                              ? LatLng(_coordinates["longitude"]!,
                                  _coordinates["latitude"]!)
                              : LatLng(_event.longitude!, _event.latitude!),
                          builder: (context) => const Icon(Icons.location_on))
                    ],
                  )
                ],
              )),
            ],
          )),
    );
  }
}
