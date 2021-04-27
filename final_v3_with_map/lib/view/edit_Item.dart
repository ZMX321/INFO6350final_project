import 'dart:io';

import 'package:final_project/authentication.dart';
import 'package:final_project/categoary/Item.dart';
import 'package:final_project/components/get_location.dart';
import 'package:final_project/view/home_page.dart';
import 'package:final_project/view/my_post_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

import '../constants.dart';

class edit_item extends StatefulWidget {
  Item item;
  List<Item> items;
  int index;

  @override
  edit_item(this.items, this.index);

  _edit_itemState createState() => _edit_itemState();
}

class _edit_itemState extends State<edit_item> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  DatabaseReference itemRef;

  String condition = 'Like New';
  double maxValue = 0.0;
  bool _isloading;
  PickedFile _image1;
  PickedFile _image2;
  PickedFile _image3;
  PickedFile _image4;
  DateTime date = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.item = widget.items[widget.index];
    print(widget.item.favorite);
    _isloading = false;
    itemRef = database.reference().child('items');
  }

  //show the selection button of camera and gallery,
  //after choosing a picture show it at the select place
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

  //Call function to get access of camera
  _imgFromCamera(int choose) async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    if (choose == 1) {
      setState(() {
        _image1 = image;
      });
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

  //Call function to get access of gallery
  _imgFromGallery(int choose) async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    print(choose);
    if (choose == 1) {
      setState(() {
        _image1 = image;
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

  getUrl() async {
    final _storage = FirebaseStorage.instance;
    if (_image1 != null) {
      var imagelink = await _storage
          .ref()
          .child('PostItem/${widget.item.userId}/${widget.item.item}/imageone')
          .putFile(File(_image1.path));
      var imageurl = await imagelink.ref.getDownloadURL();
      widget.item.imageOne = "$imageurl";
    }
    if (_image2 != null) {
      var imagelink = await _storage
          .ref()
          .child('PostItem/${widget.item.userId}/${widget.item.item}/imagetwo')
          .putFile(File(_image2.path));
      var imageurl = await imagelink.ref.getDownloadURL();
      widget.item.imageTwo = "$imageurl";
    }
    if (_image3 != null) {
      var imagelink = await _storage
          .ref()
          .child(
              'PostItem/${widget.item.userId}/${widget.item.item}/imagethree')
          .putFile(File(_image3.path));
      var imageurl = await imagelink.ref.getDownloadURL();
      widget.item.imageThree = "$imageurl";
    }
    if (_image4 != null) {
      var imagelink = await _storage
          .ref()
          .child('PostItem/${widget.item.userId}/${widget.item.item}/imagefour')
          .putFile(File(_image4.path));
      var imageurl = await imagelink.ref.getDownloadURL();
      widget.item.imageFour = "$imageurl";
    }
  }

  Future<void> handlePost() async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      await getUrl();
      form.reset();
      itemRef.child(widget.item.key).set(widget.item.toJson());
    }
  }

  //Since all pics are seperated, we should creat four widget to monitor their action
  //they all can be added or not
  Widget choosePicone() {
    if (widget.item.imageOne == "" && _image1 == null) {
      return Icon(
        Icons.add_outlined,
        color: Colors.pinkAccent,
      );
    }
    if (_image1 != null) {
      return Image.file(File(_image1.path));
    }
    if (widget.item.imageOne != "") {
      return Image.network(widget.item.imageOne);
    }
  }

  Widget choosePictwo() {
    if (widget.item.imageTwo == "" && _image2 == null) {
      return Icon(
        Icons.add_outlined,
        color: Colors.pinkAccent,
      );
    }
    if (_image2 != null) {
      return Image.file(File(_image2.path));
    }
    if (widget.item.imageTwo != "") {
      return Image.network(widget.item.imageTwo);
    }
  }

  Widget choosePicthree() {
    if (widget.item.imageThree == "" && _image3 == null) {
      return Icon(
        Icons.add_outlined,
        color: Colors.pinkAccent,
      );
    }
    if (_image3 != null) {
      return Image.file(File(_image3.path));
    }
    if (widget.item.imageThree != "") {
      return Image.network(widget.item.imageThree);
    }
  }

  Widget choosePicfour() {
    if (widget.item.imageFour == "" && _image4 == null) {
      return Icon(
        Icons.add_outlined,
        color: Colors.pinkAccent,
      );
    }
    if (_image4 != null) {
      return Image.file(File(_image4.path));
    }
    if (widget.item.imageFour != "") {
      return Image.network(widget.item.imageFour);
    }
  }

  //Once item is sold, user can change them from edit_item page
  //when clicked the sold button, the item will be assigned as SOLD
  //which means the detail of this item cannot be seen
  //after reload the app, the item will be removed from home_page
  soldItem(String itemKey) {
    widget.item.sold = "true";
    itemRef.child(itemKey).set(widget.item.toJson());
    itemRef.child(itemKey).remove().then((_) {
      print("delete $itemKey successful");
      widget.items.removeAt(widget.index);
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
        title: Text('Edit Item'),
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
                              initialValue: widget.item.item,
                              // onSaved: (val) => _item.item = val,
                              // validator: (val) => val == "" ? val : null,
                              decoration: InputDecoration(
                                // filled: true,
                                hintText: widget.item.item,
                                labelText: 'Item',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value == null || value == "") {
                                    value = widget.item.item;
                                  }
                                  widget.item.item = value;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Condition',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16.0),
                                ),
                                DropdownButton<String>(
                                  value: condition,
                                  icon:
                                      Icon(Icons.keyboard_arrow_down_outlined),
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
                                      widget.item.condition = condition;
                                    });
                                  },
                                ),
                              ],
                            ),
                            TextFormField(
                              initialValue: widget.item.description,
                              // onSaved: (val) => _item.description = val,
                              // validator: (val) => val == "" ? val : null,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                // filled: true,
                                hintText: widget.item.description,
                                labelText: 'Description',
                              ),
                              onChanged: (value) {
                                if (value == null || value == "") {
                                  value = widget.item.description;
                                }
                                widget.item.description = value;
                              },
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Slider(
                                  min: 0,
                                  max: 1000,
                                  divisions: 500,
                                  value: maxValue,
                                  onChanged: (value) {
                                    setState(() {
                                      maxValue = value;
                                      widget.item.money = "$maxValue";
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                                          child: choosePicone()),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showPicker(context, 2);
                                      },
                                      child: Container(
                                          color: Colors.black12,
                                          child: choosePictwo()),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showPicker(context, 3);
                                      },
                                      child: Container(
                                          color: Colors.black12,
                                          child: choosePicthree()),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showPicker(context, 4);
                                      },
                                      child: Container(
                                          color: Colors.black12,
                                          child: choosePicfour()),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7.0,
                                ),
                                TextFormField(
                                  initialValue: widget.item.contact,
                                  // onSaved: (val) => _item.contact = val,
                                  // validator: (val) => val == "" ? val : null,
                                  decoration: InputDecoration(
                                    // filled: true,
                                    hintText: widget.item.contact,
                                    labelText: 'Contact Info',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == null || value == "") {
                                        value = widget.item.contact;
                                      }
                                      widget.item.contact = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 7.0,
                                ),
                                GetLocation(
                                  item: widget.item,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await soldItem(widget.item.key);

                                        Navigator.pop(context, widget.index);
                                      },
                                      child: Text(
                                        'Sold',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isloading = true;
                                        });
                                        await handlePost();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Update',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                  ],
                                )
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
                        ],
                      ),
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
