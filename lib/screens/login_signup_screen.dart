import 'package:flutter/material.dart';
import 'package:gch_cityservice/main.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:gch_cityservice/screens/intro_screen.dart';
import 'package:gch_cityservice/screens/siggnin_details_screen.dart';
import 'package:gch_cityservice/services/authentication.dart';

class LoginSignUpScreen extends StatefulWidget {
  LoginSignUpScreen({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginSignUpScreenState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          var _address, _number, _fullName;

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => SigninDetailsScreen(
                        callback: (
                          address,
                          phoneNumber,
                          fullName,
                        ) {
                          _address = address;
                          _number = phoneNumber;
                          _fullName = fullName;

                          Navigator.pop(context);
                        },
                      ))).then((_) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => IntroScreen(
                        callback: () async {
                          userId = await widget.auth.signUp(_email, _password);
                          widget.auth.sendEmailVerification();
                          databaseReference
                              .child("users")
                              .child((await widget.auth.getCurrentUser()).uid)
                              .set({
                            "address": _address,
                            "phoneNumber": _number,
                            "fullName": _fullName
                          });
                          await _showVerifyEmailSentDialog();

                          Navigator.pop(context);
                          print('Signed up user: $userId');
                        },
                      ))));
        }
        setState(() {
          _isLoading = false;
        });
        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
        appBar: AppBar(
          title: Text('Авторизация'),
        ),
        body: Stack(
          children: <Widget>[
            _showBody(),
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

  Future _showVerifyEmailSentDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Подтвердите аккаунт"),
          content: Text(
              "Перейдите по ссылке в письме отправленном на вашу электронную почту"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ок"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
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

  Widget _showLogo() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      //I used some padding without fixed width and height
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // You can use like this way or like the below line
        //borderRadius: new BorderRadius.circular(30.0),
        color: Colors.blue,
      ),
      child: Image.asset(
          'assets/icons/icon.png'), // You can add a Icon instead of text also, like below.
      //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Необходимо ввести почту' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Пароль',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Необходимо заполнить пароль' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showSecondaryButton() {
    return FlatButton(
      child: _formMode == FormMode.LOGIN
          ? Text('Создать аккаунт',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : Text('Уже есть аккаунт? Войдите',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: _formMode == FormMode.LOGIN
                ? Text('Войти',
                    style: TextStyle(fontSize: 20.0, color: Colors.white))
                : Text('Зарегистрироваться',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }
}
