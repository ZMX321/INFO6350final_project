import 'package:final_project/authentication.dart';
import 'package:final_project/view/home_page.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  static const String id = 'login_signup_page';
  LoginSignupPage({this.auth, this.loginCallback,this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          print(_email);
          print(_password);
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          final FormState form = _formKey.currentState;
          form.save();
          userId = await widget.auth.signUp(_email, _password);
          form.reset();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _showForm(),
        _showCircularProgress(),
      ],
    ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: ClipOval(
          child: Image.asset('assets/title1.png', width: 200, height: 200),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.mail,
              color: Colors.pinkAccent,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.pinkAccent,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(
        _isLoginForm ? 'Don\'t have an account?' : 'Already have an account?',
        style: TextStyle(color: Colors.grey),
      ),
      TextButton(
          child: Text(_isLoginForm ? 'Sign Up' : 'Log In',
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w300)),
          onPressed: toggleFormMode)
    ]);
  }

  Widget showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: Material(
        elevation: 5.0,
        color: Colors.pinkAccent,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: validateAndSubmit,
          minWidth: 200.0,
          height: 40.0,
          child: Text(
            _isLoginForm ? 'Login' : 'Create account',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
