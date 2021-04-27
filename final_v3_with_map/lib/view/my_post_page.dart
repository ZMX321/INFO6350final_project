import 'dart:async';

import 'package:final_project/authentication.dart';
import 'package:final_project/categoary/Item.dart';
import 'package:final_project/view/add_new_item_page.dart';
import 'package:final_project/view/edit_Item.dart';
import 'package:final_project/view/home_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class MyPostPage extends StatefulWidget {
  MyPostPage(this.userId, this.auth, this.logoutCallback);
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  _MyPostPageState createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  List<Item> _items = [];
  final FirebaseDatabase database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onItemAddedSubscription;
  StreamSubscription<Event> _onItemChangedSubscription;
  Query _itemQuery;

  @override
  void initState() {
    super.initState();
    print(widget.userId);
    _itemQuery = database
        .reference()
        .child("items")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onItemAddedSubscription = _itemQuery.onChildAdded.listen(onItemEntryAdded);
    _onItemChangedSubscription =
        _itemQuery.onChildChanged.listen(onItemEntryChanged);
  }

  void dispose() {
    _onItemAddedSubscription.cancel();
    _onItemChangedSubscription.cancel();
    super.dispose();
  }

  onItemEntryChanged(Event event) {
    var oldEntry = _items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      _items[_items.indexOf(oldEntry)] = Item.fromSnapshot(event.snapshot);
    });
  }

  onItemEntryAdded(Event event) async {
    setState(() {
      _items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  void _navigateToNewItem() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddNewItemPage(userId: widget.userId)));
  }

  Widget showItems() {
    if (_items.length > 0) {
      print("_items.length" + "${_items.length}");
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _items.length,
          itemBuilder: (context, index) {
            String itemtitle = _items[index].item;
            String imageUrl = _items[index].imageOne;
            String money = "${_items[index].money}";
            String location = _items[index].location;
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => edit_item(_items, index)))
                      .then((val) {
                    setState(() {
                      _items.removeAt(val);
                      new HomePage(
                        userId: widget.userId,
                        auth: widget.auth,
                        logoutCallback: widget.logoutCallback,
                      );
                    });
                  });
                },
                leading: imageUrl == ""
                    ? Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.pinkAccent,
                        size: 50.0,
                      )
                    : Image.network(
                        imageUrl,
                        width: 50.0,
                      ),
                title: Text(
                  itemtitle,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(location, style: TextStyle(fontSize: 13.0)),
                trailing: Text("\$" + money, style: TextStyle(fontSize: 18.0)),
              ),
            );
          });
    } else {
      return Center(
          child: Text(
        "Welcome. There is no post item",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('My Post'),
        ),
        body: showItems(),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToNewItem,
          tooltip: 'Post Item',
          child: Icon(Icons.add),
        ));
  }
}
