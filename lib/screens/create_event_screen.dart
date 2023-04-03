import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:reunionou/screens/create_invitation_screen.dart';
import 'package:reunionou/widgets/map_widget.dart';
import 'package:reunionou/widgets/mycheckbox.dart';

import '../widgets/navbar.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  CreateEventScreenState createState() {
    return CreateEventScreenState();
  }
}

class CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  final LatLng _selectedLocation = LatLng(10.0002, 12.3568);
  final double _latitude = 0.0;
  final double _longitude = 0.0;

  final myControllerTitle = TextEditingController();
  final myControllerDescription = TextEditingController();
  final myControllerStreet = TextEditingController();
  final myControllerCity = TextEditingController();
  final myControllerZipcode = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myControllerTitle.dispose();
    myControllerDescription.dispose();
    myControllerStreet.dispose();
    myControllerCity.dispose();
    myControllerZipcode.dispose();
    super.dispose();
  }

  // Future<Map<String, double>> getLatLong(String address) async {
  //   final Dio dio = Dio();
  //   Response response = await dio.get(
  //       "https://api-adresse.data.gouv.fr/search/?",
  //       queryParameters: {"q": address, "limit": "1"});
  //   if (response.statusCode == 200) {
  //     final lat =
  //         response.data['data']['features']['geometry']['coordinates'][0];
  //     final lng =
  //         response.data['data']['features']['geometry']['coordinates'][1];
  //     return {'latitude': lat, 'longitude': lng};
  //   } else {
  //     throw Exception('Failed to load location');
  //   }
  // }

  // void _onAddressChanged(String address) async {
  //   final latLng = await getLatLong(address);
  //   setState(() {
  //     _latitude = latLng['latitude']!;
  //     _longitude = latLng['longitude']!;
  //   });
  // }

  void submitForm(String title, String description, String? street,
      String? city, String? zipcode, double longitude, double latitude) async {
    final Dio dio = Dio();
    Response response =
        await dio.post('https://fruits.shrp.dev/auth/login', data: {
      'title': title,
      'description': description,
      'street': street,
      'city': city,
      'zipcode': zipcode,
      'longitude': longitude,
      'latitude': latitude
    });

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CreateInvitationScreen()));

      //ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Maintenant, inviter des gens à votre événement !")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(100), child: Navbar()),
        backgroundColor: const Color(0xFFF2F2F2),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Créer un évènement',
                style: TextStyle(fontSize: 30, color: Colors.grey[700]),
              ),
              const SizedBox(height: 25),
              Form(
                  child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Titre",
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            hintText: "Titre",
                            hintStyle: TextStyle(color: Colors.grey[500])),
                        // inputFormatters: <TextInputFormatter>[
                        //   FilteringTextInputFormatter.allow(RegExp('')),
                        // ],
                        controller: myControllerTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Titre non valide';
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Description",
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          hintText: "Description",
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      controller: myControllerDescription,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description non valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      }),
                  isChecked
                      ? MapWidget(selectedLocation: _selectedLocation)
                      : Column(children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  labelText: "Adresse",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400)),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  hintText: "Adresse",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[500])),
                              controller: myControllerStreet,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Adresse non valide';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  labelText: "Ville",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400)),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  hintText: "Ville",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[500])),
                              controller: myControllerCity,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ville non valide';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  labelText: "Code postal",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400)),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  hintText: "Code postal",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[500])),
                              controller: myControllerZipcode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Code postal non valide';
                                }
                                return null;
                              },
                            ),
                          ),
                        ]),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (isChecked) {
                          submitForm(
                              myControllerTitle.text,
                              myControllerDescription.text,
                              null,
                              null,
                              null,
                              _longitude,
                              _latitude);
                        } else {
                          submitForm(
                              myControllerTitle.text,
                              myControllerDescription.text,
                              myControllerStreet.text,
                              myControllerCity.text,
                              myControllerZipcode.text,
                              _longitude,
                              _latitude);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA084DC),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text(
                      'Créer',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}
