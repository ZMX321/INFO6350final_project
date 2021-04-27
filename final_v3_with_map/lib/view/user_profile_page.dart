import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:final_project/authentication.dart';
import 'package:final_project/categoary/UserSchema.dart';
import 'package:final_project/view/home_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  static const String id = 'profile_page';


  UserProfilePage({Key key, this.userId, this.auth, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;


  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<UserSchema> users = [];
  UserSchema user;
  DatabaseReference userRef;
  String tmpKey;
  bool check = false;

  StreamSubscription<Event> _onUserAddedSubscription;
  StreamSubscription<Event> _onUserChangedSubscription;
  Query _userQuery;
  PickedFile _image;
  bool isloading;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getUser() {
    if (users == null || users.isEmpty) {
      print("none users");
      print(users.length);
    } else {
      print("check users");
      print(users.length);
      for (UserSchema tempuser in users) {
        if (tempuser.userId == widget.userId) {
          print(tempuser.userId);
          check = true;
          user = tempuser;
        }
      }
    }
  }

  void initState() {
    super.initState();
    isloading = false;
    _userQuery = database
        .reference()
        .child("users")
        .orderByChild("userId")
        .equalTo(widget.userId);
    user = UserSchema(
      "https://firebasestorage.googleapis.com/v0/b/info6350-56ed1.appspot.com/o/default%2FAvatar-man.png?alt=media&token=974faf38-602e-44b6-aa1c-b86c9ca9a48d",
      "",
      "",
      "",
      "",
      "",
      widget.userId,
    );
    print(widget.userId);
    userRef = database.reference().child('users');
    _onUserAddedSubscription = _userQuery.onChildAdded.listen(_onEntryAdded);
    _onUserChangedSubscription =
        _userQuery.onChildChanged.listen(_onEntryChanged);
  }

  void _onEntryAdded(Event event) {
    setState(() {
      users.add(UserSchema.fromSnapshot(event.snapshot));
      print(users.toString());
    });
    getUser();
  }

  void _onEntryChanged(Event event) {
    var old = users.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      users[users.indexOf(old)] = UserSchema.fromSnapshot(event.snapshot);
    });
    getUser();
  }

  ImageProvider choosePic() {
    if (user.imageUrl == "" && _image == null) {
      return NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/info6350-56ed1.appspot.com/o/default%2FAvatar-man.png?alt=media&token=974faf38-602e-44b6-aa1c-b86c9ca9a48d");
    }
    if (_image != null) {
      return FileImage(File(_image.path));
    }
    if (user.imageUrl != "") {
      return NetworkImage(user.imageUrl);
    }
  }

  getImageUrl() async {
    final _storage = FirebaseStorage.instance;
    if (_image != null) {
      var imagelink = await _storage
          .ref()
          .child('Avatar/${user.userId}')
          .putFile(File(_image.path));
      var imageurl = await imagelink.ref.getDownloadURL();

      user.imageUrl = imageurl;
    }
  }

  Future<void> handleSubmit() async {
    final FormState form = formKey.currentState;
    form.save();
    await getImageUrl();
    print(user.imageUrl);
    form.reset();
    if(check){
      userRef.child(user.key).set(user.toJson());
    }else{
      userRef.push().set(user.toJson());
    }

  }

  void dispose() {
    _onUserAddedSubscription.cancel();
    _onUserChangedSubscription.cancel();
    super.dispose();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imageFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imageFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Widget _showCircularProgress() {
    if (isloading) {
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
        title: Text("Edit Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 110,
              height: 110,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      backgroundImage: choosePic(),
                      radius: 50.0,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.photo_camera_sharp),
                      onPressed: () {
                        _showPicker(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      initialValue: user.fName,
                      // onSaved: (val) => user.fName = val,
                      // validator: (val) => val == "" ? val : null,
                      decoration: InputDecoration(
                        // filled: true,
                        hintText: user.fName,
                        labelText: 'First Name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value == null || value == "") {
                            value = user.fName;
                          }
                          user.fName = value;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: user.lName,
                      // onSaved: (val) => user.lName = val,
                      // validator: (val) => val == "" ? val : null,
                      decoration: InputDecoration(
                        // filled: true,
                        hintText: user.lName,
                        labelText: 'Last Name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value == null || value == "") {
                            value = user.lName;
                          }
                          user.lName = value;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: user.email,
                      // onSaved: (val) => user.email = val,
                      // validator: (val) => val == "" ? val : null,
                      decoration: InputDecoration(
                        // filled: true,
                        hintText: '${user.email}',
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value == null || value == "") {
                            value = user.email;
                          }
                          user.email = value;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: user.contact,
                      // onSaved: (val) => user.contact = val,
                      // validator: (val) => val == "" ? val : null,
                      decoration: InputDecoration(
                        // filled: true,
                        hintText: '${user.contact}',
                        labelText: 'Contact number',
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value == null || value == "") {
                            value = user.contact;
                          }
                          user.contact = value;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: user.location,
                      // onSaved: (val) => user.location = val,
                      // validator: (val) => val == "" ? val : null,
                      decoration: InputDecoration(
                        // filled: true,
                        hintText: user.location,
                        labelText: 'Location',
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value == null || value == "") {
                            value = user.location;
                          }
                          user.location = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15.0, color: Colors.black54),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isloading = true;
                    });
                    await handleSubmit();
                    HomePage(
                      userId: widget.userId,
                      auth: widget.auth,
                      logoutCallback: widget.logoutCallback,
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 15.0, color: Colors.black54),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
              ],
            ),
            _showCircularProgress()
          ],
        ),
      ),
    );
  }
}
