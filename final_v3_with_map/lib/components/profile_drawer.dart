import 'package:final_project/authentication.dart';
import 'package:final_project/categoary/Item.dart';
import 'package:final_project/categoary/UserSchema.dart';
import 'package:final_project/view/login_signup_page.dart';
import 'package:final_project/view/user_profile_page.dart';
import 'package:final_project/view/my_post_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// this profile drawer is the left drawer of the home page, to show the basic information
//of current user. Form this drawer, users can go to edit their own profile and see their
// previous post. Also log out their account from app.
class ProfileDrawer extends StatefulWidget {
  ProfileDrawer({this.user, this.auth, this.userId, this.logoutCallback});

  final UserSchema user;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  void _navigateUserprofile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserProfilePage(userId: widget.user.userId)));
  }

  //Used by the logout button
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  //Used by the my post button, to go to the list of user own post and edit their posting item.
  void _navigateToMyPost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyPostPage(
                widget.user.userId, widget.auth, widget.logoutCallback)));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: widget.user.imageUrl == ''
                      ? AssetImage('assets/Avatar-man.png')
                      : NetworkImage(widget.user.imageUrl),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.user.fName == ''
                          ? 'User Name'
                          : widget.user.fName + widget.user.lName,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextButton(
                      onPressed: () {
                        _navigateUserprofile();
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            size: 15.0,
                          ),
                          Text(
                            'Edit your profile',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.email,
              color: Colors.pinkAccent,
            ),
            title: Text(
              widget.user.email == "" ? "test@test.com" : widget.user.email,
              style: TextStyle(
                  color: Colors.black54, fontSize: 18.0, letterSpacing: 1.0),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.phone,
              color: Colors.pinkAccent,
            ),
            title: Text(
              widget.user.contact == "" ? "(XXX)XXX-XXXX" : widget.user.contact,
              style: TextStyle(
                  color: Colors.black54, fontSize: 18.0, letterSpacing: 1.0),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.location_city,
              color: Colors.pinkAccent,
            ),
            title: Text(
              widget.user.location == "" ? "Location" : widget.user.location,
              style: TextStyle(
                  color: Colors.black54, fontSize: 18.0, letterSpacing: 1.0),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                _navigateToMyPost();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text(
                'My Posts',
                style: TextStyle(
                    color: Colors.black54, fontSize: 18.0, letterSpacing: 1.0),
              ),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                signOut();
                // Navigator.pushNamed(context, LoginSignupPage.id);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text(
                'Sign Out',
                style: TextStyle(
                    color: Colors.pinkAccent.shade200,
                    fontSize: 18.0,
                    letterSpacing: 1.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
