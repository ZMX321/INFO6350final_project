import 'package:final_project/authentication.dart';
import 'package:final_project/view/add_new_item_page.dart';
import 'package:final_project/view/user_profile_page.dart';
import 'package:final_project/view/home_page.dart';
import 'package:final_project/view/login_signup_page.dart';
import 'package:final_project/view/root_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyperGarageSale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: RootPage(auth: new Auth()),
      initialRoute: RootPage.id,
      routes: {
        AddNewItemPage.id: (context) => AddNewItemPage(),
        LoginSignupPage.id: (context) => LoginSignupPage(),
        HomePage.id: (context) => HomePage(),
        UserProfilePage.id: (context) => UserProfilePage(),
      },
    );
  }
}
