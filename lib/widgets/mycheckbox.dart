// import 'package:flutter/material.dart';
// import 'package:reunionou/widgets/map_widget.dart';

// class MyCheckbox extends StatefulWidget {
//   const MyCheckbox({super.key});

//   @override
//   CheckboxState createState() => CheckboxState();
// }

// class CheckboxState extends State<MyCheckbox> {
//   bool isChecked = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Checkbox(
//           value: isChecked,
//           onChanged: (bool? value) {
//             setState(() {
//               isChecked = value!;
//             });
//           }),
//       isChecked ? MapWidget() : Text("Chercher votre évènement !")
//     ]);
//   }
// }
