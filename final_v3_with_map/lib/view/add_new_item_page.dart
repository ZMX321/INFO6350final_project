import 'dart:async';
import 'dart:io';

import 'package:final_project/categoary/Item.dart';
import 'package:final_project/components/get_location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

import '../constants.dart';

class AddNewItemPage extends StatefulWidget {
  static const String id = 'additem_page';

  AddNewItemPage({Key key, this.userId}) : super(key: key);

  int choose = 0;
  final String userId;

  _AddNewItemPage createState() => _AddNewItemPage();
}

class _AddNewItemPage extends State<AddNewItemPage> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();

  final Geolocator geolocator = Geolocator();

  DatabaseReference itemRef;
  Item _item;
  String location = '';
  String description = '';
  String condition = 'Like New';
  List added = [];
  DateTime date = DateTime.now();

  double maxValue = 0.0;
  PickedFile _image1;
  PickedFile _image2;
  PickedFile _image3;
  PickedFile _image4;
  bool _isloading;


  void initState() {
    super.initState();
    _isloading = false;
    _item = Item("", "", "0", "", "", "", "", "", "", "$date", widget.userId,
        "", "false");
    print(_item.date);
    itemRef = database.reference().child('items');
    print("restart");
  }

  // get_label() async{
  //   // image_label.clear();
  //   // final File imageFile = File(_image1.path);
  //   FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(_image1.path);
  //   ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
  //   List<ImageLabel> labels = await labeler.processImage(visionImage);
  //   print("ml");
  //   print(labels.length);
  //   for(ImageLabel label in labels){
  //     _item.label = label.text;
  //     print(_item.label);
  //   }
  // }

  //send data to the firebase
  Future<void> handlePost() async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('hi');
      await getUrl();
      form.reset();
      itemRef.push().set(_item.toJson());
    }
  }

  //Since we can only use the File object to receive the picture from picture_picker
  getUrl() async {
    final _storage = FirebaseStorage.instance;
    if (_image1 != null) {
      var imagelink = await _storage
          .ref()
          .child('PostItem/${widget.userId}/${_item.item}/imageone')
          .putFile(File(_image1.path));
      var imageurl = await imagelink.ref.getDownloadURL();
      _item.imageOne = "$imageurl";
    }
    if (_image2 != null) {
      var imagelink = await _storage
          .ref()
          .child('PostItem/${widget.userId}/${_item.item}/imagetwo')
          .putFile(File(_image2.path));
      var imageurl = await imagelink.ref.getDownloadURL();
      _item.imageTwo = "$imageurl";
    }
    if (_image3 != null) {
      var imagelink = await _storage
          .ref()
          .child('PostItem/${widget.userId}/${_item.item}/imagethree')
          .putFile(File(_image3.path));
      var imageurl = await imagelink.ref.getDownloadURL();
      _item.imageThree = "$imageurl";
    }
    if (_image4 != null) {
      var imagelink = await _storage
          .ref()
          .child('PostItem/${widget.userId}/${_item.item}/imagefour')
          .putFile(File(_image4.path));
      var imageurl = await imagelink.ref.getDownloadURL();
      _item.imageFour = "$imageurl";
    }
  }

  _imgFromCamera(int choose) async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    if (choose == 1) {
      setState(() {
        _image1 = image;
      });
      // get_label();
    } else if (choose == 2) {
      setState(() {
        _image2 = image;
      });
    } else if (choose == 3) {
      setState(() {
        _image3 = image;
      });
    } else if (choose == 4) {
      setState(() {
        _image4 = image;
      });
    }
  }

  _imgFromGallery(int choose) async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    print(choose);
    if (choose == 1) {
      setState(() {
        _image1 = image;
        // get_label();
        image = null;
      });
    } else if (choose == 2) {
      setState(() {
        _image2 = image;
        image = null;
      });
    } else if (choose == 3) {
      setState(() {
        _image3 = image;
        image = null;
      });
    } else if (choose == 4) {
      setState(() {
        _image4 = image;
        image = null;
      });
    }
  }

  void _showPicker(context, int choose) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(choose);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(choose);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _showCircularProgress() {
    if (_isloading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Scrollbar(
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ...[
                              TextFormField(
                                initialValue: '',
                                onSaved: (val) => _item.item = val,
                                validator: (val) => val == "" ? val : null,
                                decoration: InputDecoration(
                                  hintText: 'Enter your Item Name...',
                                  labelText: 'Item',
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Condition',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 16.0),
                                  ),
                                  DropdownButton<String>(
                                    value: condition,
                                    icon: Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                    items: conditionList
                                        .map((condition) => DropdownMenuItem(
                                              value: condition,
                                              child: Text(
                                                condition,
                                                style: TextStyle(
                                                    color: Colors.pinkAccent),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (selected) {
                                      setState(() {
                                        condition = selected;
                                        _item.condition = condition;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              TextFormField(
                                initialValue: '',
                                onSaved: (val) => _item.description = val,
                                validator: (val) => val == "" ? val : null,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  // filled: true,
                                  hintText: 'Enter a description...',
                                  labelText: 'Description',
                                ),
                                // onChanged: (value) {
                                //   description = value;
                                // },
                                maxLines: 5,
                              ),
                              // SizedBox(height: 7.0,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        color: Colors.pinkAccent,
                                      ),
                                      SizedBox(
                                        width: 7.0,
                                      ),
                                      Text(
                                        'Estimated Value',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7.0,
                                  ),
                                  Text(
                                    intl.NumberFormat.currency(
                                            symbol: "\$", decimalDigits: 0)
                                        .format(maxValue),
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Slider(
                                    min: 0,
                                    max: 1000,
                                    divisions: 500,
                                    value: maxValue,
                                    onChanged: (value) {
                                      setState(() {
                                        maxValue = value;
                                        _item.money = "$maxValue";
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.pinkAccent,
                                      ),
                                      SizedBox(
                                        width: 7.0,
                                      ),
                                      Text(
                                        "Picture",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7.0,
                                  ),
                                  GridView.count(
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.all(20),
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 4,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showPicker(context, 1);
                                        },
                                        child: Container(
                                            color: Colors.black12,
                                            child: _image1 == null
                                                ? Icon(
                                                    Icons.add_outlined,
                                                    color: Colors.pinkAccent,
                                                  )
                                                : Image.file(
                                                    File(_image1.path))),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showPicker(context, 2);
                                        },
                                        child: Container(
                                            color: Colors.black12,
                                            child: _image2 == null
                                                ? Icon(
                                                    Icons.add_outlined,
                                                    color: Colors.pinkAccent,
                                                  )
                                                : Image.file(
                                                    File(_image2.path))),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showPicker(context, 3);
                                        },
                                        child: Container(
                                            color: Colors.black12,
                                            child: _image3 == null
                                                ? Icon(
                                                    Icons.add_outlined,
                                                    color: Colors.pinkAccent,
                                                  )
                                                : Image.file(
                                                    File(_image3.path))),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showPicker(context, 4);
                                        },
                                        child: Container(
                                            color: Colors.black12,
                                            child: _image4 == null
                                                ? Icon(
                                                    Icons.add_outlined,
                                                    color: Colors.pinkAccent,
                                                  )
                                                : Image.file(
                                                    File(_image4.path))),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7.0,
                                  ),
                                  TextFormField(
                                    initialValue: '',
                                    onSaved: (val) => _item.contact = val,
                                    validator: (val) => val == "" ? val : null,
                                    decoration: InputDecoration(
                                      // filled: true,
                                      hintText:
                                          'Enter your phone number or email...',
                                      labelText: 'Contact Info',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7.0,
                                  ),
                                  GetLocation(
                                    item: _item,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isloading = true;
                                      });
                                      await handlePost();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                            Text('You post a new Item')
                                          ],
                                        ),
                                      ));
                                    },
                                    child: Text(
                                      'Post',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ],
                              )
                            ].expand(
                              (widget) => [
                                widget,
                                SizedBox(
                                  height: 24,
                                )
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _showCircularProgress()
        ],
      ),
    );
  }
}
