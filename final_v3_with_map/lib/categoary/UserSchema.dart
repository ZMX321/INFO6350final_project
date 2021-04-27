import 'package:firebase_database/firebase_database.dart';

//this User class is created to store information of post items and upload it to Firebase RTDB
class UserSchema {
  String key;
  String fName;
  String lName;
  String userId;
  String email;
  String contact;
  String location;
  String imageUrl;

  UserSchema(this.imageUrl, this.fName, this.lName, this.email, this.contact,
      this.location, this.userId);

  //Get user information from RTDB and create user object
  UserSchema.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        imageUrl = snapshot.value["imageUrl"],
        userId = snapshot.value["userId"],
        fName = snapshot.value["fName"],
        lName = snapshot.value["lName"],
        email = snapshot.value["email"],
        contact = snapshot.value["contact"],
        location = snapshot.value["location"];

  //Send information to firebase
  toJson() {
    return {
      "userId": userId,
      "imageUrl": imageUrl,
      "fName": fName,
      "lName": lName,
      "email": email,
      "contact": contact,
      "location": location,
    };
  }
}
