import 'package:final_project/authentication.dart';
import 'package:final_project/categoary/Item.dart';
import 'package:final_project/categoary/UserSchema.dart';
import 'package:final_project/components/profile_drawer.dart';
import 'package:final_project/components/snackbar_page.dart';
import 'package:final_project/view/add_new_item_page.dart';
import 'package:final_project/view/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserSchema> _users = [];
  List<Item> _items = [];

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StreamSubscription<Event> _onUserAddedSubscription;
  StreamSubscription<Event> _onUserChangedSubscription;
  StreamSubscription<Event> _onItemAddedSubscription;
  StreamSubscription<Event> _onItemChangedSubscription;
  UserSchema user;
  Query _userQuery;
  Query _itemQuery;

  //TODO: unused
  void _navigateToNewItem(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddNewItemPage(userId: widget.userId)));

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    print("showsnackbar");
    SnackBarPage();
  }

  //As start the home_page,we should retrive all the data of users and items
  //Put the User information at drawerpage
  //Put the Item information at home_page as list
  @override
  void initState() {
    super.initState();
    user = UserSchema("", "", "", "", "", "", widget.userId);
    _userQuery = _database
        .reference()
        .child("users")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _itemQuery = _database.reference().child("items");
    _onUserAddedSubscription = _userQuery.onChildAdded.listen(onUserEntryAdded);
    _onUserChangedSubscription =
        _userQuery.onChildChanged.listen(onUserEntryChanged);
    _onItemAddedSubscription = _itemQuery.onChildAdded.listen(onItemEntryAdded);
    _onItemChangedSubscription =
        _itemQuery.onChildChanged.listen(onItemEntryChanged);
  }

  void getUser() {
    if (_users == null || _users.isEmpty) {
      print("none users");
      print(_users.length);
    } else {
      print("check users");
      print(_users.length);
      for (UserSchema tempuser in _users) {
        if (tempuser.userId == widget.userId) {
          print(user.userId);
          user = tempuser;
        }
      }
    }
  }

  @override
  void dispose() {
    _onUserAddedSubscription.cancel();
    _onUserChangedSubscription.cancel();
    _onItemAddedSubscription.cancel();
    _onItemChangedSubscription.cancel();
    super.dispose();
  }

  onUserEntryChanged(Event event) {
    var oldEntry = _users.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _users[_users.indexOf(oldEntry)] =
          UserSchema.fromSnapshot(event.snapshot);
      getUser();
    });
  }

  onUserEntryAdded(Event event) async {
    print('add');
    setState(() {
      _users.add(UserSchema.fromSnapshot(event.snapshot));
      getUser();
    });
    print(_users.length);
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
    // print("Items + $_items.length");
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget showItems() {
    if (_items.length > 0) {
      print("_items.length" + "${_items.length}");
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _items.length,
        itemBuilder: (context, index) {
          String itemTitle = _items[index].item;
          String imageUrl = _items[index].imageOne;
          String money = "${_items[index].money}";
          String location = _items[index].location;
          String sold = _items[index].sold;
          String favorite = _items[index].favorite;
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostDetail(
                            _items[index], widget.userId, widget.auth)));
              },
              leading: imageUrl == ""
                  ? Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.pinkAccent,
                      size: 50.0,
                    )
                  : Image.network(
                      imageUrl,
                      width: 50,
                    ),
              title: Text(
                itemTitle,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                location,
                style: TextStyle(fontSize: 13.0),
              ),
              trailing: sold == "false"
                  ? Text(
                      "\$" + money,
                      style:
                          TextStyle(fontSize: 18.0, color: Colors.pinkAccent),
                    )
                  : Text(
                      "SOLD",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.red[900],
                      ),
                    ),
            ),
          );
        },
      );
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Here'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
                size: 28.0,
              ),
              onPressed: () {
                signOut();
              }),
        ],
      ),
      body: showItems(),
      drawer: ProfileDrawer(
          user: user, auth: widget.auth, logoutCallback: widget.logoutCallback),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewItemPage(userId: widget.userId)));
        },
        tooltip: 'Post Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
