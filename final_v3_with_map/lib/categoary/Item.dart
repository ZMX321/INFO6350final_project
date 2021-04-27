import 'package:firebase_database/firebase_database.dart';

//this Item class is created to store information of post items and upload it to Firebase RTDB
class Item {
  String key;
  String item;
  String description;
  String money;
  String imageOne;
  String imageTwo;
  String imageThree;
  String imageFour;
  String contact;
  String location;
  String date;
  String userId;
  String sold = "false";
  String condition;
  String favorite = "false";

  Item(
    this.item,
    this.description,
    this.money,
    this.imageOne,
    this.imageTwo,
    this.imageThree,
    this.imageFour,
    this.contact,
    this.location,
    this.date,
    this.userId,
    this.condition,
    this.favorite,
  );

  //Get user information from RTDB and create user object
  Item.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    item = snapshot.value["item"];
    description = snapshot.value["description"];
    money = snapshot.value["money"];
    imageOne = snapshot.value["imageone"];
    imageTwo = snapshot.value["imagetwo"];
    imageThree = snapshot.value["imagethree"];
    imageFour = snapshot.value["imagefour"];
    contact = snapshot.value["contact"];
    location = snapshot.value["location"];
    date = snapshot.value["date"];
    userId = snapshot.value["userId"];
    sold = snapshot.value["sold"];
    condition = snapshot.value["condition"];
    favorite = snapshot.value["favorite"];
  }
  //Send information to firebase
  toJson() {
    return {
      "item": item,
      "description": description,
      "money": money,
      "imageone": imageOne,
      "imagetwo": imageTwo,
      "imagethree": imageThree,
      "imagefour": imageFour,
      "contact": contact,
      "location": location,
      "date": date,
      "userId": userId,
      "sold": sold,
      "condition": condition,
      "favorite": favorite,
    };
  }
}
