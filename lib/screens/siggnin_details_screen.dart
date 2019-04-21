import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_places_picker/google_places_picker.dart';

class SigninDetailsScreen extends StatefulWidget {
  final Function(
    String address,
    String phoneNumber,
    String fullName,
  ) callback;

  SigninDetailsScreen({Key key, this.callback}) : super(key: key);

  @override
  _SigninDetailsScreenState createState() => _SigninDetailsScreenState();
}

class _SigninDetailsScreenState extends State<SigninDetailsScreen> {
  String address;
  final phoneController = TextEditingController(),
      fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Доп. информация"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            child: TextFormField(
              controller: TextEditingController(text: address),
              maxLines: 1,
              decoration: InputDecoration(
                enabled: false,
                hintText: 'Адрес проживания',
                icon: GestureDetector(
                    child: Icon(
                      Icons.location_city,
                      color: Colors.grey,
                    ),
                    onTap: () async {
                      var _place =
                          await PluginGooglePlacePicker.showAutocomplete(
                              mode: PlaceAutocompleteMode.MODE_FULLSCREEN);
                      setState(() {
                        address = _place.address;
                      });
                    }),
              ),
              validator: (value) =>
                  value.isEmpty ? 'Необходимо выбрать адрес' : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            child: TextFormField(
              maxLines: 1,
              controller: phoneController,
              decoration: InputDecoration(
                  prefix: Text("+7"),
                  hintText: 'Номер телефона',
                  icon: Icon(
                    Icons.phone,
                    color: Colors.grey,
                  )),
              validator: (value) =>
                  value.isEmpty ? 'Необходимо заполнить номер телефона' : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            child: TextFormField(
              maxLines: 1,
              controller: fullNameController,
              decoration: InputDecoration(
                  hintText: 'ФИО',
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  )),
              validator: (value) =>
                  value.isEmpty ? 'Необходимо заполнить фио' : null,
            ),
          ),
          Expanded(child: Container()),
          FlatButton(
            child: Text("Готово"),
            onPressed: () => widget.callback(
                address, phoneController.text, fullNameController.text),
          ),
        ],
      ),
    );
  }
}
