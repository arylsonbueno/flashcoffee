import 'package:flutter/cupertino.dart';
import 'package:flashcoffee/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../firebase/auth/problems.dart';
import '../widgets/primary_button.dart';
import '../widgets/ui.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth? auth;
  final VoidCallback? loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final K_LOGIN_TIMEOUT = Duration(seconds: 20);
  final _formKey = new GlobalKey<FormState>();

  String? _email;
  String? _password;
  String? _errorMessage;
  bool _inputFocus = false;
  bool _obscurePassword = true;
  String _appVersion = "";

  late bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    if (!_isLoading) {
      if (validateAndSave()) {
        setState(() {
          _errorMessage = "";
          _isLoading = true;
        });
        String? userId = "";
        try {
          await widget.auth!
              .signIn(_email, _password)
              .timeout(K_LOGIN_TIMEOUT)
              .then((value) {
            userId = value;
          });
          print('Signed in: $userId');
          setState(() {
            _isLoading = false;
          });

          if (userId != null && userId!.length > 0) {
            widget.loginCallback!();
          } else {
            setState(() {
              _errorMessage = 'Login inválido';
            });
          }
        } on PlatformException catch (e) {
          AuthProblems errType = plaformExceptionHandle(e);
          String errMessage = "Usuário e/ou senha inválido(s)!";
          setState(() {
            _isLoading = false;
            _formKey.currentState!.reset();
            _errorMessage = errMessage;
          });
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            //_formKey.currentState.reset();
            _errorMessage = e.toString();
          });
        }
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _fetchAppVersion();
    super.initState();
  }

  void _fetchAppVersion() async {
    String _version = await PackageInfo.fromPlatform().then((onValue) {
      return onValue.version;
    });
    if (mounted)
      setState(() {
        _appVersion = _version;
      });
  }

  void resetForm() {
    _formKey.currentState!.reset();
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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

  Widget showErrorMessage() {
    if (_errorMessage != null && _errorMessage!.length > 0) {
      return Container(
          padding: new EdgeInsets.only(top: 20),
          child: Text(
            _errorMessage!,
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.bold),
          ));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget logo() {
    return Visibility(
      visible: !_inputFocus,
      child: Hero(
        tag: 'logo',
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 110.0,
          ),
        ),
      ),
    );
  }

  Widget welcomeMessage() {
    return Center(
        heightFactor: 0.75,
        child: Column(children: <Widget>[
          Text(
            "Bem-vindo(a) ao REP-A",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: Text(
              "Software Prime na palma da sua mão",
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: Text(
              _appVersion.isEmpty ? "" : "Versão: " + _appVersion,
            ),
          )
        ]));
  }

  Widget emailInput() {
    return Semantics(
      label: 'Campo email para login',
      child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 75.0, 5.0, 0.0),
          child: Focus(
              onFocusChange: (focus) => setState(() {
                _inputFocus = !_inputFocus;
              }),
              child: TextFormField(
                maxLines: 1,
                maxLength: 50,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: UI.textFieldOutlined("Login", context),
                validator: (value) =>
                value!.isEmpty ? "Email requerido" : null,
                onSaved: (value) => _email = value!.trim(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaler.scale(16),
                ),
              ))),
    );
  }

  Widget passwordInput() {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Semantics(
        label: 'Campo senha para login',
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          child: Focus(
              onFocusChange: (focus) => setState(() {
                _inputFocus = !_inputFocus;
              }),
              child: TextFormField(
                maxLines: 1,
                maxLength: 14,
                obscureText: _obscurePassword,
                autofocus: false,
                decoration: UI.textFieldOutlined(
                  "Senha",
                  context,
                  new IconButton(
                    icon: Icon(UI.viewPassIconData),
                    onPressed: _togglePassword,
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? "Email obrigatório" : null,
                onSaved: (value) => _password = value!.trim(),
                style: TextStyle(
                  fontSize: 16 / scaleFactor,
                ),
              )),
        ));
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Widget primaryButton() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.1, horizontal: screenWidth * 0.1),
        child: PrimaryButton(
          title: "Login",
          label: "Entrar",
          onPressed: validateAndSubmit,
        ));
  }

  Widget _showForm() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            semanticChildCount: 3,
            children: <Widget>[
              logo(),
              welcomeMessage(),
              emailInput(),
              passwordInput(),
              showErrorMessage(),
              primaryButton(),
              //showSecondaryButton(),
            ],
          ),
        ));
  }
}