import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/screens/create_invitation_screen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../widgets/navbar.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  CreateEventScreenState createState() => CreateEventScreenState();
}

class CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  MapController? mapController;
  LatLng? _selectedLocation;

  void _onLocationSelected(TapPosition location1, LatLng location2) {
    setState(() {
      _selectedLocation = location2;
    });
  }

  final myControllerTitle = TextEditingController();
  final myControllerDescription = TextEditingController();
  final myControllerDateTime = TextEditingController();
  final myControllerStreet = TextEditingController();
  final myControllerCity = TextEditingController();
  final myControllerZipcode = TextEditingController();

  @override
  void dispose() {
    myControllerTitle.dispose();
    myControllerDescription.dispose();
    myControllerDateTime.dispose();
    myControllerStreet.dispose();
    myControllerCity.dispose();
    myControllerZipcode.dispose();
    super.dispose();
  }

  void submitForm(
      String title,
      String description,
      String? street,
      String? city,
      String? zipcode,
      double? longitude,
      double? latitude,
      DateTime date) async {
    try {
      String token = Provider.of<UserProvider>(context, listen: false)
          .currentUser!
          .accessToken;

      final Dio dio = Dio();

      Map<String, dynamic> data = {
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
      };

      if (longitude != null && latitude != null) {
        data.addAll({
          'longitude': longitude,
          'latitude': latitude,
        });
      } else {
        data.addAll({
          'street': street,
          'city': city,
          'zipcode': zipcode,
        });
      }

      Response response = await dio.post('http://localhost:19185/event',
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateInvitationScreen()));

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Maintenant, invitez des gens à votre événement !")),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Navbar(),
      ),
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
              key: _formKey,
              child: Expanded(
                  child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.title),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: 'Titre',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          hintText: 'Titre',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                        controller: myControllerTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le titre doit être complété';
                          } else if (!RegExp(r'^[a-zA-Z0-9\' + 'À-ÖØ-öø-ÿ]+\$')
                              .hasMatch(value)) {
                            return 'Le titre peut uniquement contenir des lettres ou chiffres';
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.comment),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: 'Description',
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      controller: myControllerDescription,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La description doit être complété';
                        } else if (!RegExp(r'^[a-zA-Z0-9\' + 'À-ÖØ-öø-ÿ]+\$')
                            .hasMatch(value)) {
                          return 'Le description peut uniquement contenir des lettres ou chiffres';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Date et heure',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: 'Date et heure',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      controller: myControllerDateTime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La date et l\'heure doit être complété';
                        }
                        return null;
                      },
                      onTap: () {
                        DatePicker.showDateTimePicker(
                          context,
                          showTitleActions: true,
                          onConfirm: (date) {
                            myControllerDateTime.text = date
                                .toString(); // ou toute autre format de date/heure souhaité
                            myControllerDateTime.value =
                                myControllerDateTime.value.copyWith(
                              text: date.toString(),
                              selection: TextSelection.collapsed(
                                  offset: date.toString().length),
                            );
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.fr,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: 250,
                      height: 50,
                      child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: isChecked
                              ? const Text("Géolocalisation par map")
                              : const Text("Géolocalisation par adresse"),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          })),
                  const SizedBox(height: 10),
                  isChecked
                      ? Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: FlutterMap(
                                mapController: mapController,
                                options: MapOptions(
                                  minZoom: 3,
                                  maxZoom: 18,
                                  center: LatLng(46.232193, 2.209667),
                                  zoom: 5,
                                  onTap: _onLocationSelected,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    subdomains: const ['a', 'b', 'c'],
                                  ),
                                  MarkerLayer(
                                    markers: _selectedLocation != null
                                        ? [
                                            Marker(
                                              point: _selectedLocation!,
                                              builder: (context) =>
                                                  const Icon(Icons.location_on),
                                            ),
                                          ]
                                        : [],
                                  ),
                                ],
                              )))
                      : Column(children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.location_on),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Adresse',
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: 'Adresse',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                              controller: myControllerStreet,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'L\'adresse postal doit être complété';
                                } else if (!RegExp(
                                        r'^[a-zA-Z0-9\' + 'À-ÖØ-öø-ÿ]+\$')
                                    .hasMatch(value)) {
                                  return 'L`adresse peut uniquement contenir des lettres ou chiffres';
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
                                prefixIcon: const Icon(Icons.location_on),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Ville',
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: 'Ville',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                              controller: myControllerCity,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'La ville doit être complété';
                                } else if (!RegExp(
                                        r'^[a-zA-Z\' + 'À-ÖØ-öø-ÿ]+\$')
                                    .hasMatch(value)) {
                                  return 'La ville peut uniquement contenir des lettres ou chiffres';
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
                                prefixIcon: const Icon(Icons.location_on),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Code postal',
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: 'Code postal',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                              controller: myControllerZipcode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Le code postal doit être complété';
                                } else if (!RegExp(
                                        r'^(0[1-9]|[1-9][0-9])[0-9]{3}$')
                                    .hasMatch(value)) {
                                  return 'Le code postal peut uniquement contenir des Chiffres';
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
                                _selectedLocation!.longitude,
                                _selectedLocation!.latitude,
                                DateTime.parse(myControllerDateTime.text));
                          } else {
                            submitForm(
                                myControllerTitle.text,
                                myControllerDescription.text,
                                myControllerStreet.text,
                                myControllerCity.text,
                                myControllerZipcode.text,
                                null,
                                null,
                                DateTime.parse(myControllerDateTime.text));
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
                      )),
                ],
              )))
        ],
      )),
    );
  }
}
