import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gch_cityservice/category.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:path_provider/path_provider.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  MyTask task = MyTask();
  List<Asset> assetImages = List<Asset>();

  final addressController = TextEditingController(),
      titleController = TextEditingController(),
      snippetController = TextEditingController();

//  Future<String> uploadPic(String filename) async {
//    //Get the file from the image picker and store it
//    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    //Create a reference to the location you want to upload to in firebase
//    StorageReference reference = storageReference.child("tasks/" + filename);
//
//    //Upload the file to firebase
//    StorageUploadTask uploadTask = reference.putFile(image);
//
//    // Waits till the file is uploaded then stores the download url
//    final location = await (await uploadTask.onComplete).ref.getDownloadURL();
//
//    //returns the download url
//    return location;
//  }

  ProgressHUD _progressHUD;

  @override
  void initState() {
    super.initState();

    _progressHUD = ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Загрузка...',
      loading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить заявку"),
      ),
      body: Stack(
        children: <Widget>[
          Column(mainAxisSize: MainAxisSize.max, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Row(
                children: <Widget>[
                  Text("Секция:", style: Theme.of(context).textTheme.title),
                  Container(width: 10),
                  DropdownButton(
                    value: task.category.index,
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
                          task.position =
                              LatLng(_place.latitude, _place.longitude);
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
            Divider(),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) => index == assetImages.length
                    ? GestureDetector(
                        onTap: () => loadAssets(),
                        child: Container(
                          width: 200,
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 50,
                            ),
                          ),
                        ))
                    : Stack(
                        children: <Widget>[
                          AssetThumb(
                            asset: assetImages[index],
                            height: 200,
                            width: 200,
                          ),
                          Container(
                            width: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                child: IconButton(
                                  color: Colors.white,
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      assetImages.removeAt(index);
                                    });
                                  },
                                ),
                                alignment: Alignment.topRight,
                              ),
                            ),
                          ),
                        ],
                      ),
                itemCount: assetImages.length <= 5
                    ? assetImages.length + 1
                    : assetImages.length,
              ),
            ),
            Divider(),
//        FlatButton(
//          child: Text("Добавить картинку"),
//          onPressed: () => loadAssets(),
////          async {
////
////
////
////            task.picUrls.add((await uploadPic(
////                (((await databaseReference.child("tasks").once())
////                                .value
////                                ?.length ??
////                            0)
////                        .toString() +
////                    '_' +
////                    task.picUrls.length.toString()))));
////          },
//        ),
            Expanded(child: Container()),
            FlatButton(
              child: Text("Добавить", style: Theme.of(context).textTheme.title),
              onPressed: () async {
                _progressHUD.state.show();

                await addTask();

                _progressHUD.state.dismiss();

                Navigator.pop(context);
              },
            ),
          ]),
          _progressHUD,
        ],
      ),
    );
  }

  Future<File> _getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$dir/$filename');
    return f;
  }

  Future<void> addTask() async {
    task.title = titleController.text;
    task.snippet = snippetController.text;

    final nextId =
        (await databaseReference.child("tasks").once()).value?.length ?? 0;

    task.picUrls ??= List();
    task.picUrls.clear();
    for (var assetId = 0; assetId < assetImages.length; assetId++) {
      var asset = assetImages[assetId];

      ByteData byteData = await asset.requestOriginal();
      List<int> imageData = byteData.buffer.asUint8List();
      StorageReference ref = storageReference
          .child("tasks/" + nextId.toString() + '_' + assetId.toString());
      StorageUploadTask uploadTask = ref.putData(imageData);

      var location = await (await uploadTask.onComplete).ref.getDownloadURL();

      task.picUrls.add(location);
    }

    await task
        .toDatabase(databaseReference.child("tasks").child(nextId.toString()));
  }

  Future<void> loadAssets() async {
    List<Asset> resultList;

    resultList = await MultiImagePicker.pickImages(
      maxImages: 5 - assetImages.length,
      enableCamera: true,
    );

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      assetImages.addAll(resultList ?? List());
    });
  }
}
