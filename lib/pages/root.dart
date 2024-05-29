import 'package:flutter/material.dart';
import '../pages/login.dart';
import '../services/authentication.dart';
import '../widgets/app_navigator.dart';

enum AuthStatus {
  UNDETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage(this.auth);

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.UNDETERMINED;
  bool _loggedOffline = false;

  @override
  void initState() {
    super.initState();
    _loginCallback();
  }

  _loginCallback() {
    if (_loggedOffline) {
      setState(() {
        authStatus = AuthStatus.LOGGED_IN;
      });
    } else {
      setState(() {
        widget.auth.getCurrentUser().then((userSession) {
          setState(() {
            authStatus = userSession?.uid == null
                ? AuthStatus.NOT_LOGGED_IN
                : AuthStatus.LOGGED_IN;
            print('login callback ON: ${authStatus.toString()}');
          });
        });
      });
    }
  }

  _logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.LOGGED_IN:
        return AppNavigator(
          auth: widget.auth,
          logoutCallback: _logoutCallback,
        );
      case AuthStatus.NOT_LOGGED_IN:
        return LoginSignupPage(
          auth: widget.auth,
          loginCallback: _loginCallback,
        );
      default: // AuthStatus.UNDETERMINED:
        return _buildWaitingScreen();
    }
  }

}
