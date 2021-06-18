import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
import 'package:venti_metri/screens/auth/utilities/constants.dart';
import 'package:venti_metri/screens/event/single_event_manager_screen.dart';
import 'package:venti_metri/screens/event/utils_event/utils_event.dart';
import 'package:venti_metri/utils/utils.dart';

import '../branch_choose.dart';

class LoginAuthScreen extends StatefulWidget {
  static String id = 'auth_login';
  @override
  _LoginAuthScreenState createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  final String _passwordAdmin = '1905';
  final _auth = FirebaseAuth.instance;
  bool _registrationButtonPressed = false;
  bool _resetPasswordButtonPressed = false;

  Map<String,EventClass> _alreadyUsedPasswordMap;

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _accessPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _choosePasswordController = TextEditingController();
  TextEditingController _adminPasswordController = TextEditingController();

  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    initEvents();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }


  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildEmailTF() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              _resetPasswordButtonPressed ? 'Reset Password' : 'Accedi area gestione',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontFamily: 'LoraFont',
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _mailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: VENTI_METRI_BLUE,
                fontFamily: 'LoraFont',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: VENTI_METRI_BLUE,
                ),
                hintText: 'Email',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTF() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _accessPasswordController,
              obscureText: true,
              style: TextStyle(
                color: VENTI_METRI_BLUE,
                fontFamily: 'LoraFont',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: VENTI_METRI_BLUE,
                ),
                hintText: 'Password',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPasswordReg() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _choosePasswordController,
              obscureText: true,
              style: TextStyle(
                color: VENTI_METRI_BLUE,
                fontFamily: 'LoraFont',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: VENTI_METRI_BLUE,
                ),
                hintText: 'Scegli la password',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminPasswordReg() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _adminPasswordController,
              obscureText: true,
              style: TextStyle(
                color: VENTI_METRI_BLUE,
                fontFamily: 'LoraFont',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.vpn_key,
                  color: VENTI_METRI_BLUE,
                ),
                hintText: 'Chiave creazione utenza admin',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPasswordConf() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          SizedBox(height: 15.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: TextStyle(
                color: VENTI_METRI_BLUE,
                fontFamily: 'LoraFont',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: VENTI_METRI_BLUE,
                ),
                hintText: 'Conferma la password',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForgotPasswordRowBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 30, 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _registrationButtonPressed ? FlatButton(
              onPressed: () {
                setState(() {
                  _registrationButtonPressed = false;
                });
              },
              padding: EdgeInsets.only(right: 0.0),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontFamily: 'LoraFont'),
              ),
            ) : FlatButton(
              onPressed: () {
                setState(() {
                  _registrationButtonPressed = true;
                  _resetPasswordButtonPressed = false;
                });
              },
              padding: EdgeInsets.only(right: 0.0),
              child: Text(
                'Registrati',
                style: TextStyle(color: Colors.white, fontFamily: 'LoraFont'),
              ),
            ),
            FlatButton(
              onPressed: () async {
                setState(() {
                  _resetPasswordButtonPressed = true;
                  _registrationButtonPressed = false;
                });
              },
              padding: EdgeInsets.only(right: 0.0),
              child: Text(
                'Password dimenticata?',
                style: TextStyle(color: Colors.white, fontFamily: 'LoraFont'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            if(_mailController.value.text == ''){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 400),
                  backgroundColor: Colors.black,
                  content: Text('Inserire la mail', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
            } else if(_accessPasswordController.value.text == ''){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 400),
                  backgroundColor: Colors.black,
                  content: Text('Scegli la password', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
            }else{

              try{
                final user = await _auth.signInWithEmailAndPassword(email: _mailController.value.text, password: _accessPasswordController.value.text);

                if(user != null){
                  Navigator.pushNamed(context, BranchChooseScreen.id);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 700),
                      backgroundColor: Colors.green,
                      content: Text('Accesso con utenza ${_mailController.value.text}', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                }
              }catch (e){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    duration: Duration(milliseconds: 2000),
                    backgroundColor: Colors.red,
                    content: Text('Errore accesso. ${e}' , style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
              }

            }
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: VENTI_METRI_BLUE,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordForgotBtn() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            if(_mailController.value.text == ''){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 400),
                  backgroundColor: Colors.black,
                  content: Text('Inserire la mail', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
            } else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_mailController.value.text)){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 1000),
                  backgroundColor: Colors.black,
                  content: Text('Mail non corretta', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
            }else{
              try{
                await _auth.sendPasswordResetEmail(email: _mailController.value.text);
                setState(() {
                  _registrationButtonPressed = false;
                  _resetPasswordButtonPressed = false;
                });
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 1500),
                      backgroundColor: Colors.green,
                      content: Text('Email per reset password inviata a ${_mailController.value.text}', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));

              }catch (e){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    duration: Duration(milliseconds: 2000),
                    backgroundColor: Colors.red,
                    content: Text('Errore invio mail per reset password. Errore: ${e}' , style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
              }

            }
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'INVIA MAIL',
            style: TextStyle(
              color: VENTI_METRI_BLUE,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterBtn() {
    return Container(

      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () async {

            if(_mailController.value.text == ''){
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1000),
            backgroundColor: Colors.black,
            content: Text('Inserire la mail', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
            } else if(_confirmPasswordController.value.text == ''){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 1000),
                  backgroundColor: Colors.black,
                  content: Text('Scegli la password', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
            }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_mailController.value.text)){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 1000),
                  backgroundColor: Colors.black,
                  content: Text('Mail non corretta', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
            }else if(_choosePasswordController.value.text == ''){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 1000),
                  backgroundColor: Colors.black,
                  content: Text('Conferma la password', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
            }else if (_confirmPasswordController.value.text != _choosePasswordController.value.text) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 1000),
                  backgroundColor: Colors.black,
                  content: Text('Le password non coincidono', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white))));
            }else if(_adminPasswordController.value.text != _passwordAdmin){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 1500),
                  backgroundColor: Colors.deepOrangeAccent,
                  content: Text('Chiave per creazione utenza admin errata', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
            }else{
              try{
                final newUser = await _auth.createUserWithEmailAndPassword(email: _mailController.value.text, password: _choosePasswordController.value.text);
                if(newUser != null){
                  Navigator.pushNamed(context, BranchChooseScreen.id);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 700),
                      backgroundColor: Colors.green,
                      content: Text('Accesso con utenza ${_mailController.value.text}', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                }else{

                }
              }catch(e){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    duration: Duration(milliseconds: 700),
                    backgroundColor: Colors.redAccent,
                    content: Text('Creazione utenza fallita. Errore ${e}', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
              }

            }
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'REGISTRATI',
            style: TextStyle(
              color: VENTI_METRI_BLUE,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: Text(
            '- OR -',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          'Sign in with',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildInputPasswordForEventWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Form(
            key: formKey,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  obscureText: true,
                  obscuringCharacter: '*',
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  textStyle: TextStyle(color: Colors.black),
                  pinTheme: PinTheme(
                    inactiveColor: VENTI_METRI_BLUE,
                    selectedColor: VENTI_METRI_LOCOROTONDO,
                    activeColor: Colors.white,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 80,
                    fieldWidth: 80,
                    activeFillColor:
                    hasError ? Colors.blue.shade100 : Colors.white,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  errorAnimationController: errorController,
                  controller: _textEditingController,
                  keyboardType: TextInputType.number,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.white,
                      blurRadius: 1,
                    )
                  ],
                  onCompleted: (v) {
                    formKey.currentState.validate();
                    // conditions for validating
                    if (currentText.length != 4 || !_alreadyUsedPasswordMap.keys.contains(currentText)) {
                      errorController.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() {
                        _textEditingController.clear();
                        hasError = true;
                      });
                      snackBar("Password sbagliata. Nessun Evento trovato!!");
                    } else {
                      snackBar("Accesso all\'evento ${_alreadyUsedPasswordMap[currentText].title} in corso..");

                      EventClass toSend = _alreadyUsedPasswordMap[currentText];
                      print(toSend.title + ' - pass: ' + toSend.passwordEvent);
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SingleEventManagerScreen(eventClass: toSend, function: (){},),),);
                      setState(() {
                        _textEditingController.clear();
                        hasError = false;
                      },);
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: TextButton(
                  child: Text("Clear",style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'LoraFont'),),
                  onPressed: () {
                    _textEditingController.clear();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
                () => print('Login with Facebook'),
            AssetImage(
              'images/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
                () => print('Login with Google'),
            AssetImage(
              'images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey.shade500,
        title: Text('20m2 - Drink&Enjoy', style: TextStyle(
        color: Colors.white,
        fontFamily: 'LoraFont',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueGrey.shade500,
                      Colors.blueGrey.shade600,
                      Colors.blueGrey.shade700,
                      Colors.blueGrey.shade800,
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Ricerca serata',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'LoraFont',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildInputPasswordForEventWidget(),
                      SizedBox(height: 20.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _resetPasswordButtonPressed ? SizedBox(width: 0,) : _registrationButtonPressed ? Column(
                        children: [
                          _buildPasswordReg(),
                          _buildPasswordConf(),
                        ],
                      ) : _buildPasswordTF(),
                      //_buildRememberMeCheckbox(),
                      _registrationButtonPressed ? _buildAdminPasswordReg() : SizedBox(height: 0,),
                      _buildRegistrationForgotPasswordRowBtn(),
                      _resetPasswordButtonPressed ? _buildPasswordForgotBtn() :
                      _registrationButtonPressed ? SizedBox(height: 0,) : _buildLoginBtn(),
                      _registrationButtonPressed ? _buildRegisterBtn() : SizedBox(height: 10,),


                      //_buildSignInWithText(),
                      //_buildSocialBtnRow(),
                      //_buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void initEvents() async {
    CRUDModel crudModel = CRUDModel(EVENTS_SCHEMA);
    await crudModel.fetchEvents().then((value) {
      setState(() {
        _alreadyUsedPasswordMap = getMapAlreadyUsedPassword(value);
      });
    });
  }
}