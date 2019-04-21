import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gch_cityservice/pages/section_list_page.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_picker/google_places_picker.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  int categoryId;

  MyTask task = MyTask();

  final addressController = TextEditingController(),
      titleController = TextEditingController(),
      snippetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить заявку"),
      ),
      body: Column(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Row(
            children: <Widget>[
              Text("Секция:", style: Theme.of(context).textTheme.title),
              Container(width: 10),
              DropdownButton(
                value: categoryId,
                items: categoryNames
                    .map<DropdownMenuItem>((val) => DropdownMenuItem(
                          value: categoryNames.indexOf(val),
                          child: Text(val),
                        ))
                    .toList(),
                onChanged: (catId) {
                  setState(() {
                    task.category = Category.values[catId];
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: TextFormField(
            controller: addressController,
            maxLines: 1,
            decoration: InputDecoration(
              enabled: false,
              hintText: 'Адрес',
              icon: GestureDetector(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  onTap: () async {
                    var _place =
                        await PluginGooglePlacePicker.showAutocomplete();

                    setState(() {
                      addressController.text = _place.address;
                      task.position = LatLng(_place.latitude, _place.longitude);
                    });
                  }),
            ),
            validator: (value) =>
                value.isEmpty ? 'Необходимо выбрать/вписать адрес' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: TextFormField(
            maxLines: 2,
            controller: titleController,
            decoration: InputDecoration(
                hintText: 'Название',
                icon: Icon(
                  Icons.title,
                  color: Colors.grey,
                )),
            validator: (value) =>
                value.isEmpty ? 'Необходимо заполнить название' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: TextFormField(
            maxLines: 6,
            controller: snippetController,
            decoration: InputDecoration(
                hintText: 'Описание',
                icon: Icon(
                  Icons.textsms,
                  color: Colors.grey,
                )),
          ),
        ),
        Expanded(child: Container()),
        FlatButton(
          child: Text("Добавить", style: Theme.of(context).textTheme.title),
          onPressed: () async {
            task.title = titleController.text;
            task.snippet = snippetController.text;

            final nextId =
                (await databaseReference.child("tasks").once()).value.length;

            await task
                .toDatabase(databaseReference.child("tasks").child(nextId.toString()));
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }
}
