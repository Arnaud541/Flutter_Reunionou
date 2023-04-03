import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reunionou/screens/create_invitation_screen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../widgets/navbar.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  double _latitude = 0.0;
  double _longitude = 0.0;

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

  Future<Map<String, double>> getLatLong(String address, String city) async {
    final Dio dio = Dio();
    Response response = await dio.get(
        "https://api-adresse.data.gouv.fr/search/?q=$address&city=$city&limit=1");

    if (response.statusCode == 200) {
      final lat =
      response.data['features'][0]['geometry']['coordinates'][1];
      final lng =
      response.data['features'][0]['geometry']['coordinates'][0];
      return {'latitude': lat, 'longitude': lng};
    } else {
      throw Exception('Failed to load location');
    }
  }

  void _onAddressChanged(String address) async {
    final latLng =
    await getLatLong(myControllerStreet.text, myControllerCity.text);
    setState(() {
      _latitude = latLng['latitude']!;
      _longitude = latLng['longitude']!;
    });
  }

  void submitForm(String title, String description, String street, String city,
      String zipcode, double longitude, double latitude) async {
    final Dio dio = Dio();
    Response response = await dio.post(
        'https://fruits.shrp.dev/events',
        data: {
          'title': title,
          'description': description,
          'street': street,
          'city': city,
          'zipcode': zipcode,
          'longitude': longitude,
          'latitude': latitude
        },
        options: Options(headers: {
          'Authorization': 'Bearer <YOUR_AUTH_TOKEN>'
        }));

    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CreateInvitationScreen()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Maintenant, invitez des gens à votre événement !")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
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
                  key: _formKey, // add the key to the Form widget
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.title),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Titre',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey
                                  .shade400),
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
                            } else if (!RegExp(r'^[a-zA-Z0-9\'+'À-ÖØ-öø-ÿ]+\$').hasMatch(
                                value)) {
                              return 'Le titre peut uniquement contenir des lettres ou chiffres';
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
                            prefixIcon: const Icon(Icons.comment),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Description',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey
                                  .shade400),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            hintText: 'Description',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          controller: myControllerDescription,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La description doit être complété';
                            } else if (!RegExp(r'^[a-zA-Z0-9\'+'À-ÖØ-öø-ÿ]+\$').hasMatch(
                                value)) {
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
                                  color: Colors.grey.shade400),
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
                            } else if (!RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$').hasMatch(
                                value)) {
                              return 'La date et l\'heure peut uniquement contenir une date et une heure';
                            }
                            return null;
                          },
                          onTap: () {
                            DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              onConfirm: (date) {
                                String monthName = '';

                                switch (date.month) {
                                  case 1:
                                    monthName = 'Janvier';
                                    break;
                                  case 2:
                                    monthName = 'Février';
                                    break;
                                  case 3:
                                    monthName = 'Mars';
                                    break;
                                  case 4:
                                    monthName = 'Avril';
                                    break;
                                  case 5:
                                    monthName = 'Mai';
                                    break;
                                  case 6:
                                    monthName = 'Juin';
                                    break;
                                  case 7:
                                    monthName = 'Juillet';
                                    break;
                                  case 8:
                                    monthName = 'Août';
                                    break;
                                  case 9:
                                    monthName = 'Septembre';
                                    break;
                                  case 10:
                                    monthName = 'Octobre';
                                    break;
                                  case 11:
                                    monthName = 'Novembre';
                                    break;
                                  case 12:
                                    monthName = 'Décembre';
                                    break;
                                }
                                myControllerDateTime.text = '${date.day} ${monthName} ${date.year} à ${date.hour}h ${date.minute}min';
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.fr,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.location_on),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Adresse',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey
                                  .shade400),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            hintText: 'Adresse',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          controller: myControllerStreet,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'L`adresse postal doit être complété';
                            } else if (!RegExp(r'^[a-zA-Z0-9\'+'À-ÖØ-öø-ÿ]+\$').hasMatch(
                                value)) {
                              return 'L`adresse peut uniquement contenir des lettres ou chiffres';
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
                            prefixIcon: const Icon(Icons.location_on),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Ville',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey
                                  .shade400),
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
                            } else if (!RegExp(r'^[a-zA-Z\'+'À-ÖØ-öø-ÿ]+\$').hasMatch(
                                value)) {
                              return 'La ville peut uniquement contenir des lettres ou chiffres';
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
                            prefixIcon: const Icon(Icons.location_on),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Code postal',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey
                                  .shade400),
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
                            } else if (!RegExp(r'^(0[1-9]|[1-9][0-9])[0-9]{3}$').hasMatch(
                                value)) {
                              return 'Le code postal peut uniquement contenir des Chiffres';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitForm(
                                myControllerTitle.text,
                                myControllerDescription.text,
                                myControllerStreet.text,
                                myControllerCity.text,
                                myControllerZipcode.text,
                                _longitude,
                                _latitude);
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
                  ))
            ],
          ),
        ));
  }
}
